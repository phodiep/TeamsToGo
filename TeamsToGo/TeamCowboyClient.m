//
//  TeamCowboyClient.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/11/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "TeamCowboyClient.h"
#import "NetworkController.h"
#import "ApiKeys.h"
#import "TeamCowboyService.h"

@interface TeamCowboyClient ()

@property (strong, nonatomic) NSString *httpEndPoint;
@property (strong, nonatomic) NSString *httpsEndPoint;
@property (strong, nonatomic) NSString *timestamp;
@property (strong, nonatomic) NSString *nonce;



@end

@implementation TeamCowboyClient

+(id)sharedService {
    static TeamCowboyClient *mySharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mySharedService = [[self alloc] init];
    });
    return mySharedService;
}

#pragma mark - set secure/non-secure endpoint
-(NSString *)httpEndPoint {
    if (_httpEndPoint == nil) {
        _httpEndPoint = @"http://api.teamcowboy.com/v1/";
    }
    return _httpEndPoint;
}

-(NSString *)httpsEndPoint {
    if (_httpsEndPoint == nil) {
        _httpsEndPoint = @"https://api.teamcowboy.com/v1/";
    }
    return _httpsEndPoint;
}

-(NSString *)timestamp {
    return [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
}

-(NSString *)nonce {
    return [NSString stringWithFormat:@"%.4f", [[NSDate date] timeIntervalSince1970]];
}

#pragma mark - Test_GetRequest
-(void)testGetRequest {
    NSString *methodCall = @"Test_GetRequest";
    BOOL usingSSL = false;

    NSDictionary *param = @{@"method" : methodCall,
                            @"timestamp" : self.timestamp,
                            @"nonce" : self.nonce,
                            @"testParam" : @"testingGetParam"};
    NSLog(@"TestingGetRequest");
    [[NetworkController sharedInstance] makeApiGetRequest:methodCall
                                            toEndPointUrl:( usingSSL ? self.httpsEndPoint : self.httpEndPoint)
                                           withParameters:param withCompletionHandler:^(NSObject *results) {
                                               if (results != nil) {
                                                   NSArray *json = (NSArray*)results;
                                                   
                                                   NSLog(@"%@", json);
                                                   
                                               }
                                           }];
    
}

#pragma mark - Test_GetRequest
-(void)testPostRequest {
    NSString *methodCall = @"Test_PostRequest";
    BOOL usingSSL = false;
    NSLog(@"TestingPostRequest");
    NSDictionary *param = @{@"method" : methodCall,
                            @"timestamp" : self.timestamp,
                            @"nonce" : self.nonce,
                            @"testParam" : @"testingPostParam"};
    
    [[NetworkController sharedInstance] makeApiPostRequest:methodCall
                                            toEndPointUrl:( usingSSL ? self.httpsEndPoint : self.httpEndPoint)
                                           withParameters:param
                                     withCompletionHandler:^(NSObject *results) {
                                         NSLog(@"%@", results);
                                     }];
}

#pragma mark - Auth_GetUserToken
-(void)authGetUserToken {
    NSString *methodCall = @"Auth_GetUserToken";
    BOOL usingSSL = true;
    
    [ApiKeys instance];
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    
    NSDictionary *param = @{@"method" : methodCall,
                            @"timestamp" : self.timestamp,
                            @"nonce" : self.nonce,
                            @"username" : username,
                            @"password" : password};
    
    [[NetworkController sharedInstance] makeApiPostRequest:methodCall
                                             toEndPointUrl:( usingSSL ? self.httpsEndPoint : self.httpEndPoint)
                                            withParameters:param
                                     withCompletionHandler:^(NSObject *results) {
                                         if (results != nil) {
                                             NSDictionary *json = (NSDictionary*)results;
                                             if (results != nil) {
                                                 [[NSUserDefaults standardUserDefaults]setObject:json[@"userId"]
                                                                                          forKey:@"userId"];
                                                 [[NSUserDefaults standardUserDefaults]setObject:json[@"token"]
                                                                                          forKey:@"userToken"];
                                                 [[NSUserDefaults standardUserDefaults]synchronize];
                                             }
                                         }
     }];
}

#pragma mark - User_Get (login user)
-(void)userGet {
    NSString *methodCall = @"User_Get";
    BOOL usingSSL = false;

    NSString *userToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];
    
    NSDictionary *param = @{@"method" : methodCall,
                            @"timestamp" : self.timestamp,
                            @"nonce" : self.nonce,
                            @"userToken" : userToken};
    
    [[NetworkController sharedInstance] makeApiGetRequest:methodCall
                                             toEndPointUrl:( usingSSL ? self.httpsEndPoint : self.httpEndPoint)
                                            withParameters:param
                                     withCompletionHandler:^(NSObject *results) {
                                         if (results != nil) {
                                             NSDictionary *json = (NSDictionary*)results;
                                             [[TeamCowboyService sharedService] createNewUserIfNecessaryElseUpdate:json];
                                             
                                         }
                                     }];
}

