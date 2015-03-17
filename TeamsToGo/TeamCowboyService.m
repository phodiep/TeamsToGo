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

-(void)addNewTeamWithJson:(NSDictionary*)json {
    if (json != nil) {
        if ( [self teamAlreadyExists:json[@"teamId"]] == false ) {
            Team *team = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:self.context];
            
            [self setTeamProperties:team withJson:json];
            [self saveContext:[NSString stringWithFormat:@"Created Team: %@", team.name]];
            
        } else {
            [self updateTeamIfNecessary:json[@"teamId"] withJson:json];
        }
    }
}

-(void)setTeamProperties:(Team*)team withJson:(NSDictionary*)json {
    team.teamId = [NSString stringWithFormat:@"%@",json[@"teamId"]];
    team.activity = json[@"activity"][@"name"];
    team.name = json[@"name"];
    
    team.lastUpdate = [self formatDate:json[@"dateLastUpdatedUtc"]];
    
    //TODO: add manager
    team.manager = [self addNewUserWithJson:json[@"managerUser"]];
    NSLog(@"%@", team.manager.name);
}

-(void)updateTeamIfNecessary:(NSString*)teamId withJson:(NSDictionary*)json {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:self.context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teamId == %@", teamId];
    [fetchRequest setPredicate:predicate];
    
    NSError *fetchError = nil;
    NSArray *fetchResults = [self.context executeFetchRequest:fetchRequest error:&fetchError];
    
    if ([fetchResults count] == 1) {
        Team *team = fetchResults[0];

        if (team.lastUpdate != [self formatDate:json[@"dateLastUpdatedUtc"]]) {
            [self setTeamProperties:team withJson:json];
            [self saveContext:[NSString stringWithFormat:@"Updated Team: %@", team.name]];
        }
    }
}

-(BOOL)teamAlreadyExists:(NSString*)teamId {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:self.context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teamId == %@", teamId];
    [fetchRequest setPredicate:predicate];
    
    NSError *fetchError = nil;
    NSUInteger count = [self.context countForFetchRequest:fetchRequest error:&fetchError];

    if (fetchError != nil) {
        NSLog(@"Fetch Error: %@", fetchError.localizedDescription);
        return nil;
    }
    return (count != 0);
}


#pragma mark - User
-(User*)addNewUserWithJson:(NSDictionary*)json {
    if (json !=nil) {
        if ( [self userAlreadyExists:json[@"userId"]] == false ) {
            User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.context];
            [self setUserProperties:user withJson:json];
        
            [self saveContext:[NSString stringWithFormat:@"\nUser Name ... %@",user.name]];
        }
    }
    return nil;
}

-(BOOL)userAlreadyExists:(NSString*)userId {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@", userId];
    [fetchRequest setPredicate:predicate];
    
    NSError *fetchError = nil;
    NSUInteger count = [self.context countForFetchRequest:fetchRequest error:&fetchError];
    
    if (fetchError != nil) {
        NSLog(@"Fetch Error: %@", fetchError.localizedDescription);
        return nil;
    }
    return (count != 0);
}

-(void)setUserProperties:(User*)user withJson:(NSDictionary*)json {
    user.userId = [NSString stringWithFormat:@"%@",json[@"userId"]];
    user.name = json[@"fullName"];
    
    if (json[@"emailAddress"] == nil) {
        user.emailAddress = json[@"emailAddress"];
    }
    if (json[@"emailAddress1"] == nil) {
        user.emailAddress = json[@"emailAddress1"];
    }

    if (json[@"phone1"] == nil) {
        user.phone = json[@"phone1"];
    }
    if (json[@"gender"] == nil) {
        user.gender = json[@"gender"];
    }
    if (json[@"dateLastUpdatedUtc"] == nil) {
        user.lastUpdated = [self formatDate:json[@"dateLastUpdatedUtc"]];
    }
}



-(NSDate*)formatDate:(NSString*)dateString {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
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
