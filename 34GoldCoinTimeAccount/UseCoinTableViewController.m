//
//  UseCoinTableViewController.m
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/24.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import "UseCoinTableViewController.h"
#import "OneDayCoins.h"

#define ViewHight   160
#define ViewWidth   ([UIScreen mainScreen].bounds.size.width/2)
#define UseCoinCellHight   40
#define UseCoinCellWidth \
    ([UIScreen mainScreen].bounds.size.width)

@interface UseCoinTableViewController ()<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>
{
    UIButton *_fromBtn;
    UIButton *_toBtn;
    UITextField *_todoText;
    UIButton *_typeBtn;
    UITextField *_whoText;
    UITextField *_whereText;
    UITextField *_detailText;
    
    UIView  *_fromDateView;
    UIButton *_fromDateViewCancelBtn;
    UIButton *_fromDateViewOKBtn;
    UIPickerView *_fromPickerView;
    CGFloat _fromTime;
    
    UIView  *_toDateView;
    UIButton *_toDateViewCancelBtn;
    UIButton *_toDateViewOKBtn;
    UIPickerView *_toPickerView;
    CGFloat _toTime;
    
    NSString *_today;
    NSInteger _pickerHour;
    NSInteger _pickerMinute;
    
    NSRange _usedCoinRange;
    
    OneDayCoins *_todayCoins;
    
    UIView *_typeView;
    UIButton *_EffectiveWorkBtn;
    UIButton *_EffectiveEntertainmentBtn;
    UIButton *_RestBtn;
    UIButton *_ForcedWorkBtn;
    UIButton *_IneffectiveDelayBtn;
    
    GoldCoinType _type;
}

@property (assign, nonatomic) BOOL newCoins;
@property (assign, nonatomic) int tableBtnQueueIndex;

@end

@implementation UseCoinTableViewController

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
//    NSLog(@"new coins: %d", self.newCoins);
//    NSLog(@"btn index: %d", self.tableBtnQueueIndex);
    _todayCoins = [OneDayCoins sharedOneDayCoins];
    
    //navigation
    self.navigationItem.title = @"使用金币";
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editDone:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(editCancel:)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    //table
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //basic message
    NSString *fromMessage = nil;
    NSString *toMessage = nil;
    _today = [NSString stringWithFormat:@"%@ %@", _todayCoins.dateYear, _todayCoins.dateWeek];
    if (self.newCoins == YES) {
        fromMessage = [NSString stringWithFormat:@"从 %@ 07:00", _today];
        toMessage = [NSString stringWithFormat:@"到 %@ 07:30", _today];
    }
    else
    {
        int index = ((Coin*)[_todayCoins.usedCoinQueue objectAtIndex:self.tableBtnQueueIndex]).coinID;
        NSString *timePeriod = [_todayCoins.globalTimeBox objectAtIndex:index];
        NSRange range = {0, 5};
        fromMessage = [NSString stringWithFormat:@"从 %@ %@", _today, [timePeriod substringWithRange:range]];
        range.location = 6;
        range.length = 5;
        toMessage = [NSString stringWithFormat:@"到 %@ %@", _today, [timePeriod substringWithRange:range]];
    }
    
    _fromTime = 7.0;
    _toTime = 7.5;
    _usedCoinRange.location = 14;
    _usedCoinRange.length = 1;
    
    CGRect rect = CGRectMake(15, 0, UseCoinCellWidth, UseCoinCellHight);
    
    //button
    _fromBtn = [[UIButton alloc]initWithFrame:rect];
    [_fromBtn setTitle:fromMessage forState:UIControlStateNormal];
    [_fromBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_fromBtn addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchDown];
    
    _toBtn = [[UIButton alloc]initWithFrame:rect];
    [_toBtn setTitle:toMessage forState:UIControlStateNormal];
    [_toBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_toBtn addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchDown];
    
    //text field
    _todoText = [[UITextField alloc]initWithFrame:rect];
    _todoText.placeholder = @"输入事项名称";
    [_todoText setTextColor:[UIColor blackColor]];
    
    _whoText = [[UITextField alloc]initWithFrame:rect];
    _whoText.placeholder = @"输入事项参与者";
    [_whoText setTextColor:[UIColor blackColor]];
    
    _whereText = [[UITextField alloc]initWithFrame:rect];
    _whereText.placeholder = @"输入事项发生地点";
    [_whereText setTextColor:[UIColor blackColor]];
    
    _detailText = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, UseCoinCellWidth, 2*UseCoinCellHight)];
    _detailText.placeholder = @"输入事项详细内容";
    [_detailText setTextColor:[UIColor blackColor]];
    
    [self dateUILayout];
    
    [self typeUILayout];
    
    [self loadCoinData];
}

