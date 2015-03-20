//
//  EventCell.h
//  TeamsToGo
//
//  Created by Pho Diep on 3/18/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell

@property (strong, nonatomic) UILabel *dateTimeLabel;
@property (strong, nonatomic) UILabel *teamLabel;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UILabel *userStatus;
@property (strong, nonatomic) UILabel *eventStatus;
@property (strong, nonatomic) UILabel *ownTeamLabel;
@property (strong, nonatomic) UILabel *homeAwayLabel;
@property (strong, nonatomic) UILabel *otherTeamLabel;

@property (strong, nonatomic) UILabel *ownTeamColor;
@property (strong, nonatomic) UILabel *otherTeamColor;

@end
