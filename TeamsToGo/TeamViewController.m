//
//  TeamViewController.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/26/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "TeamViewController.h"
#import "TeamCowboyService.h"
#import "TeamCowboyClient.h"


@interface TeamViewController ()

@end

@implementation TeamViewController

-(void)loadView {


    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[TeamCowboyClient sharedService]teamGetRoster:self.teamId];
    
}

@end
