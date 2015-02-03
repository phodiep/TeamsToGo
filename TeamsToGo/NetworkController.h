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
- (NSString *)requestSignature:(NSString *)reqMethod methodBeingCalled:(NSString *)methodCall parameters:(NSArray *)parameters;

@end
