//
//  UseCoinTableViewController.m
//  34GoldCoinTimeAccount
//
//  Created by jason on 15/11/24.
//  Copyright © 2015年 JasonAi. All rights reserved.
//

#import "UseCoinTableViewController.h"

#define ViewHight   160
#define ViewWidth   ([UIScreen mainScreen].bounds.size.width/2)
#define UseCoinCellHight   40
#define UseCoinCellWidth \
    ([UIScreen mainScreen].bounds.size.width)

@interface UseCoinTableViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_weekCn;
    
    UIButton *_fromBtn;
    UIButton *_toBtn;
    UITextField *_todoText;
    UITextField *_whoText;
    UITextField *_whereText;
    UITextField *_detailText;
    
    UIView  *_fromDateView;
    UIButton *_fromDateViewCancelBtn;
    UIButton *_fromDateViewOKBtn;
    
    UIView  *_toDateView;
    UIButton *_toDateViewCancelBtn;
    UIButton *_toDateViewOKBtn;
    

}

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

-(void)UILayout{
    //navigation
    self.navigationItem.title = @"使用金币";
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editDone:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(editCancel:)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    //table
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self initArray];
    
    //basic message
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps =[calendar components:(NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday |NSCalendarUnitWeekdayOrdinal) fromDate:today];
    
    NSString *todayWeek = [_weekCn objectAtIndex:[comps weekday]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *todayYear = [dateFormatter stringFromDate:today];
    
    NSString *fromMessage = [NSString stringWithFormat:@"从 %@ %@ 上午7:00", todayYear, todayWeek];
    NSString *toMessage = [NSString stringWithFormat:@"到 %@ %@ 上午7:30", todayYear, todayWeek];
    
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
    
    //form date view
    _fromDateView = [[UIView alloc]initWithFrame:CGRectMake(-ViewWidth-10, UseCoinCellHight, ViewWidth, ViewHight)];
    _fromDateView.backgroundColor = [UIColor lightGrayColor];
 
    _fromDateViewCancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, ViewHight-30, 50, 20)];
    _fromDateViewCancelBtn.backgroundColor = [UIColor darkGrayColor];
    [_fromDateViewCancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [_fromDateViewCancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _fromDateViewCancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    _fromDateViewOKBtn = [[UIButton alloc]initWithFrame:CGRectMake(110, ViewHight-30, 50, 20)];
    _fromDateViewOKBtn.backgroundColor = [UIColor darkGrayColor];
    [_fromDateViewOKBtn setTitle:@"OK" forState:UIControlStateNormal];
    [_fromDateViewOKBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _fromDateViewOKBtn.titleLabel.font = [UIFont systemFontOfSize:12];
 
    [_fromDateViewOKBtn addTarget:self action:@selector(selectDateDone:) forControlEvents:UIControlEventTouchDown];
    [_fromDateViewCancelBtn addTarget:self action:@selector(selectDateCancel:) forControlEvents:UIControlEventTouchDown];
    
    [_fromDateView addSubview:_fromDateViewOKBtn];
    [_fromDateView addSubview:_fromDateViewCancelBtn];
    [self.view addSubview:_fromDateView];
    
    //to date view
    _toDateView = [[UIView alloc]initWithFrame:CGRectMake(-ViewWidth-10, 2*UseCoinCellHight, ViewWidth, ViewHight)];
    _toDateView.backgroundColor = [UIColor lightGrayColor];
    
    _toDateViewCancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, ViewHight-30, 50, 20)];
    _toDateViewCancelBtn.backgroundColor = [UIColor darkGrayColor];
    [_toDateViewCancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [_toDateViewCancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _toDateViewCancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    _toDateViewOKBtn = [[UIButton alloc]initWithFrame:CGRectMake(110, ViewHight-30, 50, 20)];
    _toDateViewOKBtn.backgroundColor = [UIColor darkGrayColor];
    [_toDateViewOKBtn setTitle:@"OK" forState:UIControlStateNormal];
    [_toDateViewOKBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _toDateViewOKBtn.titleLabel.font = [UIFont systemFontOfSize:12];
  
    [_toDateViewOKBtn addTarget:self action:@selector(selectDateDone:) forControlEvents:UIControlEventTouchDown];
    [_toDateViewCancelBtn addTarget:self action:@selector(selectDateCancel:) forControlEvents:UIControlEventTouchDown];
    
    [_toDateView addSubview:_toDateViewOKBtn];
    [_toDateView addSubview:_toDateViewCancelBtn];
    [self.view addSubview:_toDateView];
}

-(void)initArray{
    _weekCn = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
}
-(void)editDone:(id)sender{

}

-(void)editCancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectDate:(UIButton*)sender{
    if (sender == _fromBtn) {
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
            _fromDateView.transform = CGAffineTransformMakeTranslation(ViewWidth+10+ViewWidth/2, 0);
        } completion:^(BOOL finished) {
//            [self.tableView setUserInteractionEnabled:NO];
//            [_fromDateView setUserInteractionEnabled:YES];
//            [_fromDateViewCancelBtn setUserInteractionEnabled:YES];
        }];
    }
    else if (sender == _toBtn)
    {
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
            _toDateView.transform = CGAffineTransformMakeTranslation(ViewWidth+10+ViewWidth/2, 0);
        } completion:^(BOOL finished) {
//            [self.tableView setUserInteractionEnabled:NO];
        }];
    }
}

-(void)selectDateDone:(id)sender{
    NSLog(@"selectDateDone");
}

-(void)selectDateCancel:(id)sender{
    NSLog(@"selectDateCancel");
    if (sender == _fromDateViewCancelBtn) {
        
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
            _fromDateView.transform = CGAffineTransformMakeTranslation(-ViewWidth-10-ViewWidth/2, 0);
        } completion:^(BOOL finished) {
            [self.tableView setUserInteractionEnabled:YES];
        }];
    }
    else if (sender == _toDateViewCancelBtn)
    {
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
            _toDateView.transform = CGAffineTransformMakeTranslation(-ViewWidth-10-ViewWidth/2, 0);
        } completion:^(BOOL finished) {
            [self.tableView setUserInteractionEnabled:YES];
        }];
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
            cell.textLabel.text = @"hello";
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

#pragma mark - 视图控制器的触摸事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"UIViewController start touch...");
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"UIViewController moving...");
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"UIViewController touch end.");
}
@end