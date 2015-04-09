//
//  TeamCowboyService.h
//  TeamsToGo
//
//  Created by Pho Diep on 3/14/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"
#import "Team.h"
#import "Event.h"
#import "TeamMember.h"
#import "Rsvp.h"

@interface TeamCowboyService : NSObject

+(id)sharedService;

@property (strong, nonatomic) User *loginUser;
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) NSMutableArray *teams;
@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSMutableArray *teamMembers;
@property (strong, nonatomic) NSMutableArray *rsvps;

-(User*)createNewUserIfNecessaryElseUpdate:(NSDictionary *)json;
-(NSArray*)createMultipleUsersIfNecessaryElseUpdate:(NSArray*)jsonArray;
-(NSArray*)fetchAllUsers;

-(Team*)createNewTeamIfNecessaryElseUpdate:(NSDictionary *)json;
-(NSArray*)createMultipleTeamsIfNecessaryElseUpdate:(NSArray *)jsonArray;
-(NSArray*)fetchAllTeams;

-(Event*)createNewEventIfNecessaryElseUpdate:(NSDictionary*)json;
-(NSArray*)createMultipleEventsIfNecessaryElseUpdate:(NSArray *)jsonArray;
-(NSArray*)fetchAllEvents;
-(void)deletePastEvents;

-(TeamMember*)createNewTeamMemberIfNecessaryElseUpdate:(NSDictionary*)json forTeam:(Team*)team;
-(NSArray*)createMultipleTeamMembersIfNecessaryElseUpdate:(NSArray *)jsonArray forTeam:(NSString*)teamId;
-(NSArray*)fetchAllTeamMembersForTeam:(Team*)team;

-(Event*)updateRsvpsForEvent:(NSString*)eventId withJson:(NSDictionary*)json;
-(Rsvp*)fetchRsvpForUserId:(NSString*)userId forEvent:(Event*)event;


-(void)resetData;

@end
