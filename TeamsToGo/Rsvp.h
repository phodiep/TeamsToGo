//
//  Rsvp.h
//  TeamsToGo
//
//  Created by Pho Diep on 3/14/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Rsvp : NSManagedObject

@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * addlMale;
@property (nonatomic, retain) NSString * addlFemale;
@property (nonatomic, retain) NSString * comments;
@property (nonatomic, retain) NSManagedObject *event;
@property (nonatomic, retain) User *user;

@end
