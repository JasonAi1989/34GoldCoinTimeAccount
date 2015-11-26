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

@interface CDCoinService : NSObject

@property (nonatomic,strong) NSManagedObjectContext *context;

singleton_interface(CDCoinService);

-(void)addCoin:(CDCoin*) coin;
-(void)addCoinWithCoinID:(int)coinID Used:(BOOL)used Title:(NSString*)title Type:(int16_t)type Who:(NSString*)who Where:(NSString*)where Detail:(NSString*)detail;

-(void)removeCoin:(CDCoin*) coin;
-(void)removeCoinWithCoinID:(int)coinID;

-(CDCoin *)getCoinWithCoinID:(int)coinID;

@end
