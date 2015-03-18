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

@interface ScheduleViewController () <UITableViewDataSource>

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDictionary *views;
@property (strong, nonatomic) NSArray *events;

@end

@implementation ScheduleViewController

-(void)loadView {
    self.rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    [[TeamCowboyClient alloc] userGetTeamEvents];
    
    self.tableView = [[UITableView alloc] init];
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.rootView addSubview:self.tableView];
    
    self.views = @{@"tableView" : self.tableView};
    
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:0 views:self.views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[tableView]-55-|" options:0 metrics:0 views:self.views]];
    
    self.view = self.rootView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.context = [[CoreDataStack alloc] init].managedObjectContext;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getEventSchedule];
    self.tableView.dataSource = self;
    
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
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    Event *event = self.events[indexPath.row];
    
    cell.textLabel.text = event.title;
    
    return cell;
}

@end
