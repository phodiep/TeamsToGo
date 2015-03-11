//
//  ResponseError.m
//  TeamsToGo
//
//  Created by Pho Diep on 2/8/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "ResponseError.h"

@interface ResponseError ()

@property (strong, nonatomic) NSString *errorCode;
@property (strong, nonatomic) NSString *httpResponse;
@property (strong, nonatomic) NSString *message;

@end

@implementation ResponseError

- (instancetype)init:(NSDictionary*)jsonData {
    self = [super init];
    if (self) {
        self.errorCode = [jsonData valueForKey:@"errorCode"];
        self.httpResponse = [jsonData valueForKey:@"httpResponse"];
        self.message = [jsonData valueForKey:@"message"];
    }
    return self;
}


- (NSString*)getErrorCode {
    return self.errorCode;
}

- (NSString*)getHttpResponse {
    return self.httpResponse;
}

- (NSString*)getMessage {
    return self.message;
}


@end
