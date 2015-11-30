//
//  CoinsHistory.h
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/26.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "Coin.h"
#import "CDCoin.h"

@interface CoinsHistory : NSObject
singleton_interface(CoinsHistory);

-(instancetype)init;

@property (nonatomic, strong) NSMutableString *fromDate;

@property (assign, nonatomic) int years;
@property (assign, nonatomic) int months;
@property (assign, nonatomic) int64_t days;
@property (assign, nonatomic) Float32 hours;
@property (assign, nonatomic) int64_t coins;

@property (assign, nonatomic) int64_t coinsEffectiveWork;
@property (assign, nonatomic) int64_t coinsEffectiveEntertainment;
@property (assign, nonatomic) int64_t coinsRest;
@property (assign, nonatomic) int64_t coinsForcedWork;
@property (assign, nonatomic) int64_t coinsIneffectiveDelay;

-(void)addNewCoin:(Coin*)coin;
-(void)addNewCDCoin:(CDCoin *)coin;

-(void)updateData;
@end
