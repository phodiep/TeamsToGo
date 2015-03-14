//
//  Event.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/13/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "Event.h"
#import "Team.h"
#import "Color.h"
#import "Location.h"

@interface Event ()

@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) Team *team;
@property (strong, nonatomic) NSString *seasonId;
@property (strong, nonatomic) NSString *seasonName;
@property (strong, nonatomic) NSString *onelineDisplay;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *homeAway;
@property (strong, nonatomic) NSString *comments;
@property (strong, nonatomic) UIColor *teamColor;
@property (strong, nonatomic) UIColor *opponentColor;
@property (strong, nonatomic) NSArray *rsvpInstances;
@property (strong, nonatomic) Location *location;


@property (nonatomic) BOOL inFuture;

@end

@implementation Event

- (instancetype)initWithJson:(NSDictionary*)json {
    self = [super init];
    if (self) {
        self.eventId = json[@"eventId"];
        self.team = [[Team alloc] initWithJson:json[@"team"]];
        self.seasonId = json[@"seasonId"];
        self.seasonName = json[@"seasonName"];
        self.onelineDisplay = json[@"oneLineDisplay"];
        self.status = json[@"statusDisplay"];
        self.startTime = json[@"dateTimeInfo"][@"startDateTimeLocalDisplay"];
        self.title = json[@"title"];
        self.homeAway = json[@"homeAway"];
        self.comments = json[@"comments"];
        
        self.teamColor = [Color colorFromHexString: json[@"team1"][@"colors"][0][@"hexCode"]];
        self.opponentColor = [Color colorFromHexString: json[@"team2"][@"colors"][0][@"hexCode"]];

        self.location = [[Location alloc] initWithJson:json[@"location"]];
        
        //rsvps
        
        
        
    }
    return self;
}



@end
