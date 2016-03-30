//
//  TrackerHistoryController.m
//  IDCTracker
//
//  Created by Jack on 20/1/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "TrackerHistoryController.h"
#import "MCChart.h"
#import "MFloatBox.h"

#define DateRangeTag     456

#define testValue 40

typedef NS_ENUM(NSInteger, UISegementIndexType) {
    UISegementIndexTypeTemperature = 0, // Temperature
    UISegementIndexTypeHumidity,        // Humidity
    UISegementIndexTypeAQI ,            // AQI
    UISegementIndexTypePM ,             // pm2.5
    UISegementIndexTypeActiveValue ,    // active value
};

typedef NS_ENUM(NSInteger, UIDateRangeType) {
    UIDateRangeTypeDay = 0,             // Day
    UIDateRangeTypeWeek,                // Week
    UIDateRangeTypeMonth ,              // Month
    UIDateRangeTypeHalfYear ,           // halfYear
    UIDateRangeTypeYear ,               // year
};

@interface TrackerHistoryController ()<MCBarChartViewDelegate>

@property(strong,nonatomic)NSArray*segementArr;

@property(strong,nonatomic)NSArray*dateArr;

@property(strong,nonatomic)UISegmentedControl*segement;

@property(strong,nonatomic)UISegmentedControl*dateSegement;

//calculate pm2.5

@property(strong,nonatomic)UILabel*maxValueLabel;
@property(strong,nonatomic)UILabel*minValueLabel;
@property(strong,nonatomic)UILabel*averageValueLabel;
@property(strong,nonatomic)UILabel*totalValueLabel;

//chart
@property (strong, nonatomic) NSMutableArray *xTitles;

@property (strong, nonatomic) MCBarChartView *barChartView;
//pm value data source
@property(strong,nonatomic)NSMutableArray*PMDataList;
/**
 *  pop view
 */
@property(strong,nonatomic)MFloatBox*popView;
/**
 *
 */
@property (nonatomic, strong) MCColumn *mColumnSelected;

@property (nonatomic, strong) UIColor *tempColor;
@end

@implementation TrackerHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _segementArr = @[@"温度",@"湿度",@"AQI",@"PM2.5",@"活跃值"];
    _dateArr = @[@"日",@"周",@"月",@"半年",@"年"];
    
    self.navigationItem.title = _segementArr[self.segementIndex];
    self.view.backgroundColor = [UIColor whiteColor];
  
    NSMutableArray*chartDataList = [NSMutableArray array];
    _xTitles = [NSMutableArray array];
    for (int i = 0; i < 24; i++)
    {
        int value = arc4random() % testValue;
        MCColumnModel *mColumnModel = [[MCColumnModel alloc] initWithLabel:[NSString stringWithFormat:@"%d", i] value:value index:i];
        [chartDataList addObject:mColumnModel];
        NSString*hour = [NSString stringWithFormat:@"%d:00",i+1];
        [_xTitles addObject:hour];
    }
    self.PMDataList = [NSMutableArray arrayWithArray:chartDataList];
    
    //1.add UI layout
    [self addSegement];
  
    //2. add chart
    [self addChartWithData:chartDataList];
    

}


/**
 *  add segement
 */
