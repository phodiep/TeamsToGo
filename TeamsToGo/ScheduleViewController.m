//
//  ScheduleViewController.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/12/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "ScheduleViewController.h"

@interface ScheduleViewController ()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *events;

@end

@implementation ScheduleViewController

-(void)loadView {
    UIView *rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    self.view = rootView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor greenColor];
}


@end
