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
-(NSDictionary*)makeApiPostRequest:(NSString*)apiMethod toEndPointUrl:(NSString*)endPoint withParameters:(NSDictionary*)inputParams;

//-(NSData*) makeApiRequest:(NSString*)apiMethod usingHttpMethod:(NSString*)httpMethod usingSSL:(BOOL)usingSSL withParams:(NSDictionary*)inputParams;

//- (void)getUserToken;

@end
