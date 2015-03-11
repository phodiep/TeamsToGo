//
//  Response.h
//  TeamsToGo
//
//  Created by Pho Diep on 2/8/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseError.h"

@interface Response : NSObject

- (instancetype)init:(NSDictionary*)data;

-(BOOL)getSuccess;
-(NSDictionary*)getResults;
-(ResponseError*)getResponseError;

@end
