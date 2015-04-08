//
//  TeamCowboyClient.h
//  TeamsToGo
//
//  Created by Pho Diep on 3/11/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface TeamCowboyClient : NSObject

+(id)sharedService;

-(void)testGetRequest;
-(void)testPostRequest;
-(void)authGetUserToken;
-(void)userGet;
-(void)userGetTeams;
-(void)userGetTeamEvents;
-(void)teamGetRoster:(NSString*)teamId;
-(void)eventGetAttendanceList:(NSString*)eventId forTeamId:(NSString*)teamId;
-(void)eventSaveRsvp:(NSString*)rsvp forTeam:(NSString*)teamId forEvent:(NSString*)eventId addlMale:(NSString*)addlMale addlFemale:(NSString*)addlFemale withComments:(NSString*)comments rsvpAsUserId:(NSString*)rsvpAsUserId;

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSArray *teams;

@end
