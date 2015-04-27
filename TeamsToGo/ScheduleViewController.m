//
//  ScheduleViewController.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/12/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "ScheduleViewController.h"
#import "CoreDataStack.h"
#import "TeamCowboyClient.h"
#import "Event.h"
#import "EventCell.h"
#import "Team.h"
#import "Color.h"
#import "TeamCowboyService.h"
#import "EventViewController.h"
#import "Fonts.h"

#pragma mark - Interface
@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic) BOOL largeScreen;

@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *viewTitle;
@property (strong, nonatomic) UIButton *menuButton;
@property (strong, nonatomic) NSDictionary *views;
@property (strong, nonatomic) NSArray *events;

@property (strong, nonatomic) NSMutableArray *rotationConstraints;

@property (strong, nonatomic) Team *filterTeam;
@property (strong, nonatomic) NSArray *teams;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSDate *lastUpdated;

@end

#pragma mark - Implemenation
@implementation ScheduleViewController

#pragma mark - UIViewController Lifecycle
-(void)loadView {
    self.rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    self.viewTitle = [[UILabel alloc]init];
    self.viewTitle.text = @"Schedule";
    self.viewTitle.font = [[Fonts alloc] titleFont];
    self.viewTitle.textAlignment = NSTextAlignmentCenter;
    self.viewTitle.textColor = [Color headerTextColor];
    self.viewTitle.backgroundColor = [Color headerColor];
    
    self.menuButton = [[UIButton alloc] init];
    [self.menuButton setImage:[UIImage imageNamed:@"menu_invert"] forState:UIControlStateNormal];
    [self.menuButton addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchDown];
    
    self.tableView = [[UITableView alloc] init];
    
    [self.viewTitle setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.menuButton setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.rootView addSubview:self.viewTitle];
    [self.rootView addSubview:self.tableView];
    [self.rootView addSubview:self.menuButton];
    
    self.views = @{@"title" : self.viewTitle,
                   @"tableView" : self.tableView,
                   @"menu" : self.menuButton};
    
    self.rotationConstraints = [[NSMutableArray alloc] init];
    
    self.view = self.rootView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        self.largeScreen = true;
    } else {
        self.largeScreen = false;
    }
    
    self.view.backgroundColor = [Color headerColor];
    
    [self.tableView registerClass: EventCell.class forCellReuseIdentifier:@"EVENT_CELL"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    [self getEventSchedule];
    self.lastUpdated = [NSDate date];

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Last Updated: %@", [self formatRefreshDate:self.lastUpdated]]];
    [self.refreshControl addTarget:self action:@selector(manualRefreshSchedule) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![self.events count]) {
        [self refreshSchedule];
    }
    [self getRsvpForEvents];
}


-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self applyRotationAutolayout];
}

-(void)applyRotationAutolayout {
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self.rootView removeConstraints:self.rotationConstraints];
    [self.rotationConstraints removeAllObjects];
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {

        [self.rotationConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:0 views:self.views]];
        [self.rotationConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[menu(25)]-[tableView]-50-|" options:0 metrics:0 views:self.views]],
        [self.rotationConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[menu(25)]-[title]-(38)-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:self.views] ];

        [self.rootView addConstraints:self.rotationConstraints];
        
    }
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        [self.rotationConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:0 views:self.views]];
        [self.rotationConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[menu(25)]-[tableView]-50-|" options:0 metrics:0 views:self.views]],
        [self.rotationConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[menu(25)]-[title]-(38)-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:self.views] ];
        
        [self.rootView addConstraints:self.rotationConstraints];
        
    }
    
}

-(void)getEventSchedule {
//    [[TeamCowboyService sharedService] deletePastEvents];
    [[TeamCowboyClient sharedService] userGetTeamEvents];
    
    self.teams = [[TeamCowboyService sharedService] fetchTeamsFromAllEvents];
    self.teams = [self.teams sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]]];
    
    if (self.filterTeam == nil) {
        self.events = [[TeamCowboyService sharedService] fetchAllEvents];
    } else {
        self.events = [[TeamCowboyService sharedService] fetchEventsForTeam:self.filterTeam];
    }
    
    [self.tableView reloadData];
    
}

-(void)getRsvpForEvents {
    
    //TODO: fix this for updating user status for each event
//    NSInteger rowIndex = 0;
//    for (Event *event in self.events) {
//        [[TeamCowboyClient sharedService] eventGetAttendanceList:event.eventId forTeamId:event.team.teamId];
//        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:rowIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//
//        rowIndex += 1;
//    }
}

-(void)refreshSchedule {
    [self getEventSchedule];
    
    [self.tableView reloadData];
    
    self.lastUpdated = [NSDate date];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Last Updated: %@", [self formatRefreshDate:self.lastUpdated]]];
    [self getRsvpForEvents];
}

-(void)manualRefreshSchedule {
    float minutesSinceLastUpdate = -[self.lastUpdated timeIntervalSinceNow]/60;
    
    float minimumMinutesBetweenUpdates = 1.0;
    
    if (minutesSinceLastUpdate >= minimumMinutesBetweenUpdates) {
        [self refreshSchedule];
    }
    
    [self.refreshControl endRefreshing];
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.events count]>0) {
        return [self.events count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventCell *cell = (EventCell*)[self.tableView dequeueReusableCellWithIdentifier:@"EVENT_CELL" forIndexPath:indexPath];
    
    Event *event = (Event*)self.events[indexPath.row];
    
    cell.event = event;
    [cell setCellValues];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = (Event*)self.events[indexPath.row];
    
    EventViewController *eventVC = [[EventViewController alloc] init];
    
    eventVC.event = event;
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
    [self presentViewController:eventVC animated:true completion:nil];
    
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        self.filterTeam = nil;
        self.viewTitle.text = @"Schedule";
    } else {
        Team *team = self.teams[buttonIndex -1];
        self.filterTeam = team;
        self.viewTitle.text = [NSString stringWithFormat:@"%@ Schedule", team.name];
    }
    [self refreshSchedule];
}

#pragma mark - button actions
-(void)menuButtonPressed {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.delegate = self;
    [actionSheet setTitle:@"Select Team To Show"];
    [actionSheet addButtonWithTitle:@"(Show All Teams)"];
    
    for (Team *team in self.teams) {
        [actionSheet addButtonWithTitle:team.name];
    }

    [actionSheet showInView:self.view];
}

#pragma mark - misc
-(NSString*)formatDate:(NSDate*)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, MMM d yy 'at' h:mm aaa"];
    return [dateFormat stringFromDate:date];
}

-(NSString*)formatRefreshDate:(NSDate*)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM d h:mm aaa"];
    return [dateFormat stringFromDate:date];
}

@end
