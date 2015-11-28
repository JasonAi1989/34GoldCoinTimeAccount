//
//  ShowCoinsViewController.m
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/27.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import "ShowCoinsViewController.h"
#import "DataGridComponent.h"
#import "CDBasketService.h"
#import "CDBasket.h"
#import "CDCoin.h"

extern NSMutableArray *globalSelectedDaysArray;

@interface ShowCoinsViewController ()
{
    DataGridComponentDataSource *_tableDataSource;
    CGFloat _navigationHight;
}

@property (nonatomic, strong) NSMutableArray *selectedArray;
@end

@implementation ShowCoinsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];

    [self UILayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    if (globalSelectedDaysArray == nil
        || globalSelectedDaysArray.count == 0) {
        NSLog(@"empty");
        return;
    }
    
    _tableDataSource = [[DataGridComponentDataSource alloc]init];

    NSUInteger count = globalSelectedDaysArray.count;
    _tableDataSource.titles = [[NSMutableArray alloc]init];
    _tableDataSource.columnWidth = [[NSMutableArray alloc]init];
    _tableDataSource.data = [[NSMutableArray alloc]init];

    
    [_tableDataSource.titles addObject:@"金币"];
    [_tableDataSource.columnWidth addObject:@"70.0"];
    
    //标题行
    for (int i=0; i<count; i++) {
        NSString *str = [globalSelectedDaysArray objectAtIndex:i];
        [_tableDataSource.titles addObject:str];
        [_tableDataSource.columnWidth addObject:@"80.0"];
    }
    
    //data
    //最左列
    {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        for (int i=0; i<48; i++) {
            [array addObject:[NSString stringWithFormat:@"第%d枚", i+1]];
        }
        
        [_tableDataSource.data addObject:array];
    }
    
    //右列
    NSSortDescriptor *sd = [[NSSortDescriptor alloc]initWithKey:@"coinID" ascending:YES];
    NSArray *sortDirection = [NSArray arrayWithObject:sd];
    for (int i=0; i<count; i++) {
        NSString *str = [globalSelectedDaysArray objectAtIndex:i];
        CDBasket *basket = [[CDBasketService sharedCDBasketService] getBasketWithDate:str];
        
        NSMutableArray *textArray=[[NSMutableArray alloc]init];
        NSMutableArray *typeArray=[[NSMutableArray alloc]init];
        
        if (basket && basket.coins && basket.coins.count!=0) {
            NSArray *results = [basket.coins sortedArrayUsingDescriptors:sortDirection];
            
            int index=0;
            for (int j=0; j<48; j++) {
                CDCoin *ret = [results objectAtIndex:index];
                if ([ret.coinID intValue] == j) {
                    index<(results.count-1) ? index++ : index;
                    [textArray addObject:ret.title];
                    [typeArray addObject:ret.type];
                }
                else
                {
                    [textArray addObject:@"+"];
                    [typeArray addObject:@0];
                }
            }
        }
        else
        {
            for (int j=0; j<48; j++) {
                [textArray addObject:@"+"];
                [typeArray addObject:@0];
            }
        }
        
        [_tableDataSource.data addObject:textArray];
        [_tableDataSource.data addObject:typeArray];
    }
    
//    for (int i=0; i<48; i++) {
//        NSLog(@"i: %@", [array objectAtIndex:i]);
//    }
}

-(void)UILayout{
    self.navigationItem.title = @"金币使用情况";
    _navigationHight = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    
    CGRect rect = CGRectMake(0, _navigationHight, self.navigationController.navigationBar.frame.size.width, self.view.bounds.size.height - _navigationHight - self.tabBarController.tabBar.frame.size.height);
    DataGridComponent *grid = [[DataGridComponent alloc] initWithFrame:rect data:_tableDataSource];
    
    [self.view addSubview:grid];
}

@end
