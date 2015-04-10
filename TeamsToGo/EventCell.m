//
//  EventCell.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/18/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "EventCell.h"
#import "TeamCowboyService.h"
#import "Team.h"
#import "Color.h"
#import "Fonts.h"
#import "Rsvp.h"


@interface EventCell ()

@property (strong, nonatomic) UIView *cell;
@property (strong, nonatomic) NSMutableDictionary *views;

@property (strong, nonatomic) UILabel *dateTimeLabel;
@property (strong, nonatomic) UILabel *teamLabel;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UILabel *userStatus;
@property (strong, nonatomic) UILabel *eventStatus;
@property (strong, nonatomic) UILabel *ownTeamLabel;
@property (strong, nonatomic) UILabel *homeAwayLabel;
@property (strong, nonatomic) UILabel *otherTeamLabel;

@property (strong, nonatomic) UILabel *statusLabel;

@property (strong, nonatomic) UILabel *ownTeamColor;
@property (strong, nonatomic) UILabel *otherTeamColor;

@end

@implementation EventCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        [self initAllObjects];
        [self prepAllForAutoLayout];
        
        [self applyAutolayout];
    }
    
    return self;
}

-(void)applyAutolayout {
    [self initAllObjects];
    [self prepAllForAutoLayout];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[dateTimeLabel]-8-[teamLabel]-8-[ownTeamColor(20)]-8-[otherTeamColor(20)]-8-[locationLabel]-8-[eventStatus]-[status]-16-|" options:0 metrics:0 views:self.views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[dateTimeLabel]-(>=8)-[userStatus]-16-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:self.views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[teamLabel]" options:0 metrics:0 views:self.views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[ownTeamColor(20)]-8-[ownTeamLabel]-8-[homeAwayLabel]-(>=16)-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:self.views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[otherTeamColor(20)]-8-[otherTeamLabel]-(>=16)-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:self.views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[locationLabel]-(>=16)-|" options:0 metrics:0 views:self.views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[eventStatus]-(>=16)-|" options:0 metrics:0 views:self.views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[status]-|" options:0 metrics:0 views:self.views]];

}

-(void)applyAutolayoutLarge {
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[dateTimeLabel]-8-[teamLabel]-8-[ownTeamColor(20)]-8-[locationLabel]-8-[eventStatus]-[status]-16-|" options:0 metrics:0 views:self.views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[otherTeamColor(20)]" options:0 metrics:0 views:self.views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[dateTimeLabel]-(>=8)-[userStatus]-16-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:self.views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[teamLabel]" options:0 metrics:0 views:self.views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[ownTeamColor(20)]-8-[ownTeamLabel]-8-[homeAwayLabel]-[otherTeamColor(20)]-8-[otherTeamLabel]-(>=16)-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:self.views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[locationLabel]-(>=16)-|" options:0 metrics:0 views:self.views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[eventStatus]-(>=16)-|" options:0 metrics:0 views:self.views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[status]-|" options:0 metrics:0 views:self.views]];
}


-(void)initAllObjects {
    self.dateTimeLabel = [[UILabel alloc] init];
    self.dateTimeLabel.font = [[Fonts alloc] headerFont];
    
    self.teamLabel = [[UILabel alloc] init];
    self.teamLabel.font = [[Fonts alloc] textFont];
    
    self.locationLabel = [[UILabel alloc] init];
    self.locationLabel.font = [[Fonts alloc] textFontItalic];
    
    self.userStatus = [[UILabel alloc] init];
    
    self.eventStatus = [[UILabel alloc] init];
    self.eventStatus.font = [[Fonts alloc] textFontBoldItalic];

    self.ownTeamLabel = [[UILabel alloc] init];
    self.ownTeamLabel.font = [[Fonts alloc] textFont];
    
    self.homeAwayLabel = [[UILabel alloc] init];
    self.homeAwayLabel.font = [[Fonts alloc] textFont];
    
    self.otherTeamLabel = [[UILabel alloc] init];
    self.otherTeamLabel.font = [[Fonts alloc] textFont];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [[Fonts alloc] textFontItalic];
    self.statusLabel.textColor = [UIColor blueColor];
    
    self.ownTeamColor = [[UILabel alloc] init];
    [self.ownTeamColor.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.ownTeamColor.layer setBorderWidth:0.5];
    
    self.otherTeamColor = [[UILabel alloc] init];
    [self.otherTeamColor.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.otherTeamColor.layer setBorderWidth:0.5];
    
    self.views = [[NSMutableDictionary alloc] init];
}

