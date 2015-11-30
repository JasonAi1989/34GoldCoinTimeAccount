//
//  HistoryTableViewController.m
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/26.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "CoinsHistory.h"

@interface HistoryTableViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    CoinsHistory *_history;
}
@end

@implementation HistoryTableViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [self UILayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 自定义方法
-(void)loadData{
    _history = [CoinsHistory sharedCoinsHistory];
}

-(void)UILayout{
    //table
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //navigation
    self.navigationItem.title = @"金币往事";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"详细" style:UIBarButtonItemStylePlain target:self action:@selector(gotoDetail:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

#pragma mark Actions
-(void)gotoDetail:(id)sender{

    [self performSegueWithIdentifier:@"gotoDetail" sender:self];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 3;
    }
    else if (section == 1)
    {
        return 5;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identify = @"history";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"%lld 天", _history.days];
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"%.1f 小时", _history.hours];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"%lld 枚金币", _history.coins];
                break;
                
            default:
                break;
        }

        cell.textLabel.textAlignment = NSTextAlignmentRight;
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"［高效工作］使用了 [%lld]枚金币", _history.coinsEffectiveWork];
                cell.backgroundColor = [UIColor yellowColor];
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"［尽兴娱乐］使用了 [%lld]枚金币", _history.coinsEffectiveEntertainment];
                cell.backgroundColor = [UIColor blueColor];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"［休息放松］使用了 [%lld]枚金币", _history.coinsRest];
                cell.backgroundColor = [UIColor greenColor];
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"［强迫工作］使用了 [%lld]枚金币", _history.coinsForcedWork];
                cell.backgroundColor = [UIColor orangeColor];
                break;
            case 4:
                cell.textLabel.text = [NSString stringWithFormat:@"［无效拖延］使用了 [%lld]枚金币", _history.coinsIneffectiveDelay];
                cell.backgroundColor = [UIColor redColor];
                break;
                
            default:
                break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 60;
    }
    else if (section == 1)
    {
        return 30;
    }
    else
    {
        return 50;
    }
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [NSString stringWithFormat:@"您的时间记录始于：	XXXX-XX-XX\n到目前为止，您总共记录了："];
    }
    else
    {
        return @"金币使用：";
    }
}

@end
