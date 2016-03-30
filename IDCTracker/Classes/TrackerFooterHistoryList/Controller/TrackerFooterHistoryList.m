//
//  TrackerFooterHistoryList.m
//  IDCTracker
//
//  Created by admin on 17/2/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "TrackerFooterHistoryList.h"
#import "TrackerFooterHistory.h"
#import "TrackerFooterListCell.h"
#import "TrackerHeadView.h"

static NSString*cellID = @"TrackerFooterListCellID";

@interface TrackerFooterHistoryList ()<UITableViewDataSource,UITableViewDelegate,TrackerHeadViewDelegate>

@property(strong,nonatomic)UITableView*tableView;

@property(strong,nonatomic)NSMutableArray*footerDataList;

@property(strong,nonatomic)TrackerHeadView*headerView;

@end

@implementation TrackerFooterHistoryList

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //1. add header view
    [self addHeaderView];
    //2. add tableView
    [self addTableView];
}
-(void)addTableView
{
    //tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, TrackerWidth, TrackerHeight-100) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //regist cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TrackerFooterListCell" bundle:nil] forCellReuseIdentifier:cellID];
    
    self.tableView.rowHeight = 93;

}
-(void)addHeaderView
{
    
    //header view
    TrackerHeadView*headerView = [[TrackerHeadView alloc] initWithFrame:CGRectMake(0, 0, TrackerWidth, 100)];
    self.headerView = headerView;
    headerView.backgroundColor = [UIColor lightGrayColor];
    headerView.delegate = self;
    headerView.block = ^(NSString*dateStr){
        TLog(@"----%@",dateStr);
        
        //根据日期来请求数据
        [self.tableView reloadData];
    };
    
    [self.view addSubview:headerView];
    
}
- (void)setSelectedDate:(NSDate *)selectedDate
{
    _selectedDate = selectedDate;
    //TLog(@"----%@",selectedDate);
    //1.重新设置headerView的日期
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay;

    NSDateComponents *components = [calendar components:unit fromDate:selectedDate];

    self.headerView.yearLabel.text = [NSString stringWithFormat:@"%ld年",components.year];
    self.headerView.monthLabel.text = [NSString stringWithFormat:@"%ld月",components.month];
    self.headerView.dayLabel.text = [NSString stringWithFormat:@"%ld",components.day];

    self.headerView.yearCount = components.year;
    self.headerView.monthCount = components.month;
    self.headerView.dayCount = components.day;
    
    //2.根据日期来请求数据
    [self.tableView reloadData];
    
}
#pragma mark - TrackerHeadViewDelegate
- (void)headViewCalenderShowButtonClick
{
    //NSCParameterAssert(<#condition#>)
    if (self.calenderShowButtonClickBlock) {
        self.calenderShowButtonClickBlock();
    }
}
#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrackerFooterListCell*cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.contentLbl.text = [NSString stringWithFormat:@"这是%d次旅行",arc4random()%15];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TrackerFooterHistory*tfh = [[TrackerFooterHistory alloc] init];
    [self.navigationController pushViewController:tfh animated:YES];
}
@end
