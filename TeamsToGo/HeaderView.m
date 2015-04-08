//
//  HeaderView.m
//  TeamsToGo
//
//  Created by Pho Diep on 4/7/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "HeaderView.h"
#import "Fonts.h"

@interface HeaderView ()

@property (strong, nonatomic) UILabel *eventTitle;
@property (strong, nonatomic) UILabel *eventTime;
@property (strong, nonatomic) UILabel *comments;
@property (strong, nonatomic) UILabel *locationName;
@property (strong, nonatomic) UILabel *locationAddress;

@end

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

-(void)setHeaderValues {

    NSMutableString *title = [[NSMutableString alloc] initWithString:self.event.team.name];
    
    switch (self.event.homeAway) {
        case Home:
            [title appendString:@" (Home)"];
            break;
        case Away:
            [title appendString:@" (Away)"];
            break;
        default:
            break;
    }
    
    if (![self.event.title isEqualToString:@""]) {
        [title appendString:[NSString stringWithFormat:@"\nvs. %@", self.event.title]];
    }
    
    self.eventTitle.text = title;
    
    self.eventTime.text = [self formatDate:self.event.startTime];
    if (self.event.comments != nil) {
        self.comments.text = [NSString stringWithFormat:@"Comments: %@", self.event.comments ];
    }
    
    if (self.event.location != nil) {
        Location *location = (Location*)self.event.location;
        
        self.locationName.text = location.name;
        NSMutableString *address = [[NSMutableString alloc] initWithString:location.address];
        
        if (![location.city isEqualToString:@""]) {
            [address appendString:[NSString stringWithFormat:@", %@", location.city]];
        }
        if (![location.partOfTown isEqualToString:@""]) {
            [address appendString:[NSString stringWithFormat:@"\n%@", location.partOfTown]];
        }
        
        self.locationAddress.text = address;
    }

}

#pragma mark - misc
-(NSString*)formatDate:(NSDate*)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, MMM d yyyy '@' h:mm aaa"];
    return [dateFormat stringFromDate:date];
}


@end
