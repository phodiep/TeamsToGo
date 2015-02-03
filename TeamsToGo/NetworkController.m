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

#pragma mark - interface
@interface NetworkController()

//@property (strong, nonatomic) NSString *privateKey;
@property (strong, nonatomic) NSString *httpEndPoint;
@property (strong, nonatomic) NSString *httpsEndPoint;
@property (strong, nonatomic) NSString *requestToken;


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
//        self.privateKey = [[ApiKeys sharedInstance] getPrivateKey];
        self.httpEndPoint = @"http://api.teamcowboy.com/v1";
        self.httpsEndPoint = @"https://api.teamcowboy.com/v1";
    }
    return self;
}

#pragma mark - RequestSignature
- (NSString *)getNounce {
    //unique 8+ character long value
    long low = 10000000;
    long high = 9999999999;
    long random = (arc4random() % high) + low; //get random int between low and high
    return [NSString stringWithFormat:@"%ld", random];
}

- (NSString *)getTimestamp {
    //UNIX timestamp
    return [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
}

- (NSString *)requestSignature:(NSString *)reqMethod methodBeingCalled:(NSString *)methodCall parameters:(NSArray *)parameters {
    NSString *privateKey = [[ApiKeys instance] getPrivateKey];
    NSString *nounce = self.getNounce;
    NSString *timestamp = self.getTimestamp;

    NSString *keyStr = [[NSString stringWithFormat:@"api_key=%@", privateKey] lowercaseString];
    NSString *nounceStr = [[NSString stringWithFormat:@"nounce=%@", nounce] lowercaseString];
    NSString *timestampStr = [[NSString stringWithFormat:@"timestamp=%@", timestamp] lowercaseString];

    //create concatinated request string, sorted alphabetically
    NSMutableArray *concatArray = [parameters mutableCopy];
    [concatArray addObject:keyStr];
    [concatArray addObject:nounceStr];
    [concatArray addObject:timestampStr];
    NSArray *sortedConcatArray = [concatArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *concat = [sortedConcatArray componentsJoinedByString:@"&"];

    NSString *signature = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@", privateKey, reqMethod, methodCall, timestamp, nounce, concat];
    NSString *encryptedSignature = [[Hashes alloc] sha1:signature];
    return encryptedSignature;
}




//get request token

//get authorize token

//get access token



@end
