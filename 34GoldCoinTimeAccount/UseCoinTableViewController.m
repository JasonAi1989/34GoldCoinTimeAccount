//
//  UseCoinTableViewController.m
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/24.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import "UseCoinTableViewController.h"
#import "OneDayCoins.h"
#import "CDCoinService.h"
#import "CDBasketService.h"
#import "CoinsHistory.h"
#import "CoinsHistory.h"

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
    NSInteger _fromPickerHour;
    NSInteger _fromPickerMinute;
    
    UIView  *_toDateView;
    UIButton *_toDateViewCancelBtn;
    UIButton *_toDateViewOKBtn;
    UIPickerView *_toPickerView;
    CGFloat _toTime;
    NSInteger _toPickerHour;
    NSInteger _toPickerMinute;
    
    NSString *_today;
    
    OneDayCoins *_todayCoins;
    
    UIView *_typeView;
    UIButton *_EffectiveWorkBtn;
    UIButton *_EffectiveEntertainmentBtn;
    UIButton *_RestBtn;
    UIButton *_ForcedWorkBtn;
    UIButton *_IneffectiveDelayBtn;
    
    GoldCoinType _type;
    
    UIView *_mask;
    
    BOOL _fromDateSelected;
    BOOL _toDateSelected;
    BOOL _typeSelected;
    
    BOOL _modifyFlag;  //cancle is NO, OK is YES
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
        
        _fromTime = 7.0;
        _toTime = 7.5;
    }
    else
    {
        int index = ((Coin*)[_todayCoins.usedCoinQueue objectAtIndex:self.tableBtnQueueIndex]).coinID;
        NSString *timePeriod = [_todayCoins.globalTimeBox objectAtIndex:index];
        
        //@"01:30-02:00"
        NSRange range = {0, 5};
        fromMessage = [NSString stringWithFormat:@"从 %@ %@", _today, [timePeriod substringWithRange:range]];
        range.location = 6;
        range.length = 5;
        toMessage = [NSString stringWithFormat:@"到 %@ %@", _today, [timePeriod substringWithRange:range]];
        
        NSRange hourRange = {0,2};
        NSRange minuteRange = {3, 2};
        int hour = [[timePeriod substringWithRange:hourRange] intValue];
        int minute = [[timePeriod substringWithRange:minuteRange] intValue];
        
        if (minute == 30) {
            _fromTime = hour + 0.5;
        }
        else
        {
            _fromTime = hour;
        }
        
        hourRange.location = 6;
        hourRange.length = 2;
        minuteRange.location = 9;
        minuteRange.length = 2;
        hour = [[timePeriod substringWithRange:hourRange] intValue];
        minute = [[timePeriod substringWithRange:minuteRange] intValue];
        
        if (minute == 30) {
            _toTime = hour + 0.5;
        }
        else
        {
            _toTime = hour;
        }
    }
    
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
    
    //mask
    _mask = [[UIView alloc]initWithFrame:self.tableView.bounds];
    [_mask setBackgroundColor:[UIColor blackColor]];
    [_mask setAlpha:0.3];

    [self dateUILayout];
    
    [self typeUILayout];
    
    [self loadCoinData];
    
    [self addTapForMask];
    
    _modifyFlag = NO;
}

-(void) dateUILayout{
    //form date view
    _fromDateView = [[UIView alloc]initWithFrame:CGRectMake(-ViewWidth-10, UseCoinCellHight, ViewWidth, ViewHight)];
    _fromDateView.backgroundColor = [[UIColor alloc]initWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    _fromDateView.layer.cornerRadius = 5;
//    [self.view addSubview:_fromDateView];
    
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
//    [self.view addSubview:_toDateView];
    
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
    
    _fromDateSelected = NO;
    _toDateSelected = NO;
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
//    [self.view addSubview:_typeView];
    
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
    
    _typeSelected = NO;
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
//    [_fromBtn setEnabled:NO];
//    [_toBtn setEnabled:NO];
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
            coin.title = [[NSMutableString alloc]initWithString:_todoText.text];
        }
        
        collect = YES;
    }
    
    if (_whoText.text.length != 0) {
        if (coin.who == nil) {
            coin.who = [[NSMutableString alloc]initWithString:_whoText.text];
        }
        else
        {
//            [coin.who setString:_whoText.text];
            coin.who = [[NSMutableString alloc]initWithString:_whoText.text];
        }
        
        collect = YES;
    }
    
    if (_whereText.text.length != 0) {
        if (coin.where == nil) {
            coin.where = [[NSMutableString alloc]initWithString:_whereText.text];
        }
        else
        {
//            [coin.where setString:_whereText.text];
            coin.where = [[NSMutableString alloc]initWithString:_whereText.text];
        }
        
        collect = YES;
    }
    
    if (_detailText.text.length != 0) {
        if (coin.detail == nil) {
            coin.detail = [[NSMutableString alloc]initWithString:_detailText.text];
        }
        else
        {
//            [coin.detail setString:_detailText.text];
            coin.detail = [[NSMutableString alloc]initWithString:_detailText.text];
        }
        
        collect = YES;
    }
    
    if (_type != GCNone) {
        if (coin.type != GCNone
            && coin.type != _type) {

            [[CoinsHistory sharedCoinsHistory] updateWithOldTypr:coin.type NewType:_type];
        }
        
        coin.type = _type;
        collect = YES;
    }
    
    coin.used = collect;
    
    return;
}

