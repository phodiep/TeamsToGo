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

typedef enum {
    Yes,
    Maybe,
    Available,
    No,
    NoResponse
} Status;

@property (strong, nonatomic) TeamMember *member;
@property (strong, nonatomic) NSString *addlFemale;
@property (strong, nonatomic) NSString *addlMale;
@property (strong, nonatomic) NSString *comments;
@property (nonatomic) Status status;

@end