#pragma mark - User_GetTeams
-(void)userGetTeams {
    NSString *methodCall = @"User_GetTeams";
    BOOL usingSSL = false;
    
    NSString *userToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];
    
    NSDictionary *param = @{@"method" : methodCall,
                            @"timestamp" : self.timestamp,
                            @"nonce" : self.nonce,
                            @"userToken" : userToken};
    
    [[NetworkController sharedInstance] makeApiGetRequest:methodCall
                                            toEndPointUrl:( usingSSL ? self.httpsEndPoint : self.httpEndPoint)
                                           withParameters:param
                                    withCompletionHandler:^(NSObject *results) {
                                        if (results != nil) {
                                            NSArray *json = (NSArray*)results;
                                            
                                            [[TeamCowboyService sharedService] createMultipleTeamsIfNecessaryElseUpdate:json];                                            
                                        }
                                    }];
}

#pragma mark - User_GetTeamMessages
//-(void)userGetTeamMessagesForTeam:(NSString*)teamId {
//    NSString *methodCall = @"User_GetTeamMessages";
//    BOOL usingSSL = false;
//    
//    NSString *userToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];
//
//    NSDictionary *param = @{@"method" : methodCall,
//                            @"timestamp" : self.timestamp,
//                            @"nonce" : self.nonce,
//                            @"userToken" : userToken,
//                            @"teamId" : teamId};
//    
//    [[NetworkController sharedInstance] makeApiGetRequest:methodCall
//                                            toEndPointUrl:( usingSSL ? self.httpsEndPoint : self.httpEndPoint)
//                                           withParameters:param
//                                    withCompletionHandler:^(NSObject *results) {
//                                        if (results != nil) {
//                                            NSArray *json = (NSArray*)results;
////                                            self.teams = [[NSArray alloc] initWithArray:[[Team alloc]arrayOfTeamsWithJson:json]];
//                                        }
//                                    }];
//}


#pragma mark - User_GetTeamEvents
-(void)userGetTeamEvents {
    NSString *methodCall = @"User_GetTeamEvents";
    BOOL usingSSL = false;
    
    NSString *userToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];
    
    NSDictionary *param = @{@"method" : methodCall,
                            @"timestamp" : self.timestamp,
                            @"nonce" : self.nonce,
                            @"userToken" : userToken};
    
    [[NetworkController sharedInstance] makeApiGetRequest:methodCall
                                            toEndPointUrl:( usingSSL ? self.httpsEndPoint : self.httpEndPoint)
                                           withParameters:param
                                    withCompletionHandler:^(NSObject *results) {
                                        if (results != nil) {
                                            NSArray *json = (NSArray*)results;
                                            
                                            [[TeamCowboyService sharedService] createMultipleEventsIfNecessaryElseUpdate:json];
                                            
                                        }
                                    }];
}

