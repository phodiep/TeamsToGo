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

@interface TeamCowboyService : NSObject

//@property (strong, nonatomic) CoreDataStack *coreDataStack;

+(id)sharedService;

@property (strong, nonatomic) User *loginUser;
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) NSMutableArray *teams;
@property (strong, nonatomic) NSMutableArray *events;


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



-(void)resetData;

@end
