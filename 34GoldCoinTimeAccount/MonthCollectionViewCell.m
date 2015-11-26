//
//  MonthCollectionViewCell.m
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/27.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import "MonthCollectionViewCell.h"
#import <UIKit/UIKit.h>

@implementation MonthCollectionViewCell

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
        
        [_titleLabel setBackgroundColor:[[UIColor alloc]initWithRed:46/255.0 green:195/255.0 blue:139/255.0 alpha:1]];
        
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont systemFontOfSize:20]];
        
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}
-(UILabel*)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.bounds.size.width, 80)];
        
        [_contentLabel setBackgroundColor:[[UIColor alloc]initWithRed:252/255.0 green:250/255.0 blue:225/255.0 alpha:1]];
        
        [_contentLabel setTextAlignment:NSTextAlignmentCenter];
        [_contentLabel setFont:[UIFont systemFontOfSize:20]];
        
        [self addSubview:_contentLabel];
    }
    
    return _contentLabel;
}

-(void)test{
    NSLog(@"test");
}
@end
