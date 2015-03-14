//
//  User.h
//  TeamsToGo
//
//  Created by Pho Diep on 3/14/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSSet *teamManager;
@property (nonatomic, retain) NSSet *rsvps;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addTeamManagerObject:(NSManagedObject *)value;
- (void)removeTeamManagerObject:(NSManagedObject *)value;
- (void)addTeamManager:(NSSet *)values;
- (void)removeTeamManager:(NSSet *)values;

- (void)addRsvpsObject:(NSManagedObject *)value;
- (void)removeRsvpsObject:(NSManagedObject *)value;
- (void)addRsvps:(NSSet *)values;
- (void)removeRsvps:(NSSet *)values;

@end
