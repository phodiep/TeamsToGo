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

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

@property (nonatomic) BOOL largeScreen;

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDictionary *views;
@property (strong, nonatomic) NSArray *events;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSDate *lastUpdated;

@end

@implementation ScheduleViewController

-(void)loadView {
    self.rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    self.context = [[CoreDataStack alloc] init].managedObjectContext;
    [self deletePastEvents];
    
    
    UILabel *title = [[UILabel alloc]init];
    title.text = @"Schedule";
    title.font = [UIFont systemFontOfSize:20];
    
    self.tableView = [[UITableView alloc] init];
    
    [title setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.rootView addSubview:title];
    [self.rootView addSubview:self.tableView];
    
    self.views = @{@"title" : title,
                   @"tableView" : self.tableView};

    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:0 views:self.views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[title]-[tableView]-55-|" options:NSLayoutFormatAlignAllCenterX metrics:0 views:self.views]];
    
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
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

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
    
}

-(void)deletePastEvents {
    [[TeamCowboyService sharedService] deleteAllPastEvents];
}

-(void)getEventSchedule {
    self.events = [[TeamCowboyService sharedService] fetchAllFutureEvents];
}

-(void)makeApiRequestToGetFreshEvents {
    [[TeamCowboyClient alloc] userGetTeamEvents];
}

-(void)refreshSchedule {
    [self makeApiRequestToGetFreshEvents];
    [self getEventSchedule];
    
    [self.tableView reloadData];
    
    self.lastUpdated = [NSDate date];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Last Updated: %@", [self formatRefreshDate:self.lastUpdated]]];

}

-(void)manualRefreshSchedule {
    float minutesSinceLastUpdate = -[self.lastUpdated timeIntervalSinceNow]/60;
    
    float minimumMinutesBetweenUpdates = 1.0;
    
    if (minutesSinceLastUpdate >= minimumMinutesBetweenUpdates) {
        [self refreshSchedule];
    }
    
    [self.refreshControl endRefreshing];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.events count]>0) {
        return [self.events count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventCell *cell = (EventCell*)[self.tableView dequeueReusableCellWithIdentifier:@"EVENT_CELL" forIndexPath:indexPath];
    
    Event *event = (Event*)self.events[indexPath.row];
    
    cell.dateTimeLabel.text = [self formatDate:event.startTime];
    cell.teamLabel.text = [(Team*)event.team name];
    cell.locationLabel.text = @"here/there";
    //    self.userStatus = [[UILabel alloc] init];
    
    if (![event.status isEqualToString:@"active"]) {
        cell.eventStatus.text = [NSString stringWithFormat:@"Status: %@", event.status];
    } else {
        cell.eventStatus.text = @"";
    }
    
    cell.ownTeamLabel.text = [(Team*)event.team name];
    if (event.homeAway != nil && ![event.homeAway isEqualToString:@""]) {
        cell.homeAwayLabel.text = [NSString stringWithFormat:@"(%@) vs",event.homeAway];
    } else {
        cell.homeAwayLabel.text = @"";
    }
    cell.otherTeamLabel.text = event.title;
    
    if (event.teamColor != nil) {
        cell.ownTeamColor.backgroundColor = [Color colorFromHexString:event.teamColor];
        cell.ownTeamColor.text = @"";
    } else {
        cell.ownTeamColor.backgroundColor = [UIColor whiteColor];
        cell.ownTeamColor.textAlignment = NSTextAlignmentCenter;
        cell.ownTeamColor.text = @"?";
    }
    if (event.opponentColor != nil) {
        cell.otherTeamColor.backgroundColor = [Color colorFromHexString:event.opponentColor];
        cell.otherTeamColor.text = @"";
    } else {
        cell.otherTeamColor.backgroundColor = [UIColor whiteColor];
        cell.otherTeamColor.textAlignment = NSTextAlignmentCenter;
        cell.otherTeamColor.text = @"?";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = (Event*)self.events[indexPath.row];
    Team * team = (Team*)event.team;
    
    [[TeamCowboyClient sharedService] eventGetAttendanceList:event.eventId forTeamId:team.teamId];
    
    EventViewController *eventVC = [[EventViewController alloc] init];
    
    eventVC.event = event;

    [self presentViewController:eventVC animated:true completion:nil];
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

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
