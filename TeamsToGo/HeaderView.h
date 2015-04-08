//
//  HeaderView.h
//  TeamsToGo
//
//  Created by Pho Diep on 4/7/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *subHeaderView;

@property (strong, nonatomic) UILabel *eventTitle;
@property (strong, nonatomic) UILabel *eventTime;
@property (strong, nonatomic) UILabel *comments;
@property (strong, nonatomic) UILabel *locationName;
@property (strong, nonatomic) UILabel *locationAddress;

-(void)setupObjectsForAutolayout;

@end
