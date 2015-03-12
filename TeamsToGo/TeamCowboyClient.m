//
//  TeamCowboyClient.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/11/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "TeamCowboyClient.h"
#import "NetworkController.h"
#import "ApiKeys.h"

@interface TeamCowboyClient ()

@property (strong, nonatomic) NSString *httpEndPoint;
@property (strong, nonatomic) NSString *httpsEndPoint;
@property (strong, nonatomic) NSString *timestamp;
@property (strong, nonatomic) NSString *nonce;

@end

@implementation TeamCowboyClient

#pragma mark - set secure/non-secure endpoint
-(NSString *)httpEndPoint {
    if (_httpEndPoint == nil) {
        _httpEndPoint = @"http://api.teamcowboy.com/v1/";
    }
    return _httpEndPoint;
}

-(NSString *)httpsEndPoint {
    if (_httpsEndPoint == nil) {
        _httpsEndPoint = @"https://api.teamcowboy.com/v1/";
    }
    return _httpsEndPoint;
}

-(NSString *)timestamp {
    return [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
}

-(NSString *)nonce {
    return [NSString stringWithFormat:@"%.4f", [[NSDate date] timeIntervalSince1970]];
}


#pragma mark - Test_GetRequest
-(void)testGetRequest {
    NSString *methodCall = @"Test_GetRequest";
    BOOL usingSSL = false;

    NSDictionary *param = @{@"method" : methodCall,
                            @"timestamp" : self.timestamp,
                            @"nonce" : self.nonce,
                            @"testParam" : @"testingParam"};

    [[NetworkController sharedInstance] makeApiGetRequest:methodCall
                                            toEndPointUrl:( usingSSL ? self.httpsEndPoint : self.httpEndPoint)
                                           withParameters:param];
}

#pragma mark - Test_GetRequest
-(void)testPostRequest {
    NSString *methodCall = @"Test_PostRequest";
    BOOL usingSSL = false;
    
    NSDictionary *param = @{@"method" : methodCall,
                            @"timestamp" : self.timestamp,
                            @"nonce" : self.nonce,
                            @"testParam" : @"testingParam"};
    
    [[NetworkController sharedInstance] makeApiPostRequest:methodCall
                                            toEndPointUrl:( usingSSL ? self.httpsEndPoint : self.httpEndPoint)
                                           withParameters:param];
}

#pragma mark - Auth_GetUserToken
-(void)authGetUserToken {
    NSString *methodCall = @"Auth_GetUserToken";
    BOOL usingSSL = true;
    
    NSString *username = [[ApiKeys instance] getUsername];
    NSString *password = [[ApiKeys instance] getPassword];
    
    NSDictionary *param = @{@"method" : methodCall,
                            @"timestamp" : self.timestamp,
                            @"nonce" : self.nonce,
                            @"username" : username,
                            @"password" : password};
    
    [[NetworkController sharedInstance] makeApiPostRequest:methodCall
                                             toEndPointUrl:( usingSSL ? self.httpsEndPoint : self.httpEndPoint)
                                            withParameters:param];
    
    
}



@end
