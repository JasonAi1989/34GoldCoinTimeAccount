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
    [self addBasketWithYear:basket.year Month:basket.month Day:basket.day];
}

-(void)addBasketWithYear:(NSNumber*)year Month:(NSNumber*)month Day:(NSNumber*)day{
    CDBasket *basket = [NSEntityDescription insertNewObjectForEntityForName:@"CDBasket" inManagedObjectContext:self.context];
    
    basket.year = year;
    basket.month = month;
    basket.day = day;
    basket.date = [self dateFormatWithYear:year Month:month Day:day];
    
    NSError *error=nil;
    //保存上下文
    if (![self.context save:&error]) {
        NSLog(@"添加过程中发生错误,错误信息：%@！",error.localizedDescription);
    }
}

-(void)addBasketWithDate:(NSString*)date{
    CDBasket *basket = [NSEntityDescription insertNewObjectForEntityForName:@"CDBasket" inManagedObjectContext:self.context];
    NSRange range = {0,4};
    basket.year = [NSNumber numberWithInt:[[date substringWithRange:range] intValue]];
    
    range.location = 5;
    range.length = 2;
    basket.month = [NSNumber numberWithInt:[[date substringWithRange:range] intValue]];;

    range.location = 8;
    range.length = 2;
    basket.day = [NSNumber numberWithInt:[[date substringWithRange:range] intValue]];;;
    basket.date = date;
    
    NSError *error=nil;
    //保存上下文
    if (![self.context save:&error]) {
        NSLog(@"添加过程中发生错误,错误信息：%@！",error.localizedDescription);
    }
}

-(void)removeBasket:(CDBasket*) basket{
    if (basket == nil) {
        return;
    }
    
    [self.context deleteObject:basket];
    
    NSError *error=nil;
    //保存上下文
    if (![self.context save:&error]) {
        NSLog(@"删除过程中发生错误，错误信息：%@!",error.localizedDescription);
    }
}
-(void)removeBasketWithYear:(NSNumber*)year Month:(NSNumber*)month Day:(NSNumber*)day{
    CDBasket *basket = [self getBasketWithYear:year Month:month Day:day];
    
    [self removeBasket:basket];
}

-(CDBasket *)getBasketWithYear:(NSNumber*)year Month:(NSNumber*)month Day:(NSNumber*)day{
    return [self getBasketWithDate:[self dateFormatWithYear:year Month:month Day:day]];
}

-(CDBasket *)getBasketWithDate:(NSString*)date{
    //实例化查询
    NSFetchRequest *result = [NSFetchRequest fetchRequestWithEntityName:@"CDBasket"];
    
    //使用谓词查询是基于Keypath查询的，如果键是一个变量，格式化字符串时需要使用%K而不是%@
    result.predicate = [NSPredicate predicateWithFormat:@"%K=%@", @"date", date];
    
    NSError *error=nil;
    CDBasket *basket=nil;
    NSArray *results = [self.context executeFetchRequest:result error:&error];
    
    if (error) {
        NSLog(@"查询过程中发生错误，错误信息：%@！",error.localizedDescription);
    }
    else
    {
        basket = [results firstObject];
    }
    
    return basket;
}

-(NSString*)dateFormatWithYear:(NSNumber*)year Month:(NSNumber*)month Day:(NSNumber*)day{
    return [NSString stringWithFormat:@"%04d-%02d-%02d", [year intValue], [month intValue], [day intValue]];
}
@end
