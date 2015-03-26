//
//  AppDelegate.m
//  TeamsToGo
//
//  Created by Pho Diep on 2/2/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "NetworkController.h"
#import "CoreDataStack.h"
#import "TeamCowboyClient.h"
#import "LoginViewController.h"
#import "SettingsViewController.h"
#import "TeamsViewController.h"
#import "ScheduleViewController.h"
#import "MessagesViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) UITabBarController *tabBar;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];

    [self setupTabBar];
    self.window.rootViewController = self.tabBar;

    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"username"] == nil ||
        [[NSUserDefaults standardUserDefaults]objectForKey:@"password"] == nil) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.tabBar presentViewController:loginVC animated:true completion:nil];
    } else {
        [self getUserTokenIfNecessary];
    }
    
    return YES;
}

- (void)getUserTokenIfNecessary {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"] == nil) {
        [[TeamCowboyClient sharedService] authGetUserToken];
    }
}

-(void)setupTabBar {
    self.tabBar = [[UITabBarController alloc] init];
    
    ScheduleViewController *scheduleVC = [[ScheduleViewController alloc] init];
    scheduleVC.tabBarItem.title = @"Schedule";
    scheduleVC.tabBarItem.image = [UIImage imageNamed:@"calendar"];
    
    TeamsViewController *teamsVC = [[TeamsViewController alloc] init];
    teamsVC.tabBarItem.title = @"Teams";
    teamsVC.tabBarItem.image = [UIImage imageNamed:@"team"];
    
//    MessagesViewController *messagesVC = [[MessagesViewController alloc] init];
//    messagesVC.tabBarItem.title = @"Messages";
//    messagesVC.tabBarItem.image = [UIImage imageNamed:@"message"];
    
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    settingsVC.tabBarItem.title = @"Settings";
    settingsVC.tabBarItem.image = [UIImage imageNamed:@"settings"];
    
    self.tabBar.viewControllers = @[scheduleVC,
                                    teamsVC,
                                    //messagesVC,
                                    settingsVC
                                    ];
    self.tabBar.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
//    [self saveContext];
    [[CoreDataStack alloc] saveContext];
}



@end
