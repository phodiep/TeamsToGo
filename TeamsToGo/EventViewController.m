//
//  EventViewController.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/30/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "EventViewController.h"
#import "TeamCowboyService.h"
#import "TeamCowboyClient.h"
#import "Event.h"
#import "User.h"
#import "Team.h"
#import "Color.h"
#import "RsvpCell.h"
#import "Fonts.h"
#import "Location.h"
#import "RsvpViewController.h"
#import "HeaderView.h"

#pragma mark - Interface
@interface EventViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *headerTableViewConstraint;
@property (nonatomic) BOOL headerOverlapIsMaxed;

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *rsvpButton;
@property (strong, nonatomic) UILabel *rsvpLabel;

@property (strong, nonatomic) HeaderView *headerView;

@property (strong, nonatomic) NSMutableDictionary *playersGrouped;
@property (strong, nonatomic) NSMutableArray *groupTypes;

@property (strong, nonatomic) NSDictionary *views;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSDate *lastUpdated;

@end

#pragma mark - Implementation
@implementation EventViewController

#pragma mark - UIViewController Lifecycle
-(void)loadView {
    self.rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    self.tableView = [[UITableView alloc] init];
    
    self.backButton = [[UIButton alloc] init];
    [self.backButton setImage:[UIImage imageNamed:@"back_invert"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.rsvpButton = [[UIButton alloc] init];
    [self.rsvpButton addTarget:self action:@selector(rsvpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.rsvpLabel = [[UILabel alloc] init];
    self.rsvpLabel.text = @"RSVP";
    self.rsvpLabel.textColor = [Color headerTextColor];
    self.rsvpLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:10];
    self.rsvpLabel.textAlignment = NSTextAlignmentCenter;
    
    self.headerView = [[HeaderView alloc] init];
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.backButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.rsvpButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.rsvpLabel setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.headerView setTranslatesAutoresizingMaskIntoConstraints:false];

    [self.rootView addSubview:self.headerView];
    [self.rootView addSubview:self.tableView];
    
    [self.headerView addSubview:self.backButton];
    [self.headerView addSubview:self.rsvpButton];
    [self.headerView addSubview:self.rsvpLabel];
    
    self.views = @{@"tableview" : self.tableView,
                   @"back" : self.backButton,
                   @"rsvp" : self.rsvpButton,
                   @"rsvpLabel" : self.rsvpLabel,
                   @"header" : self.headerView,
                   };
    
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[header]" options:0 metrics:0 views:self.views]];
    
    self.headerOverlapIsMaxed = false;
    [self setHeaderOverlap:0];
    
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableview]|" options:0 metrics:0 views:self.views]];

    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[header]|" options:0 metrics:0 views:self.views]];

    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[back(25)]" options:0 metrics:0 views:self.views]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rsvp(25)]-8-|" options:0 metrics:0 views:self.views]];

    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-17-[back(25)]" options:0 metrics:0 views:self.views]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-13-[rsvp(25)]-2-[rsvpLabel]" options:NSLayoutFormatAlignAllCenterX metrics:0 views:self.views]];
    
    [self.headerView setupObjectsForAutolayout];
    
    self.view = self.rootView;
}

