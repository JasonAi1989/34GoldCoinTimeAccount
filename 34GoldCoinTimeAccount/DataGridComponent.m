//
//  DataGridComponent.m
//  Multi-tableTest
//
//  Created by jason on 15/11/27.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import "DataGridComponent.h"
#import "UIColor+ZXLazy.h"
#import "OneDayCoins.h"

@implementation DataGridComponentDataSource

@end

/////////////////
@implementation DataGridScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *t = [touches anyObject];
    if([t tapCount] == 1){
        DataGridComponent *d = (DataGridComponent*)self.dataGridComponent;
        int idx = [t locationInView:self].y / d.cellHeight;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.65];
        for(int i=0;i<[d.dataSource.titles count];i++){
            UILabel *l = (UILabel*)[self.dataGridComponent viewWithTag:idx * d.cellHeight + i + 1000];
            l.alpha = .5;
        }
        for(int i=0;i<[d.dataSource.titles count];i++){
            UILabel *l = (UILabel*)[self.dataGridComponent viewWithTag:idx * d.cellHeight + i + 1000];
            l.alpha = 1.0;
        }		
        [UIView commitAnimations];
    }
}

@end


//////////////
@interface DataGridComponent ()<UIScrollViewDelegate>
{
    //右下列表内容
    UIView *_vRightContent;
    
    //左下列表内容
    UIView *_vLeftContent;
    
    //右上标题
    UIView *_vTopRight;
    
    //左上标题
    UIView *_vTopLeft;
    
    //内容总高度
    float _contentHeight ;
    
    //内容总宽度
    float _contentWidth;
    
    //单元格默认宽度
    float _cellWidth;
}
@end

@implementation DataGridComponent

- (id)initWithFrame:(CGRect)aRect data:(DataGridComponentDataSource*)aDataSource{
    self = [super initWithFrame:aRect];
    if(self != nil){
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithHexString:@"E4F7D0"];
        self.dataSource = aDataSource;
        
        //初始显示视图及Cell的长宽高
        _contentWidth = .0;
        self.cellHeight = 30.0;
        _cellWidth = [[self.dataSource.columnWidth objectAtIndex:0] intValue];
        for(int i=1;i<[self.dataSource.columnWidth count];i++)
            _contentWidth += [[self.dataSource.columnWidth objectAtIndex:i] intValue];
        _contentHeight = 48 * self.cellHeight;
        _contentWidth = _contentWidth + [[self.dataSource.columnWidth objectAtIndex:0] intValue]  < aRect.size.width
        ? aRect.size.width : _contentWidth;
        
        //初始化各视图
        [self layoutSubView:aRect];
        
        //填冲数据
        [self fillData];
        
    }
    return self;
}
-(void)layoutSubView:(CGRect)aRect{
    _vLeftContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, _contentHeight)];
    _vRightContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aRect.size.width - _cellWidth, _contentHeight)];
    
    _vLeftContent.opaque = YES;
    _vRightContent.opaque = YES;
    
    
    //初始化各视图
    _vTopLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _cellWidth, self.cellHeight)];
    self.vLeft = [[DataGridScrollView alloc] initWithFrame:CGRectMake(0, self.cellHeight, aRect.size.width, aRect.size.height - self.cellHeight)];
    self.vRight = [[DataGridScrollView alloc] initWithFrame:CGRectMake(_cellWidth, 0, aRect.size.width - _cellWidth, _contentHeight)];
    _vTopRight = [[UIView alloc] initWithFrame:CGRectMake(_cellWidth, 0, aRect.size.width - _cellWidth, self.cellHeight)];
    
    self.vLeft.dataGridComponent = self;
    self.vRight.dataGridComponent = self;
    
    self.vLeft.opaque = YES;
    self.vRight.opaque = YES;
    _vTopLeft.opaque = YES;
    _vTopRight.opaque = YES;
    
    //设置ScrollView的显示内容
    self.vLeft.contentSize = CGSizeMake(aRect.size.width, _contentHeight);
    self.vRight.contentSize = CGSizeMake(_contentWidth,aRect.size.height - self.cellHeight);
    
    //设置ScrollView参数
    self.vRight.delegate = self;
    
    _vTopRight.backgroundColor = [[UIColor alloc]initWithRed:46/255.0 green:195/255.0 blue:139/255.0 alpha:1];
    self.vRight.backgroundColor = [[UIColor alloc]initWithRed:252/255.0 green:250/255.0 blue:225/255.0 alpha:1];
    _vTopLeft.backgroundColor = [[UIColor alloc]initWithRed:46/255.0 green:195/255.0 blue:139/255.0 alpha:1];
    
    //添加各视图
    [self.vRight addSubview:_vRightContent];
    [self.vLeft addSubview:_vLeftContent];
    [self.vLeft addSubview:self.vRight];
    [self addSubview:_vTopLeft];
    [self addSubview:self.vLeft];
    
    [self.vLeft bringSubviewToFront:self.vRight];
    [self addSubview:_vTopRight];
    [self bringSubviewToFront:_vTopRight];
}