-(void)writeToCoreData:(Coin*)coin Basket:(CDBasket*)basket{
    CDCoinService *cs = [CDCoinService sharedCDCoinService];
    CDCoin *cdCoin = [cs getCoinWithCoinID:[NSNumber numberWithInt:coin.coinID]];
    
    //add new coin
    if (cdCoin == nil) {
        [cs addCoinWithCoinID:[NSNumber numberWithInt:coin.coinID] Used:[NSNumber numberWithBool:coin.used] Title:coin.title Type:[NSNumber numberWithInt:coin.type] Who:coin.who Where:coin.where Detail:coin.detail Basket:basket];
        
        CDCoin *newCDCoin = [cs getCoinWithCoinID:[NSNumber numberWithInt:coin.coinID]];

        [basket addCoinsObject:newCDCoin];

        //增加历史统计信息
        [[CoinsHistory sharedCoinsHistory] addNewCoin:coin];
    }
    else//modify the old coin
    {

        [cs modifyCoinWithCoinID:[NSNumber numberWithInt:coin.coinID] Used:[NSNumber numberWithBool:coin.used] Title:coin.title Type:[NSNumber numberWithInt:coin.type] Who:coin.who Where:coin.where Detail:coin.detail Basket:basket];
    }
}

- (void)addTapForMask
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideForMask)];
    [_mask addGestureRecognizer:tap];
}

#pragma mark Action
-(void)editDone:(id)sender{
    // check the time
    if (_fromTime >= _toTime) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"时间错误" message:@"您设置的事件结束时间早于开始时间，请更正！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //check the title and type Label is fill or not
    if (_todoText.text.length == 0 || _type == GCNone) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"内容错误" message:@"您至少需要输入事项名称和状态" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //get the basket to contain the coins
    CDBasket *basket = [[CDBasketService sharedCDBasketService] getBasketWithDate:_todayCoins.dateYear];
    if (basket == nil) {
        [[CDBasketService sharedCDBasketService] addBasketWithDate:_todayCoins.dateYear];
        basket = [[CDBasketService sharedCDBasketService] getBasketWithDate:_todayCoins.dateYear];
    }
    
    //compute the coin index, there may be many coins used.
    int minCoin = floorf(_fromTime) * 2 + ((_fromTime - floorf(_fromTime) > 0) ? 1: 0);
    int maxCoin = floorf(_toTime) * 2 + ((_toTime - floorf(_toTime) > 0) ? 1: 0);
    
    //check the time
    if (_modifyFlag == NO) {
        for (int i = minCoin; i<maxCoin; i++) {
            for (int j=0; j<_todayCoins.usedCoinQueue.count; j++) {
                Coin *coin = [_todayCoins.usedCoinQueue objectAtIndex:j];
                if (coin.coinID == i && coin.used) {
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"金币被使用" message:@"您设置的事件执行时间已经被使用，如若确认更改，请点击确定！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alert show];
                    
                    return;
                }
            }
        }
    }
    
    //modify or add
    for (int i = minCoin; i<maxCoin; i++) {
        BOOL modifyFlag=NO;
        
        for (int j=0; j<_todayCoins.usedCoinQueue.count; j++) {
            Coin *coin = [_todayCoins.usedCoinQueue objectAtIndex:j];
            if (coin.coinID == i) {
                [self collectInfo:coin];
                modifyFlag = YES;
                
                [self writeToCoreData:coin Basket:basket];
            }
        }
        
        if (modifyFlag == NO) {
            Coin *coin = [[Coin alloc]init];
            coin.coinID = i;
            [self collectInfo:coin];
            
            [self writeToCoreData:coin Basket:basket];
            
            [_todayCoins.usedCoinQueue addObject:coin];
            
            [_todayCoins.usedCoinQueue sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                Coin *coin1 = obj1;
                Coin *coin2 = obj2;
                
                if (coin1.coinID > coin2.coinID) {
                    return YES;
                }
                
                return NO;
            }];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)editCancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectDate:(UIButton*)sender{
    if (sender == _fromBtn) {
        [self.tableView addSubview:_mask];
        [self.tableView addSubview:_fromDateView];
        
        _fromDateSelected = YES;
        
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
            _fromDateView.transform = CGAffineTransformMakeTranslation(ViewWidth+10+ViewWidth/2, 0);
        } completion:^(BOOL finished) {
            
        }];
    }
    else if (sender == _toBtn)
    {
        [self.tableView addSubview:_mask];
        [self.tableView addSubview:_toDateView];
        
        _toDateSelected = YES;
        
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
            _toDateView.transform = CGAffineTransformMakeTranslation(ViewWidth+10+ViewWidth/2, 0);
        } completion:^(BOOL finished) {

        }];
    }
}

