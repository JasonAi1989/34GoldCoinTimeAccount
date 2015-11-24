//
//  TodayTableViewController.m
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/24.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import "TodayTableViewController.h"
#import "TodayTableViewCell.h"
#import "common.h"

#define DEFAULT_ITEMS      34

@interface TodayTableViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_weekCn;
    NSArray *_timeBox;
    NSInteger _minTime;
    NSInteger _maxTime;
    NSArray *_typeBox;
}
@end

@implementation TodayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self UILayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 自定义方法
-(void)UILayout{
    [self initArray];
    
    //navigation
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps =[calendar components:(NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday |NSCalendarUnitWeekdayOrdinal) fromDate:today];
    
    NSString *todayWeek = [_weekCn objectAtIndex:[comps weekday]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *todayYear = [dateFormatter stringFromDate:today];

    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", todayYear, todayWeek];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //table
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

-(void)initArray{
    _weekCn = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    
    _timeBox = @[@"00:00-00:30",@"00:30-01:00",\
                 @"01:00-01:30",@"01:30-02:00",\
                 @"02:00-02:30",@"02:30-03:00",\
                 @"03:00-03:30",@"03:30-04:00",\
                 @"04:00-04:30",@"04:30-05:00",\
                 @"05:00-05:30",@"05:30-06:00",\
                 @"06:00-06:30",@"06:30-07:00",\
                 @"07:00-07:30",@"07:30-08:00",\
                 @"08:00-08:30",@"08:30-09:00",\
                 @"09:00-09:30",@"09:30-10:00",\
                 @"10:00-10:30",@"10:30-11:00",\
                 @"11:00-11:30",@"11:30-12:00",\
                 @"12:00-12:30",@"12:30-13:00",\
                 @"13:00-13:30",@"13:30-14:00",\
                 @"14:00-14:30",@"14:30-15:00",\
                 @"15:00-15:30",@"15:30-16:00",\
                 @"16:00-16:30",@"16:30-17:00",\
                 @"17:00-17:30",@"17:30-18:00",\
                 @"18:00-18:30",@"18:30-19:00",\
                 @"19:00-19:30",@"19:30-20:00",\
                 @"20:00-20:30",@"20:30-21:00",\
                 @"21:00-21:30",@"21:30-22:00",\
                 @"22:00-22:30",@"22:30-23:00",\
                 @"23:00-23:30",@"23:30-24:00"];
    
    _minTime = 15;
    _maxTime = 48;
    
    _typeBox = @[@[[UIColor grayColor], @"暂无状态"],\
                 @[[UIColor yellowColor], @"高效工作"],\
                 @[[UIColor blueColor], @"尽兴娱乐"],\
                 @[[UIColor greenColor], @"休息放松"],\
                 @[[UIColor orangeColor], @"强迫工作"],\
                 @[[UIColor redColor], @"无效拖延"]];
}

#pragma mark actions
-(void)addItem:(id)sender{

}

-(void)insertContent:(id)sender{
    
    //    if (self.isUsed) {
    //        <#statements#>
    //    }
    
    [self performSegueWithIdentifier:@"useCoin" sender:self];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return DEFAULT_ITEMS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"goldCoin";
    
    TodayTableViewCell *cell=nil;
    cell = [self.tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[TodayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    NSInteger index = _minTime + indexPath.row - 1;
    
    [cell setTime:[_timeBox objectAtIndex:index]];
    [cell setType:[_typeBox objectAtIndex:1]];
    UIButton *btn = [cell getTodoBtn];
    if (btn) {
        [btn addTarget:self action:@selector(insertContent:) forControlEvents:UIControlEventTouchDown];
    }

    return cell;
}

#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

#pragma mrak 重写方法
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"useCoin"]) {
        NSLog(@"here1");
    }
}

@end
