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

-(NSDictionary*)makeApiGetRequest:(NSString*)apiMethod toEndPointUrl:(NSString*)endPoint withParameters:(NSDictionary*)params;
-(void)makeApiPostRequest:(NSString*)apiMethod toEndPointUrl:(NSString*)endPoint withParameters:(NSDictionary*)inputParams withCompletionHandler:(void (^)(NSDictionary *results))completionHandler;


@end
