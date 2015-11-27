//
//  SZCalendarCell.h
//  SZCalendarPicker
//
//  Created by Stephen Zhuang on 14/12/1.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZCalendarCell : UICollectionViewCell
@property (nonatomic , strong) UILabel *dateLabel;

-(void)tap;
-(void)setFlag:(BOOL)flag;
-(void)clearStatus;
@end
