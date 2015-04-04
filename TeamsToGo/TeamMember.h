//
//  TeamMember.h
//  TeamsToGo
//
//  Created by Pho Diep on 4/4/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Team.h"

@interface TeamMember : NSObject

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) Team *team;
@property (strong, nonatomic) NSString *memberType;

@property (strong, nonatomic) NSDate *timestamp;

-(void)updateTimestamp;

@end
