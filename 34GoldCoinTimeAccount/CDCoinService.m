//
//  CDCoinService.m
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/26.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import "CDCoinService.h"
#import "DbManager.h"

@implementation CDCoinService

singleton_implementation(CDCoinService)

-(NSManagedObjectContext *)context{
    return [DbManager sharedDbManager].context;
}

-(void)addCoin:(CDCoin*) coin{

}
-(void)addCoinWithCoinID:(int)coinID Used:(BOOL)used Title:(NSString*)title Type:(int16_t)type Who:(NSString*)who Where:(NSString*)where Detail:(NSString*)detail{

}

-(void)removeCoin:(CDCoin*) coin{

}
-(void)removeCoinWithCoinID:(int)coinID{

}

-(CDCoin *)getCoinWithCoinID:(int)coinID{
    return nil;
}

@end
