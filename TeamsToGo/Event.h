//
//  Event.h
//  TeamsToGo
//
//  Created by Pho Diep on 4/4/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"
#import "Rsvp.h"
#import "Location.h"

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
@property (strong, nonatomic) Location *location;

@property (strong, nonatomic) NSArray *rsvps;

@property (strong, nonatomic) NSString *rsvpYesFemale;
@property (strong, nonatomic) NSString *rsvpYesMale;
@property (strong, nonatomic) NSString *rsvpYesOther;

@property (strong, nonatomic) NSString *rsvpNoFemale;
@property (strong, nonatomic) NSString *rsvpNoMale;
@property (strong, nonatomic) NSString *rsvpNoOther;

@property (strong, nonatomic) NSString *rsvpMaybeFemale;
@property (strong, nonatomic) NSString *rsvpMaybeMale;
@property (strong, nonatomic) NSString *rsvpMaybeOther;

@property (strong, nonatomic) NSString *rsvpNoResponseFemale;
@property (strong, nonatomic) NSString *rsvpNoResponseMale;
@property (strong, nonatomic) NSString *rsvpNoResponseOther;

@property (strong, nonatomic) NSString *rsvpAvailableFemale;
@property (strong, nonatomic) NSString *rsvpAvailableMale;
@property (strong, nonatomic) NSString *rsvpAvailableOther;

@property (strong, nonatomic) NSString *rsvpStatusDisplayYes;
@property (strong, nonatomic) NSString *rsvpStatusDisplayNo;
@property (strong, nonatomic) NSString *rsvpStatusDisplayMaybe;
@property (strong, nonatomic) NSString *rsvpStatusDisplayAvailable;
@property (strong, nonatomic) NSString *rsvpStatusDisplayNoResponse;

@property (strong, nonatomic) NSDate *lastUpdate;

@property (strong, nonatomic) NSDate *timestamp;

-(NSString*)getRsvpCountsForStatus:(NSString*)status andGender:(NSString*)gender;
-(void)updateTimestamp;

@end
