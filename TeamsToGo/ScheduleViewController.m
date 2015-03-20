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

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BOOL largeScreen;

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDictionary *views;
@property (strong, nonatomic) NSArray *events;

@end

@implementation ScheduleViewController

-(void)loadView {
    self.rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];

    self.context = [[CoreDataStack alloc] init].managedObjectContext;
    [[TeamCowboyClient alloc] userGetTeamEvents];
    [self getEventSchedule];
    
    
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

}

-(void)getEventSchedule {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    
    NSError *fetchError = nil;
    self.events = [self.context executeFetchRequest:fetchRequest error:&fetchError];
    NSLog(@"%lu", (unsigned long)[self.events count]);
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

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

-(NSString*)formatDate:(NSDate*)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, MMM d yy 'at' h:mm aaa"];
    return [dateFormat stringFromDate:date];
}

@end
