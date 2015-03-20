//
//  Response.m
//  TeamsToGo
//
//  Created by Pho Diep on 2/8/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "Response.h"

@interface Response ()

@property (nonatomic) BOOL didSucceed;
@property (strong, nonatomic) NSString* requestSeconds;
@property (strong, nonatomic) NSDictionary* result;

@property (strong, nonatomic) NSString *errorCode;
@property (strong, nonatomic) NSString *errorHttpResponse;
@property (strong, nonatomic) NSString *errorMessage;

@end

@implementation Response

- (instancetype)init:(NSDictionary*)data {
    self = [super init];
    if (self) {
        
        self.didSucceed = (data[@"success"] == 0 ? NO : YES);

        self.requestSeconds = data[@"requestSecs"];

        NSDictionary* body = data[@"body"];
        if (self.didSucceed) {
            self.result = body;
        } else {
            NSDictionary *error = body[@"error"];
            self.errorCode = error[@"errorCode"];
            self.errorHttpResponse = error[@"httpResponse"];
            self.errorMessage = error[@"message"];
        }
    }
    return self;
}

-(BOOL)getDidSucceed {
    return self.didSucceed;
}

-(NSString*)getRequestSeconds {
    return self.requestSeconds;
}

-(NSObject*)getResults {
    return self.result;
}

@end