-(void)prepAllForAutoLayout {
    [self prepObjectForAutolayout:self.dateTimeLabel    addToSubview:self.contentView addToDictionary:@"dateTimeLabel"];
    [self prepObjectForAutolayout:self.teamLabel        addToSubview:self.contentView addToDictionary:@"teamLabel"];
    [self prepObjectForAutolayout:self.locationLabel    addToSubview:self.contentView addToDictionary:@"locationLabel"];
    [self prepObjectForAutolayout:self.userStatus       addToSubview:self.contentView addToDictionary:@"userStatus"];
    [self prepObjectForAutolayout:self.eventStatus      addToSubview:self.contentView addToDictionary:@"eventStatus"];
    [self prepObjectForAutolayout:self.ownTeamLabel     addToSubview:self.contentView addToDictionary:@"ownTeamLabel"];
    [self prepObjectForAutolayout:self.homeAwayLabel    addToSubview:self.contentView addToDictionary:@"homeAwayLabel"];
    [self prepObjectForAutolayout:self.otherTeamLabel   addToSubview:self.contentView addToDictionary:@"otherTeamLabel"];
    [self prepObjectForAutolayout:self.ownTeamColor     addToSubview:self.contentView addToDictionary:@"ownTeamColor"];
    [self prepObjectForAutolayout:self.otherTeamColor   addToSubview:self.contentView addToDictionary:@"otherTeamColor"];
    [self prepObjectForAutolayout:self.statusLabel      addToSubview:self.contentView addToDictionary:@"status"];
    
}

-(void)prepObjectForAutolayout:(id)object addToSubview:(UIView*)view addToDictionary:(NSString*)reference {
    [object setTranslatesAutoresizingMaskIntoConstraints:false];
    [view addSubview:object];
    [self.views setObject:object forKey:reference];
}

-(void)setCellValues {
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    Rsvp *userRsvp = [[TeamCowboyService sharedService] fetchRsvpForUserId:userId forEvent:self.event];
    
    switch (userRsvp.status) {
        case Yes:
            self.statusLabel.text = self.event.rsvpStatusDisplayYes;
            break;
        case Maybe:
            self.statusLabel.text = self.event.rsvpStatusDisplayMaybe;
            break;
        case Available:
            self.statusLabel.text = self.event.rsvpStatusDisplayAvailable;
            break;
        case No:
            self.statusLabel.text = self.event.rsvpStatusDisplayNo;
            break;
        default:
            self.statusLabel.text = @"";
            break;
    }
    
    self.dateTimeLabel.text = [self formatDate:self.event.startTime];
    self.teamLabel.text = [(Team*)self.event.team name];
    self.locationLabel.text = self.event.location.name;
    
    if (![self.event.status isEqualToString:@"active"]) {
        self.eventStatus.text = [NSString stringWithFormat:@"Status: %@", self.event.status];
    } else {
        self.eventStatus.text = @"";
    }
    
    self.ownTeamLabel.text = [(Team*)self.event.team name];
    
    switch (self.event.homeAway) {
        case Home:
            self.homeAwayLabel.text = @"(Home)";
            break;
        case Away:
            self.homeAwayLabel.text = @"(Away)";
            break;
        default:
            self.homeAwayLabel.text = @"";
            break;
    }
    
    self.otherTeamLabel.text = self.event.title;
    
    if (self.event.teamColor != nil) {
        self.ownTeamColor.backgroundColor = [Color colorFromHexString:self.event.teamColor];
        self.ownTeamColor.text = @"";
    } else {
        self.ownTeamColor.backgroundColor = [UIColor whiteColor];
        self.ownTeamColor.textAlignment = NSTextAlignmentCenter;
        self.ownTeamColor.text = @"?";
    }
    if (self.event.opponentColor != nil) {
        self.otherTeamColor.backgroundColor = [Color colorFromHexString:self.event.opponentColor];
        self.otherTeamColor.text = @"";
    } else {
        self.otherTeamColor.backgroundColor = [UIColor whiteColor];
        self.otherTeamColor.textAlignment = NSTextAlignmentCenter;
        self.otherTeamColor.text = @"?";
    }

}

-(NSString*)formatDate:(NSDate*)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, MMM d yyyy '@' h:mm aaa"];
    return [dateFormat stringFromDate:date];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
