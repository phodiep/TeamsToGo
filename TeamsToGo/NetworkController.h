//
//  NetworkController.h
//  TeamsToGo
//
//  Created by Pho Diep on 2/2/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkController : NSObject

+ (instancetype)sharedInstance;

-(void)makeApiGetRequest:(NSString*)apiMethod toEndPointUrl:(NSString*)endPoint withParameters:(NSDictionary*)inputParams withCompletionHandler:(void (^)(NSObject *results))completionHandler;
-(void)makeApiPostRequest:(NSString*)apiMethod toEndPointUrl:(NSString*)endPoint withParameters:(NSDictionary*)inputParams withCompletionHandler:(void (^)(NSObject *results))completionHandler;


@end
