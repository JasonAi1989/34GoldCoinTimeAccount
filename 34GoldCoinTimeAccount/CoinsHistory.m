//
//  CoinsHistory.m
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/26.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import "CoinsHistory.h"
#import "CDBasketService.h"
#import "CDCoinService.h"

@implementation CoinsHistory
singleton_implementation(CoinsHistory);

-(instancetype)init{
    self = [super init];
    if (self) {
        NSArray *basketArray = [[CDBasketService sharedCDBasketService] getAllBasket];
        NSArray *coinsArray = [[CDCoinService sharedCDCoinService] getAllCoins];
        
        self.days = basketArray.count;
        self.coins = coinsArray.count;
        self.hours = self.coins/2.0;
        
        for (CDCoin* coin in coinsArray) {
            switch ([coin.type intValue]) {
                case 1:
                    self.coinsEffectiveWork++;
                    break;
                case 2:
                    self.coinsEffectiveEntertainment++;
                    break;
                case 3:
                    self.coinsRest++;
                    break;
                case 4:
                    self.coinsForcedWork++;
                    break;
                case 5:
                    self.coinsIneffectiveDelay++;
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    return self;
}

-(void)addNewCoin:(Coin*)coin{
    if (coin == nil) {
        return;
    }
    
    self.coins++;
    switch (coin.type) {
        case 1:
            self.coinsEffectiveWork++;
            break;
        case 2:
            self.coinsEffectiveEntertainment++;
            break;
        case 3:
            self.coinsRest++;
            break;
        case 4:
            self.coinsForcedWork++;
            break;
        case 5:
            self.coinsIneffectiveDelay++;
            break;
            
        default:
            break;
    }
    
    self.hours = self.coins/2.0;
}
-(void)addNewCDCoin:(CDCoin *)coin{
    if (coin == nil) {
        return;
    }
    
    self.coins++;
    switch ([coin.type intValue]) {
        case 1:
            self.coinsEffectiveWork++;
            break;
        case 2:
            self.coinsEffectiveEntertainment++;
            break;
        case 3:
            self.coinsRest++;
            break;
        case 4:
            self.coinsForcedWork++;
            break;
        case 5:
            self.coinsIneffectiveDelay++;
            break;
            
        default:
            break;
    }
    
    self.hours = self.coins/2.0;
}
@end
