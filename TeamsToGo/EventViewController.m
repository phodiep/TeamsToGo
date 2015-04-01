//
//  EventViewController.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/30/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "EventViewController.h"
#import "TeamCowboyService.h"
#import "Event.h"
#import "User.h"
#import "Team.h"
#import "Rsvp.h"
#import "RsvpCell.h"
#import "CountByStatus.h"
#import "Fonts.h"

@interface EventViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *rsvps;
@property (strong, nonatomic) NSArray *counts;

@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *eventTitle;
@property (strong, nonatomic) UILabel *eventTime;
@property (strong, nonatomic) UILabel *comments;

@property (strong, nonatomic) NSMutableDictionary *playersGrouped;
@property (strong, nonatomic) NSMutableArray *groupTypes;


@end

@implementation EventViewController

-(void)loadView {
    self.rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    self.tableView = [[UITableView alloc] init];
    self.backButton = [[UIButton alloc] init];
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor orangeColor];
    
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
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.backButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.headerView setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.eventTitle setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.eventTime setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.comments setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.rootView addSubview:self.tableView];
    [self.rootView addSubview:self.backButton];
    [self.rootView addSubview:self.headerView];
    [self.headerView addSubview:self.eventTitle];
    [self.headerView addSubview:self.eventTime];
    [self.headerView addSubview:self.comments];
    
    NSDictionary *views = @{@"tableview" : self.tableView,
                            @"back" : self.backButton,
                            @"header" : self.headerView,
                            @"eventTitle" : self.eventTitle,
                            @"eventTime" : self.eventTime,
                            @"comments" : self.comments};
    
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[back(20)]-[header][tableview]|" options:0 metrics:0 views:views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableview]|" options:0 metrics:0 views:views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[back(20)]" options:0 metrics:0 views:views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[header]|" options:0 metrics:0 views:views]];
    
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[eventTitle]-[eventTime]-[comments]-8-|" options:0 metrics:0 views:views]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[eventTitle]-8-|" options:0 metrics:0 views:views]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[eventTime]-8-|" options:0 metrics:0 views:views]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[comments]-8-|" options:0 metrics:0 views:views]];
    
    self.view = self.rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.rootView.backgroundColor = [UIColor yellowColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:RsvpCell.class forCellReuseIdentifier:@"RSVP_CELL"];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.rsvps = [[TeamCowboyService sharedService] fetchRsvpByEvent:self.event];
    self.counts = [[TeamCowboyService sharedService] fetchCountByStatus:self.event];
    
    [self groupRsvps];

    NSMutableString *title = [[NSMutableString alloc] initWithString:self.event.team.name];
    
    if (![self.event.homeAway isEqualToString:@""]) {
        [title appendString:[NSString stringWithFormat:@" (%@)", self.event.homeAway]];
    }
    
    if (![self.event.title isEqualToString:@""]) {
        [title appendString:[NSString stringWithFormat:@" vs. %@", self.event.title]];
    }
    
    self.eventTitle.text = title;
    
    self.eventTime.text = [self formatDate:self.event.startTime];
    if (self.event.comments != nil) {
        self.comments.text = [NSString stringWithFormat:@"Comments: %@", self.event.comments ];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.groupTypes count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *status = [self getStatus:self.groupTypes[section]];
    NSString *gender = [self getGender:self.groupTypes[section]];
    NSMutableString *sectionCount;
    
    CountByStatus* count = [self getCountByStatus: [self getStatusShort:self.groupTypes[section]]];
    
    if ([gender isEqualToString:@"Female"]) {
        sectionCount = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@", count.female]];
    } else if ([gender isEqualToString:@"Male"]) {
        sectionCount = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@", count.male]];
    } else if ([gender isEqualToString:@"Other"]) {
        sectionCount = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@", count.other]];
    }

    return [NSString stringWithFormat:@"%@ - %@ (%@)", status, gender, sectionCount];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.playersGrouped[self.groupTypes[section]] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *type = self.groupTypes[indexPath.section];
    Rsvp *rsvp = (Rsvp*)self.playersGrouped[type][indexPath.row];

    RsvpCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RSVP_CELL" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableString *cellLabel = [[NSMutableString alloc] initWithString:rsvp.user.name];
    
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
    }
    
    cell.label.text = cellLabel;

    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    NSString *status = [self getStatus:self.groupTypes[section]];
    NSString *gender = [self getGender:self.groupTypes[section]];
    NSMutableString *sectionCount;
    
    CountByStatus* count = [self getCountByStatus: [self getStatusShort:self.groupTypes[section]]];
    
    if ([gender isEqualToString:@"Female"]) {
        sectionCount = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@", count.female]];
    } else if ([gender isEqualToString:@"Male"]) {
        sectionCount = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@", count.male]];
    } else if ([gender isEqualToString:@"Other"]) {
        sectionCount = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@", count.other]];
    }
    
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

#pragma mark - group rsvps by type
-(void)groupRsvps {
    self.playersGrouped = [[NSMutableDictionary alloc] init];
    self.groupTypes = [[NSMutableArray alloc] init];

    //sort by 1) Status   2) Gender
    
    for (Rsvp* rsvp in self.rsvps) {
        
        //check if they exist in groupTypes
        
        NSString *statusGender = [NSString stringWithFormat:@"%@_%@", rsvp.status, rsvp.user.gender];
        
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

-(CountByStatus*)getCountByStatus:(NSString*)status {
    for (CountByStatus *count in self.counts) {
        if ([count.status isEqualToString: status]) {
            return count;
        }
    }
    return nil;
}

-(NSString*)formatDate:(NSDate*)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, MMM d yy 'at' h:mm aaa"];
    return [dateFormat stringFromDate:date];
}


@end
