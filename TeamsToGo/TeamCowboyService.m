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
        self.users = [[NSMutableArray alloc] init];
        self.teams = [[NSMutableArray alloc] init];
        self.events = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - User
-(User*)createNewUserIfNecessaryElseUpdate:(NSDictionary *)json {
    if (json == nil) {
        return nil;
    }
    
    User *user = [self fetchUserById:json[@"userId"]];
    if (user == nil) {
        user = [[User alloc] init];
        [self updateUserInfo:user withJson:json];
        [self addUser:user];
        NSLog(@"Created new user: %@", user.name);
    } else {
        [self updateUserInfo:user withJson:json];
        NSLog(@"Updated user: %@", user.name);
    }
    return user;
}

-(void)addUser:(User*)user {
    if (user != nil) {
        [self.users addObject:user];
    }
}

-(User*)updateUserInfo:(User*)user withJson:(NSDictionary*)json {
    if (user == nil) {
        return nil;
    }
    
    if (json == nil) {
        return user;
    }
    
    [user updateTimestamp];
    
    NSDate *lastUpdate = [self formatStringToDate:json[@"dateLastUpdatedUtc"]];
    if ([user.lastUpdate isEqualToDate:lastUpdate]) {
        return user;
    }

    if ([self isNotNull: json[@"userId"]]) {
        user.userId = [NSString stringWithFormat:@"%@",json[@"userId"]];
    }
    
    if ([self isNotNull: json[@"fullName"]]) {
        user.name = json[@"fullName"];
    }
    
    if ([self isNotNull:json[@"gender"]]) {
        user.gender = [self determineGender: json[@"gender"]];
    }
    
    if ([self isNotNull:json[@"phone1"]]) {
        user.phoneNumber = json[@"phone1"];
    } else if ([self isNotNull:json[@"phone2"]]) {
        user.phoneNumber = json[@"phone2"];
    }
    
    if ([self isNotNull: json[@"emailAddress1"]]) {
        user.emailAddress = json[@"emailAddress1"];
    } else if ([self isNotNull: json[@"emailAddress2"]]) {
        user.emailAddress = json[@"emailAddress2"];
    }
    
    if ([self isNotNull:json[@"dateLastUpdatedUtc"]]) {
        user.lastUpdate = lastUpdate;
    }

    return user;
}

-(User*)fetchUserById:(NSString*)userId {
    for (User *user in self.users) {
        if ([user.userId isEqualToString:[NSString stringWithFormat:@"%@", userId]]) {
            return user;
        }
    }
    return nil;
}

-(NSArray*)fetchAllUsers {
    return self.users;
}

-(NSArray*)createMultipleUsersIfNecessaryElseUpdate:(NSArray*)jsonArray {
    if (jsonArray == nil) {
        return nil;
    }
    NSMutableArray *usersFromJson = [[NSMutableArray alloc] init];
    for (NSDictionary *json in jsonArray) {
        User *user = [self createNewUserIfNecessaryElseUpdate:json];
        if (user != nil) {
            [usersFromJson addObject:user];
        }
    }
    return usersFromJson;
}

-(Gender)determineGender:(id)object {
    if ([object isEqualToString:@"m"] || [object isEqualToString:@"male"]) {
        return Male;
    }
    if ([object isEqualToString:@"f"] || [object isEqualToString:@"female"]) {
        return Female;
    }
    
    return Other;
}


#pragma mark - Team

-(Team*)createNewTeamIfNecessaryElseUpdate:(NSDictionary *)json {
    if (json == nil) {
        return nil;
    }

    Team *team = [self fetchTeamById:json[@"teamId"]];

    if (team == nil) {
        team = [[Team alloc] init];
        [self updateTeamInfo:team withJson:json];
        [self addTeam:team];
        NSLog(@"Created new team: %@", team.name);
    } else {
        [self updateTeamInfo:team withJson:json];
        NSLog(@"Updated team: %@", team.name);
    }
    return team;
}

-(void)addTeam:(Team*)team {
    if (team != nil) {
        [self.teams addObject:team];
    }
}

