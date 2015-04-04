//
//  Team.h
//  TeamsToGo
//
//  Created by Pho Diep on 4/4/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Team : NSObject

@property (strong, nonatomic) NSString *teamId;
@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *displayMale;
@property (strong, nonatomic) NSString *displayFemale;
@property (strong, nonatomic) NSString *displayOther;

@property (strong, nonatomic) NSDate *lastUpdate;

@property (strong, nonatomic) NSDate *timestamp;

-(void)updateTimestamp;

@end
