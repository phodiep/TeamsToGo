//
//  TeamCowboyService.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/14/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "TeamCowboyService.h"

#pragma mark - Interface
@interface TeamCowboyService ()

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

#pragma mark - Implementation
@implementation TeamCowboyService

+(id)sharedService {
    static TeamCowboyService *mySharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mySharedService = [[self alloc] init];
    });
    return mySharedService;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        self.coreDataStack = [[CoreDataStack alloc] init];
        self.context = self.coreDataStack.managedObjectContext;
    }
    return self;
}


#pragma mark - Team
-(void)addMultipleTeams:(NSArray*)jsonArray {
    if (jsonArray != nil) {
        for (NSDictionary *json in jsonArray) {
            [self addNewTeamWithJson:json];
        }
    }
}

-(Team*)addNewTeamWithJson:(NSDictionary*)json {
    if (json != nil) {
        if ( [self teamAlreadyExists:json[@"teamId"]] == false ) {
            Team *team = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:self.context];
            [self setTeamProperties:team withJson:json];
            [self saveContext:[NSString stringWithFormat:@"Created Team: %@", team.name]];
            return team;
        } else {
            return [self updateTeamIfNecessary:json[@"teamId"] withJson:json];
        }
    }
    return nil;
}

-(void)setTeamProperties:(Team*)team withJson:(NSDictionary*)json {
    if (json[@"teamId"] != nil) {
        team.teamId = [NSString stringWithFormat:@"%@",json[@"teamId"]];
    }
    
    if (json[@"activity"][@"name"] != nil) {
        team.activity = json[@"activity"][@"name"];
    }
    
    if (json[@"name"] != nil) {
        team.name = json[@"name"];
    }
    
    if (json[@"dateLastUpdatedUtc"] != nil) {
        team.lastUpdate = [self formatDate:json[@"dateLastUpdatedUtc"]];
    }
    
    if (json[@"managerUser"] != nil) {
        team.manager = [self addNewUserWithJson:json[@"managerUser"]];
    }
}

-(Team*)updateTeamIfNecessary:(NSString*)teamId withJson:(NSDictionary*)json {
    NSArray *fetchTeamResults = [self fetchTeams:teamId];
    
    if ([fetchTeamResults count] == 1) {
        Team *team = fetchTeamResults[0];

        if (team.lastUpdate != [self formatDate:json[@"dateLastUpdatedUtc"]]) {
            [self setTeamProperties:team withJson:json];
            [self saveContext:[NSString stringWithFormat:@"Updated Team: %@", team.name]];
        }
        return team;
    }
    return nil;
}

-(BOOL)teamAlreadyExists:(NSString*)teamId {
    NSArray *fetchTeamResults = [self fetchTeams:teamId];
    
    if ([fetchTeamResults count] > 0) {
        return true;
    }
    return false;
}

-(NSArray*)fetchTeams:(NSString*)teamId {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:self.context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    if (teamId != nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teamId == %@", teamId];
        [fetchRequest setPredicate:predicate];
    }
    
    NSError *fetchError = nil;
    NSArray *fetchResults = [self.context executeFetchRequest:fetchRequest error:&fetchError];
    
    if (fetchError != nil) {
        NSLog(@"Fetch Error: %@", fetchError.localizedDescription);
    }
    
    return fetchResults;
}

-(NSArray*)fetchAllTeams {
    return [self fetchTeams:nil];
}

-(void)deleteAllTeamsFromCoreData {
    NSArray *teams = [self fetchAllTeams];
    
    if ([teams count] >0) {
        [self deleteFromCoreData:teams stringPluralForItems:@"all teams"];
    }
}


#pragma mark - User
-(User*)addNewUserWithJson:(NSDictionary*)json {
    if (json !=nil) {
        if ( [self userAlreadyExists:json[@"userId"]] == false ) {
            User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.context];
            [self setUserProperties:user withJson:json];
            [self saveContext:[NSString stringWithFormat:@"\nUser Name ... %@",user.name]];
            return user;
            
        } else {
            User *user = [self updateUserIfNecessary:json[@"userId"] withJson:json];
            return user;
        }
    }
    return nil;
}

-(BOOL)userAlreadyExists:(NSString*)userId {
    return ( [[self fetchUsers:userId] count] > 0 );
}

-(User*)updateUserIfNecessary:(NSString*)userId withJson:(NSDictionary*)json {
    NSArray *fetchUserResults = [self fetchUsers:userId];
    
    if ([fetchUserResults count] == 1) {
        User *user = fetchUserResults[0];
        
//        if (user.lastUpdated != [self formatDate:json[@"dateLastUpdatedUtc"]] ||
//            [user.phone isEqualToString:@""] || [user.emailAddress isEqualToString:@""]) {
            [self setUserProperties:user withJson:json];
            [self saveContext:[NSString stringWithFormat:@"Updated User: %@", user.name]];
//        }
        return user;
    }
    return nil;
}


