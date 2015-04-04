//
//  Rsvp.h
//  TeamsToGo
//
//  Created by Pho Diep on 4/4/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamMember.h"
#import "Event.h"

@interface Rsvp : NSObject

typedef NS_ENUM(NSInteger, Status) {
    Yes = 0,
    Maybe = 1,
    Available = 2,
    No = 3,
    NoResponse = 4
};


@property (strong, nonatomic) TeamMember *member;
@property (strong, nonatomic) NSString *addlFemale;
@property (strong, nonatomic) NSString *addlMale;
@property (strong, nonatomic) NSString *comments;
@property (nonatomic) Status status;

@end
