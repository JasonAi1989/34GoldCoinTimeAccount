//
//  OneDayCoins.h
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/25.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface OneDayCoins : NSObject

singleton_interface(OneDayCoins);

-(instancetype)init;

@property (nonatomic, strong) NSMutableArray *usedCoinQueue;

@property (nonatomic, strong) NSMutableArray *tableCellBtnQueue;
@end