-(void)setUserProperties:(User*)user withJson:(NSDictionary*)json {
    if (json[@"userId"] != nil) {
        user.userId = [NSString stringWithFormat:@"%@",json[@"userId"]];
    }
    
    if (json[@"fullName"] != nil) {
        user.name = json[@"fullName"];
    }
    
    if (json[@"emailAddress"] != nil) {
        user.emailAddress = json[@"emailAddress"];
    }
    
    if (json[@"emailAddress1"] != nil) {
        user.emailAddress = json[@"emailAddress1"];
    }

    if (json[@"phone1"] != nil) {
        user.phone = json[@"phone1"];
    }
    
    if (json[@"gender"] != nil) {
        user.gender = json[@"gender"];
    }
    if (json[@"dateLastUpdatedUtc"] != nil) {
        user.lastUpdated = [self formatDate:json[@"dateLastUpdatedUtc"]];
    }
}

-(NSArray*)fetchUsers:(NSString*)userId {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    if (userId != nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@", userId];
        [fetchRequest setPredicate:predicate];
    }
    
    NSError *fetchError = nil;
    NSArray *fetchResults = [self.context executeFetchRequest:fetchRequest error:&fetchError];
    
    if (fetchError != nil) {
        NSLog(@"Fetch Error: %@", fetchError.localizedDescription);
    }
    
    return fetchResults;
}


#pragma mark - Player

-(void)addPlayers:(NSArray*)jsonArray toTeam:(NSString*)teamId {
    if (jsonArray != nil && ![teamId isEqualToString:@""] ) {
        Team *team = [self fetchTeams:teamId][0];
        for (NSDictionary *json in jsonArray) {
            User *user = [self addNewUserWithJson:json];
            [self addPlayer:user toTeam:team withType:json[@"teamMeta"][@"teamMemberType"][@"titleShort"]];
        }
    }
    
}

-(Player*)addPlayer:(User*)user toTeam:(Team*)team withType:(NSString*)type {
    
    if (user != nil && team != nil && ![type isEqualToString:@""] &&
        ![self playerAlreadyExists:user onTeam:team]) {
        Player *player = [NSEntityDescription insertNewObjectForEntityForName:@"Player" inManagedObjectContext:self.context];
        player.user = user;
        player.team = team;
        if ([[type lowercaseString] containsString:@"full"]){
            player.type = @"Full-time";
        } else if ([[type lowercaseString] containsString:@"part"]) {
            player.type = @"Part-time";
        } else if ([[type lowercaseString] containsString:@"sub"]) {
            player.type = @"Sub";
        } else if ([[type lowercaseString] containsString:@"injured"]) {
            player.type = @"Injured";
        } else {
            player.type = type;
        }
        
        [self saveContext:[NSString stringWithFormat:@"\nPlayer's Name ... %@ (%@)",user.name, type]];
        return player;
    }
    return nil;
}

-(BOOL)playerAlreadyExists:(User*)user onTeam:(Team*)team {
    return ( [[self fetchPlayersForTeam:team specificUser:user] count] > 0);
}

-(NSArray*)fetchPlayersForTeam:(Team*)team specificUser:(User*)user {
    if (team != nil) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:self.context];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entityDescription];
        
        if (user == nil) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"team == %@", team];
            [fetchRequest setPredicate:predicate];
        }
        if (user != nil) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"team == %@ AND user == %@", team, user];
            [fetchRequest setPredicate:predicate];
        }
        
        
        NSError *fetchError = nil;
        NSArray *fetchResults = [self.context executeFetchRequest:fetchRequest error:&fetchError];
        
        if (fetchError != nil) {
            NSLog(@"Fetch Error: %@", fetchError.localizedDescription);
        }
        
        return fetchResults;
        
    }
    return nil;
    
}

-(NSArray*)fetchPlayersForTeam:(Team*)team {
    return [self fetchPlayersForTeam:team specificUser:nil];
}

#pragma mark - Event
-(void)addMultipleEvents:(NSArray *)jsonArray {
    if (jsonArray != nil) {
        for (NSDictionary *json in jsonArray) {
            [self addNewEventWithJson:json];
        }
    }
}

-(Event*)addNewEventWithJson:(NSDictionary*)json {
    if (json != nil) {
        if ([self eventAlreadyExists:json[@"eventId"]]) {
            return [self updateEventIfNecessary:json[@"eventId"] withJson:json];
            
        } else {
            Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.context];
            [self setEventProperties:event withJson:json];
            [self saveContext:[NSString stringWithFormat:@"Created Event: %@", event.title]];
            return event;
        }
    }
    return nil;
}

-(BOOL)eventAlreadyExists:(NSString*)eventId {
    NSArray *fetchResults = [self fetchEventWithId:eventId];
    
    return ([fetchResults count] > 0);
}

