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
    UILabel *_flagLabel;
    UILabel *_selectedLabel;
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
    
    if (!_flagLabel) {
        CGRect rect = CGRectMake(5, 5, 3, 3);
        _flagLabel = [[UILabel alloc]initWithFrame:rect];
        [_flagLabel setAlpha:0];
        [_dateLabel addSubview:_flagLabel];
    }
    
    if (!_selectedLabel) {
        CGRect rect = CGRectMake(self.bounds.size.width/2-10, self.bounds.size.height/2-10, 20, 20);
        _selectedLabel = [[UILabel alloc]initWithFrame:rect];

        [_selectedLabel setAlpha:0];
        [_dateLabel addSubview:_selectedLabel];
    }
    
    return _dateLabel;
}

-(void)setFlag:(BOOL)flag{
    if (flag) {
        [_flagLabel setAlpha:1];
        [_flagLabel setBackgroundColor:[UIColor blueColor]];
    }
    else
    {
        [_flagLabel setAlpha:0];
        [_flagLabel setBackgroundColor:[UIColor whiteColor]];
    }
}

-(void)clearStatus{
    _isSelected = NO;
    [_dateLabel setBackgroundColor:[UIColor whiteColor]];
    [_flagLabel setBackgroundColor:[UIColor whiteColor]];
    [_selectedLabel setBackgroundColor:[UIColor whiteColor]];
    [_flagLabel setAlpha:0];
    [_selectedLabel setAlpha:0];
}

-(BOOL)cellTap{
    if (_isSelected) {
        [_selectedLabel setAlpha:0];
        [_selectedLabel setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        [_selectedLabel setAlpha:0.5];
        [_selectedLabel setBackgroundColor:[UIColor blueColor]];
    }
    
    _isSelected = !_isSelected;
    
    return _isSelected;
}
- (void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTap)];
    [self addGestureRecognizer:tap];
}
-(BOOL)tap{
    return [self cellTap];
}
@end