-(void) dateUILayout{
    //form date view
    _fromDateView = [[UIView alloc]initWithFrame:CGRectMake(-ViewWidth-10, UseCoinCellHight, ViewWidth, ViewHight)];
    _fromDateView.backgroundColor = [[UIColor alloc]initWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    _fromDateView.layer.cornerRadius = 5;
    [self.view addSubview:_fromDateView];
    
    _fromDateViewOKBtn = [[UIButton alloc]initWithFrame:CGRectMake(_fromDateView.frame.size.width/2-25, ViewHight-30, 50, 20)];
    _fromDateViewOKBtn.backgroundColor = [[UIColor alloc]initWithRed:142/255.0 green:186/255.0 blue:236/255.0 alpha:1];
    [_fromDateViewOKBtn setTitle:@"OK" forState:UIControlStateNormal];
    [_fromDateViewOKBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _fromDateViewOKBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _fromDateViewOKBtn.layer.cornerRadius = 5;
    [_fromDateViewOKBtn addTarget:self action:@selector(selectDateDone:) forControlEvents:UIControlEventTouchDown];
    [_fromDateView addSubview:_fromDateViewOKBtn];
    
    CGRect pickerViewRect = CGRectMake(20, 20, _fromDateView.frame.size.width-40, ViewHight-50);
    
    _fromPickerView = [[UIPickerView alloc]initWithFrame:pickerViewRect];
    _fromPickerView.backgroundColor = [[UIColor alloc]initWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [_fromDateView addSubview:_fromPickerView];
    _fromPickerView.dataSource = self;
    _fromPickerView.delegate = self;
    
    //to date view
    _toDateView = [[UIView alloc]initWithFrame:CGRectMake(-ViewWidth-10, 2*UseCoinCellHight, ViewWidth, ViewHight)];
    _toDateView.backgroundColor = [[UIColor alloc]initWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    _toDateView.layer.cornerRadius = 5;
    [self.view addSubview:_toDateView];
    
    _toDateViewOKBtn = [[UIButton alloc]initWithFrame:CGRectMake(_toDateView.frame.size.width/2-25, ViewHight-30, 50, 20)];
    _toDateViewOKBtn.backgroundColor = [[UIColor alloc]initWithRed:142/255.0 green:186/255.0 blue:236/255.0 alpha:1];
    [_toDateViewOKBtn setTitle:@"OK" forState:UIControlStateNormal];
    [_toDateViewOKBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _toDateViewOKBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _toDateViewOKBtn.layer.cornerRadius = 5;
    [_toDateViewOKBtn addTarget:self action:@selector(selectDateDone:) forControlEvents:UIControlEventTouchDown];
    [_toDateView addSubview:_toDateViewOKBtn];
    
    _toPickerView = [[UIPickerView alloc]initWithFrame:pickerViewRect];
    _toPickerView.backgroundColor = [[UIColor alloc]initWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [_toDateView addSubview:_toPickerView];
    _toPickerView.dataSource = self;
    _toPickerView.delegate = self;
}

-(void)typeUILayout{
    _type = GCNone;
    
    CGRect rectBtn = CGRectMake(15, 0, UseCoinCellWidth, UseCoinCellHight);
    _typeBtn = [[UIButton alloc]initWithFrame:rectBtn];
    [_typeBtn setTitle:[((NSArray*)[_todayCoins.globalTypeBox objectAtIndex:0]) objectAtIndex:1] forState:UIControlStateNormal];

    [_typeBtn setTitleColor:[[UIColor alloc]initWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:0.65] forState:UIControlStateNormal];
    _typeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    _typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_typeBtn addTarget:self action:@selector(selectTypeBtn:) forControlEvents:UIControlEventTouchDown];
    
    
    _typeView = [[UIView alloc]initWithFrame:CGRectMake(-ViewWidth-10, 4*UseCoinCellHight, ViewWidth, ViewHight+30)];
    _typeView.backgroundColor = [[UIColor alloc]initWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    _typeView.layer.cornerRadius = 5;
    [self.view addSubview:_typeView];
    
    CGRect rect = _typeView.frame;
    rect.origin.x =10;
    rect.origin.y =10;
    rect.size.width -=20;
    rect.size.height = 25;
    
    _EffectiveWorkBtn = [[UIButton alloc]initWithFrame:rect];
    [_EffectiveWorkBtn setBackgroundColor:[((NSArray*)[_todayCoins.globalTypeBox objectAtIndex:1]) objectAtIndex:0]];
    [_EffectiveWorkBtn setTitle:[((NSArray*)[_todayCoins.globalTypeBox objectAtIndex:1]) objectAtIndex:1] forState:UIControlStateNormal];
    [_EffectiveWorkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    rect.origin.y = CGRectGetMaxY(_EffectiveWorkBtn.frame)+10;
    _EffectiveEntertainmentBtn = [[UIButton alloc]initWithFrame:rect];
    [_EffectiveEntertainmentBtn setBackgroundColor:[((NSArray*)[_todayCoins.globalTypeBox objectAtIndex:2]) objectAtIndex:0]];
    [_EffectiveEntertainmentBtn setTitle:[((NSArray*)[_todayCoins.globalTypeBox objectAtIndex:2]) objectAtIndex:1] forState:UIControlStateNormal];
    [_EffectiveEntertainmentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    rect.origin.y = CGRectGetMaxY(_EffectiveEntertainmentBtn.frame)+10;
    _RestBtn = [[UIButton alloc]initWithFrame:rect];
    [_RestBtn setBackgroundColor:[((NSArray*)[_todayCoins.globalTypeBox objectAtIndex:3]) objectAtIndex:0]];
    [_RestBtn setTitle:[((NSArray*)[_todayCoins.globalTypeBox objectAtIndex:3]) objectAtIndex:1] forState:UIControlStateNormal];
    [_RestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    rect.origin.y = CGRectGetMaxY(_RestBtn.frame)+10;
    _ForcedWorkBtn = [[UIButton alloc]initWithFrame:rect];
    [_ForcedWorkBtn setBackgroundColor:[((NSArray*)[_todayCoins.globalTypeBox objectAtIndex:4]) objectAtIndex:0]];
    [_ForcedWorkBtn setTitle:[((NSArray*)[_todayCoins.globalTypeBox objectAtIndex:4]) objectAtIndex:1] forState:UIControlStateNormal];
    [_ForcedWorkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    rect.origin.y = CGRectGetMaxY(_ForcedWorkBtn.frame)+10;
    _IneffectiveDelayBtn = [[UIButton alloc]initWithFrame:rect];
    [_IneffectiveDelayBtn setBackgroundColor:[((NSArray*)[_todayCoins.globalTypeBox objectAtIndex:5]) objectAtIndex:0]];
    [_IneffectiveDelayBtn setTitle:[((NSArray*)[_todayCoins.globalTypeBox objectAtIndex:5]) objectAtIndex:1] forState:UIControlStateNormal];
    [_IneffectiveDelayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_typeView addSubview:_EffectiveWorkBtn];
    [_typeView addSubview:_EffectiveEntertainmentBtn];
    [_typeView addSubview:_RestBtn];
    [_typeView addSubview:_ForcedWorkBtn];
    [_typeView addSubview:_IneffectiveDelayBtn];
    
    [_EffectiveWorkBtn addTarget:self action:@selector(typeBtn:) forControlEvents:UIControlEventTouchDown];
    [_EffectiveEntertainmentBtn addTarget:self action:@selector(typeBtn:) forControlEvents:UIControlEventTouchDown];
    [_RestBtn addTarget:self action:@selector(typeBtn:) forControlEvents:UIControlEventTouchDown];
    [_ForcedWorkBtn addTarget:self action:@selector(typeBtn:) forControlEvents:UIControlEventTouchDown];
    [_IneffectiveDelayBtn addTarget:self action:@selector(typeBtn:) forControlEvents:UIControlEventTouchDown];
}

-(void)loadCoinData{
    if (self.newCoins == YES) {
        return;
    }
    
    Coin* coin = [_todayCoins.usedCoinQueue objectAtIndex:self.tableBtnQueueIndex];
    if (coin.title != nil && coin.title.length != 0) {
        [_todoText setText:coin.title];
    }
    
    if (coin.who != nil && coin.who.length != 0) {
        [_whoText setText:coin.who];
    }
    
    if (coin.where != nil && coin.where.length !=0 ) {
        [_whereText setText:coin.where];
    }
    
    if (coin.detail != nil && coin.detail.length != 0) {
        [_detailText setText:coin.detail];
    }
    
    if (coin.type != GCNone) {
        _type = coin.type;
        [_typeBtn setTitle:[((NSArray*)[_todayCoins.globalTypeBox objectAtIndex:_type]) objectAtIndex:1] forState:UIControlStateNormal];
        [_typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _typeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    
    //冻结时间选项
    [_fromBtn setEnabled:NO];
    [_toBtn setEnabled:NO];
}

-(void)collectInfo:(Coin*)coin{
    if (coin == nil) {
        return;
    }
    
    BOOL collect = NO;
    if (_todoText.text.length != 0) {
        if (coin.title == nil) {
            coin.title = [[NSMutableString alloc]initWithString:_todoText.text];
        }
        else
        {
            [coin.title setString:_todoText.text];
        }
        
        collect = YES;
    }
    
    if (_whoText.text.length != 0) {
        if (coin.who == nil) {
            coin.who = [[NSMutableString alloc]initWithString:_whoText.text];
        }
        else
        {
            [coin.who setString:_whoText.text];
        }
        
        collect = YES;
    }
    
    if (_whereText.text.length != 0) {
        if (coin.where == nil) {
            coin.where = [[NSMutableString alloc]initWithString:_whereText.text];
        }
        else
        {
            [coin.where setString:_whereText.text];
        }
        
        collect = YES;
    }
    
    if (_detailText.text.length != 0) {
        if (coin.detail == nil) {
            coin.detail = [[NSMutableString alloc]initWithString:_detailText.text];
        }
        else
        {
            [coin.detail setString:_detailText.text];
        }
        
        collect = YES;
    }
    
    if (_type != GCNone) {
        coin.type = _type;
        collect = YES;
    }
    
    coin.used = collect;
    
    return;
}

#pragma mark Action
-(void)editDone:(id)sender{
    // check the time
    if (_fromTime >= _toTime) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"时间错误" message:@"您设置的事件结束时间早于开始时间，请更正！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //如果是新建 需要插入到全局队列中
    if (self.newCoins) {
        //comppute the coin index, there may be many coins used.
        int minCoin = floorf(_fromTime) * 2 + ((_fromTime - floorf(_fromTime) > 0) ? 1: 0);
        int maxCoin = floorf(_toTime) * 2 + ((_toTime - floorf(_toTime) > 0) ? 1: 0);
        
        int placeHold=-1;
        int index=0;
        for (Coin* coin in _todayCoins.usedCoinQueue) {
            int coinID = coin.coinID;
            if (minCoin <= coinID && coinID <= maxCoin) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"时间错误" message:@"您设置的事件执行时间已经被占用，请更正！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            else if (placeHold == -1 && maxCoin < coinID)
            {
                placeHold =index;
            }
            
            index++;
        }
        
        //insert the new coin to coin queue
        if (placeHold == -1) {
            for (int i=minCoin; i<maxCoin; i++) {
                Coin *coin = [[Coin alloc]init];
                coin.coinID = i;
                [self collectInfo:coin];
                
                [_todayCoins.usedCoinQueue addObject:coin];
            }
        }
        else
        {
            int coinIndex = minCoin;
            for (int i=placeHold; i<placeHold+maxCoin-minCoin; i++) {
                Coin *coin = [[Coin alloc]init];
                coin.coinID = coinIndex;
                [self collectInfo:coin];
                
                [_todayCoins.usedCoinQueue insertObject:coin atIndex:i];
                coinIndex++;
            }
        }
    }
    else{ //不是新建，直接修改即可
        Coin *coin = [_todayCoins.usedCoinQueue objectAtIndex:_tableBtnQueueIndex];
        [self collectInfo:coin];
    }
    
        
//    for (Coin *i in _todayCoins.usedCoinQueue) {
//        NSLog(@"index: %d", i.coinID);
//    }
    
//    NSLog(@"%ld, %ld", _usedCoinRange.location, _usedCoinRange.length);
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)editCancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectDate:(UIButton*)sender{
    if (sender == _fromBtn) {
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
            _fromDateView.transform = CGAffineTransformMakeTranslation(ViewWidth+10+ViewWidth/2, 0);
        } completion:^(BOOL finished) {
            
        }];
    }
    else if (sender == _toBtn)
    {
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
            _toDateView.transform = CGAffineTransformMakeTranslation(ViewWidth+10+ViewWidth/2, 0);
        } completion:^(BOOL finished) {

        }];
    }
}

-(void)selectDateDone:(id)sender{
//    NSLog(@"selectDateDone");
    
    if (sender == _fromDateViewOKBtn) {
        NSString *fromMessage = [NSString stringWithFormat:@"从 %@ %02ld:%02ld", _today, _pickerHour, _pickerMinute];

        [_fromBtn setTitle:fromMessage forState:UIControlStateNormal];
        
        if (_pickerMinute == 30) {
            _fromTime = _pickerHour + 0.5;
        }
        else
        {
            _fromTime = _pickerHour;
        }
    }
    else if (sender == _toDateViewOKBtn)
    {
        NSString *toMessage = [NSString stringWithFormat:@"从 %@ %02ld:%02ld", _today,_pickerHour, _pickerMinute];
        
        [_toBtn setTitle:toMessage forState:UIControlStateNormal];
        
        if (_pickerMinute == 30) {
            _toTime = _pickerHour + 0.5;
        }
        else
        {
            _toTime = _pickerHour;
        }
    }
    
    [self selectDateCancel:sender];
}

-(void)selectDateCancel:(id)sender{
//    NSLog(@"selectDateCancel");
    if (sender == _fromDateViewCancelBtn
        || sender == _fromDateViewOKBtn) {
        
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:0 animations:^{
            _fromDateView.transform = CGAffineTransformMakeTranslation(-ViewWidth-10-ViewWidth/2, 0);
        } completion:^(BOOL finished) {

        }];
    }
    else if (sender == _toDateViewCancelBtn
             || _toDateViewOKBtn)
    {
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:0 animations:^{
            _toDateView.transform = CGAffineTransformMakeTranslation(-ViewWidth-10-ViewWidth/2, 0);
        } completion:^(BOOL finished) {

        }];
    }
}

-(void)selectTypeBtn:(id)sender{
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
        _typeView.transform = CGAffineTransformMakeTranslation(ViewWidth+10+20, 0);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)typeBtn:(id)sender{
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:0 animations:^{
        _typeView.transform = CGAffineTransformMakeTranslation(-ViewWidth-10-20, 0);
    } completion:^(BOOL finished) {
        
    }];
    
    if (sender == _EffectiveWorkBtn) {
        _type = GCEffectiveWork;
    }
    else if (sender == _EffectiveEntertainmentBtn)
    {
        _type = GCEffectiveEntertainment;
    }
    else if (sender == _RestBtn)
    {
        _type = GCRest;
    }
    else if (sender == _ForcedWorkBtn)
    {
        _type = GCForcedWork;
    }
    else if (sender == _IneffectiveDelayBtn)
    {
        _type = GCIneffectiveDelay;
    }
    
    [_typeBtn setTitle:[((NSArray*)[_todayCoins.globalTypeBox objectAtIndex:_type]) objectAtIndex:1] forState:UIControlStateNormal];
    [_typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _typeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"useCoin";
    
    UITableViewCell *cell = nil;
    cell = [self.tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }

    switch (indexPath.row) {
        case 0:
            [cell.contentView addSubview:_fromBtn];
            break;
        case 1:
            [cell.contentView addSubview:_toBtn];
            break;
        case 2:
            [cell.contentView addSubview:_todoText];
            break;
        case 3:
            [cell.contentView addSubview:_typeBtn];
            break;
        case 4:
            [cell.contentView addSubview:_whoText];
            break;
        case 5:
            [cell.contentView addSubview:_whereText];
            break;
        case 6:
            [cell.contentView addSubview:_detailText];
            break;
            
        default:
            break;
    }
  
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 6) {
        return 2*UseCoinCellHight;
    }
    else if (indexPath.row == 7) {
        return [UIScreen mainScreen].bounds.size.height - 8*UseCoinCellHight  - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height;
    }
    else
        return UseCoinCellHight;
}

#pragma mark UIPickerView datesource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 24;
    }
    else if (component == 1)
    {
        return 1;
    }
    else if (component == 2)
    {
        return 2;
    }
    
    return 0;
}

#pragma mark UIPickerView delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == 1) {
        return 15;
    }
    return 40;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 25;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [NSString stringWithFormat:@"%02ld", (long)row];
    }
    else if (component == 1)
    {
        return @":";
    }
    else
    {
        if (row == 0) {
            return @"00";
        }
        else
        {
            return @"30";
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        _pickerHour = row;
    }
    else if (component == 2)
    {
        if (row == 0) {
            _pickerMinute = 0;
        }
        else
        {
            _pickerMinute = 30;
        }
        
    }
}

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

}
@end