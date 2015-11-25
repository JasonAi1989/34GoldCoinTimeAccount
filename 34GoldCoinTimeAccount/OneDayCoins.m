//
//  OneDayCoins.m
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/25.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import "OneDayCoins.h"

@implementation OneDayCoins

singleton_implementation(OneDayCoins);

-(instancetype)init{
    self = [super init];
    if (self) {
        self.usedCoinQueue = [[NSMutableArray alloc]initWithCapacity:48];
        self.tableCellBtnQueue = [[NSMutableArray alloc]initWithCapacity:48];
    }
    
    return self;
}
@end
