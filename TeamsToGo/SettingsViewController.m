//
//  SettingsViewController.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/12/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "SettingsViewController.h"
#import "TeamCowboyService.h"
#import "LoginViewController.h"
#import "Color.h"

@interface SettingsViewController () <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SettingsViewController

-(void)loadView {
    self.rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    self.tableView = [[UITableView alloc] init];

    UILabel *title = [[UILabel alloc]init];
    title.text = @"Settings";
    title.font = [UIFont systemFontOfSize:20];
    title.textColor = [Color headerTextColor];
    
    [title setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.rootView addSubview:title];
    [self.rootView addSubview:self.tableView];
    
    NSDictionary *views = @{@"title" : title,
                            @"tableView" : self.tableView};
    
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[title]-20-[tableView]-50-|" options:NSLayoutFormatAlignAllCenterX metrics:0 views:views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:0 views:views]];
    
    self.view = self.rootView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];

    //map
    NSString *defaultMapApp;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultMap"] == nil ||
        [[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultMap"] isEqualToString:@"Apple"]) {
        defaultMapApp = @"Apple Maps";
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultMap"] isEqualToString:@"Google"]) {
        defaultMapApp = @"Google Maps";
    }
    
    //version
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Logout of Team Cowboy";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"Default Map: %@", defaultMapApp];
            break;
            
        case 4:
            cell.textLabel.text = [NSString stringWithFormat:@"Current Version: %@", version];
            break;

        default:
            cell.backgroundColor = [UIColor grayColor];
            break;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self logoutButtonPressed];
            break;
        case 2:
            [self mapAppButtonPressed];
            break;
        default:
            break;
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - button acitons
-(void)logoutButtonPressed {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please Confirm" message:@"Are you sure you want to logout of Team Cowboy?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Logout", nil];
    [alertView show];
}

-(void)mapAppButtonPressed {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.delegate = self;
    [actionSheet setTitle:@"Select Map App"];
    
    [actionSheet addButtonWithTitle:@"Apple Maps"];
    
    //if google maps installed
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        [actionSheet addButtonWithTitle:@"Google Maps"];
    }
    
    [actionSheet showInView:self.view];

}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //cancel
    }
    
    if (buttonIndex == 1) {
        //logout
//        [[TeamCowboyService sharedService] deleteAllEventsFromCoreData];
//        [[TeamCowboyService sharedService] deleteAllTeamsFromCoreData];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"username"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userToken"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[TeamCowboyService sharedService] resetData];
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:true completion:nil];
        
    }
}

#pragma mark - UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"Apple" forKey:@"defaultMap"];
    }
    if (buttonIndex == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"Google" forKey:@"defaultMap"];
    }
}


@end