-(void)selectDateDone:(id)sender{
//    NSLog(@"selectDateDone");
    
    if (sender == _fromDateViewOKBtn) {
        NSString *fromMessage = [NSString stringWithFormat:@"从 %@ %02ld:%02ld", _today, _fromPickerHour, _fromPickerMinute];

        [_fromBtn setTitle:fromMessage forState:UIControlStateNormal];
        
        if (_fromPickerMinute == 30) {
            _fromTime = _fromPickerHour + 0.5;
        }
        else
        {
            _fromTime = _fromPickerHour;
        }
    }
    else if (sender == _toDateViewOKBtn)
    {
        NSString *toMessage = [NSString stringWithFormat:@"从 %@ %02ld:%02ld", _today, _toPickerHour, _toPickerMinute];
        
        [_toBtn setTitle:toMessage forState:UIControlStateNormal];
        
        if (_toPickerMinute == 30) {
            _toTime = _toPickerHour + 0.5;
        }
        else
        {
            _toTime = _toPickerHour;
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
        
        [_mask removeFromSuperview];
        [_fromDateView removeFromSuperview];
        
        _fromDateSelected = NO;
    }
    else if (sender == _toDateViewCancelBtn
             || _toDateViewOKBtn)
    {
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:0 animations:^{
            _toDateView.transform = CGAffineTransformMakeTranslation(-ViewWidth-10-ViewWidth/2, 0);
        } completion:^(BOOL finished) {

        }];
        
        [_mask removeFromSuperview];
        [_toDateView removeFromSuperview];
        
        _toDateSelected = NO;
    }
}

-(void)selectTypeBtn:(id)sender{
    [self.tableView addSubview:_mask];
    [self.tableView addSubview:_typeView];
    
    _typeSelected = YES;
    
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
        _typeView.transform = CGAffineTransformMakeTranslation(ViewWidth+10+20, 0);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)typeBtn:(id)sender{
    _typeSelected = NO;
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:0 animations:^{
        _typeView.transform = CGAffineTransformMakeTranslation(-ViewWidth-10-20, 0);
        [_mask setAlpha:0];
    } completion:^(BOOL finished) {
        [_mask removeFromSuperview];
        [_typeView removeFromSuperview];
        [_mask setAlpha:0.3];
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
    else
    {
        _type = GCNone;
    }
    
    [_typeBtn setTitle:[((NSArray*)[_todayCoins.globalTypeBox objectAtIndex:_type]) objectAtIndex:1] forState:UIControlStateNormal];
    [_typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _typeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
}

-(void)hideForMask{
    if (_typeSelected) {
        [self typeBtn:nil];
    }
    
    if (_fromDateSelected) {
        [self selectDateDone:_fromDateViewOKBtn];
    }
    
    if (_toDateSelected) {
        [self selectDateDone:_toDateViewOKBtn];
    }
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
        if (pickerView == _fromPickerView) {
            _fromPickerHour = row;
        }
        else
        {
            _toPickerHour = row;
        }
        
    }
    else if (component == 2)
    {
        if (pickerView == _fromPickerView) {
            if (row == 0) {
                _fromPickerMinute = 0;
            }
            else
            {
                _fromPickerMinute = 30;
            }
        }
        else
        {
            if (row == 0) {
                _fromPickerMinute = 0;
            }
            else
            {
                _toPickerMinute = 30;
            }
        }
    }
}

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"button index:%d", buttonIndex);
    
    //cancle
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else //OK
    {
        _modifyFlag = YES;
        [self editDone:nil];
    }
}
@end