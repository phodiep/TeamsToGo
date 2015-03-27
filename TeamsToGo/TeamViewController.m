//
//  TeamViewController.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/27/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "TeamViewController.h"
#import "TeamCowboyService.h"
#import "User.h"
#import "Player.h"
#import "Team.h"

@interface TeamViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *players;

@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *backButton;

@end

@implementation TeamViewController

-(void)loadView {
    self.rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.tableView = [[UITableView alloc] init];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = [self.team name];
    
    self.backButton = [[UIButton alloc] init];
    [self.backButton setTitle:@"<Back" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    [title setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.backButton setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.rootView addSubview:self.tableView];
    [self.rootView addSubview:title];
    [self.rootView addSubview:self.backButton];
    
    NSDictionary *views = @{@"title" : title,
                            @"tableView" : self.tableView,
                            @"back" : self.backButton};
    
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[title]-[tableView]-8-|" options:NSLayoutFormatAlignAllCenterX metrics:0 views:views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[back]" options:NSLayoutFormatAlignAllCenterX metrics:0 views:views]];

    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:0 views:views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[back]" options:NSLayoutFormatAlignAllCenterY metrics:0 views:views]];
    
    self.view = self.rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    

    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;    
    
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
    [self getPlayers];
    [self.tableView reloadData];
}

-(void)getPlayers {
    self.players = [[TeamCowboyService sharedService] fetchPlayersForTeam:self.team];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.players count] > 0) {
        return [self.players count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    Player *player = (Player*)self.players[indexPath.row];
    User *user = (User*)player.user;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", user.name, player.type];
    
    return cell;
}

#pragma mark - button actions
-(void)backButtonPressed {
    [self dismissViewControllerAnimated:true completion:nil];

}

@end
