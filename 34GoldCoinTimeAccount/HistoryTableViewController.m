//
//  HistoryTableViewController.m
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/26.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import "HistoryTableViewController.h"

@interface HistoryTableViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation HistoryTableViewController

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

}

-(void)UILayout{
    //table
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //navigation
    self.navigationItem.title = @"金币往事";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"Detail" style:UIBarButtonItemStylePlain target:self action:@selector(gotoDetail:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

#pragma mark Actions
-(void)gotoDetail:(id)sender{


}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 5;
    }
    else if (section == 1)
    {
        return 4;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identify = @"history";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    return cell;
}



@end
