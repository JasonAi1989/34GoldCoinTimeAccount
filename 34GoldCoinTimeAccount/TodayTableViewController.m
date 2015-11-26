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
#import "OneDayCoins.h"
#import "CDBasket.h"
#import "CDBasketService.h"
#import "CDCoin.h"

#define DEFAULT_ITEMS      34

@interface TodayTableViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _usedCoinNumber;
    OneDayCoins *_todayCoins;
    BOOL _newCoins;
    int _tableBtnQueueIndex;
}
@end

@implementation TodayTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_usedCoinNumber != _todayCoins.usedCoinQueue.count) {
        _usedCoinNumber = _todayCoins.usedCoinQueue.count;
        
        [self.tableView reloadData];
    }
    else if (_newCoins == NO) {
        [self.tableView reloadData];
    }
}

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
    //load default coins
    [self loadDefaultCoins];
    
    //navigation
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", _todayCoins.dateYear, _todayCoins.dateWeek];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //table
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(void)loadDefaultCoins{
    _todayCoins = [OneDayCoins sharedOneDayCoins];
    _usedCoinNumber = _todayCoins.usedCoinQueue.count;
}


#pragma mark actions
-(void)addItem:(id)sender{
    _newCoins = YES;
    
    [self performSegueWithIdentifier:@"useCoin" sender:self];
}

-(void)insertContent:(id)sender{
    _newCoins = NO;
    _tableBtnQueueIndex = 0;
    for (UIButton* btn in _todayCoins.tableCellBtnQueue) {
        if (sender == btn) {
            break;
        }
        
        _tableBtnQueueIndex++;
    }

    [self performSegueWithIdentifier:@"useCoin" sender:self];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _usedCoinNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int index = ((Coin*)[_todayCoins.usedCoinQueue objectAtIndex:indexPath.row]).coinID;
    
    TodayTableViewCell *cell=nil;
    cell = [self.tableView dequeueReusableCellWithIdentifier:[_todayCoins.tableCellIdentifyQueue objectAtIndex:index]];
    if (cell == nil) {
        cell = [[TodayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[_todayCoins.tableCellIdentifyQueue objectAtIndex:index]];
        
        UIButton *btn = [cell getTodoBtn];
        if (btn) {
            [btn addTarget:self action:@selector(insertContent:) forControlEvents:UIControlEventTouchDown];
        }
        
        [_todayCoins.tableCellBtnQueue insertObject:btn atIndex:indexPath.row];
        [cell setTime:[_todayCoins.globalTimeBox objectAtIndex:index]];
    }
    
    //类型会改变，所以每次要重新赋值
    [cell setType:[_todayCoins.globalTypeBox objectAtIndex:((Coin*)[_todayCoins.usedCoinQueue objectAtIndex:indexPath.row]).type]];
    [cell setDetail:((Coin*)[_todayCoins.usedCoinQueue objectAtIndex:indexPath.row]).title];

    return cell;
}

#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

#pragma mrak 重写方法
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"useCoin"]) {
//        NSLog(@"here");
        id peer = segue.destinationViewController;
        [peer setValue:[NSNumber numberWithBool:_newCoins] forKey:@"newCoins"];
        [peer setValue:[NSNumber numberWithInt:_tableBtnQueueIndex] forKey:@"tableBtnQueueIndex"];
    }
}

@end
