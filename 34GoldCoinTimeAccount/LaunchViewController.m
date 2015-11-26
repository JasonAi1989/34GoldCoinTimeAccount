//
//  LaunchViewController.m
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/26.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import "LaunchViewController.h"
#import "CoinsHistory.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [self performSegueWithIdentifier:@"gotoMainContent" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    [CoinsHistory sharedCoinsHistory];
}

@end
