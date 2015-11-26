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
    
    //load the basket coins
    [self loadCDBasketCoins];
    
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
-(void)loadCDBasketCoins{
    CDBasket *basket = [[CDBasketService sharedCDBasketService] getBasketWithDate:_todayCoins.dateYear];
    if (basket == nil) {
        [[CDBasketService sharedCDBasketService] addBasketWithDate:_todayCoins.dateYear];
        return;
    }
    
    //取出来的值是乱序的
    [basket.coins enumerateObjectsUsingBlock:^(CDCoin * _Nonnull obj, BOOL * _Nonnull stop) {
        int index = 0;
        for (Coin* coin in _todayCoins.usedCoinQueue) {
            //可以直接修改
            if (coin.coinID == [obj.coinID intValue]) {
                coin.used = [obj.used boolValue];
                
                if (obj.title != nil) {
                    if (coin.title == nil) {
                        coin.title = [[NSMutableString alloc]initWithString:obj.title];
                    }
                    else
                    {
                        [coin.title setString:obj.title];
                    }
                }

                coin.type = [obj.type intValue];
                
                if (obj.who != nil) {
                    if (coin.who == nil) {
                        coin.who = [[NSMutableString alloc]initWithString:obj.who];
                    }
                    else
                    {
                        [coin.who setString:obj.who];
                    }
                }
                
                if (obj.where != nil) {
                    if (coin.where == nil) {
                        coin.where = [[NSMutableString alloc]initWithString:obj.where];
                    }
                    else
                    {
                        [coin.where setString:obj.where];
                    }
                }
                
                if (obj.detail != nil) {
                    if (coin.detail == nil) {
                        coin.detail = [[NSMutableString alloc]initWithString:obj.detail];
                    }
                    else
                    {
                        [coin.detail setString:obj.detail];
                    }
                }
                
                *stop = NO;
                return;
            }
            //在前面插入
            else if (coin.coinID > [obj.coinID intValue])
            {
                Coin* newCoin = [[Coin alloc]init:[obj.coinID intValue] used:[obj.used boolValue] title:obj.title type:[obj.type intValue] who:obj.who where:obj.where detail:obj.detail];
                [_todayCoins.usedCoinQueue insertObject:newCoin atIndex:index];
                *stop = NO;
                return;
            }
            
            index++;
        }
        
        //遍历完了之后发现可以在后面插入
        Coin* coin = [_todayCoins.usedCoinQueue lastObject];
        if (coin.coinID < 47) {
            Coin* newCoin = [[Coin alloc]init:[obj.coinID intValue] used:[obj.used boolValue] title:obj.title type:[obj.type intValue] who:obj.who where:obj.where detail:obj.detail];
            [_todayCoins.usedCoinQueue addObject:newCoin];
        }
        
        *stop = NO;
    }];
    
//    for (Coin*coin in _todayCoins.usedCoinQueue) {
//        NSLog(@"coin id:%d", coin.coinID);
//        NSLog(@"coin title: %@", coin.title);
//    }
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
