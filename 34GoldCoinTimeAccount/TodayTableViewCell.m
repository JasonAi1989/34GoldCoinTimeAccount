//
//  TodayTableViewCell.m
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/24.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import "TodayTableViewCell.h"
#import "common.h"

#define CellHight 40
#define Hight CellHight-1
#define TimeLabelWidth 120
#define TypeLabelWidth 100
#define TodoBtnWidth \
    ([UIScreen mainScreen].bounds.size.width - \
    TimeLabelWidth - \
    TypeLabelWidth)

#define FontSize 16

@interface TodayTableViewCell()
{
    UILabel *_timeLabel;
    UILabel *_typeLabel;
    UIButton *_todoBtn;
}

@property (assign, nonatomic) BOOL isUsed;

@end

@implementation TodayTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self UILayout];
    }
    
    return self;
}

-(void)UILayout{
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TimeLabelWidth-1, Hight)];
    _timeLabel.font = [UIFont systemFontOfSize:FontSize];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    
    CGRect spaceLabel1Rect = CGRectMake(CGRectGetMaxX(_timeLabel.frame), 0, 1, Hight);
    UILabel *spaceLabel1 = [[UILabel alloc]initWithFrame:spaceLabel1Rect];
    spaceLabel1.backgroundColor = [UIColor grayColor];
    
    CGRect todoBtnRect = CGRectMake(CGRectGetMaxX(_timeLabel.frame)+1, 0, TodoBtnWidth, Hight);
    _todoBtn = [[UIButton alloc]initWithFrame:todoBtnRect];
    [_todoBtn setTitle:@"+" forState:UIControlStateNormal];
    [_todoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    CGRect spaceLabel2Rect = CGRectMake(CGRectGetMaxX(_todoBtn.frame), 0, 1, Hight);
    UILabel *spaceLabel2 = [[UILabel alloc]initWithFrame:spaceLabel2Rect];
    spaceLabel2.backgroundColor = [UIColor grayColor];
    
    CGRect typeLabelRect = CGRectMake(CGRectGetMaxX(_todoBtn.frame)+1, 0, TypeLabelWidth-1, Hight);
    _typeLabel = [[UILabel alloc]initWithFrame:typeLabelRect];
    _typeLabel.font = [UIFont systemFontOfSize:FontSize];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    
    CGRect spaceLabel3Rect = CGRectMake(0, Hight, [UIScreen mainScreen].bounds.size.width, 1);
    UILabel *spaceLabel3 = [[UILabel alloc]initWithFrame:spaceLabel3Rect];
    spaceLabel3.backgroundColor = [UIColor grayColor];

    
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:spaceLabel1];
    [self.contentView addSubview:_todoBtn];
    [self.contentView addSubview:spaceLabel2];
    [self.contentView addSubview:_typeLabel];
    [self.contentView addSubview:spaceLabel3];
}

-(void) setTime:(NSString*)time{
    _timeLabel.text = time;
}
-(void) setType:(NSArray*)type{
    _typeLabel.backgroundColor = [type objectAtIndex:0];
    _typeLabel.text = [type objectAtIndex:1];
}
-(void) setDetail:(NSString*)detail{
//    NSLog(@"detail: %@", detail);
    if (detail == nil || detail.length == 0) {
        [_todoBtn setTitle:@"+" forState:UIControlStateNormal];
    }
    else
    {
        [_todoBtn setTitle:detail forState:UIControlStateNormal];
    }
    
    [_todoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

-(UIButton*) getTodoBtn{
    return _todoBtn;
}
@end
