//
//  ResponseError.h
//  TeamsToGo
//
//  Created by Pho Diep on 2/8/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseError : NSObject

- (instancetype)init:(NSDictionary*)jsonData;

- (NSString*)getErrorCode;
- (NSString*)getHttpResponse;
- (NSString*)getMessage;

@end
