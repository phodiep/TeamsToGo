//
//  TeamCowboyClient.h
//  TeamsToGo
//
//  Created by Pho Diep on 3/11/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface TeamCowboyClient : NSObject

-(void)testGetRequest;
-(void)testPostRequest;
-(void)authGetUserToken;
-(void)userGet;
-(void)userGetTeams;

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSArray *teams;

@end
