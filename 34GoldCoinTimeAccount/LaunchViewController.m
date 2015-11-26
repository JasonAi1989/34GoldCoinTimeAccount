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
    if (basket == nil) {
        [[CDBasketService sharedCDBasketService] addBasketWithDate:todayCoins.dateYear];
        return;
    }
    
    //取出来的值是乱序的
    [basket.coins enumerateObjectsUsingBlock:^(CDCoin * _Nonnull obj, BOOL * _Nonnull stop) {
        int index = 0;
        for (Coin* coin in todayCoins.usedCoinQueue) {
            //可以直接修改
            if (coin.coinID == [obj.coinID intValue]) {
                coin.used = [obj.used boolValue];
                
                if (obj.title != nil) {
                    if (coin.title == nil) {
                        coin.title = [[NSMutableString alloc]initWithString:obj.title];
                    }
                    else
                    {
                        [coin.title setString:obj.title];
                    }
                }
                
                coin.type = [obj.type intValue];
                
                if (obj.who != nil) {
                    if (coin.who == nil) {
                        coin.who = [[NSMutableString alloc]initWithString:obj.who];
                    }
                    else
                    {
                        [coin.who setString:obj.who];
                    }
                }
                
                if (obj.where != nil) {
                    if (coin.where == nil) {
                        coin.where = [[NSMutableString alloc]initWithString:obj.where];
                    }
                    else
                    {
                        [coin.where setString:obj.where];
                    }
                }
                
                if (obj.detail != nil) {
                    if (coin.detail == nil) {
                        coin.detail = [[NSMutableString alloc]initWithString:obj.detail];
                    }
                    else
                    {
                        [coin.detail setString:obj.detail];
                    }
                }
                
                *stop = NO;
                return;
            }
            //在前面插入
            else if (coin.coinID > [obj.coinID intValue])
            {
                Coin* newCoin = [[Coin alloc]init:[obj.coinID intValue] used:[obj.used boolValue] title:obj.title type:[obj.type intValue] who:obj.who where:obj.where detail:obj.detail];
                [todayCoins.usedCoinQueue insertObject:newCoin atIndex:index];
                *stop = NO;
                return;
            }
            
            index++;
        }
        
        //遍历完了之后发现可以在后面插入
        Coin* coin = [todayCoins.usedCoinQueue lastObject];
        if (coin.coinID < 47) {
            Coin* newCoin = [[Coin alloc]init:[obj.coinID intValue] used:[obj.used boolValue] title:obj.title type:[obj.type intValue] who:obj.who where:obj.where detail:obj.detail];
            [todayCoins.usedCoinQueue addObject:newCoin];
        }
        
        *stop = NO;
    }];
    
    //    for (Coin*coin in _todayCoins.usedCoinQueue) {
    //        NSLog(@"coin id:%d", coin.coinID);
    //        NSLog(@"coin title: %@", coin.title);
    //    }
}
@end
