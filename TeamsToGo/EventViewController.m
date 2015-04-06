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
#import "RsvpCell.h"
#import "Fonts.h"
#import "Location.h"

@interface EventViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic) CGFloat tableViewOriginalY;
@property (nonatomic) CGFloat tableViewOriginalHeight;

@property (strong, nonatomic) NSArray *headerTableViewConstraint;
@property (nonatomic) BOOL headerOverlapIsMaxed;

@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *eventTitle;
@property (strong, nonatomic) UILabel *eventTime;
@property (strong, nonatomic) UILabel *comments;

@property (strong, nonatomic) UILabel *locationName;
@property (strong, nonatomic) UILabel *locationAddress;

@property (strong, nonatomic) NSMutableDictionary *playersGrouped;
@property (strong, nonatomic) NSMutableArray *groupTypes;

@property (strong, nonatomic) NSDictionary *views;

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
    
    self.locationName = [[UILabel alloc] init];
    self.locationName.numberOfLines = 0;
    self.locationName.font = [[Fonts alloc] textFont];
    
    self.locationAddress = [[UILabel alloc] init];
    self.locationAddress.numberOfLines = 0;
    self.locationAddress.font = [[Fonts alloc] textFont];
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.backButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.headerView setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.eventTitle setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.eventTime setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.comments setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.locationName setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.locationAddress setTranslatesAutoresizingMaskIntoConstraints:false];

    [self.rootView addSubview:self.headerView];
    [self.rootView addSubview:self.tableView];
    
    [self.headerView addSubview:self.backButton];
    [self.headerView addSubview:self.eventTitle];
    [self.headerView addSubview:self.eventTime];
    [self.headerView addSubview:self.comments];
    [self.headerView addSubview:self.locationName];
    [self.headerView addSubview:self.locationAddress];
    
    self.views = @{@"tableview" : self.tableView,
                            @"back" : self.backButton,
                            @"header" : self.headerView,
                            @"eventTitle" : self.eventTitle,
                            @"eventTime" : self.eventTime,
                            @"comments" : self.comments,
                            @"location" : self.locationName,
                            @"address" : self.locationAddress};
    
//    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[header][tableview]|" options:0 metrics:0 views:self.views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[header]" options:0 metrics:0 views:self.views]];
    
    self.headerOverlapIsMaxed = false;
    [self setHeaderOverlap:0];
    
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableview]|" options:0 metrics:0 views:self.views]];

    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[header]|" options:0 metrics:0 views:self.views]];

    
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[eventTitle]-[eventTime]-[comments]-[location]-[address]-8-|" options:0 metrics:0 views:self.views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[back(20)]" options:0 metrics:0 views:self.views]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(28)-[eventTitle]-8-|" options:0 metrics:0 views:self.views]];

    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[back(20)]" options:0 metrics:0 views:self.views]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[eventTime]-8-|" options:0 metrics:0 views:self.views]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[comments]-8-|" options:0 metrics:0 views:self.views]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[location]-8-|" options:0 metrics:0 views:self.views]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[address]-8-|" options:0 metrics:0 views:self.views]];

    
    self.view = self.rootView;
}

-(void)setHeaderOverlap:(double)spacing {
    
    if (self.headerOverlapIsMaxed && spacing >= 80) {
        return;
    }
    
    //TODO: refactor for case: spacing (-) and header at max view... constraints would not need to be reset!
    
    self.headerOverlapIsMaxed = spacing >= 80;
    double constrainedValue = MAX(spacing, 0);
    constrainedValue = MIN(constrainedValue, 80);
    
    
    [self.rootView removeConstraints:self.headerTableViewConstraint];
    NSDictionary *metrics = @{@"space" : [NSNumber numberWithDouble:-constrainedValue] };
    self.headerTableViewConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[header]-(space)-[tableview]|" options:0 metrics:metrics views:self.views];
    [self.rootView addConstraints:self.headerTableViewConstraint];
    
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
    
    self.tableViewOriginalY = self.tableView.frame.origin.y;
    self.tableViewOriginalHeight = self.tableView.frame.size.height;
    
    [self groupRsvps];

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
    
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.groupTypes count];
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
    [dateFormat setDateFormat:@"EEEE, MMM d yy 'at' h:mm aaa"];
    return [dateFormat stringFromDate:date];
}


@end
