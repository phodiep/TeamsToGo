//
//  Event.h
//  TeamsToGo
//
//  Created by Pho Diep on 4/4/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"

@interface Event : NSObject

typedef NS_ENUM(NSInteger, HomeAway) {
    Home = 0,
    Away = 1,
    Null = 2
};


@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) Team *team;
@property (strong, nonatomic) NSString *comments;
@property (nonatomic) HomeAway homeAway;
@property (strong, nonatomic) NSString *opponentColor;
@property (strong, nonatomic) NSString *teamColor;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *location;

@property (strong, nonatomic) NSDate *lastUpdate;

@property (strong, nonatomic) NSDate *timestamp;

-(void)updateTimestamp;

@end
