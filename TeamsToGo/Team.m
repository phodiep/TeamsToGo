//
//  Team.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/12/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "Team.h"
#import "User.h"

@interface Team ()

@property (strong, nonatomic) NSString *teamId;
@property (strong, nonatomic) NSString *activity;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) User *manager;
@property (strong, nonatomic) User *captain;

@end

@implementation Team

- (instancetype)initWithJson:(NSDictionary*)json {
    self = [super init];
    if (self) {
        self.teamId = json[@"teamId"];

        NSDictionary *activityDictionary = json[@"activity"];
        self.activity = activityDictionary[@"name"];
        
        self.name = json[@"name"];
        self.manager = [[User alloc] initWithJson:json[@"managerUser"]];
        self.captain = [[User alloc] initWithJson:json[@"captainUser"]];
    }
    return self;
}

- (NSArray*)arrayOfTeamsWithJson:(NSArray*)json {
    NSMutableArray *teams = [[NSMutableArray alloc] init];
    for (NSDictionary *teamData in json) {
        [teams addObject:[[Team alloc] initWithJson:teamData]];
    }
    return [[NSArray alloc] initWithArray:teams];
}

@end
