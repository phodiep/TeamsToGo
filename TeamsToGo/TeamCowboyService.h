//
//  TeamCowboyService.h
//  TeamsToGo
//
//  Created by Pho Diep on 3/14/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataStack.h"
#import "Location.h"
#import "Event.h"
#import "Rsvp.h"
#import "Team.h"
#import "User.h"
#import "Player.h"
#import "CountByStatus.h"

@interface TeamCowboyService : NSObject

@property (strong, nonatomic) CoreDataStack *coreDataStack;

+(id)sharedService;

-(void)addMultipleTeams:(NSArray*)jsonArray;
-(void)addMultipleEvents:(NSArray *)jsonArray;

-(NSArray*)fetchAllTeams;
-(void)deleteAllTeamsFromCoreData;

-(void)addPlayers:(NSArray*)jsonArray toTeam:(NSString*)teamId;
-(NSArray*)fetchPlayersForTeam:(Team*)team;


-(NSArray*)fetchAllEvents;
-(NSArray*)fetchAllFutureEvents;
-(NSArray*)fetchEventWithId:(NSString*)eventId;
-(void)deleteAllEventsFromCoreData;
-(void)deleteAllPastEvents;


-(NSArray*)fetchCountByStatus:(Event*)event;
-(NSArray*)addMultipleCountByStatusForEvent:(NSString*)eventId withJson:(NSDictionary*)json;

-(NSArray*)addMultipleRsvpsForEvent:(NSString*)eventId withJson:(NSDictionary*)json;

@end
