//
//  TeamsViewController.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/12/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "CoreDataStack.h"
#import "Color.h"
#import "Fonts.h"
#import "TeamsViewController.h"
#import "Team.h"
#import "TeamCowboyClient.h"
#import "TeamCowboyService.h"
#import "TeamViewController.h"
#import "MessagesViewController.h"

@interface TeamsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) NSDictionary *views;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *teams;
@property (strong, nonatomic) UILabel *viewTitle;

@property (strong, nonatomic) NSMutableArray *rotationConstraints;

@property (strong, nonatomic) NSDate *lastUpdated;

@end

@implementation TeamsViewController

-(void)loadView {
    
    self.tableView = [[UITableView alloc] init];
    self.teams = [[NSArray alloc]init];
    self.views = [[NSMutableDictionary alloc] init];
    self.rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];

    
    self.viewTitle = [[UILabel alloc] init];
    self.viewTitle.text = @"Teams";
    self.viewTitle.font = [[Fonts alloc] titleFont];
    self.viewTitle.textColor = [Color headerTextColor];
    
    [self.viewTitle setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.rootView addSubview:self.viewTitle];
    [self.rootView addSubview:self.tableView];

    self.views = @{@"title" : self.viewTitle,
                   @"tableView" : self.tableView};
    
    self.rotationConstraints = [[NSMutableArray alloc] init];
    
    self.view = self.rootView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [Color headerColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self getAllTeams];
    self.lastUpdated = [NSDate date];
    
    NSLog(@"Last Updated: %@",[self formatRefreshDate:self.lastUpdated]);

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Last Updated: %@", [self formatRefreshDate:self.lastUpdated]]];
    [refreshControl addTarget:self action:@selector(refreshTeamList:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

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
        [self.rotationConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-28-[title]-[tableView]-50-|" options:NSLayoutFormatAlignAllCenterX metrics:0 views:self.views]];
        
        [self.rootView addConstraints:self.rotationConstraints];
        
    }
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        [self.rotationConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:0 views:self.views]];
        [self.rotationConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[title]-[tableView]-50-|" options:NSLayoutFormatAlignAllCenterX metrics:0 views:self.views]];
        
        [self.rootView addConstraints:self.rotationConstraints];
        
    }
    
}


-(void)getAllTeams {
    [[TeamCowboyClient sharedService] userGetTeams];
    NSArray *fetchedTeams = [[TeamCowboyService sharedService] fetchAllTeams];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    self.teams = [fetchedTeams sortedArrayUsingDescriptors:@[sort]];
}

-(void)refreshTeamList:(UIRefreshControl*)refreshControl {
    float minutesSinceLastUpdate = -[self.lastUpdated timeIntervalSinceNow]/60;
    
    float minimumMinutesBetweenUpdates = 1.0;
    
    if (minutesSinceLastUpdate >= minimumMinutesBetweenUpdates) {
        NSLog(@"minutes since last update: %f", minutesSinceLastUpdate);
        
        [self getAllTeams];
        [self.tableView reloadData];
        
        self.lastUpdated = [NSDate date];
        refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Last Updated: %@", [self formatRefreshDate:self.lastUpdated]]];
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
    
    Team *team = (Team*)self.teams[indexPath.row];
    cell.textLabel.text = team.name;
    
    return cell;
}

-(NSString*)formatRefreshDate:(NSDate*)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM d h:mm aaa"];
    return [dateFormat stringFromDate:date];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamViewController *teamVC = [[TeamViewController alloc] init];
    
    Team *team = (Team*)self.teams[indexPath.row];
    teamVC.team = team;
  
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self presentViewController:teamVC animated:true completion:nil];
    
}



@end
