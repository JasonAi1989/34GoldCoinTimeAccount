//
//  OneDayCoins.m
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/25.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneDayCoins.h"
#import "common.h"

@implementation OneDayCoins

singleton_implementation(OneDayCoins);

-(instancetype)init{
    self = [super init];
    if (self) {
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        self.dateYear = [dateFormatter stringFromDate:today];
        
        self.usedCoinQueue = [[NSMutableArray alloc]initWithCapacity:48];
        for (int i=14; i<48; i++) {
            Coin *coin = [[Coin alloc]init];
            coin.coinID = i;
            coin.used = NO;
            coin.type = GCNone;
            [self.usedCoinQueue addObject:coin];
        }
        
        self.tableCellBtnQueue = [[NSMutableArray alloc]initWithCapacity:48];
        
        self.tableCellIdentifyQueue = @[@"goldCoin0", @"goldCoin1",@"goldCoin2",@"goldCoin3",\
                                        @"goldCoin4",@"goldCoin5",@"goldCoin6",@"goldCoin7",\
                                        @"goldCoin8",@"goldCoin9",@"goldCoin10",@"goldCoin11",\
                                        @"goldCoin12",@"goldCoin13",@"goldCoin14",@"goldCoin15",\
                                        @"goldCoin16", @"goldCoin17",@"goldCoin18",@"goldCoin19",\
                                        @"goldCoin20",@"goldCoin21",@"goldCoin22",@"goldCoin23",\
                                        @"goldCoin24",@"goldCoin25",@"goldCoin26",@"goldCoin27",\
                                        @"goldCoin28", @"goldCoin29",@"goldCoin30",@"goldCoin31",\
                                        @"goldCoin32",@"goldCoin33",@"goldCoin34",@"goldCoin35",\
                                        @"goldCoin36",@"goldCoin37",@"goldCoin38",@"goldCoin39",\
                                        @"goldCoin40", @"goldCoin41",@"goldCoin42",@"goldCoin43",\
                                        @"goldCoin44",@"goldCoin45",@"goldCoin46",@"goldCoin47"];
        
        self.globalWeekCn = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
        
        self.globalTimeBox = @[@"00:00-00:30",@"00:30-01:00",\
                          @"01:00-01:30",@"01:30-02:00",\
                          @"02:00-02:30",@"02:30-03:00",\
                          @"03:00-03:30",@"03:30-04:00",\
                          @"04:00-04:30",@"04:30-05:00",\
                          @"05:00-05:30",@"05:30-06:00",\
                          @"06:00-06:30",@"06:30-07:00",\
                          @"07:00-07:30",@"07:30-08:00",\
                          @"08:00-08:30",@"08:30-09:00",\
                          @"09:00-09:30",@"09:30-10:00",\
                          @"10:00-10:30",@"10:30-11:00",\
                          @"11:00-11:30",@"11:30-12:00",\
                          @"12:00-12:30",@"12:30-13:00",\
                          @"13:00-13:30",@"13:30-14:00",\
                          @"14:00-14:30",@"14:30-15:00",\
                          @"15:00-15:30",@"15:30-16:00",\
                          @"16:00-16:30",@"16:30-17:00",\
                          @"17:00-17:30",@"17:30-18:00",\
                          @"18:00-18:30",@"18:30-19:00",\
                          @"19:00-19:30",@"19:30-20:00",\
                          @"20:00-20:30",@"20:30-21:00",\
                          @"21:00-21:30",@"21:30-22:00",\
                          @"22:00-22:30",@"22:30-23:00",\
                          @"23:00-23:30",@"23:30-24:00"];
        
        self.globalTypeBox = @[@[[UIColor grayColor], @"暂无状态"],\
                          @[[UIColor yellowColor], @"高效工作"],\
                          @[[UIColor blueColor], @"尽兴娱乐"],\
                          @[[UIColor greenColor], @"休息放松"],\
                          @[[UIColor orangeColor], @"强迫工作"],\
                          @[[UIColor redColor], @"无效拖延"]];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps =[calendar components:(NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday |NSCalendarUnitWeekdayOrdinal) fromDate:today];
        self.dateWeek = [self.globalWeekCn objectAtIndex:[comps weekday]];
    }

    return self;
}
@end
