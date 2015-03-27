//
//  MessagesViewController.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/12/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "MessagesViewController.h"

@interface MessagesViewController ()

@end

@implementation MessagesViewController

-(void)loadView {
    UIView *rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    NSLog(@"messageVC");
    
    self.view = rootView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
}

@end
