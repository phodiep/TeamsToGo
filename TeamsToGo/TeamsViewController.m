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

@interface TeamsViewController () <UITableViewDataSource>

@property (strong, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) NSMutableDictionary *views;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *teams;

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
    
    
    [[TeamCowboyClient alloc] userGetTeams];
    
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
    
    [self getTeams];
    
}

-(void)getTeams {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:self.context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];

    NSError *fetchError = nil;
    self.teams = [self.context executeFetchRequest:fetchRequest error:&fetchError];

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

@end
