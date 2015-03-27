//
//  Player.h
//  TeamsToGo
//
//  Created by Pho Diep on 3/26/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Team, User;

@interface Player : NSManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Team *team;
@property (nonatomic, retain) User *user;

@end
