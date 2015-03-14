//
//  Rsvp.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/14/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "Rsvp.h"

@interface Rsvp ()

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *teamMemberType;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *addlMale;
@property (strong, nonatomic) NSString *addlFemale;
@property (strong, nonatomic) NSString *comments;

@end

@implementation Rsvp

- (instancetype)initWithJson:(NSDictionary*)json {
    self = [super init];
    if (self) {
        self.userId = json[@"userId"];
        self.displayName = json[@"displayName"];
        self.teamMemberType = json[@""];
        
        self.status = json[@"rsvpDetails"][@"statusDisplay"];
        self.addlMale = json[@"rsvpDetails"][@"addlMaleDisplay"];
        self.addlFemale = json[@"rsvpDetails"][@"addlFemaleDisplay"];
        self.comments = json[@"rsvpDetails"][@"comments"];
        
    }
    return self;
}

@end