#pragma mark - Team_GetRoster
-(void)teamGetRoster:(NSString*)teamId {
    NSString *methodCall = @"Team_GetRoster";
    BOOL usingSSL = false;
    
    NSString *userToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];
    
    NSDictionary *param = @{@"method" : methodCall,
                            @"timestamp" : self.timestamp,
                            @"nonce" : self.nonce,
                            @"userToken" : userToken,
                            @"teamId" : teamId};
    
    [[NetworkController sharedInstance] makeApiGetRequest:methodCall
                                            toEndPointUrl:( usingSSL ? self.httpsEndPoint : self.httpEndPoint)
                                           withParameters:param
                                    withCompletionHandler:^(NSObject *results) {
                                        if (results != nil) {
                                            NSArray *json = (NSArray*)results;
                                            
                                            [[TeamCowboyService sharedService] createMultipleTeamMembersIfNecessaryElseUpdate:json forTeam:teamId];

                                        }
                                    }];
}

#pragma mark - Event_GetAttendanceList
-(void)eventGetAttendanceList:(NSString*)eventId forTeamId:(NSString*)teamId {
    NSString *methodCall = @"Event_GetAttendanceList";
    BOOL usingSSL = false;
    
    NSString *userToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];
    
    NSDictionary *param = @{@"method" : methodCall,
                            @"timestamp" : self.timestamp,
                            @"nonce" : self.nonce,
                            @"userToken" : userToken,
                            @"teamId" : teamId,
                            @"eventId" : eventId};
    
    [[NetworkController sharedInstance] makeApiGetRequest:methodCall
                                            toEndPointUrl:( usingSSL ? self.httpsEndPoint : self.httpEndPoint)
                                           withParameters:param
                                    withCompletionHandler:^(NSObject *results) {
                                        if (results != nil) {
                                            NSDictionary *json = (NSDictionary*)results;

                                            [[TeamCowboyService sharedService] updateRsvpsForEvent:eventId withJson:json];                                            
                                        }
                                    }];
}


#pragma mark - Event_SaveRSVP
-(void)eventSaveRsvp:(NSString*)rsvp forTeam:(NSString*)teamId forEvent:(NSString*)eventId addlMale:(NSString*)addlMale addlFemale:(NSString*)addlFemale withComments:(NSString*)comments rsvpAsUserId:(NSString*)rsvpAsUserId {
    
    NSString *methodCall = @"Event_SaveRSVP";
    BOOL usingSSL = false;
    
    NSString *userToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];

    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:@{@"method" : methodCall,
                                                                                  @"timestamp" : self.timestamp,
                                                                                  @"nonce" : self.nonce,
                                                                                  @"userToken" : userToken,
                                                                                  @"teamId" : teamId,
                                                                                   @"eventId" : eventId}];
    if ([addlMale isEqualToString:@""] || addlMale == nil) {
        [param setObject:@"0" forKey:@"addlMale"];
    } else {
        [param setObject:addlMale forKey:@"addlMale"];
    }

    if ([addlFemale isEqualToString:@""] || addlFemale == nil) {
        [param setObject:@"0" forKey:@"addlFemale"];
    } else {
        [param setObject:addlFemale forKey:@"addlFemale"];
    }
    
    if (comments == nil) {
        [param setObject:@"" forKey:@"comments"];
    } else {
        [param setObject:comments forKey:@"comments"];
    }
    
    if (![rsvpAsUserId isEqualToString:@""] && rsvpAsUserId != nil) {
        [param setObject:rsvpAsUserId forKey:@"rsvpAsUserId"];
    }

    
    
    [[NetworkController sharedInstance] makeApiPostRequest:methodCall
                                             toEndPointUrl:( usingSSL ? self.httpsEndPoint : self.httpEndPoint)
                                            withParameters:param
                                     withCompletionHandler:^(NSObject *results) {
                                         
                                         NSLog(@"%@", results);

                                     }];
}


@end
