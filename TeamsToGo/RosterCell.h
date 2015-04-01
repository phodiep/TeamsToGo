//
//  RosterCell.h
//  TeamsToGo
//
//  Created by Pho Diep on 3/27/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RosterCell : UITableViewCell

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *phoneLabel;
@property (strong, nonatomic) UIImageView *phoneIcon;
@property (strong, nonatomic) UILabel *emailLabel;
@property (strong, nonatomic) UIImageView *emailIcon;

-(void)applyAutoLayout;
-(void)removeAutoLayout;

@end