-(Team*)fetchTeamById:(NSString*)teamId {
    for (Team *team in self.teams) {
        if ([team.teamId isEqualToString:[NSString stringWithFormat:@"%@", teamId]]) {
            return team;
        }
    }
    return nil;
}

-(Team*)updateTeamInfo:(Team*)team withJson:(NSDictionary*)json {
    if (team == nil) {
        return nil;
    }
    
    if (json == nil) {
        return team;
    }
    
    [team updateTimestamp];
    
    NSDate *lastUpdate = [self formatStringToDate:json[@"dateLastUpdatedUtc"]];
    if ([team.lastUpdate isEqualToDate:lastUpdate]) {
        return team;
    }

    if ([self isNotNull:json[@"teamId"]]) {
        team.teamId = [NSString stringWithFormat:@"%@",json[@"teamId"]];
    }

    if ([self isNotNull:json[@"name"]]) {
        team.name = json[@"name"];
    }

    if ([self isNotNull:json[@"dateLastUpdatedUtc"]]) {
        team.lastUpdate = lastUpdate;
    }
    
    NSDictionary *misc = json[@"options"][@"misc"];
    if ([self isNotNull:misc[@"attendanceListFemaleLabel"]]) {
        team.displayFemale = misc[@"attendanceListFemaleLabel"];
    }
    if ([self isNotNull:misc[@"attendanceListMaleLabel"]]) {
        team.displayMale = misc[@"attendanceListMaleLabel"];
    }
    if ([self isNotNull:misc[@"attendanceListOtherGenderLabel"]]) {
        team.displayOther = misc[@"attendanceListOtherGenderLabel"];
    }
    
    //TODO: add manager to team members
//    if (json[@"managerUser"] != nil) {
//        team.manager = [self addNewUserWithJson:json[@"managerUser"]];
//    }

    return team;
}

-(NSArray*)fetchAllTeams {
    return self.teams;
}

-(NSArray*)createMultipleTeamsIfNecessaryElseUpdate:(NSArray *)jsonArray {
    if (jsonArray == nil) {
        return nil;
    }
    NSMutableArray *teamsFromJson = [[NSMutableArray alloc] init];
    for (NSDictionary *json in jsonArray) {
        Team *team = [self createNewTeamIfNecessaryElseUpdate:json];
        if (team != nil) {
            [teamsFromJson addObject:team];
        }
    }
    return teamsFromJson;
}

#pragma mark - Event
-(Event*)createNewEventIfNecessaryElseUpdate:(NSDictionary*)json {
    if (json == nil) {
        return nil;
    }
    
    Event *event = [self fetchEventById:json[@"eventId"]];
    
    if (event == nil) {
        event = [[Event alloc] init];
        [self updateEventInfo:event withJson:json];
        [self addEvent:event];
        NSLog(@"Created new event: %@", event.title);
    } else {
        [self updateEventInfo:event withJson:json];
        NSLog(@"Updated event: %@", event.title);
    }
    return event;
}

-(Event*)fetchEventById:(NSString*)eventId {
    for (Event *event in self.events) {
        if ([event.eventId isEqualToString:[NSString stringWithFormat:@"%@", eventId]]) {
            return event;
        }
    }
    return nil;
}

-(void)addEvent:(Event*)event {
    if (event != nil) {
        [self.events addObject:event];
    }
}

-(NSArray*)fetchAllEvents {
    return self.events;
}

