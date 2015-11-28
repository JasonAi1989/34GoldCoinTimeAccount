//
//  DataGridComponent.h
//  Multi-tableTest
//
//  Created by jason on 15/11/27.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataGridComponent;

/**
 * DataGrid所用数据源对象
 */
@interface DataGridComponentDataSource : NSObject

@property (nonatomic, strong)NSMutableArray *titles;
@property (nonatomic, strong)NSMutableArray *data;
@property (nonatomic, strong)NSMutableArray *columnWidth;

@end

//////////////////

@interface DataGridScrollView : UIScrollView

@property (nonatomic, strong) DataGridComponent *dataGridComponent;

@end

/////////
/**
 * 数据列表组件，支持上下与左右滑动
 */
@interface DataGridComponent : UIView

- (id)initWithFrame:(CGRect)aRect data:(DataGridComponentDataSource*)aDataSource;

@property (nonatomic, strong) DataGridScrollView *vRight;
@property (nonatomic, strong) DataGridScrollView *vLeft;
@property (assign, nonatomic) float cellHeight;
@property (nonatomic, strong) 	DataGridComponentDataSource *dataSource;

@end
