//
//  NetworkController.m
//  TeamsToGo
//
//  Created by Pho Diep on 2/2/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#include <stdlib.h>
#import "NetworkController.h"
#import "ApiKeys.h"
#import "Hashes.h"
#import "Response.h"
#import <CoreFoundation/CoreFoundation.h>

#pragma mark - interface
@interface NetworkController()

//@property (strong, nonatomic) NSString *userToken;
@property (strong, nonatomic) NSURLSession *urlSession;

@end

#pragma mark - implementation
@implementation NetworkController

#pragma mark - SharedInstance Singleton
+ (instancetype)sharedInstance {
    static NetworkController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSURLSessionConfiguration *ephemeralConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        self.urlSession = [NSURLSession sessionWithConfiguration:ephemeralConfig];
    }
    return self;
}


#pragma mark - url
+ (NSString*)urlEncode:(NSString *)victim {
    //todo autorelease pool and +1 ref count
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                            NULL,
                                            (CFStringRef) victim,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8 );
}

+ (NSDictionary *)encodeValues:(NSDictionary *)queryParameters {
    NSMutableDictionary *encodedDictionary = [[NSMutableDictionary alloc]init];
    
    [queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [encodedDictionary setObject:[NetworkController urlEncode:obj] forKey:key];
    }];
    
    return encodedDictionary;
}

+ (NSArray *)sortByKey:(NSDictionary *)queryParameters {
    NSArray *unsortedKeys = (NSMutableArray*)[queryParameters allKeys];
    NSArray* sortedKeys = [unsortedKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSMutableArray *sortedPairs = [[NSMutableArray alloc]init];
    
    for (id key in sortedKeys) {
        NSArray *keyValuePair = @[key, [queryParameters valueForKey:key]];
        [sortedPairs addObject:keyValuePair];
    }
    return sortedPairs;
}

+ (NSString *)queryStringForParameters:(NSArray *)parameters {
    NSMutableArray *concat = [[NSMutableArray alloc] init];
    for (id param in parameters) {
        NSString *concatParam = [param componentsJoinedByString:@"="];
        [concat addObject:concatParam];
    }
    
    NSString *queryString = [concat componentsJoinedByString:@"&"];
    return queryString;
}

+ (NSString *)computeSignatureForQuery:(NSString*)queryString usingHttpMethod:(NSString*)httpMethod toApiMethod:(NSString*)apiMethod timestamp:(NSString*)timestamp nonce:(NSString*)nonce {
    
    NSString* lowercaseQueryString = [queryString lowercaseString];

    NSString *toSign = [@[[[ApiKeys instance] getPrivateKey],
       httpMethod,
       apiMethod,
       timestamp,
       nonce,
       lowercaseQueryString
       ] componentsJoinedByString:@"|" ];
    return [[Hashes alloc] sha1:toSign];
}

-(void)makeApiGetRequest:(NSString*)apiMethod toEndPointUrl:(NSString*)endPoint withParameters:(NSDictionary*)inputParams withCompletionHandler:(void (^)(NSObject *results))completionHandler {
    NSLog(@"...Make API Get Request");
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:inputParams];
    [params setObject:[[ApiKeys instance] getPublicKey] forKey:@"api_key"];
    [params setObject:@"json" forKey:@"response_type"];
    
    NSDictionary *encodedParams = [NetworkController encodeValues:params];
    NSArray *sortedParams = [NetworkController sortByKey:encodedParams];
    NSMutableString *joinedQuery = [[NSMutableString alloc] initWithString:[NetworkController queryStringForParameters:sortedParams]];
    
    NSString *signature = [NetworkController computeSignatureForQuery:joinedQuery
                                                      usingHttpMethod:@"GET"
                                                          toApiMethod:apiMethod
                                                            timestamp:params[@"timestamp"]
                                                                nonce:params[@"nonce"]];
    
    [joinedQuery appendString:[NSString stringWithFormat:@"&sig=%@", signature]];
    
    NSString *urlString = [NSString stringWithFormat:@"%@?%@", endPoint, joinedQuery];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";

    completionHandler([NetworkController makeSynchronousApiRequest:request]);
    
}

-(void)makeApiPostRequest:(NSString*)apiMethod toEndPointUrl:(NSString*)endPoint withParameters:(NSDictionary*)inputParams withCompletionHandler:(void (^)(NSObject *results))completionHandler {
    NSLog(@"...Make API Post Request");
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:inputParams];
    [params setObject:[[ApiKeys instance] getPublicKey] forKey:@"api_key"];
    [params setObject:@"json" forKey:@"response_type"];
    
    NSDictionary *encodedParams = [NetworkController encodeValues:params];
    NSArray *sortedParams = [NetworkController sortByKey:encodedParams];
    NSMutableString *joinedQuery = [[NSMutableString alloc] initWithString:[NetworkController queryStringForParameters:sortedParams]];
    
    NSString *signature = [NetworkController computeSignatureForQuery:joinedQuery
                                                      usingHttpMethod:@"POST"
                                                          toApiMethod:apiMethod
                                                            timestamp:params[@"timestamp"]
                                                                nonce:params[@"nonce"]];
    
    [joinedQuery appendString:[NSString stringWithFormat:@"&sig=%@", signature]];
    NSURL *url = [[NSURL alloc] initWithString:endPoint];
    
    NSData *bodyString = [joinedQuery dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *bodyLength = [NSString stringWithFormat:@"%lu", (unsigned long)[bodyString length]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = bodyString;
    
    [request setValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    completionHandler([NetworkController makeSynchronousApiRequest:request]);
    
}

+ (NSObject*)makeSynchronousApiRequest:(NSURLRequest*)request {
    NSURLResponse* response;
    NSError* error = nil;
    
    NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error != nil) {
        NSLog(@"\n\nRequest Error: %@", error);
        return nil;
    }

    if ([NetworkController goodResponseCode:response] == false) {
        //deal w/ bad response
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        NSLog(@"Bad Response: %ld", (long)httpResponse.statusCode);
        return nil;
    }

    Response* finalResponse = [[Response alloc] init:[NSJSONSerialization JSONObjectWithData:result options:0 error:nil]];
    return [finalResponse getResults];
    
}


+ (BOOL)goodResponseCode:(NSURLResponse*)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    
    switch (httpResponse.statusCode) {
        case 200: //OK
            return true;
        case 400: //Bad request
            return false;
        case 401: //Unauthorized
            return false;
        case 403: //Forbidden
            return false;
        case 404: //Not Found
            return false;
        case 405: //Method not allowed
            return false;
        case 500: //Internal server error
            return false;
        case 501: //Not implemented
            return false;
        default: //unknown
            return false;
    }
}

@end
