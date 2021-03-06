//
//  TeamViewController.h
//  TeamsToGo
//
//  Created by Pho Diep on 3/27/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

@interface TeamViewController : UIViewController

@property (strong, nonatomic) Team *team;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
