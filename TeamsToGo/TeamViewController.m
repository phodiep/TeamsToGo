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
#import "RosterCell.h"

@interface TeamViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *players;
@property (strong, nonatomic) NSMutableDictionary *playersGrouped;
@property (strong, nonatomic) NSMutableArray *groupTypes;

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
    
    [self.tableView registerClass:RosterCell.class forCellReuseIdentifier:@"ROSTER_CELL"];

}

-(void)viewDidAppear:(BOOL)animated {
    [self getPlayers];
    [self groupPlayersByType];
    [self.tableView reloadData];
}

-(void)getPlayers {
    self.players = [[TeamCowboyService sharedService] fetchPlayersForTeam:self.team];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.groupTypes count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.groupTypes[section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.playersGrouped[self.groupTypes[section]] count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *type = self.groupTypes[indexPath.section];
    
    Player *player = (Player*)self.playersGrouped[type][indexPath.row];
    User *user = (User*)player.user;
    
    RosterCell *cell = (RosterCell*)[self.tableView dequeueReusableCellWithIdentifier:@"ROSTER_CELL" forIndexPath:indexPath];
    
    cell.nameLabel.text = user.name;
    
    if (![user.phone isEqualToString:@""]){
        cell.phoneLabel.text = [self formatUsPhoneNumber:[self numbersOnlyFromString:user.phone]];
        cell.phoneLabel.hidden = NO;
        cell.phoneIcon.hidden = NO;
    } else {
        cell.phoneLabel.text = @"";
        cell.phoneLabel.hidden = YES;
        cell.phoneIcon.hidden = YES;
    }
    if (![user.emailAddress isEqualToString:@""]) {
        cell.emailLabel.text = user.emailAddress;
        cell.emailLabel.hidden = NO;
        cell.emailIcon.hidden = NO;
    } else {
        cell.emailLabel.text = @"";
        cell.emailLabel.hidden = YES;
        cell.emailIcon.hidden = YES;
    }
    
    return cell;
}


#pragma mark - group players by type
-(void)groupPlayersByType {
    self.playersGrouped = [[NSMutableDictionary alloc] init];
    self.groupTypes = [[NSMutableArray alloc] init];
    
    for (Player* player in self.players) {
        if (![self.playersGrouped objectForKey:player.type]) {
            [self.groupTypes addObject:player.type];
            [self.playersGrouped setObject:[[NSMutableArray alloc] initWithArray:@[player]]
                                    forKey:player.type];
        } else {
            [[self.playersGrouped objectForKey:player.type] addObject:player];
        }
    }
    
    NSArray *sortOrder = @[@"Manager",
                           @"Full-time",
                           @"Part-time",
                           @"Sub",
                           @"Injured"];

    [self.groupTypes sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSUInteger indexOfObj1 = [sortOrder indexOfObject: obj1];
        NSUInteger indexOfObj2 = [sortOrder indexOfObject: obj2];
        
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
    NSLog(@"%@", self.groupTypes);
}

#pragma mark - button actions
-(void)backButtonPressed {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - misc
-(NSString*)numbersOnlyFromString:(NSString*)originalString {
    return [[originalString componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                  componentsJoinedByString:@""];
}

-(NSString*)formatUsPhoneNumber:(NSString*)originalString {
    return [NSString stringWithFormat:@"(%@) %@-%@",
            [originalString  substringToIndex:3],
            [originalString substringWithRange:NSMakeRange(3,3)],
            [originalString substringFromIndex:6]];
}

@end
