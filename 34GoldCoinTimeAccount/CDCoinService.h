//
//  CDCoinService.h
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/26.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Singleton.h"
#import "CDCoin.h"
#import "CDBasket.h"

@interface CDCoinService : NSObject

@property (nonatomic,strong) NSManagedObjectContext *context;

singleton_interface(CDCoinService);

-(void)addCoin:(CDCoin*) coin;
-(void)addCoinWithCoinID:(NSNumber*)coinID Used:(NSNumber*)used Title:(NSString*)title Type:(NSNumber*)type Who:(NSString*)who Where:(NSString*)where Detail:(NSString*)detail Basket:(CDBasket*)basket;

-(void)removeCoin:(CDCoin*) coin;
-(void)removeCoinWithCoinID:(NSNumber*)coinID;

-(CDCoin *)getCoinWithCoinID:(NSNumber*)coinID;

-(void)modifyCoin:(CDCoin*) coin;
-(void)modifyCoinWithCoinID:(NSNumber*)coinID Used:(NSNumber*)used Title:(NSString*)title Type:(NSNumber*)type Who:(NSString*)who Where:(NSString*)where Detail:(NSString*)detail Basket:(CDBasket*)basket;

-(NSArray*)getAllCoins;
@end