-(void)setHeaderOverlap:(double)spacing {
    
    if (self.headerOverlapIsMaxed && spacing >= self.headerView.subHeaderView.frame.size.height) {
        return;
    }
    
    //TODO: refactor for case: spacing (-) and header at max view... constraints would not need to be reset!
    
    self.headerOverlapIsMaxed = spacing >= self.headerView.subHeaderView.frame.size.height;
    double constrainedValue = MAX(spacing, 0);
    constrainedValue = MIN(constrainedValue, self.headerView.subHeaderView.frame.size.height);
    
    
    [self.rootView removeConstraints:self.headerTableViewConstraint];
    NSDictionary *metrics = @{@"space" : [NSNumber numberWithDouble:-constrainedValue] };
    self.headerTableViewConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[header]-(space)-[tableview]|" options:0 metrics:metrics views:self.views];
    [self.rootView addConstraints:self.headerTableViewConstraint];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.rootView.backgroundColor = [Color headerColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:RsvpCell.class forCellReuseIdentifier:@"RSVP_CELL"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Last Updated: %@", [self formatRefreshDate:self.lastUpdated]]];
    [self.refreshControl addTarget:self action:@selector(manualRefreshList) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.headerView.event = self.event;
    [self.headerView setHeaderValues];

    [self refreshRsvpList];
}

-(void)refreshRsvpList {
    Event *event = (Event*)self.event;
    Team * team = (Team*)event.team;
    
    [[TeamCowboyClient sharedService] eventGetAttendanceList:event.eventId forTeamId:team.teamId];
    
    [self.headerView setHeaderYesCounts];
    
    Rsvp *userRsvp = [[TeamCowboyService sharedService] fetchRsvpForUserId:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forEvent:self.event];

    switch (userRsvp.status) {
        case Yes:
            [self.rsvpButton setBackgroundImage:[UIImage imageNamed:@"check_invert"] forState:UIControlStateNormal];
            break;
            
        case Maybe:
        case Available:
            [self.rsvpButton setBackgroundImage:[UIImage imageNamed:@"question_invert"] forState:UIControlStateNormal];
            break;
            
        case No:
            [self.rsvpButton setBackgroundImage:[UIImage imageNamed:@"crossmark_invert"] forState:UIControlStateNormal];
            break;
        default:
            [self.rsvpButton setBackgroundImage:nil forState:UIControlStateNormal];
            [self.rsvpButton layer].borderColor = [UIColor whiteColor].CGColor;
            [self.rsvpButton layer].borderWidth = 1.5;
            break;
    }
    
    [self groupRsvps];
    
    [self.tableView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
    self.lastUpdated = [NSDate date];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Last Updated: %@", [self formatRefreshDate:self.lastUpdated]]];
}

-(void)manualRefreshList {
    float minutesSinceLastUpdate = -[self.lastUpdated timeIntervalSinceNow]/60;
    
    float minimumMinutesBetweenUpdates = 1.0;
    
    if (minutesSinceLastUpdate >= minimumMinutesBetweenUpdates) {
        [self refreshRsvpList];
    }
    
    [self.refreshControl endRefreshing];
    
}


#pragma mark - UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.groupTypes count];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *status = [self getStatus:self.groupTypes[section]];
    NSString *gender = [self getGender:self.groupTypes[section]];
    NSString *sectionCount = [self.event getRsvpCountsForStatus:status andGender:gender];

    return [NSString stringWithFormat:@"%@ - %@ (%@)", status, gender, sectionCount];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.playersGrouped[self.groupTypes[section]] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *type = self.groupTypes[indexPath.section];
    Rsvp *rsvp = (Rsvp*)self.playersGrouped[type][indexPath.row];

    TeamMember *member = (TeamMember*)rsvp.member;
    User *user = (User*)member.user;

    RsvpCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RSVP_CELL" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableString *cellLabel = [[NSMutableString alloc] initWithString:user.name];
    
    if (![rsvp.addlFemale isEqualToString:@"0"] &&
        ![rsvp.addlMale isEqualToString:@"0"]) {
        [cellLabel appendString:[NSString stringWithFormat:@" (+%@ female%@ & +%@ male%@)",
                                 rsvp.addlFemale,
                                 [rsvp.addlFemale isEqualToString:@"1"] ? @"" : @"s",
                                 rsvp.addlMale,
                                 [rsvp.addlMale isEqualToString:@"1"] ? @"" : @"s"]];
    } else {
        if (![rsvp.addlFemale isEqualToString:@"0"]) {
            [cellLabel appendString:[NSString stringWithFormat:@" (+%@ female)", rsvp.addlFemale]];
        }
        if (![rsvp.addlMale isEqualToString:@"0"]) {
            [cellLabel appendString:[NSString stringWithFormat:@" (+%@ male)", rsvp.addlMale]];
        }
    }
    
    if (![rsvp.comments isEqualToString:@""]) {
        cell.comments.text = [NSString stringWithFormat:@"\"%@\"", rsvp.comments];
    } else {
        cell.comments.text = @"";
    }
    
    if (![member.memberType isEqualToString:@"Full-time"] && ![member.memberType isEqualToString:@""]) {
        cell.typeLabel.text = [NSString stringWithFormat:@"(%@)", member.memberType];
    } else {
        cell.typeLabel.text = @"";
    }
    
    cell.label.text = cellLabel;

    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    NSString *status = [self getStatus:self.groupTypes[section]];
    NSString *gender = [self getGender:self.groupTypes[section]];
    NSString *sectionCount = [self.event getRsvpCountsForStatus:status andGender:gender];
    
    //---------------------
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    
    [header addSubview:headerLabel];
    
    if ([status isEqualToString:@"Yes"]) {
        header.backgroundColor = [UIColor blueColor];
    } else if ([status isEqualToString:@"No"]) {
        header.backgroundColor = [UIColor blackColor];
    } else {
        header.backgroundColor = [UIColor lightGrayColor];
    }
    
    headerLabel.textColor = [UIColor whiteColor];
    [headerLabel setFont:[[Fonts alloc] headerFont]];
    
    headerLabel.text = [NSString stringWithFormat:@"%@ - %@ (%@)", status, gender, sectionCount];
    
    return header;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGPoint scrollPos = scrollView.contentOffset;
    
    //scroll from origin down ... move table up and make bigger ... until
    if (scrollPos.y > 0) {
        [self setHeaderOverlap: scrollPos.y];
    } else {
        [self setHeaderOverlap: 0];
    }
}


#pragma mark - group rsvps by type
-(void)groupRsvps {
    self.playersGrouped = [[NSMutableDictionary alloc] init];
    self.groupTypes = [[NSMutableArray alloc] init];

    //sort by 1) Status   2) Gender  3) Name

    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"member.user.name" ascending:YES];
    NSArray *sortedRsvps = [self.event.rsvps sortedArrayUsingDescriptors:@[sort]];
    
    for (Rsvp* rsvp in sortedRsvps) {
        
        //check if they exist in groupTypes
        
        NSMutableString *statusGender = [[NSMutableString alloc] init];
        
        switch (rsvp.status) {
            case Yes:
                [statusGender appendString:@"yes_"];
                break;
            case No:
                [statusGender appendString:@"no_"];
                break;
            case Available:
                [statusGender appendString:@"available_"];
                break;
            case Maybe:
                [statusGender appendString:@"maybe_"];
                break;
            case NoResponse:
                [statusGender appendString:@"noresponse_"];
                break;
            default:
                break;
        }
        
        switch (rsvp.member.user.gender) {
            case Male:
                [statusGender appendString:@"m"];
                break;
            case Female:
                [statusGender appendString:@"f"];
                break;
            case Other:
                [statusGender appendString:@"other"];
                break;
            default:
                break;
        }
        
        if (![self.groupTypes containsObject:statusGender]) {
            [self.groupTypes addObject:statusGender];
        }

        //check dictionary
        if (![self.playersGrouped objectForKey:statusGender]) {
            [self.playersGrouped setObject:[[NSMutableArray alloc] initWithArray:@[rsvp]]
                                    forKey:statusGender];
        } else {
            [self.playersGrouped[statusGender] addObject:rsvp];
        }
    }
    
    NSArray *sortOrderStatus = @[@"yes_m", @"yes_f", @"yes_other",
                                 @"maybe_m", @"maybe_f", @"maybe_other",
                                 @"available_m", @"available_f", @"available_other",
                                 @"no_m", @"no_f", @"no_other",
                                 @"noresponse_m", @"noresponse_f", @"noresponse_other"];
    
    [self.groupTypes sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSUInteger indexOfObj1 = [sortOrderStatus indexOfObject: obj1];
        NSUInteger indexOfObj2 = [sortOrderStatus indexOfObject: obj2];
        
        if (indexOfObj1 == NSNotFound && indexOfObj2 == NSNotFound){
            return NSOrderedSame;
        } else if (indexOfObj1 != NSNotFound && indexOfObj2 == NSNotFound){
            return NSOrderedAscending;
        } else if (indexOfObj1 == NSNotFound && indexOfObj2 != NSNotFound){
            return NSOrderedDescending;
        } else if (indexOfObj1 > indexOfObj2){
            return NSOrderedDescending;
        }
        
        return NSOrderedAscending;
    }];
    
}

