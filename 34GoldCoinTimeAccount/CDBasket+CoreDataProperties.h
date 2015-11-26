//
//  CDBasket+CoreDataProperties.h
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/26.
//  Copyright © 2015年 JasonAi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDBasket.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDBasket (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *year;
@property (nullable, nonatomic, retain) NSNumber *month;
@property (nullable, nonatomic, retain) NSNumber *day;
@property (nullable, nonatomic, retain) NSNumber *week;
@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSSet<CDCoin *> *coins;

@end

@interface CDBasket (CoreDataGeneratedAccessors)

- (void)addCoinsObject:(CDCoin *)value;
- (void)removeCoinsObject:(CDCoin *)value;
- (void)addCoins:(NSSet<CDCoin *> *)values;
- (void)removeCoins:(NSSet<CDCoin *> *)values;

@end

NS_ASSUME_NONNULL_END
