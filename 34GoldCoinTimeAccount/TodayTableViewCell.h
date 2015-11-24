//
//  TodayTableViewCell.h
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/24.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayTableViewCell : UITableViewCell

-(void) setTime:(NSString*)time;
-(void) setType:(NSString*)type;
-(void) SetDetail:(NSString*)detail;

@end
