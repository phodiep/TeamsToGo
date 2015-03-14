//
//  Location.h
//  TeamsToGo
//
//  Created by Pho Diep on 3/14/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * locationId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * googleMapsUrl;
@property (nonatomic, retain) NSDate * lastSignIn;
@property (nonatomic, retain) NSSet *events;
@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
