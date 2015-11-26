//
//  SZCalendarCell.m
//  SZCalendarPicker
//
//  Created by Stephen Zhuang on 14/12/1.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import "SZCalendarCell.h"

@interface SZCalendarCell ()
{
    BOOL _isSelected;
}
@end
@implementation SZCalendarCell
- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:17]];
        
        [self addSubview:_dateLabel];
        
        _isSelected = false;
    }
    return _dateLabel;
}

-(void)cellTap{
    
    if (_isSelected) {
        [_dateLabel setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        [_dateLabel setBackgroundColor:[UIColor blueColor]];
    }
    
    _isSelected = !_isSelected;
}
- (void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTap)];
    [self addGestureRecognizer:tap];
}
-(void)tap{
    [self cellTap];
}
@end