-(void)setEventProperties:(Event*)event withJson:(NSDictionary*)json {
    if (json[@"eventId"] != nil) {
        event.eventId = [NSString stringWithFormat:@"%@", json[@"eventId"]];
    }
    if (json[@"title"] != nil) {
        event.title = json[@"title"];
    }
    if (json[@"status"] != nil) {
        event.status = json[@"status"];
    }
    if (json[@"dateTimeInfo"][@"startDateTimeLocal"] != nil) {
        event.startTime = [self formatDate:json[@"dateTimeInfo"][@"startDateTimeLocal"]];
    }
    if (json[@"homeAway"] != nil) {
        event.homeAway = json[@"homeAway"];
    }
    if (json[@"comments"] != nil) {
        if (![[NSString stringWithFormat:@"%@", json[@"comments"]] isEqualToString:@"<null>"]) {
            event.comments = json[@"comments"];
        }
    }

    if (json[@"shirtColors"][@"team1"] != nil) {
        if (![[NSString stringWithFormat:@"%@", json[@"shirtColors"][@"team1"]] isEqualToString:@"<null>"]) {
            event.teamColor = [NSString stringWithFormat:@"%@",json[@"shirtColors"][@"team1"][@"colors"][0][@"hexCode"]];
        }
    }
    if (json[@"shirtColors"][@"team2"] != nil) {
        if (![[NSString stringWithFormat:@"%@", json[@"shirtColors"][@"team2"]] isEqualToString:@"<null>"]) {
            event.opponentColor = [NSString stringWithFormat:@"%@",json[@"shirtColors"][@"team2"][@"colors"][0][@"hexCode"]];
        }
    }

    if (json[@"dateLastUpdatedUtc"] != nil) {
        event.lastUpdate = [self formatDate:json[@"dateLastUpdatedUtc"]];
    }
    if (json[@"team"] != nil) {
        event.team = [self addNewTeamWithJson:json[@"team"]];
    }
    
    //TODO: add location
//    event.location = json[@""];
}

-(Event*)updateEventIfNecessary:(NSString*)eventId withJson:(NSDictionary*)json {
    NSArray *fetchResults = [self fetchEventWithId:eventId];
    
    if ([fetchResults count] == 1) {
        Event *event = fetchResults[0];
        
        if ( [self eventHasBeenUpdated:event withJson:json]) {
            [self setEventProperties:event withJson:json];
            [self saveContext:[NSString stringWithFormat:@"Updated Event: %@", event.title]];
        }
        return event;
    }
    return nil;
}

-(BOOL)eventHasBeenUpdated:(Event*)event withJson:(NSDictionary*)json {
    if (event.lastUpdate == [self formatDate:json[@"dateLastUpdatedUtc"]]) {
        return false;
    }
    return true;
}

-(NSArray*)fetchEventWithPredicate:(NSPredicate*)predicate {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    if (predicate != nil) {
        [fetchRequest setPredicate:predicate];
    }
    
    NSError *fetchError = nil;
    NSArray *fetchResults = [self.context executeFetchRequest:fetchRequest error:&fetchError];
    
    if (fetchError != nil) {
        NSLog(@"Fetch Error: %@", fetchError.localizedDescription);
    }
    
    return fetchResults;
}


-(NSArray*)fetchEventWithId:(NSString*)eventId {
    if (eventId != nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventId == %@", eventId];
        return [self fetchEventWithPredicate:predicate];
    }
    return nil;
}

-(NSArray*)fetchAllFutureEvents {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"startTime >= %@", [NSDate date]];
    return [self fetchEventWithPredicate:predicate];
}

-(void)deleteAllPastEvents {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"startTime < %@", [NSDate date]];
    NSArray * events = [self fetchEventWithPredicate:predicate];
    
    if ([events count] > 0) {
        [self deleteFromCoreData:events stringPluralForItems:@"past events"];
    }
}

-(NSArray*)fetchAllEvents {
    return [self fetchEventWithPredicate:nil];
}

-(void)deleteAllEventsFromCoreData {
    NSArray *events = [self fetchAllEvents];
    if ([events count] > 0) {
        [self deleteFromCoreData:events stringPluralForItems:@"all events"];
    }
}



#pragma mark - misc
-(void)deleteFromCoreData:(NSArray*)items stringPluralForItems:(NSString*)name {
    if (items != nil) {
        for (NSManagedObject *item in items) {
            [self.context deleteObject:item];
        }
        [self saveContext:[NSString stringWithFormat:@"deleted %@", name]];
    }
}

-(NSDate*)formatDate:(NSString*)dateString {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormat dateFromString:dateString];
}

-(void)saveContext:(NSString*)successString {
    NSError *saveError;
    [self.context save:&saveError];
    if (saveError != nil) {
        NSLog(@"\nError ... %@", saveError.localizedDescription);
    } else {
        NSLog(@"%@",successString);
    }
}





@end
