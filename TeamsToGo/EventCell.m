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
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[cell]-13-|" options:0 metrics:0 views:self.views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[cell]-13-|" options:0 metrics:0 views:self.views]];
    
    [self.cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[dateTimeLabel]-8-[teamLabel]-8-[ownTeamColor(20)]-8-[otherTeamColor(20)]-8-[locationLabel]-8-[eventStatus]-[status]-16-|" options:0 metrics:0 views:self.views]];
    
    [self.cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[dateTimeLabel]-(>=8)-[userStatus]-16-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:self.views]];
    [self.cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[teamLabel]" options:0 metrics:0 views:self.views]];
    [self.cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[ownTeamColor(20)]-8-[ownTeamLabel]-8-[homeAwayLabel]-(>=16)-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:self.views]];
    [self.cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[otherTeamColor(20)]-8-[otherTeamLabel]-(>=16)-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:self.views]];
    [self.cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[locationLabel]-(>=16)-|" options:0 metrics:0 views:self.views]];
    [self.cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[eventStatus]-(>=16)-|" options:0 metrics:0 views:self.views]];
    [self.cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[status]-|" options:0 metrics:0 views:self.views]];

}

-(void)applyAutolayoutLarge {
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[cell]-13-|" options:0 metrics:0 views:self.views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[cell]-13-|" options:0 metrics:0 views:self.views]];
    
    [self.cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[dateTimeLabel]-8-[teamLabel]-8-[ownTeamColor(20)]-8-[locationLabel]-8-[eventStatus]-[status]-16-|" options:0 metrics:0 views:self.views]];
    [self.cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[otherTeamColor(20)]" options:0 metrics:0 views:self.views]];
    
    [self.cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[dateTimeLabel]-(>=8)-[userStatus]-16-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:self.views]];
    [self.cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-24-[teamLabel]" options:0 metrics:0 views:self.views]];
    [self.cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[ownTeamColor(20)]-8-[ownTeamLabel]-8-[homeAwayLabel]-[otherTeamColor(20)]-8-[otherTeamLabel]-(>=16)-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:self.views]];
    [self.cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[locationLabel]-(>=16)-|" options:0 metrics:0 views:self.views]];
    [self.cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[eventStatus]-(>=16)-|" options:0 metrics:0 views:self.views]];
    [self.cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[status]-|" options:0 metrics:0 views:self.views]];
}


-(void)initAllObjects {
    self.cell = [[UIView alloc] init];
    self.cell.backgroundColor = [UIColor whiteColor];
    [self.cell.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.cell.layer setBorderWidth:0.5];
    
    self.cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.cell.layer.shadowOffset = CGSizeMake(5, 5);
    self.cell.layer.shadowOpacity = 1.0;
    self.cell.layer.shadowRadius = 1.0;

    
    self.dateTimeLabel = [[UILabel alloc] init];
    
    
    self.teamLabel = [[UILabel alloc] init];
    self.locationLabel = [[UILabel alloc] init];
    self.userStatus = [[UILabel alloc] init];
    self.eventStatus = [[UILabel alloc] init];
    self.ownTeamLabel = [[UILabel alloc] init];
    self.homeAwayLabel = [[UILabel alloc] init];
    self.otherTeamLabel = [[UILabel alloc] init];
    self.statusLabel = [[UILabel alloc] init];
    
    self.ownTeamColor = [[UILabel alloc] init];
    [self.ownTeamColor.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.ownTeamColor.layer setBorderWidth:0.5];
    
    self.otherTeamColor = [[UILabel alloc] init];
    [self.otherTeamColor.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.otherTeamColor.layer setBorderWidth:0.5];
    
    self.views = [[NSMutableDictionary alloc] init];
}

-(void)prepAllForAutoLayout {
    [self prepObjectForAutolayout:self.cell             addToSubview:self.contentView addToDictionary:@"cell"];
    [self prepObjectForAutolayout:self.dateTimeLabel    addToSubview:self.cell addToDictionary:@"dateTimeLabel"];
    [self prepObjectForAutolayout:self.teamLabel        addToSubview:self.cell addToDictionary:@"teamLabel"];
    [self prepObjectForAutolayout:self.locationLabel    addToSubview:self.cell addToDictionary:@"locationLabel"];
    [self prepObjectForAutolayout:self.userStatus       addToSubview:self.cell addToDictionary:@"userStatus"];
    [self prepObjectForAutolayout:self.eventStatus      addToSubview:self.cell addToDictionary:@"eventStatus"];
    [self prepObjectForAutolayout:self.ownTeamLabel     addToSubview:self.cell addToDictionary:@"ownTeamLabel"];
    [self prepObjectForAutolayout:self.homeAwayLabel    addToSubview:self.cell addToDictionary:@"homeAwayLabel"];
    [self prepObjectForAutolayout:self.otherTeamLabel   addToSubview:self.cell addToDictionary:@"otherTeamLabel"];
    [self prepObjectForAutolayout:self.ownTeamColor     addToSubview:self.cell addToDictionary:@"ownTeamColor"];
    [self prepObjectForAutolayout:self.otherTeamColor   addToSubview:self.cell addToDictionary:@"otherTeamColor"];
    [self prepObjectForAutolayout:self.statusLabel      addToSubview:self.cell addToDictionary:@"status"];
    
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
        case 0:
            self.statusLabel.text = self.event.rsvpStatusDisplayYes;
            break;
        case 1:
            self.statusLabel.text = self.event.rsvpStatusDisplayMaybe;
            break;
        case 2:
            self.statusLabel.text = self.event.rsvpStatusDisplayAvailable;
            break;
        case 3:
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
    
    self.homeAwayLabel.text = @"";
    if (self.event.homeAway == Home) {
        self.homeAwayLabel.text = @"(Home)";
    }
    if (self.event.homeAway == Away) {
        self.homeAwayLabel.text = @"(Away)";
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
    [dateFormat setDateFormat:@"EEEE, MMM d yy 'at' h:mm aaa"];
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