-(Event*)updateEventInfo:(Event*)event withJson:(NSDictionary*)json {
    if (event == nil) {
        return nil;
    }
    
    if (json == nil) {
        return event;
    }
    
    [event updateTimestamp];
    NSDate *lastUpdate = [self formatStringToDate:json[@"dateLastUpdatedUtc"]];
    if ([event.lastUpdate isEqualToDate:lastUpdate]) {
        return event;
    }
    
    if ([self isNotNull:json[@"eventId"]]) {
        event.eventId = [NSString stringWithFormat:@"%@", json[@"eventId"]];
    }
    if ([self isNotNull:json[@"title"]]) {
        event.title = json[@"title"];
    }
    if ([self isNotNull:json[@"status"]]) {
        event.status = json[@"status"];
    }
    if ([self isNotNull:json[@"dateTimeInfo"][@"startDateTimeLocal"]]) {
        event.startTime = [self formatStringToDate:json[@"dateTimeInfo"][@"startDateTimeLocal"]];
    }
    if ([self isNotNull:json[@"homeAway"]]) {
        event.homeAway = [self determineHomeAway:json[@"homeAway"]];
    }
    
    if ([self isNotNull:json[@"comments"]]) {
        event.comments = json[@"comments"];
    }
    
    if ([self isNotNull:json[@"shirtColors"][@"team1"]]) {
        event.teamColor = [NSString stringWithFormat:@"%@",json[@"shirtColors"][@"team1"][@"colors"][0][@"hexCode"]];
    }
    if ([self isNotNull:json[@"shirtColors"][@"team2"]]) {
        event.opponentColor = [NSString stringWithFormat:@"%@",json[@"shirtColors"][@"team2"][@"colors"][0][@"hexCode"]];
    }
    
    if ([self isNotNull:json[@"dateLastUpdatedUtc"]]) {
        event.lastUpdate = lastUpdate;
    }
    
    if ([self isNotNull:json[@"team"]]) {
        event.team = [self createNewTeamIfNecessaryElseUpdate:json[@"team"]];
    }
    
    //TODO: add location

    return event;
}

-(HomeAway)determineHomeAway:(id)object {
    if ([object isEqualToString:@"home"]) {
        return Home;
    }
    if ([object isEqualToString:@"away"]) {
        return Away;
    }
    return Null;
}

-(NSArray*)createMultipleEventsIfNecessaryElseUpdate:(NSArray *)jsonArray {
    if (jsonArray == nil) {
        return nil;
    }
    NSMutableArray *eventsFromJson = [[NSMutableArray alloc] init];
    for (NSDictionary *json in jsonArray) {
        Event *event = [self createNewEventIfNecessaryElseUpdate:json];
        if (event != nil) {
            [eventsFromJson addObject:event];
        }
    }
    return eventsFromJson;
}

-(void)deletePastEvents {
    for (Event *event in self.events) {
        if ([event.startTime timeIntervalSinceNow] <= (60*60*2)) { //2+ hours ago
            [self.events removeObject:event];
        }
    }
}













#pragma mark - Player

