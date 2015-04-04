//
//  User.h
//  TeamsToGo
//
//  Created by Pho Diep on 4/4/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

typedef NS_ENUM(NSInteger, Gender) {
    Male = 0,
    Female = 1,
    Other = 2
};

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) Gender gender;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSDate *lastUpdate;

@property (strong, nonatomic) NSDate *timestamp;

-(void)updateTimestamp;

@end
