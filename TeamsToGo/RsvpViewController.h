//
//  RsvpViewController.h
//  TeamsToGo
//
//  Created by Pho Diep on 4/7/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface RsvpViewController : UIViewController

@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) NSString *userId;

@end