//-(void)addPlayers:(NSArray*)jsonArray toTeam:(NSString*)teamId {
//    if (jsonArray != nil && ![teamId isEqualToString:@""] ) {
//        Team *team = [self fetchTeams:teamId][0];
//        for (NSDictionary *json in jsonArray) {
//            User *user = [self addNewUserWithJson:json];
//            [self addPlayer:user toTeam:team withType:json[@"teamMeta"][@"teamMemberType"][@"titleShort"]];
//        }
//    }
//    
//}
//
//-(Player*)addPlayer:(User*)user toTeam:(Team*)team withType:(NSString*)type {
//    
//    if (user != nil && team != nil && ![type isEqualToString:@""] &&
//        ![self playerAlreadyExists:user onTeam:team]) {
//        Player *player = [NSEntityDescription insertNewObjectForEntityForName:@"Player" inManagedObjectContext:self.context];
//        player.user = user;
//        player.team = team;
//        if ([[type lowercaseString] containsString:@"full"]){
//            player.type = @"Full-time";
//        } else if ([[type lowercaseString] containsString:@"part"]) {
//            player.type = @"Part-time";
//        } else if ([[type lowercaseString] containsString:@"sub"]) {
//            player.type = @"Sub";
//        } else if ([[type lowercaseString] containsString:@"injured"]) {
//            player.type = @"Injured";
//        } else if ([[type lowercaseString] containsString:@"on leave"]) {
//            player.type = @"On Leave";
//        } else {
//            player.type = type;
//        }
//        
//        [self saveContext:[NSString stringWithFormat:@"\nPlayer's Name ... %@ (%@)",user.name, type]];
//        return player;
//    }
//    return nil;
//}
//
//-(BOOL)playerAlreadyExists:(User*)user onTeam:(Team*)team {
//    return ( [[self fetchPlayersForTeam:team specificUser:user] count] > 0);
//}
//
//-(NSArray*)fetchPlayersForTeam:(Team*)team specificUser:(User*)user {
//    if (team != nil) {
//        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:self.context];
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//        [fetchRequest setEntity:entityDescription];
//        
//        if (user == nil) {
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"team == %@", team];
//            [fetchRequest setPredicate:predicate];
//        }
//        if (user != nil) {
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"team == %@ AND user == %@", team, user];
//            [fetchRequest setPredicate:predicate];
//        }
//        
//        
//        NSError *fetchError = nil;
//        NSArray *fetchResults = [self.context executeFetchRequest:fetchRequest error:&fetchError];
//        
//        if (fetchError != nil) {
//            NSLog(@"Fetch Error: %@", fetchError.localizedDescription);
//        }
//        
//        return fetchResults;
//        
//    }
//    return nil;
//    
//}
//
//-(NSArray*)fetchPlayersForTeam:(Team*)team {
//    return [self fetchPlayersForTeam:team specificUser:nil];
//}
//
//#pragma mark - Event Attendence
//-(CountByStatus*)addNewCountByStatusforEvent:(Event*)event withJson:(NSDictionary*)json {
//    if (json != nil && event != nil) {
//        
//        CountByStatus *countByStatus = [NSEntityDescription insertNewObjectForEntityForName:@"CountByStatus" inManagedObjectContext:self.context];
//        
//        countByStatus.event = event;
//        countByStatus.status = json[@"status"];
//        countByStatus.male = json[@"counts"][@"byGender"][@"m"];
//        countByStatus.female = json[@"counts"][@"byGender"][@"f"];
//        countByStatus.other = json[@"counts"][@"byGender"][@"other"];
//        countByStatus.total = json[@"counts"][@"total"];
//        
//        [self saveContext:@""];
//        return countByStatus;
//    }
//    return nil;
//}
//
//-(NSArray*)addMultipleCountByStatusForEvent:(NSString*)eventId withJson:(NSDictionary*)json {
//    if (json != nil && ![eventId isEqualToString:@""]) {
//        Event *event = (Event*)[self fetchEventWithId:eventId][0];
//        [self deleteCountByStatusForEvent:event];
//        
//        NSMutableArray *newCounts = [[NSMutableArray alloc] init];
//        NSArray *countsByStatusJson = json[@"countsByStatus"];
//        
//        for (NSDictionary* counts in countsByStatusJson) {
//            [newCounts addObject:[self addNewCountByStatusforEvent:event withJson:counts]];
//        }
//    }
//    return nil;
//}
//
//-(void)deleteCountByStatusForEvent:(Event*)event {
//    NSArray *countsFound = [self fetchCountByStatus:event];
//    [self deleteFromCoreData: countsFound stringPluralForItems:[NSString stringWithFormat:@"CountByStatus (%lu)", (unsigned long)[countsFound count]]];
//}
//
//-(NSArray*)fetchCountByStatus:(Event*)event {
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"CountByStatus" inManagedObjectContext:self.context];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    [fetchRequest setEntity:entityDescription];
//    
//    if (event != nil) {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event == %@", event];
//        [fetchRequest setPredicate:predicate];
//    }
//    
//    NSError *fetchError = nil;
//    NSArray *fetchResults = [self.context executeFetchRequest:fetchRequest error:&fetchError];
//    
//    if (fetchError != nil) {
//        NSLog(@"Fetch Error: %@", fetchError.localizedDescription);
//    }
//    
//    return fetchResults;
//}
//
//-(Rsvp*)addRsvpForEvent:(Event*)event withJson:(NSDictionary*)json {
//    if (json != nil && event != nil) {
//        
//        Rsvp *rsvp = [NSEntityDescription insertNewObjectForEntityForName:@"Rsvp" inManagedObjectContext:self.context];
//        
//        rsvp.user = [self addNewUserWithJson:json[@"user"]];
//        rsvp.status = json[@"rsvpInfo"][@"status"];
//        rsvp.comments = json[@"rsvpInfo"][@"comments"];
//        rsvp.addlFemale = [NSString stringWithFormat:@"%@",json[@"rsvpInfo"][@"addlFemale"] ];
//        rsvp.addlMale = [NSString stringWithFormat:@"%@",json[@"rsvpInfo"][@"addlMale"]];
//        rsvp.event = event;
//        
//        [self saveContext:@""];
//        return rsvp;
//    }
//    return nil;
//}
//
//-(NSArray*)addMultipleRsvpsForEvent:(NSString*)eventId withJson:(NSDictionary*)json {
//    if (json != nil && ![eventId isEqualToString:@""]) {
//        Event *event = (Event*)[self fetchEventWithId:eventId][0];
//        [self deleteRsvpForEvent:event];
//        
//        NSMutableArray *rsvps = [[NSMutableArray alloc] init];
//        NSArray *usersJson = json[@"users"];
//        
//        for (NSDictionary *user in usersJson) {
//            [rsvps addObject:[self addRsvpForEvent:event withJson:user]];
//        }
//    }
//    return nil;
//}
//
//-(NSArray*)fetchRsvpByEvent:(Event*)event {
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Rsvp" inManagedObjectContext:self.context];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    [fetchRequest setEntity:entityDescription];
//    
//    if (event != nil) {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event == %@", event];
//        [fetchRequest setPredicate:predicate];
//    }
//    
//    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"user.name" ascending:YES];
//    [fetchRequest setSortDescriptors:@[sortByName]];
//    
//    NSError *fetchError = nil;
//    NSArray *fetchResults = [self.context executeFetchRequest:fetchRequest error:&fetchError];
//    
//    if (fetchError != nil) {
//        NSLog(@"Fetch Error: %@", fetchError.localizedDescription);
//    }
//    
//    return fetchResults;
//}
//
//-(void)deleteRsvpForEvent:(Event*)event {
//    NSArray *rsvpFound = [self fetchRsvpByEvent:event];
//    [self deleteFromCoreData: rsvpFound stringPluralForItems:[NSString stringWithFormat:@"Rsvps (%lu)", (unsigned long)[rsvpFound count]]];
//}
//
//-(Player*)fetchPlayer:(User*)user onTeam:(Team*)team {
//
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:self.context];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    [fetchRequest setEntity:entityDescription];
//    
//    if (user != nil && team != nil) {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user == %@ AND team == %@", user, team];
//        [fetchRequest setPredicate:predicate];
//    }
//    
//    NSError *fetchError = nil;
//    NSArray *fetchResults = [self.context executeFetchRequest:fetchRequest error:&fetchError];
//    
//    if (fetchError != nil) {
//        NSLog(@"Fetch Error: %@", fetchError.localizedDescription);
//    }
//    
//    if ([fetchResults count] == 1) {
//        return fetchResults[0];
//    }
//    
//    return nil;
//}
//
//
#pragma mark - misc
//-(void)deleteFromCoreData:(NSArray*)items stringPluralForItems:(NSString*)name {
//    if (items != nil) {
//        for (NSManagedObject *item in items) {
//            [self.context deleteObject:item];
//        }
//        [self saveContext:[NSString stringWithFormat:@"deleted %@", name]];
//    }
//}

-(NSDate*)formatStringToDate:(NSString*)dateString {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormat dateFromString:dateString];
}

-(BOOL)isNotNull:(id)object {
    if (object == nil) {
        return false;
    }
    if (object == (id)[NSNull null]) {
        return false;
    }
    return true;
}

//-(void)saveContext:(NSString*)successString {
//    NSError *saveError;
//    [self.context save:&saveError];
//    if (saveError != nil) {
//        NSLog(@"\nError ... %@", saveError.localizedDescription);
//    } else {
//        NSLog(@"%@",successString);
//    }
//}

-(void)resetData {
    self.teams = nil;
    self.users = nil;
    self.events = nil;
}




@end
