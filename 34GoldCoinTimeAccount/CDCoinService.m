//
//  CDCoinService.m
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/26.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import "CDCoinService.h"
#import "DbManager.h"

@implementation CDCoinService

singleton_implementation(CDCoinService)

-(NSManagedObjectContext *)context{
    return [DbManager sharedDbManager].context;
}

-(void)addCoin:(CDCoin*) coin{
    [self addCoinWithCoinID:coin.coinID Used:coin.used Title:coin.title Type:coin.type Who:coin.who Where:coin.where Detail:coin.detail Basket:coin.basket];
}
-(void)addCoinWithCoinID:(NSNumber*)coinID Used:(NSNumber*)used Title:(NSString*)title Type:(NSNumber*)type Who:(NSString*)who Where:(NSString*)where Detail:(NSString*)detail Basket:(CDBasket*)basket{
    CDCoin *coin = [NSEntityDescription insertNewObjectForEntityForName:@"CDCoin" inManagedObjectContext:self.context];
    
    coin.coinID = coinID;
    coin.used = used;
    coin.title = title;
    coin.type = type;
    coin.who = who;
    coin.where = where;
    coin.detail =detail;
    coin.basket = basket;
    
    NSError *error=nil;
    //保存上下文
    if (![self.context save:&error]) {
        NSLog(@"添加过程中发生错误,错误信息：%@！",error.localizedDescription);
    }
}

-(void)removeCoin:(CDCoin*) coin{
    if (coin == nil) {
        return;
    }
    
    [self.context deleteObject:coin];
    
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"删除过程中发生错误，错误信息：%@!",error.localizedDescription);
    }
}
-(void)removeCoinWithCoinID:(NSNumber*)coinID{
    CDCoin *coin = [self getCoinWithCoinID:coinID];
    [self removeCoin:coin];
}

-(CDCoin *)getCoinWithCoinID:(NSNumber*)coinID{
    NSFetchRequest *result = [NSFetchRequest fetchRequestWithEntityName:@"CDCoin"];
    result.predicate = [NSPredicate predicateWithFormat:@"%K=%d", @"coinID", [coinID intValue]];
    
    NSError *error=nil;
    CDCoin *coin=nil;
    NSArray *results = [self.context executeFetchRequest:result error:&error];
    if (error) {
        NSLog(@"查询过程中发生错误，错误信息：%@！",error.localizedDescription);
    }
    else
    {
        coin = [results firstObject];
    }
    
    return coin;
}

-(void)modifyCoin:(CDCoin*) coin{
    [self modifyCoinWithCoinID:coin.coinID Used:coin.used Title:coin.title Type:coin.type Who:coin.who Where:coin.where Detail:coin.detail Basket:coin.basket];
}

-(void)modifyCoinWithCoinID:(NSNumber*)coinID Used:(NSNumber*)used Title:(NSString*)title Type:(NSNumber*)type Who:(NSString*)who Where:(NSString*)where Detail:(NSString*)detail Basket:(CDBasket*)basket{
    CDCoin* coin = [self getCoinWithCoinID:coinID];
    
    coin.coinID = coinID;
    coin.used = used;
    coin.title = title;
    coin.type = type;
    coin.who = who;
    coin.where = where;
    coin.detail = detail;
    coin.basket = basket;
    
    NSError *error=nil;
    if (![self.context save:&error]) {
        NSLog(@"修改过程中发生错误,错误信息：%@",error.localizedDescription);
    }
}

@end