-(void)addSegement
{
    // add
    UISegmentedControl*segement = [[UISegmentedControl alloc] initWithFrame:CGRectMake(20, 20, TrackerWidth-40, 30)];
    self.segement = segement;
    for (int i = 0; i<_segementArr.count; i++) {
        [segement insertSegmentWithTitle:_segementArr[i] atIndex:i animated:NO];
    }
    
    segement.selectedSegmentIndex = self.segementIndex;
    //追加点击事件
    [segement addTarget:self action:@selector(segementClick:) forControlEvents:UIControlEventValueChanged];
    //设置背景颜色
    segement.tintColor = kColorRGB(0x960024);
    segement.backgroundColor = [UIColor grayColor];
    [self.view addSubview:segement];
    
    //add calculate pm value
    
    if (self.segementIndex == UISegementIndexTypePM) {
         [self addPMLabel];
         [self setPMValue];
    }
    
    //add line
    UIView*lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 130, TrackerWidth, 1)];
    lineView.backgroundColor = [UIColor redColor];
    [self.view addSubview:lineView];
    
    // add date segement
    UISegmentedControl*dateSegement = [[UISegmentedControl alloc] initWithFrame:CGRectMake(140, 150, 170, 30)];
    self.dateSegement = dateSegement;
    for (int i = 0; i<_dateArr.count; i++) {
        [dateSegement insertSegmentWithTitle:_dateArr[i] atIndex:i animated:NO];
    }
    
    //默认第一个选中
    dateSegement.selectedSegmentIndex = 0;
    //追加点击事件
    [dateSegement addTarget:self action:@selector(dateSegementClick:) forControlEvents:UIControlEventValueChanged];
    //设置背景颜色
    dateSegement.tintColor = kColorRGB(0x960024);
    dateSegement.backgroundColor = [UIColor grayColor];
    [self.view addSubview:dateSegement];
    
    
}
-(void)setPMValue
{
    NSInteger count = self.PMDataList.count;
    CGFloat totalValue = 0;
    for (int i = 0; i<count; i++) {
        for (int j = 0; j<count-i-1; j++) {
            MCColumnModel *model = self.PMDataList[j];
            MCColumnModel *model2 = self.PMDataList[j+1];
            float tempValue = 0;
            if (model.value > model2.value ) {
                tempValue = model.value;
                model.value = model2.value;
                model2.value = tempValue;
            }
            
        }
       MCColumnModel *model = self.PMDataList[i];
       totalValue += model.value;
    }
    //1.minValue
     MCColumnModel *minModel = self.PMDataList[0];
    self.minValueLabel.text = [NSString stringWithFormat:@"最小值 %.1f",minModel.value];
    //2.maxValue
     MCColumnModel *maxModel = self.PMDataList[count-1];
    self.maxValueLabel.text = [NSString stringWithFormat:@"最大值 %.1f",maxModel.value];
    //3.totalValue
    self.totalValueLabel.text = [NSString stringWithFormat:@"总    共 %.1f",totalValue];
    //4.avgValue
    self.averageValueLabel.text = [NSString stringWithFormat:@"平均值 %.1f",totalValue/count];

}
/**
 *  add  pm value label
 */
-(void)addPMLabel
{    
    //1.add minValue
    self.minValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 120, 30)];
    //self.minValueLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.minValueLabel];
    
    //2.add maxValue
    self.maxValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 50, 120, 30)];
    [self.view addSubview:self.maxValueLabel];
    //self.maxValueLabel.backgroundColor = [UIColor redColor];
    
    //3.add avgValue
    self.averageValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 120, 30)];
    [self.view addSubview:self.averageValueLabel];
    
    //4.add totalValue
    self.totalValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 80, 120, 30)];
    [self.view addSubview:self.totalValueLabel];

}
/**
 *  remove pm label
 */
-(void)removePMLabel
{
    [self.minValueLabel removeFromSuperview];
    [self.maxValueLabel removeFromSuperview];
    [self.averageValueLabel removeFromSuperview];
    [self.totalValueLabel removeFromSuperview];
}
/**
 *  segementClick
 *
 *  @param segement <#segement description#>
 */
-(void)segementClick:(UISegmentedControl*)segement
{
    //1. remove the _eFloatBox
    [_popView removeFromSuperview];
    //2. set navigationItem title
    self.navigationItem.title = _segementArr[segement.selectedSegmentIndex];
    if (segement.selectedSegmentIndex == UISegementIndexTypePM) {
        [self addPMLabel];
        [self setPMValue];
    }else{
        [self removePMLabel];
    }
    //3.show chart value
    [self dateSegementClick:self.dateSegement];
}
/**
 *  dateSegementClick
 */
