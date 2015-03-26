//
//  LoginViewController.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/12/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "LoginViewController.h"
#import "TeamCowboyClient.h"

@interface LoginViewController ()

@property (strong, nonatomic) UIView *rootview;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextField *username;
@property (strong, nonatomic) UITextField *password;

@property (strong, nonatomic) UIButton *loginButton;

@end

@implementation LoginViewController

-(void)loadView {
    [self initObjects];
    
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.username setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.password setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.loginButton setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.rootview addSubview:self.titleLabel];
    [self.rootview addSubview:self.username];
    [self.rootview addSubview:self.password];
    [self.rootview addSubview:self.loginButton];
    
    NSDictionary *views = @{@"title" : self.titleLabel,
                            @"username" : self.username,
                            @"password" : self.password,
                            @"login" : self.loginButton};
    
    [self.rootview addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-45-[title]-20-[username]-8-[password]-16-[login]-(>=8)-|" options:NSLayoutFormatAlignAllCenterX metrics:0 views:views]];
    [self.rootview addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[title]-|" options:0  metrics:0 views:views]];
    [self.rootview addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[username]-|" options:0 metrics:0 views:views]];
    [self.rootview addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[password]-|" options:0 metrics:0 views:views]];
    [self.rootview addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[login]-|" options:0 metrics:0 views:views]];

    
    self.view = self.rootview;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
}

-(void)initObjects {
    self.rootview = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    self.titleLabel.text = @"Login to Team Cowboy";
    
    self.username = [[UITextField alloc] init];
    self.username.backgroundColor = [UIColor whiteColor];
    self.username.placeholder = @"username (required)";
    
    self.password = [[UITextField alloc] init];
    self.password.backgroundColor = [UIColor whiteColor];
    self.password.placeholder = @"password (required)";
    self.password.secureTextEntry = true;
    
    self.loginButton = [[UIButton alloc] init];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)loginButtonPressed {
    [self resignFirstResponder];
    
    if ([self.username.text isEqualToString:@""] || [self.password.text isEqualToString:@""]) {

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry, unable to login" message:@"Please enter both username and password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    if (![self.username.text isEqualToString:@""] && ![self.password.text isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults]setObject:self.username.text forKey:@"username"];
        [[NSUserDefaults standardUserDefaults]setObject:self.password.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [[TeamCowboyClient sharedService] authGetUserToken];
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"] == nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry, unable to login" message:@"Username and password could not be confirmed, please try again " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        } else {
            [self dismissViewControllerAnimated:true completion:nil];
        }
        
    }

}


@end
