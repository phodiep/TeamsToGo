//
//  HeaderView.m
//  TeamsToGo
//
//  Created by Pho Diep on 4/7/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "HeaderView.h"
#import "Fonts.h"

@implementation HeaderView

-(instancetype)init {
    self = [super init];
    
    if (self) {
        
        [self setupInitAllObjects];
        
    }
    
    return self;
}


-(void)setupInitAllObjects {
    self.backgroundColor = [UIColor orangeColor];
    self.subHeaderView = [[UIView alloc] init];
    self.subHeaderView.backgroundColor = [UIColor clearColor];
    
    self.eventTitle = [[UILabel alloc] init];
    self.eventTitle.numberOfLines = 0;
    self.eventTitle.font = [[Fonts alloc] titleFont];
    self.eventTitle.textAlignment = NSTextAlignmentCenter;
    
    self.eventTime = [[UILabel alloc] init];
    self.eventTime.numberOfLines = 0;
    self.eventTime.font = [[Fonts alloc] textFont];
    self.eventTime.textAlignment = NSTextAlignmentCenter;
    
    self.comments = [[UILabel alloc] init];
    self.comments.numberOfLines = 0;
    self.comments.font = [[Fonts alloc] textFont];
    
    self.locationName = [[UILabel alloc] init];
    self.locationName.numberOfLines = 0;
    self.locationName.font = [[Fonts alloc] textFont];
    
    self.locationAddress = [[UILabel alloc] init];
    self.locationAddress.numberOfLines = 0;
    self.locationAddress.font = [[Fonts alloc] textFont];

}

-(void)setupObjectsForAutolayout {
    [self.subHeaderView setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.eventTitle setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.eventTime setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.comments setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.locationName setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.locationAddress setTranslatesAutoresizingMaskIntoConstraints:false];

    [self addSubview:self.eventTitle];
    [self addSubview:self.eventTime];
    [self addSubview:self.subHeaderView];
    
    [self.subHeaderView addSubview:self.comments];
    [self.subHeaderView addSubview:self.locationName];
    [self.subHeaderView addSubview:self.locationAddress];

    NSDictionary *views = @{@"subHeader" : self.subHeaderView,
                   @"eventTitle" : self.eventTitle,
                   @"eventTime" : self.eventTime,
                   @"comments" : self.comments,
                   @"location" : self.locationName,
                   @"address" : self.locationAddress
                   };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subHeader]|" options:0 metrics:0 views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[eventTitle]-[eventTime]-[subHeader]|" options:0 metrics:0 views:views]];
    [self.subHeaderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[comments]-[location]-[address]-8-|" options:0 metrics:0 views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-33-[eventTitle]-53-|" options:0 metrics:0 views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[eventTime]-8-|" options:0 metrics:0 views:views]];
    [self.subHeaderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[comments]-8-|" options:0 metrics:0 views:views]];
    [self.subHeaderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[location]-8-|" options:0 metrics:0 views:views]];
    [self.subHeaderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[address]-8-|" options:0 metrics:0 views:views]];

}

@end
