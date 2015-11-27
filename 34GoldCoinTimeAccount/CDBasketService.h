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
-(void)addBasketWithYear:(NSNumber*)year Month:(NSNumber*)month Day:(NSNumber*)day;
-(void)addBasketWithDate:(NSString*)date;

-(void)removeBasket:(CDBasket*) basket;
-(void)removeBasketWithYear:(NSNumber*)year Month:(NSNumber*)month Day:(NSNumber*)day;

-(CDBasket *)getBasketWithDate:(NSString*)date;
-(CDBasket *)getBasketWithYear:(NSNumber*)year Month:(NSNumber*)month Day:(NSNumber*)day;
-(NSArray *)getBasketWithYear:(NSNumber*)year Month:(NSNumber*)month;
-(NSArray *)getBasketWithYear:(NSNumber*)year;
-(NSArray*)getAllBasket;

@end
