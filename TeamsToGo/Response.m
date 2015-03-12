//
//  Response.m
//  TeamsToGo
//
//  Created by Pho Diep on 2/8/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "Response.h"
#import "ResponseError.h"

@interface Response ()

@property (nonatomic) BOOL success;
@property (strong, nonatomic) ResponseError* responseError;
@property (strong, nonatomic) NSString* requestSeconds;
@property (strong, nonatomic) NSDictionary* result;

@end

@implementation Response

- (instancetype)init:(NSDictionary*)data {

    self = [super init];
    if (self) {
        self.success = [data valueForKey:@"success"];
        self.requestSeconds = [data valueForKey:@"requestSecs"];

        NSDictionary* body = [data valueForKey:@"body"];
        if (self.success == false) {
            self.responseError = [[ResponseError alloc] init:[body valueForKey:@"error"]];
        } else {
            self.result = body;
        }
    }
    return self;
}

-(BOOL)getSuccess {
    return self.success;
}

-(NSString*)getRequestSeconds {
    return self.requestSeconds;
}

-(NSObject*)getResults {
    return self.result;
}

-(ResponseError*)getResponseError {
    return self.responseError;
}

@end
