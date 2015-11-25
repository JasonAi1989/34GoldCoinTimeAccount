//
//  Coin.h
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/25.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "common.h"

@interface Coin : NSObject 

-(instancetype)init:(int)coidID used:(BOOL)used title:(NSString*)title type:(GoldCoinType)type who:(NSString*)who where:(NSString*)where detail:(NSString*)detail;

@property (assign, nonatomic) int coinID;
@property (assign, nonatomic) BOOL used;
@property (nonatomic, strong) NSMutableString *title;
@property (assign, nonatomic) GoldCoinType type;
@property (nonatomic, strong) NSMutableString *who;
@property (nonatomic, strong) NSMutableString *where;
@property (nonatomic, strong) NSMutableString *detail;

@end
