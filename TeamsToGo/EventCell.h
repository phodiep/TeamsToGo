//
//  EventCell.h
//  TeamsToGo
//
//  Created by Pho Diep on 3/18/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventCell : UITableViewCell

@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) Rsvp *userRsvp;


-(void)setCellValues;

@end
