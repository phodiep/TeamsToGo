//
//  Event.m
//  TeamsToGo
//
//  Created by Pho Diep on 4/4/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "Event.h"

@implementation Event

-(void)updateTimestamp {
    self.timestamp = [NSDate date];
}


-(NSString*)getRsvpCountsForStatus:(NSString*)status andGender:(NSString*)gender {
    if ([status isEqualToString:@"Yes"]) {
        if ([gender isEqualToString:@"Male"]) {
            return self.rsvpYesMale;
        }
        if ([gender isEqualToString:@"Female"]) {
            return self.rsvpYesFemale;
        }
        if ([gender isEqualToString:@"Other"]) {
            return self.rsvpYesOther;
        }
    }
    
    if ([status isEqualToString:@"No"]) {
        if ([gender isEqualToString:@"Male"]) {
            return self.rsvpNoMale;
        }
        if ([gender isEqualToString:@"Female"]) {
            return self.rsvpNoFemale;
        }
        if ([gender isEqualToString:@"Other"]) {
            return self.rsvpNoOther;
        }
    }
    
    if ([status isEqualToString:@"No Response"]) {
        if ([gender isEqualToString:@"Male"]) {
            return self.rsvpNoResponseMale;
        }
        if ([gender isEqualToString:@"Female"]) {
            return self.rsvpNoResponseFemale;
        }
        if ([gender isEqualToString:@"Other"]) {
            return self.rsvpNoResponseOther;
        }
    }
    
    if ([status isEqualToString:@"Maybe"]) {
        if ([gender isEqualToString:@"Male"]) {
            return self.rsvpMaybeMale;
        }
        if ([gender isEqualToString:@"Female"]) {
            return self.rsvpMaybeFemale;
        }
        if ([gender isEqualToString:@"Other"]) {
            return self.rsvpMaybeOther;
        }
    }
    
    if ([status isEqualToString:@"Available"]) {
        if ([gender isEqualToString:@"Male"]) {
            return self.rsvpAvailableMale;
        }
        if ([gender isEqualToString:@"Female"]) {
            return self.rsvpAvailableFemale;
        }
        if ([gender isEqualToString:@"Other"]) {
            return self.rsvpAvailableOther;
        }
    }
    
    return nil;
}

@end
