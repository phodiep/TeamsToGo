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
#import <CoreFoundation/CoreFoundation.h>

#pragma mark - interface
@interface NetworkController()

@property (strong, nonatomic) NSString *httpEndPoint;
@property (strong, nonatomic) NSString *httpsEndPoint;
@property (strong, nonatomic) NSString *userToken;


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
        self.httpEndPoint = @"http://api.teamcowboy.com/v1";
        self.httpsEndPoint = @"https://api.teamcowboy.com/v1";
    }
    return self;
}

#pragma mark - RequestSignature
+ (NSString *)getNonce {
    //unique 8+ character long value
    long low = 10000000;
    long high = 9999999999;
    long random = (arc4random() % high) + low; //get random int between low and high
    return [NSString stringWithFormat:@"%ld", random];
}

+ (NSString *)getTimestamp {
    //UNIX timestamp
    return [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
}

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
    NSArray *sortedKeys = [queryParameters allKeys];
    [sortedKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
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
    
    return [concat componentsJoinedByString:@"&"];
    
}

+ (NSString *)computeSignatureForQuery:(NSString*)queryString usingHttpMethod:(NSString*)httpMethod toApiMethod:(NSString*)apiMethod timestamp:(NSString*)timestamp nonce:(NSString*)nonce {

    NSString *toSign = [@[[[ApiKeys instance] getPrivateKey],
       httpMethod,
       apiMethod,
       timestamp,
       nonce,
       queryString
       ] componentsJoinedByString:@"|" ];
    
    return [[Hashes alloc] sha1:toSign];
}

-(NSHTTPURLResponse*) makeApiRequest:(NSString*)apiMethod usingHttpMethod:(NSString*)httpMethod usingSSL:(BOOL)usingSSL withParams:(NSDictionary*)params {
    
    NSString *timestamp = [NetworkController getTimestamp];
    NSString *nonce = [NetworkController getNonce];
    NSString *endPoint = usingSSL ? self.httpsEndPoint : self.httpEndPoint;


    NSDictionary *encodedParams = [NetworkController encodeValues:params];
    NSArray *sortedParams = [NetworkController sortByKey:encodedParams];
    NSMutableString *joinedQuery = [[NSMutableString alloc] initWithString:[NetworkController queryStringForParameters:sortedParams]];
    
    NSString *sig = [NetworkController computeSignatureForQuery:joinedQuery usingHttpMethod:httpMethod toApiMethod:apiMethod timestamp:timestamp nonce:nonce];
    [joinedQuery appendString:[NSString stringWithFormat:@"&sig=%@", sig]];
    
    //http call TODO
    
    
    
}


#pragma mark - RequestToken
- (void)getUserToken {

    NSString *requestMethod = @"POST";
    NSString *methodCall = @"Auth_GetUserToken";
    
    
    
    
    
    
}






@end
