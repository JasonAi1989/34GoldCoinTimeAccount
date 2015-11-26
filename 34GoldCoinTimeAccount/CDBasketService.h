//
//  CDBasketService.h
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/26.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Singleton.h"
#import "CDBasket.h"


@interface CDBasketService : NSObject

@property (nonatomic,strong) NSManagedObjectContext *context;

singleton_interface(CDBasketService);

-(void)addBasket:(CDBasket*) basket;
-(void)addBasketWithYear:(int)year Month:(int)month Day:(int)day;

-(void)removeBasket:(CDBasket*) basket;
-(void)removeBasketWithYear:(int)year Month:(int)month Day:(int)day;

-(CDBasket *)getBasketWithYear:(int)year Month:(int)month Day:(int)day;

@end
