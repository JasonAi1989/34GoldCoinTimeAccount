//
//  MonthCollectionViewController.m
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/26.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import "MonthCollectionViewController.h"
#import "SZCalendarPicker.h"
#import "MonthCollectionViewCell.h"
#import "OneDayCoins.h"
#import "CDBasket.h"
#import "CDBasketService.h"

@interface MonthCollectionViewController ()
{
    CGFloat _navigationHight;
    UIBarButtonItem *_rightBtn;
    NSMutableArray *_monthUsedCoinsArray;
    NSMutableArray *_dayUsedcoinsArray;
}
@end

@implementation MonthCollectionViewController

static NSString * const reuseIdentifier = @"monthCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    [self UILayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)UILayout{
    //navigation
    self.navigationItem.title = @"今年的12个月";
    
    _rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(showAll:)];
    self.navigationItem.rightBarButtonItem = _rightBtn;
    
    _navigationHight = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    
    //注册自定义cell类
    [self.collectionView registerClass:[MonthCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

-(void)loadData{
    //记录12个月的金币
    _monthUsedCoinsArray = [[NSMutableArray alloc]initWithCapacity:12];
    //记录一个月31天的金币
    _dayUsedcoinsArray = [[NSMutableArray alloc]initWithCapacity:31];
    for (int i=0; i<31; i++) {
        [_dayUsedcoinsArray addObject:[NSNumber numberWithBool:false]];
    }
    
    NSRange range = {0,4};
    int thisYear = [[[OneDayCoins sharedOneDayCoins].dateYear substringWithRange:range] intValue];
    
    range.location = 5;
    range.length = 2;
    int thisMonth = [[[OneDayCoins sharedOneDayCoins].dateYear substringWithRange:range] intValue];
    
    for (int i=1; i<=12; i++) {
        NSArray *ret = [[CDBasketService sharedCDBasketService] getBasketWithYear:[NSNumber numberWithInt:thisYear] Month:[NSNumber numberWithInt:i]];
        
        __block NSUInteger count=0;
        [ret enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CDBasket* basket = (CDBasket*)obj;
            count = count + basket.coins.count;

            //将当前月计算出来
            if (thisMonth == i) {
                NSLog(@"count:%lu index:%d", (unsigned long)_dayUsedcoinsArray.count, [basket.day intValue]-1);
                
                [_dayUsedcoinsArray setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:[basket.day intValue]-1];
            }
        }];
        
        [_monthUsedCoinsArray insertObject:[NSNumber numberWithInteger:count] atIndex:i-1];
    }

}

#pragma mark Actions
-(void)showAll:(id)sender{

}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //如果要使用自定义的cell，需要先注册这个自定义类
    MonthCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    [cell.titleLabel setText:[NSString stringWithFormat:@"%ld 月",(long)indexPath.row+1]];
    [cell.titleLabel setTextColor:[UIColor brownColor]];
    
    [cell.contentLabel setNumberOfLines:2];
    [cell.contentLabel setText:[NSString stringWithFormat:@"%d\n枚金币", [_monthUsedCoinsArray[indexPath.row] intValue]]];
    [cell.contentLabel setTextColor:[UIColor grayColor]];
    
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
    
    //将日历指到指定的月
    NSDate *date = [NSDate date];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    NSInteger currentMonth = [dateComponents month];
    
    [dateComponents setMonth:indexPath.row+1];
    NSDate *specificDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];

    //初始化日历
    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
    calendarPicker.today = date;
    
    if (currentMonth == [dateComponents month]) {
        calendarPicker.date = calendarPicker.today;
    }
    else
    {
        calendarPicker.date = specificDate;
    }
    
    calendarPicker.frame = CGRectMake(0, _navigationHight, self.view.frame.size.width, 352);
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        
        NSLog(@"%li-%li-%li", year,month,day);
    };
    calendarPicker.returnBlock = ^(){
        //修改nivigation btn
        [_rightBtn setTitle:@"更多"];
    };
    
    //修改nivigation btn
    [_rightBtn setTitle:@"查看"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM";
    
    calendarPicker.showBlock = ^(NSInteger index, NSDate *date){
        if (index >= _dayUsedcoinsArray.count) {
            return NO;
        }
        NSString *dateStr = [NSString stringWithFormat:@"%@-%02ld",[formatter stringFromDate:date], (long)index];
        if ([[CDBasketService sharedCDBasketService] getBasketWithDate:dateStr]) {

            return YES;
        };
        return NO;
    };
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
