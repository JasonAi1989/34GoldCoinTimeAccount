//
//  LaunchViewController.m
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/26.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import "LaunchViewController.h"
#import "CoinsHistory.h"
#import "OneDayCoins.h"
#import "CDCoinService.h"
#import "CDBasketService.h"

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
    
    [self loadCDBasketCoins];
}

-(void)loadCDBasketCoins{
    OneDayCoins *todayCoins = [OneDayCoins sharedOneDayCoins];
    CDBasket *basket = [[CDBasketService sharedCDBasketService] getBasketWithDate:todayCoins.dateYear];
    if (basket == nil || basket.coins == nil || basket.coins.count == 0) {
        return;
    }
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc]initWithKey:@"coinID" ascending:YES];
    NSArray *sort = [[NSArray alloc]initWithObjects:sd, nil];
    NSArray *results = [basket.coins sortedArrayUsingDescriptors:sort];
    
    BOOL modifyFlag=NO;
    for (int i=0; i<results.count; i++) {
        CDCoin *cdCoin = [results objectAtIndex:i];
        
        for (int j=0; j<todayCoins.usedCoinQueue.count; j++) {
            Coin* coin = [todayCoins.usedCoinQueue objectAtIndex:j];
            
            if (coin.coinID == [cdCoin.coinID intValue]) {
                coin.used = YES;
                coin.title = [cdCoin.title copy];
                coin.type = [cdCoin.type intValue];
                coin.who = [cdCoin.who copy];
                coin.where = [cdCoin.where copy];
                coin.detail = [cdCoin.detail copy];
                modifyFlag = YES;
            }
        }
        
        if (modifyFlag == NO) {
            Coin* coin = [[Coin alloc]initWithCDCoin:cdCoin];
            
            [todayCoins.usedCoinQueue addObject:coin];
        }
    }
    
    [todayCoins.usedCoinQueue sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Coin *coin1 = obj1;
        Coin *coin2 = obj2;
        
        if (coin1.coinID > coin2.coinID) {
            return YES;
        }
        
        return NO;
    }];
    
    //    for (Coin*coin in _todayCoins.usedCoinQueue) {
    //        NSLog(@"coin id:%d", coin.coinID);
    //        NSLog(@"coin title: %@", coin.title);
    //    }
}
@end
