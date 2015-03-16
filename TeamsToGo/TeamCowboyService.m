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
-(Team*)addNewTeamWithJson:(NSDictionary*)json {
    if (json != nil) {
        Team *team = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:self.context];
        team.teamId = [NSString stringWithFormat:@"%@",json[@"teamId"]];
        team.activity = json[@"activity"][@"name"];
        team.name = json[@"name"];

        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
        team.lastUpdate = [dateFormat dateFromString:json[@"dateLastUpdatedUtc"]];
        
        //TODO: add manager
        
        NSError *saveError;
        [self.context save:&saveError];
        if (saveError == nil) {
            NSLog(@"\nTeam Name ... %@",team.lastUpdate);
            return team;
        } else {
            NSLog(@"\nError ... %@", saveError.localizedDescription);
        }
    }
    return nil;
}

-(void)addMultipleTeams:(NSArray*)jsonArray {
    if (jsonArray != nil) {
        for (NSDictionary *json in jsonArray) {
            [self addNewTeamWithJson:json];
        }
    }
}

#pragma mark - User
-(User*)addNewUserWithJson:(NSDictionary*)json {
    if (json !=nil) {
        User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.context];
        
        user.userId = json[@"userId"];
        user.name = json[@"fullName"];
        user.emailAddress = json[@"emailAddress1"];
        user.phone = json[@"phone1"];
        user.gender = json[@"gender"];
        //TODO: add last updated
//        user.lastUpdated = json[@"dateLastUpdatedUtc"];
        
        NSError *saveError;
        [self.context save:&saveError];
        if (saveError == nil) {
            NSLog(@"\nTeam Name ... %@",user.name);
            return user;
        } else {
            NSLog(@"\nError ... %@", saveError.localizedDescription);
        }
    }
    return nil;
}

@end
