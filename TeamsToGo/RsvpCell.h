//
//  RsvpCell.h
//  TeamsToGo
//
//  Created by Pho Diep on 3/31/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RsvpCell : UITableViewCell

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UILabel *typeLabel;
@property (strong, nonatomic) UILabel *comments;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