#pragma mark - button actions
-(void)backButtonPressed {
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)rsvpButtonPressed {
    RsvpViewController *rsvpVC = [[RsvpViewController alloc] init];
    rsvpVC.event = self.event;
    rsvpVC.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    [self presentViewController:rsvpVC animated:true completion:nil];
    
}

#pragma mark - misc
-(NSString*)getGender:(NSString*)originalString {
    NSDictionary *fullstring = @{@"m" : @"Male",
                                 @"f" : @"Female",
                                 @"other" : @"Other"};
    if (![originalString isEqualToString:@""]) {
        NSString * shortstring = [originalString componentsSeparatedByString:@"_"][1];
        return fullstring[shortstring];
    }
    return nil;
}

-(NSString*)getStatusShort:(NSString*)originalString {
    return [originalString componentsSeparatedByString:@"_"][0];
}

-(NSString*)getStatus:(NSString*)originalString {
    NSDictionary *fullstring = @{@"yes" : @"Yes",
                                 @"maybe" : @"Maybe",
                                 @"available" : @"Available",
                                 @"no" : @"No",
                                 @"noresponse" : @"No Response"};
    if (![originalString isEqualToString:@""]) {
        NSString *shortstring = [originalString componentsSeparatedByString:@"_"][0];
        return fullstring[shortstring];
    }
    return nil;
}

-(NSString*)formatDate:(NSDate*)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, MMM d yyyy '@' h:mm aaa"];
    return [dateFormat stringFromDate:date];
}

-(NSString*)formatRefreshDate:(NSDate*)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM d h:mm aaa"];
    return [dateFormat stringFromDate:date];
}


@end
