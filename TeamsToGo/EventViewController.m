//
//  EventViewController.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/30/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "EventViewController.h"
#import "TeamCowboyService.h"
#import "Event.h"
#import "User.h"
#import "Team.h"
#import "Rsvp.h"

@interface EventViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *rsvps;

@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableDictionary *playersGrouped;
@property (strong, nonatomic) NSMutableArray *groupTypesStatus;
@property (strong, nonatomic) NSMutableArray *groupTypesGender;

@end

@implementation EventViewController

-(void)loadView {
    self.rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    self.tableView = [[UITableView alloc] init];
    
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.rootView addSubview:self.tableView];
    
    NSDictionary *views = @{@"tableview" : self.tableView};
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[tableview]|" options:0 metrics:0 views:views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableview]|" options:0 metrics:0 views:views]];
    
    
    self.view = self.rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.rootView.backgroundColor = [UIColor yellowColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.rsvps = [[TeamCowboyService sharedService] fetchRsvpByEvent:self.event];
    
    [self groupRsvps];
    
    [self.tableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rsvps count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    Rsvp *rsvp = self.rsvps[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)",rsvp.user.name, rsvp.status ] ;
    
    return cell;
}

#pragma mark - group rsvps by type
-(void)groupRsvps {
    self.playersGrouped = [[NSMutableDictionary alloc] init];
    self.groupTypesStatus = [[NSMutableArray alloc] init];
    self.groupTypesGender = [[NSMutableArray alloc] init];
    

    //sort by 1) Status   2) Gender
    
    for (Rsvp* rsvp in self.rsvps) {
        
        //check if they exist in groupTypes
        if (![self.groupTypesStatus containsObject:rsvp.status]) {
            [self.groupTypesStatus addObject:rsvp.status];
        }
        if (![self.groupTypesGender containsObject:rsvp.user.gender]) {
            [self.groupTypesGender addObject: rsvp.user.gender];
        }
        
        
        //check dictionary
        if (![self.playersGrouped objectForKey:rsvp.status]) {
            [self.playersGrouped setObject:[[NSMutableDictionary alloc] initWithDictionary:@{rsvp.user.gender :
                                                                                                 [[NSMutableArray alloc] initWithArray:@[rsvp]]}]
                                    forKey:rsvp.status];
        } else {
            if (![self.playersGrouped[rsvp.status] objectForKey: rsvp.user.gender]) {
                [self.playersGrouped[rsvp.status] setObject:[[NSMutableArray alloc] initWithArray:@[rsvp]]
                                        forKey:rsvp.user.gender];

            } else {
                [self.playersGrouped[rsvp.status][rsvp.user.gender] addObject:rsvp];

            }
        }
    }
    
    NSArray *sortOrderStatus = @[@"yes",
                                 @"maybe",
                                 @"available",
                                 @"no",
                                 @"noresponse"];
    
    NSArray *sortOrderGender = @[@"m",
                                 @"f",
                                 @"other"];
    
    [self.groupTypesStatus sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSUInteger indexOfObj1 = [sortOrderStatus indexOfObject: obj1];
        NSUInteger indexOfObj2 = [sortOrderStatus indexOfObject: obj2];
        
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

    [self.groupTypesGender sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSUInteger indexOfObj1 = [sortOrderGender indexOfObject: obj1];
        NSUInteger indexOfObj2 = [sortOrderGender indexOfObject: obj2];
        
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
    
}





@end
