//
//  TeamsViewController.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/12/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "TeamsViewController.h"
#import "Team.h"
#import "TeamCowboyClient.h"

@interface TeamsViewController () <UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *teams;

@end

@implementation TeamsViewController

-(void)loadView {
    self.teams = [[NSMutableArray alloc]init];
    UIView *rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
//    [[TeamCowboyClient alloc] userGetTeams];
    
    self.view = rootView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.teams = [[TeamCowboyClient alloc] teams];
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

    cell.textLabel.text = [(Team*)self.teams[indexPath.row] getName];
    
    return cell;
}

@end
