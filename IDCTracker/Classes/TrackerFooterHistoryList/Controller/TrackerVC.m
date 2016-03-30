//
//  TrackerVC.m
//  IDCTracker
//
//  Created by admin on 23/2/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "TrackerVC.h"
#import "TrackerFooterHistoryList.h"
#import "TrackerCalendarView.h"


@interface TrackerVC ()<TrackerCalendarViewDelegate>

@property (nonatomic, strong) TrackerCalendarView * customCalendarView;

@property (nonatomic, strong) NSCalendar * gregorian;

@property (nonatomic, assign) NSInteger currentYear;

@property(strong,nonatomic)TrackerFooterHistoryList*trackerFooterHistoryListVC;
/**
 *  上一次选中的日期
 */
@property(strong,nonatomic)NSDate*preSelectedDate;
@end

@implementation TrackerVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = self.navTitle;
    //1. add calendar
    [self addCalendar];
    
    
}
-(void)addCalendar
{
       
    _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    _customCalendarView = [[TrackerCalendarView alloc]initWithFrame:CGRectMake(0, TrackerHeight, TrackerWidth, TrackerHeight/2+40)];
    _customCalendarView.delegate                    = self;
    _customCalendarView.calendarDate                = [NSDate date];
    _customCalendarView.monthAndDayTextColor        = RGBCOLOR(0,174,255);
    _customCalendarView.dayborderColorSelected      = [UIColor redColor];
    _customCalendarView.dayTxtColorWithoutData      = RGBCOLOR(57, 69, 84);
    _customCalendarView.dayTxtColorWithData         = [UIColor blackColor];
    _customCalendarView.dayTxtColorSelected         = [UIColor blackColor];
    _customCalendarView.backgroundColor = [UIColor whiteColor];
    
    _customCalendarView.allowsChangeMonthByDayTap   = YES;
    _customCalendarView.allowsChangeMonthByButtons  = YES;
    _customCalendarView.keepSelDayWhenMonthChange   = YES;
    _customCalendarView.nextMonthAnimation          = UIViewAnimationOptionTransitionFlipFromRight;
    _customCalendarView.prevMonthAnimation          = UIViewAnimationOptionTransitionFlipFromLeft;
    
    
    NSDateComponents * yearComponent = [_gregorian components:NSCalendarUnitYear fromDate:[NSDate date]];
    _currentYear = yearComponent.year;

    _trackerFooterHistoryListVC = [[TrackerFooterHistoryList alloc] init];

    __weak typeof(self) mySelf = self;
    _trackerFooterHistoryListVC.calenderShowButtonClickBlock = ^(){
        [mySelf show];
    };
    
    [self createPopVCWithRootVC:_trackerFooterHistoryListVC andPopView:_customCalendarView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.customCalendarView removeFromSuperview];
}

#pragma mark - CalendarDelegate protocol conformance
-(void)closeCalendar
{
    //关闭日历视图
    [self close];
}
-(void)dayChangedToDate:(NSDate *)selectedDate
{
    TLog(@"-----%@",selectedDate);
    //1.设置选中的日期
    if (![selectedDate isEqual:self.preSelectedDate]) {
        _trackerFooterHistoryListVC.selectedDate = selectedDate;
        self.preSelectedDate = selectedDate;
    }
    //2.关闭日历视图
    //[self close];
}
@end
