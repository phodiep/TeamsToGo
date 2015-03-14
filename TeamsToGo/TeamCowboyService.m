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

-(Team*)addNewTeam:(NSString*)name teamId:(NSString*)teamId forActivity:(NSString*)activity lastUpdate:(NSDate*)lastUpdate {
    if (name != nil && teamId != nil && lastUpdate != nil) {
        Team *team = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:self.context];
        team.teamId = teamId;
        team.activity = activity;
        team.name = name;
        team.lastUpdate = lastUpdate;
        
        NSError *saveError;
        [self.context save:&saveError];
        if (saveError == nil) {
            return team;
        }
    }
    return nil;
}

-(Team*)addNewTeamWithJson:(NSDictionary*)json {
    if (json != nil) {
        Team *team = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:self.context];
        team.teamId = [NSString stringWithFormat:@"%@",json[@"teamId"]];
        team.activity = json[@"activity"][@"name"];
        team.name = json[@"name"];
//        team.lastUpdate = json[@"dateLastUpdatedUtc"];
        
        NSError *saveError;
        [self.context save:&saveError];
        if (saveError == nil) {
            NSLog(@"\nTeam Name ... %@",team.name);
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


@end