-(void)fillData{
    
    float columnOffset = 0.0;
    
    //填冲标题数据
    for(int column = 0;column < [self.dataSource.titles count];column++){
        float columnWidth = [[self.dataSource.columnWidth objectAtIndex:column] floatValue];
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, 0, columnWidth -1, self.cellHeight )];
        l.font = [UIFont systemFontOfSize:12.0f];
        l.text = [self.dataSource.titles objectAtIndex:column];
        l.backgroundColor = [[UIColor alloc]initWithRed:46/255.0 green:195/255.0 blue:139/255.0 alpha:1];
        l.textColor = [UIColor whiteColor];
        l.textAlignment = NSTextAlignmentCenter;
        
        if( 0 == column){
            [_vTopLeft addSubview:l];
        }
        else{
            [_vTopRight addSubview:l];
            columnOffset += columnWidth;
        }
    }
    
    //填冲数据内容
    //最左列
    {
        NSArray *columnData = [self.dataSource.data objectAtIndex:0];
        float columnWidth = [[self.dataSource.columnWidth objectAtIndex:0] floatValue];
        
        for (int j=0; j<48; j++) {
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, j * self.cellHeight  , columnWidth-1, self.cellHeight -1 )];
            
            l.font = [UIFont systemFontOfSize:12.0f];
            l.text = [columnData objectAtIndex:j];
            l.textAlignment = NSTextAlignmentCenter;
            
            //斑马线
            if(j % 2 == 0)
                l.backgroundColor = [UIColor whiteColor];
            
            [_vLeftContent addSubview:l];
        }
    }
    
    //右列
    columnOffset = 0.0;
    for(int i = 1;i<[self.dataSource.data count];i+=2){
        NSArray *textData = [self.dataSource.data objectAtIndex:i];
        NSArray *typeData = [self.dataSource.data objectAtIndex:i+1];
        float columnWidth = [[self.dataSource.columnWidth objectAtIndex:(i+1)/2] floatValue];
        
        for (int j=0; j<48; j++) {
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(columnOffset, j * self.cellHeight  , columnWidth-1, self.cellHeight -1 )];
            
            l.font = [UIFont systemFontOfSize:12.0f];
            l.text = [textData objectAtIndex:j];
            l.textAlignment = NSTextAlignmentCenter;
            
            [l setBackgroundColor:[[[OneDayCoins sharedOneDayCoins].globalTypeBox objectAtIndex:[[typeData objectAtIndex:j] intValue]] objectAtIndex:0]];
            
            [_vRightContent addSubview:l];
        }
        
        columnOffset += columnWidth;
    }
}


//-------------------------------以下为事件处发方法----------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    _vTopRight.frame = CGRectMake(_cellWidth, 0, self.vRight.contentSize.width, _vTopRight.frame.size.height);
    _vTopRight.bounds = CGRectMake(scrollView.contentOffset.x, 0, _vTopRight.frame.size.width, _vTopRight.frame.size.height);
    _vTopRight.clipsToBounds = YES;
    _vRightContent.frame = CGRectMake(0, 0  ,
                                     self.vRight.contentSize.width , _contentHeight);
    [self addSubview:_vTopRight];
    self.vRight.frame =CGRectMake(_cellWidth, 0, self.frame.size.width - _cellWidth, self.vLeft.contentSize.height);
    [self.vLeft addSubview:scrollView];
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    scrollView.frame = CGRectMake(_cellWidth, 0, scrollView.frame.size.width, self.frame.size.height);
    _vRightContent.frame = CGRectMake(0, self.cellHeight - self.vLeft.contentOffset.y, self.vRight.contentSize.width , _contentHeight);
    
    _vTopRight.frame = CGRectMake(0, 0, self.vRight.contentSize.width, _vTopRight.frame.size.height);
    _vTopRight.bounds = CGRectMake(0, 0, self.vRight.contentSize.width, _vTopRight.frame.size.height);
    [scrollView addSubview:_vTopRight];
    [self addSubview:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate)
        [self scrollViewDidEndDecelerating:scrollView];
}

@end
