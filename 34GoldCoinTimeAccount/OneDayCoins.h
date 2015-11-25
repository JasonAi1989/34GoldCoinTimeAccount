//
//  OneDayCoins.h
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/25.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "Coin.h"

#define CommonLength 100
#define LongLength  200

@interface OneDayCoins : NSObject

singleton_interface(OneDayCoins);

-(instancetype)init;

@property (nonatomic, copy) NSString *dateYear; //yyyy-MM-dd
@property (nonatomic, copy) NSString *dateWeek; //星期

@property (nonatomic, strong) NSMutableArray *usedCoinQueue;

@property (nonatomic, strong) NSMutableArray *tableCellBtnQueue;
@property (nonatomic, strong) NSArray *tableCellIdentifyQueue;

@property (nonatomic, strong) NSArray *globalWeekCn;
@property (nonatomic, strong) NSArray *globalTimeBox;
@property (nonatomic, strong) NSArray *globalTypeBox;

@end
