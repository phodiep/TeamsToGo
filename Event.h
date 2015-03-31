//
//  Event.h
//  TeamsToGo
//
//  Created by Pho Diep on 3/30/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CountByStatus, Location, Rsvp, Team;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * comments;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSString * homeAway;
@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSString * opponentColor;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * teamColor;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) NSSet *rsvps;
@property (nonatomic, retain) Team *team;
@property (nonatomic, retain) NSSet *rsvpCount;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addRsvpsObject:(Rsvp *)value;
- (void)removeRsvpsObject:(Rsvp *)value;
- (void)addRsvps:(NSSet *)values;
- (void)removeRsvps:(NSSet *)values;

- (void)addRsvpCountObject:(CountByStatus *)value;
- (void)removeRsvpCountObject:(CountByStatus *)value;
- (void)addRsvpCount:(NSSet *)values;
- (void)removeRsvpCount:(NSSet *)values;

@end
