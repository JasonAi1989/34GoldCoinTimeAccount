//
//  CDBasketService.m
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/26.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import "CDBasketService.h"
#import "DbManager.h"

@implementation CDBasketService

singleton_implementation(CDBasketService)

-(NSManagedObjectContext *)context{
    return [DbManager sharedDbManager].context;
}

-(void)addBasket:(CDBasket*) basket{

}

-(void)addBasketWithYear:(int)year Month:(int)month Day:(int)day{

}

-(void)removeBasket:(CDBasket*) basket{

}
-(void)removeBasketWithYear:(int)year Month:(int)month Day:(int)day{

}

-(CDBasket *)getBasketWithYear:(int)year Month:(int)month Day:(int)day{
    return nil;
}
@end
