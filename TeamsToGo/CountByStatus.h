//
//  CountByStatus.h
//  TeamsToGo
//
//  Created by Pho Diep on 3/30/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface CountByStatus : NSManagedObject

@property (nonatomic, retain) NSNumber * male;
@property (nonatomic, retain) NSNumber * other;
@property (nonatomic, retain) NSNumber * female;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) Event *event;

@end
