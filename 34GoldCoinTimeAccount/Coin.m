//
//  Coin.m
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/25.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import "Coin.h"



@implementation Coin
-(instancetype)init:(int)coidID used:(BOOL)used title:(NSString*)title type:(GoldCoinType)type who:(NSString*)who where:(NSString*)where detail:(NSString*)detail{
    self = [super init];
    
    if (self) {
        self.coinID = coidID;
        self.used = used;
        if (title != nil) {
            self.title = [[NSMutableString alloc]initWithString:title];
        }
        
        self.type = type;
        if (who != nil) {
            self.who = [[NSMutableString alloc]initWithString:who];
        }
        
        if (where != nil) {
            self.where = [[NSMutableString alloc]initWithString:where];
        }
        
        if (detail != nil) {
            self.detail = [[NSMutableString alloc]initWithString:detail];
        }
    }
    
    return self;
}

@end
