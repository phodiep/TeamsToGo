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

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic) BOOL largeScreen;

@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *viewTitle;
@property (strong, nonatomic) UIButton *menuButton;
@property (strong, nonatomic) NSDictionary *views;
@property (strong, nonatomic) NSArray *events;

@property (strong, nonatomic) Team *filterTeam;
@property (strong, nonatomic) NSArray *teams;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSDate *lastUpdated;

@end

@implementation ScheduleViewController

-(void)loadView {
    self.rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    self.viewTitle = [[UILabel alloc]init];
    self.viewTitle.text = @"Schedule";
    self.viewTitle.font = [[Fonts alloc] titleFont];
    
    self.menuButton = [[UIButton alloc] init];
    [self.menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [self.menuButton addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
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

    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:0 views:self.views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[title]-[tableView]-55-|" options:NSLayoutFormatAlignAllCenterX metrics:0 views:self.views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[menu(22)]-(>=8)-[title]" options:0 metrics:0 views:self.views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[menu(22)]" options:0 metrics:0 views:self.views]];
    
    self.view = self.rootView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        self.largeScreen = true;
    } else {
        self.largeScreen = false;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = (Event*)self.events[indexPath.row];
    
    EventViewController *eventVC = [[EventViewController alloc] init];
    
    eventVC.event = event;
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
    [self presentViewController:eventVC animated:true completion:nil];
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        self.filterTeam = nil;
    } else {
        self.filterTeam = self.teams[buttonIndex -1];
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
