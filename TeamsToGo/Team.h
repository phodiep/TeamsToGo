//
//  Team.h
//  TeamsToGo
//
//  Created by Pho Diep on 3/14/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Team : NSManagedObject

@property (nonatomic, retain) NSString * teamId;
@property (nonatomic, retain) NSString * activity;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) User *manager;
@end

@interface Team (CoreDataGeneratedAccessors)

- (void)addEventsObject:(NSManagedObject *)value;
- (void)removeEventsObject:(NSManagedObject *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
