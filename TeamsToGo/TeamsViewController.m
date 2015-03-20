//
//  TeamsViewController.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/12/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "CoreDataStack.h"
#import "TeamsViewController.h"
#import "Team.h"
#import "TeamCowboyClient.h"
#import "TeamCowboyService.h"

@interface TeamsViewController () <UITableViewDataSource>

@property (strong, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) NSMutableDictionary *views;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *teams;

@property (strong, nonatomic) NSDate *lastUpdated;

@end

@implementation TeamsViewController

-(void)loadView {
    self.tableView = [[UITableView alloc] init];
    self.teams = [[NSArray alloc]init];
    self.views = [[NSMutableDictionary alloc] init];
    self.rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"Teams";
    title.font = [UIFont systemFontOfSize:20];
    
    
    [[TeamCowboyClient sharedService] userGetTeams];
    
    [title setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.rootView addSubview:title];
    [self.rootView addSubview:self.tableView];
    
    [self.views setObject:title forKey:@"title"];
    [self.views setObject:self.tableView forKey:@"tableView"];
    
    [self.rootView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:0 views:self.views]];
    [self.rootView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[title]-[tableView]-55-|" options:NSLayoutFormatAlignAllCenterX metrics:0 views:self.views]];

    
    self.view = self.rootView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [[CoreDataStack alloc] init].managedObjectContext;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    
    [self getAllTeams];
    self.lastUpdated = [NSDate date];
    
    NSLog(@"Last Updated: %@",[self formatDate:self.lastUpdated]);
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Last Updated: %@", [self formatDate:self.lastUpdated]]];
    [refreshControl addTarget:self action:@selector(refreshTeamList:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self refreshTeamList];
}

-(void)getAllTeams {
    self.teams = [[TeamCowboyService sharedService] fetchAllTeams];
}

-(void)refreshTeamList:(UIRefreshControl*)refreshControl {
    float minutesSinceLastUpdate = -[self.lastUpdated timeIntervalSinceNow]/60;
    
    float minutesBetweenUpdates = 5.0; //will only update if more than 5 minutes have past since last update
    
    if (minutesSinceLastUpdate >= minutesBetweenUpdates) {
        NSLog(@"minutes since last update: %f", minutesSinceLastUpdate);
    
        [[TeamCowboyService sharedService] deleteAllTeamsFromCoreData];
        [[TeamCowboyClient sharedService] userGetTeams];
        [self getAllTeams];
    
        [self.tableView reloadData];
    
        self.lastUpdated = [NSDate date];

    }
    [refreshControl endRefreshing];
    
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.teams count] > 0) {
        return [self.teams count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [(Team*)self.teams[indexPath.row] name];
    
    return cell;
}

-(NSString*)formatDate:(NSDate*)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"h:mm aaa"];
    return [dateFormat stringFromDate:date];
}


@end
