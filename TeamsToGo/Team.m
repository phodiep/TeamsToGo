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

@end

@implementation Team

- (instancetype)initWithJson:(NSDictionary*)json {
    self = [super init];
    if (self) {
        self.teamId = json[@"teamId"];
        self.activity = json[@"activity"][@"name"];
        self.name = json[@"name"];
        self.manager = [[User alloc] initWithJson:json[@"managerUser"]];
    }
    return self;
}

- (NSArray*)arrayOfTeamsWithJson:(NSArray*)json {
    NSMutableArray *teams = [[NSMutableArray alloc] init];
    for (NSDictionary *teamData in json) {
        [teams addObject:[[Team alloc] initWithJson:teamData]];
    }
    return teams;
}

-(NSString*)getName {
    return self.name;
}

-(NSString*)getActivity {
    return self.activity;
}

-(NSString*)getTeamId {
    return self.teamId;
}

-(NSString*)getManagerName {
    return [self.manager fullName];
}

@end
