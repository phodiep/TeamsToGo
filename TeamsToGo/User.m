//
//  User.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/12/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "User.h"

@interface User ()

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *gender;

@end

@implementation User

-(instancetype)initWithJson:(NSDictionary*)jsonDictionary {
    self = [super init];
    if (self) {
        self.userId = jsonDictionary[@"userId"];
        self.firstName = jsonDictionary[@"firstName"];
        self.lastName = jsonDictionary[@"lastName"];
        self.fullName = jsonDictionary[@"fullName"];
        self.displayName = jsonDictionary[@"displayName"];
        self.emailAddress = jsonDictionary[@"emailAddress1"];
        self.phone = jsonDictionary[@"phone1"];
        self.gender = jsonDictionary[@"gender"];
    }
    return self;
}

-(NSString*)fullName {
    return self.fullName;
}



@end