-(void)dateSegementClick:(UISegmentedControl*)segement
{
    //1. remove the _eFloatBox
    [_popView removeFromSuperview];
    
    NSMutableArray *temp = [NSMutableArray array];
    [temp removeAllObjects];
    [_xTitles removeAllObjects];
    switch (segement.selectedSegmentIndex) {
        case UIDateRangeTypeDay:
            for (int i = 0; i < 24; i++)
            {
                int value = arc4random() % testValue;
                MCColumnModel *mColumnModel = [[MCColumnModel alloc] initWithLabel:[NSString stringWithFormat:@"%d", i] value:value index:i];
                [temp addObject:mColumnModel];
                NSString*hour = [NSString stringWithFormat:@"%d:00",i+1];
                [_xTitles addObject:hour];
            }
            break;
        case UIDateRangeTypeWeek:
            {
                for (int i = 0; i < 7; i++)
                {
                    int value = arc4random() % testValue;
                    MCColumnModel *eColumnDataModel = [[MCColumnModel alloc] initWithLabel:[NSString stringWithFormat:@"%d", i] value:value index:i];
                    [temp addObject:eColumnDataModel];
                }
                NSArray*arr = @[@"Sun", @"Mon", @"Tue", @"Wen", @"Thr", @"Fri",@"Sta"];
                _xTitles = [NSMutableArray arrayWithArray:arr];
            }
            break;
        case UIDateRangeTypeMonth:
            {
                NSDictionary*dict = [Tools getTodayDate];
                //NSInteger count = [NSDate ];
                //NSInteger dayCount = [NSString ]
                for (int i = 0; i < 29; i++)
                {
                    int value = arc4random() % testValue;
                    MCColumnModel *eColumnDataModel = [[MCColumnModel alloc] initWithLabel:[NSString stringWithFormat:@"%d", i] value:value index:i];
                    [temp addObject:eColumnDataModel];
                    NSString*monthDay = [NSString stringWithFormat:@"%@-%d",dict[@"month"],i+1];
                    [_xTitles addObject:monthDay];
                }
            }
            break;
        case UIDateRangeTypeHalfYear:
            for (int i = 0; i < 6; i++)
            {
                int value = arc4random() % testValue;
                MCColumnModel *eColumnDataModel = [[MCColumnModel alloc] initWithLabel:[NSString stringWithFormat:@"%d", i] value:value index:i];
                [temp addObject:eColumnDataModel];
                NSString*month = [NSString stringWithFormat:@"%d月",i+1];
                [_xTitles addObject:month];
            }
            break;
        case UIDateRangeTypeYear:
            for (int i = 0; i < 12; i++)
            {
                int value = arc4random() % testValue;
                MCColumnModel *eColumnDataModel = [[MCColumnModel alloc] initWithLabel:[NSString stringWithFormat:@"%d", i] value:value index:i];
                [temp addObject:eColumnDataModel];
                NSString*month = [NSString stringWithFormat:@"%d月",i+1];
                [_xTitles addObject:month];
            }
            break;
        default:
            break;
    }
    
    // 判断是否选中pm
    if(self.segement.selectedSegmentIndex == 3)
    {
        self.PMDataList = temp;
        [self setPMValue];
    }
    TLog(@"----%@---%ld",temp,temp.count);
    [self addChartWithData:temp];
}
/**
 *  add chart
 */
-(void)addChartWithData:(NSArray*)arr
{
    [self.barChartView removeFromSuperview];
    
    _barChartView = [[MCBarChartView alloc] initWithFrame:CGRectMake(0, 230, [UIScreen mainScreen].bounds.size.width, 260)];
    _barChartView.tag = 111;
    _barChartView.delegate = self;
   // _barChartView.maxValue = @50;
    _barChartView.colorOfXAxis = [UIColor redColor];
    _barChartView.colorOfXText = [UIColor redColor];
    _barChartView.colorOfYAxis = [UIColor redColor];
    _barChartView.colorOfYText = [UIColor redColor];
    _barChartView.chartDataSource = arr;
    _barChartView.XTitleArray = _xTitles;
    [self.view addSubview:_barChartView];
    
    [_barChartView reloadData];

}
#pragma mark -MCBarChartViewDelegate
//设置bar的颜色用的
- (UIColor *)barChartView:(MCBarChartView *)barChartView colorOfBarInSection:(NSInteger)section index:(NSInteger)index
{
    return [UIColor colorWithRed:2/255.0 green:185/255.0 blue:187/255.0 alpha:1.0];
}
//设置滚动区域用的
- (CGFloat)paddingForSectionInBarChartView:(MCBarChartView *)barChartView {
    return 24;
}

- (void)barChartView:(MCBarChartView *)barChartView didSelectBarmCcolumn:(MCColumn *)mCcolumn
{
    if (_mColumnSelected)
    {
        _mColumnSelected.barColor= _tempColor;
    }
    _mColumnSelected = mCcolumn;
    _tempColor = mCcolumn.barColor;
    mCcolumn.barColor = [UIColor yellowColor];
    
    [_popView removeFromSuperview];
    CGFloat eFloatBoxX = mCcolumn.frame.origin.x+18;
    CGFloat eFloatBoxY = mCcolumn.frame.origin.y +(1- mCcolumn.grade) *mCcolumn.frame.size.height-30;
    CGFloat value = [barChartView.maxValue floatValue]*mCcolumn.grade;
    _popView = [[MFloatBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:value unit:nil title:self.navigationItem.title imageName:@"dialog_frame"];
    _popView.center = CGPointMake(eFloatBoxX, eFloatBoxY+20);
    [UIView animateWithDuration:0.5f animations:^{
        
        _popView.center = CGPointMake(eFloatBoxX, eFloatBoxY);
        
        [barChartView.scrollView addSubview:_popView];
    }];
    
}

/**
 *  hidden the _eFloatBox
 *
 *  @param touches <#touches description#>
 *  @param event   <#event description#>
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch*touch = [touches anyObject];
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        if (![touch.view isKindOfClass:[MCColumn class]]) {
            // remove the _eFloatBox
            [_popView removeFromSuperview];
        }
    } completion:^(BOOL finished) {
    }];
}
@end
