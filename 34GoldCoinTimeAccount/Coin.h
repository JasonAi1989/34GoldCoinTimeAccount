//
//  Coin.h
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/25.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coin : NSObject 

-(instancetype)init:(int)coidID used:(BOOL)used title:(NSString*)title type:(NSString*)type who:(NSString*)who where:(NSString*)where detail:(NSString*)detail;

@property (assign, nonatomic) int coinID;
@property (assign, nonatomic) BOOL used;
@property (nonatomic, copy) NSMutableString *title;
@property (nonatomic, copy) NSMutableString *type;
@property (nonatomic, copy) NSMutableString *who;
@property (nonatomic, copy) NSMutableString *where;
@property (nonatomic, copy) NSMutableString *detail;

@end
