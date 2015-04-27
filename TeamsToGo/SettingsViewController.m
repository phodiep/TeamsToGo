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

@interface SettingsViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UIButton *logoutButton;

@end

@implementation SettingsViewController

-(void)loadView {
    self.rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];

    self.logoutButton = [[UIButton alloc] init];
    [self.logoutButton setTitle:@"Logout of Team Cowboy" forState:UIControlStateNormal];
    self.logoutButton.backgroundColor = [UIColor redColor];
    self.logoutButton.titleLabel.textColor = [UIColor whiteColor];
    [self.logoutButton addTarget:self action:@selector(logoutButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    UILabel *title = [[UILabel alloc]init];
    title.text = @"Settings";
    title.font = [UIFont systemFontOfSize:20];
    title.textColor = [Color headerTextColor];
    
    [self.logoutButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [title setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.rootView addSubview:self.logoutButton];
    [self.rootView addSubview:title];
    
    NSDictionary *views = @{@"title" : title,
                            @"logout" : self.logoutButton};
    
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[title]-20-[logout]-(>=8)-|" options:NSLayoutFormatAlignAllCenterX metrics:0 views:views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[logout]-16-|" options:0 metrics:0 views:views]];
    
    self.view = self.rootView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
}

#pragma mark - button acitons
-(void)logoutButtonPressed {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please Confirm" message:@"Are you sure you want to logout of Team Cowboy?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Logout", nil];
    [alertView show];
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


@end
