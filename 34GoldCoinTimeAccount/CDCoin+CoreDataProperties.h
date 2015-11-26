//
//  CDCoin+CoreDataProperties.h
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/26.
//  Copyright © 2015年 JasonAi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDCoin.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDCoin (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *coinID;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSNumber *used;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *who;
@property (nullable, nonatomic, retain) NSString *where;
@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) CDBasket *basket;

@end

NS_ASSUME_NONNULL_END
