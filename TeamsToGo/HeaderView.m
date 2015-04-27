//
//  HeaderView.m
//  TeamsToGo
//
//  Created by Pho Diep on 4/7/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "HeaderView.h"
#import "Fonts.h"
#import "Color.h"

@interface HeaderView ()

@property (strong, nonatomic) UILabel *eventTitle;
@property (strong, nonatomic) UILabel *eventTime;
@property (strong, nonatomic) UILabel *comments;
@property (strong, nonatomic) UILabel *locationName;
@property (strong, nonatomic) UILabel *locationAddress;

@property (strong, nonatomic) UILabel *yesCountsLabel;

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
    self.backgroundColor = [Color headerColor];
    self.subHeaderView = [[UIView alloc] init];
    self.subHeaderView.backgroundColor = [UIColor clearColor];
    
    self.eventTitle = [[UILabel alloc] init];
    self.eventTitle.numberOfLines = 0;
    self.eventTitle.font = [[Fonts alloc] titleFont];
    self.eventTitle.textAlignment = NSTextAlignmentCenter;
    self.eventTitle.textColor = [Color headerTextColor];
    
    self.eventTime = [[UILabel alloc] init];
    self.eventTime.numberOfLines = 0;
    self.eventTime.font = [[Fonts alloc] textFont];
    self.eventTime.textAlignment = NSTextAlignmentCenter;
    self.eventTime.textColor = [Color headerTextColor];
    
    self.comments = [[UILabel alloc] init];
    self.comments.numberOfLines = 0;
    self.comments.font = [[Fonts alloc] textFont];
    self.comments.textColor = [Color headerTextColor];
    
    self.locationName = [[UILabel alloc] init];
    self.locationName.numberOfLines = 0;
    self.locationName.font = [[Fonts alloc] textFont];
    self.locationName.textColor = [Color headerTextColor];
    
    self.locationAddress = [[UILabel alloc] init];
    self.locationAddress.numberOfLines = 0;
    self.locationAddress.font = [[Fonts alloc] textFont];
    self.locationAddress.textColor = [Color headerTextColor];
    
    self.yesCountsLabel = [[UILabel alloc] init];
    self.yesCountsLabel.numberOfLines = 0;
    self.yesCountsLabel.font = [[Fonts alloc] textFontBoldItalic];
    self.yesCountsLabel.textAlignment = NSTextAlignmentCenter;
    self.yesCountsLabel.textColor = [Color headerTextColor];
    
}

-(void)setupObjectsForAutolayout {
    [self.subHeaderView setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.eventTitle setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.eventTime setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.yesCountsLabel setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.comments setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.locationName setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.locationAddress setTranslatesAutoresizingMaskIntoConstraints:false];

    [self addSubview:self.eventTitle];
    [self addSubview:self.eventTime];
    [self addSubview:self.yesCountsLabel];
    [self addSubview:self.subHeaderView];
    
    [self.subHeaderView addSubview:self.comments];
    [self.subHeaderView addSubview:self.locationName];
    [self.subHeaderView addSubview:self.locationAddress];

    NSDictionary *views = @{@"subHeader" : self.subHeaderView,
                   @"eventTitle" : self.eventTitle,
                   @"eventTime" : self.eventTime,
                   @"yes" : self.yesCountsLabel,
                   @"comments" : self.comments,
                   @"location" : self.locationName,
                   @"address" : self.locationAddress
                   };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subHeader]|" options:0 metrics:0 views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[eventTitle]-[eventTime]-[yes]-[subHeader]|" options:0 metrics:0 views:views]];
    [self.subHeaderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[comments]-[location]-[address]-8-|" options:0 metrics:0 views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-33-[eventTitle]-53-|" options:0 metrics:0 views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[eventTime]-8-|" options:0 metrics:0 views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[yes]-8-|" options:0 metrics:0 views:views]];
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
        self.comments.text = [NSString stringWithFormat:@"Manager's Comments: %@", self.event.comments ];
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

-(void)setHeaderYesCounts {
    NSMutableString *yesCounts = [[NSMutableString alloc] initWithString:@""];
    
    if (![self.event.rsvpYesFemale isEqualToString:@"0"]) {
        [yesCounts appendString:[NSString stringWithFormat:@"Female (%@) ", self.event.rsvpYesFemale]];
    }
    if (![self.event.rsvpYesMale isEqualToString:@"0"]) {
        [yesCounts appendString:[NSString stringWithFormat:@"Male (%@) ", self.event.rsvpYesMale]];
    }
    if (![self.event.rsvpYesOther isEqualToString:@"0"]) {
        [yesCounts appendString:[NSString stringWithFormat:@"Other (%@)", self.event.rsvpYesOther]];
    }
    
    if (![yesCounts isEqualToString:@""]) {
        self.yesCountsLabel.text = [NSString stringWithFormat:@"RSVP'd Yes: %@", yesCounts];
    }

}

#pragma mark - misc
-(NSString*)formatDate:(NSDate*)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, MMM d yyyy '@' h:mm aaa"];
    return [dateFormat stringFromDate:date];
}


@end
