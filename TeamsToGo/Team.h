//
//  Team.h
//  TeamsToGo
//
//  Created by Pho Diep on 3/12/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Team : NSObject

- (instancetype)initWithJson:(NSDictionary*)json;
- (NSArray*)arrayOfTeamsWithJson:(NSArray*)json;


@end
