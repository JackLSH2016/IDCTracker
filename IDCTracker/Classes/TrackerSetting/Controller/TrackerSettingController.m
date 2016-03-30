//
//  TrackerSettingController.m
//  IDCTracker
//
//  Created by Jack on 18/1/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "TrackerSettingController.h"
#import "LMContainsLMComboxScrollView.h"
#import "LMComBoxView.h"
#import "NMRangeSlider.h"

//set Border
#define TrackerSettingViewBorder 20

// set RangeSlider tag
#define TrackerRangeSliderTag    555

// set DropDownList tag
#define TrackerDropDownListTag    666


typedef NS_ENUM(NSInteger, UIRangeSliderType) {
    UIRangeSliderTypePM = 0,      // pm2.5
    UIRangeSliderTypeAQI ,        // AQI
    UIRangeSliderTypeTemperature, //Temperature
    UIRangeSliderTypeHumidity,    //Humidity
};

typedef NS_ENUM(NSInteger, UIDropDownListType) {
    UIDropDownListTypeUserType = 0,    // user type
    UIDropDownListTypeHealthStatus ,   // Health status
    UIDropDownListTypeTemperatureUnit, //Temperature unit
    UIDropDownListTypeRemindTime,      //remind time
};

@interface TrackerSettingController ()<LMComBoxViewDelegate>

@property(strong,nonatomic)LMContainsLMComboxScrollView *bgScrollView;

@property(strong,nonatomic)NSMutableArray*dataList;
//pm2.5
@property(strong,nonatomic)NMRangeSlider*pmRangeSlider;
@property (strong, nonatomic) UILabel *pmLowerLabel;
@property (strong, nonatomic) UILabel *pmUpperLabel;

//AQI
@property(strong,nonatomic)NMRangeSlider*AQIRangeSlider;
@property (strong, nonatomic) UILabel *AQILowerLabel;
@property (strong, nonatomic) UILabel *AQIUpperLabel;

//Temperature
@property(strong,nonatomic)NMRangeSlider*temperatureRangeSlider;
@property (strong, nonatomic) UILabel *temperatureLowerLabel;
@property (strong, nonatomic) UILabel *temperatureUpperLabel;

//Humidity
@property(strong,nonatomic)NMRangeSlider*humidityRangeSlider;
@property (strong, nonatomic) UILabel *humidityLowerLabel;
@property (strong, nonatomic) UILabel *humidityUpperLabel;

//userTypeIndex
@property(assign,nonatomic)int userTypeIndex;
@property(assign,nonatomic)int healthTypeIndex;

@end

@implementation TrackerSettingController
- (void)dealloc
{
    NSLog(@"TrackerSettingController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
   
    self.navigationItem.title = @"设置";

    //create save Button
    UIButton*saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    
    //1. add ScrollView
    [self addScrollView];
    
    //2. add range slider
    [self addRangeSlider];
    
    //3. add disconnect button
    [self addDisconnectButton];
    
}
/**
 *  save info
 */
-(void)saveBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //pm2.5
    [self rangeSliderAction:self.pmRangeSlider];
    //AQI
    [self rangeSliderAction:self.AQIRangeSlider];
    //temperature
    [self rangeSliderAction:self.temperatureRangeSlider];
    //humidity
    [self rangeSliderAction:self.humidityRangeSlider];
}
/**
 *  add range slider
 *
 *  @param frame frame
 *  @param data  dict
 *  @param title title
 */
-(void)addRangeSliderWithFrame:(CGRect)frame data:(NSDictionary*)dict tag:(NSInteger)tag
{
    NMRangeSlider*rangeSlider = [[NMRangeSlider alloc] initWithFrame:frame];
    [self.bgScrollView addSubview:rangeSlider];
    rangeSlider.userInteractionEnabled = NO;
    [rangeSlider addTarget:self action:@selector(rangeSliderAction:) forControlEvents:UIControlEventValueChanged];
    
    // set title label
    CGFloat titleLabelW = 4*TrackerSettingViewBorder;
    CGFloat titleLabelX = frame.origin.x-titleLabelW-TrackerSettingViewBorder;
    CGFloat titleLabelY =frame.origin.y-15;
    CGFloat titleLabelH =frame.size.height+10;

    UILabel*titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY , titleLabelW, titleLabelH)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = dict[@"title"];
    //titleLabel.backgroundColor = [UIColor redColor];
    [self.bgScrollView addSubview:titleLabel];
    
    //set default button
    
    CGFloat defaultButtonW = titleLabelW;
    CGFloat defaultButtonX = titleLabelX;
    CGFloat defaultButtonY = CGRectGetMaxY(titleLabel.frame);
    CGFloat defaultButtonH = titleLabelH;
    
    UIButton*defaultButton = [[UIButton alloc] initWithFrame:CGRectMake(defaultButtonX, defaultButtonY, defaultButtonW, defaultButtonH)];
    [defaultButton setTitle:@"默认设置" forState:UIControlStateNormal];
    [defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    defaultButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //defaultButton.backgroundColor = [UIColor greenColor];
    [defaultButton setImage:[UIImage imageNamed:@"just right_sign"] forState:UIControlStateNormal];
    [defaultButton setImage:[UIImage imageNamed:@"right_sign"] forState:UIControlStateSelected];
    defaultButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    defaultButton.selected = YES;
    defaultButton.tag = tag;
    [defaultButton addTarget:self action:@selector(defaultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:defaultButton];
    
    //set lowerValue label
    UILabel*lowerLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y , 3*TrackerSettingViewBorder, TrackerSettingViewBorder)];
    lowerLabel.textAlignment = NSTextAlignmentCenter;
    lowerLabel.font = [UIFont systemFontOfSize:14];
   // lowerLabel.backgroundColor = [UIColor greenColor];
    [self.bgScrollView addSubview:lowerLabel];
    
    //set upperValue label
    UILabel*upperLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lowerLabel.frame)+TrackerSettingViewBorder, CGRectGetMinY(lowerLabel.frame), lowerLabel.frame.size.width, lowerLabel.frame.size.height)];
    upperLabel.font = [UIFont systemFontOfSize:14];
    upperLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgScrollView addSubview:upperLabel];
    
    // set rangeSlider init value
    rangeSlider.tag = tag;
    
   
    rangeSlider.minimumValue = [dict[@"data"][@"minimumValue"] floatValue];
    rangeSlider.maximumValue = [dict[@"data"][@"maximumValue"] floatValue];
    
    [rangeSlider setLowerValue:[dict[@"data"][@"lowerValue"] floatValue] upperValue:[dict[@"data"][@"upperValue"] floatValue] animated:YES];
    
    
    //华氏度(℉)=32+摄氏度(℃)×1.8，
    //摄氏度(℃)=（华氏度(℉)-32）÷1.8。
    
    switch (tag-TrackerRangeSliderTag) {
        case UIRangeSliderTypePM:
            self.pmRangeSlider = rangeSlider;
            self.pmLowerLabel = lowerLabel;
            self.pmUpperLabel = upperLabel;
            break;
        case UIRangeSliderTypeAQI:
            self.AQIRangeSlider = rangeSlider;
            self.AQILowerLabel = lowerLabel;
            self.AQIUpperLabel = upperLabel;
            break;
        case UIRangeSliderTypeTemperature:
            self.temperatureRangeSlider = rangeSlider;
            self.temperatureLowerLabel = lowerLabel;
            self.temperatureUpperLabel = upperLabel;
            break;
        case UIRangeSliderTypeHumidity:
            self.humidityRangeSlider = rangeSlider;
            self.humidityLowerLabel = lowerLabel;
            self.humidityUpperLabel= upperLabel;
            break;
        default:
            break;
    }
    //refresh UI
    [self rangeSliderAction:rangeSlider];
}
/**
 *  set default
 *
 *  @param btn defaultButton
 */
-(void)defaultButtonAction:(UIButton*)btn
{
    btn.selected = !btn.selected;
    
    switch (btn.tag - TrackerRangeSliderTag) {
        case UIRangeSliderTypePM:
            if (btn.selected) {
                self.pmRangeSlider.userInteractionEnabled = NO;
            }else{
                self.pmRangeSlider.userInteractionEnabled = YES;
            }
            break;
        case UIRangeSliderTypeAQI:
            if (btn.selected) {
                self.AQIRangeSlider.userInteractionEnabled = NO;
            }else{
                self.AQIRangeSlider.userInteractionEnabled = YES;
            }
            break;
        case UIRangeSliderTypeTemperature:
            if (btn.selected) {
                self.temperatureRangeSlider.userInteractionEnabled = NO;
            }else{
                self.temperatureRangeSlider.userInteractionEnabled = YES;
            }
            break;
        case UIRangeSliderTypeHumidity:
            if (btn.selected) {
                self.humidityRangeSlider.userInteractionEnabled = NO;
            }else{
                self.humidityRangeSlider.userInteractionEnabled = YES;
            }
            break;
        default:
            break;
    }

}
/**
 *  change label position
 */
-(void)rangeSliderAction:(NMRangeSlider*)rangeSlider
{
    CGPoint lowerCenter;
    lowerCenter.x = (rangeSlider.lowerCenter.x + rangeSlider.frame.origin.x);
    lowerCenter.y = (rangeSlider.center.y - 30.0f);
    CGPoint upperCenter;
    upperCenter.x = (rangeSlider.upperCenter.x + rangeSlider.frame.origin.x);
    upperCenter.y = (rangeSlider.center.y - 30.0f);

    switch (rangeSlider.tag-TrackerRangeSliderTag) {
        case UIRangeSliderTypePM:
            self.pmLowerLabel.center = lowerCenter;
            self.pmLowerLabel.text = [NSString stringWithFormat:@"%.01f", rangeSlider.lowerValue];
            
            self.pmUpperLabel.center = upperCenter;
            self.pmUpperLabel.text = [NSString stringWithFormat:@"%.01f", rangeSlider.upperValue];
            break;
        case UIRangeSliderTypeAQI:
            self.AQILowerLabel.center = lowerCenter;
            self.AQILowerLabel.text = [NSString stringWithFormat:@"%.01f", rangeSlider.lowerValue];
            
            self.AQIUpperLabel.center = upperCenter;
            self.AQIUpperLabel.text = [NSString stringWithFormat:@"%.01f", rangeSlider.upperValue];
 
            break;
        case UIRangeSliderTypeTemperature:
            self.temperatureLowerLabel.center = lowerCenter;
            self.temperatureLowerLabel.text = [NSString stringWithFormat:@"%.01f", rangeSlider.lowerValue];
            
            self.temperatureUpperLabel.center = upperCenter;
            self.temperatureUpperLabel.text = [NSString stringWithFormat:@"%.01f", rangeSlider.upperValue];

            break;
        case UIRangeSliderTypeHumidity:
            self.humidityLowerLabel.center = lowerCenter;
            self.humidityLowerLabel.text = [NSString stringWithFormat:@"%.01f", rangeSlider.lowerValue];
            
            self.humidityUpperLabel.center = upperCenter;
            self.humidityUpperLabel.text = [NSString stringWithFormat:@"%.01f", rangeSlider.upperValue];
            break;
        default:
            break;
    }
    
  
}


/**
 *  add DropDownList and label
 *  @param frame frame
 *  @param arr   data
 *  @param title title
 *  @param tag tag
 */
-(void)addDropDownListWithFrame:(CGRect)frame Data:(NSArray*)arr title:(NSString*)title tag:(NSInteger)tag
{
    CGFloat titleLableX = frame.origin.x;
    CGFloat titleLableY = frame.origin.y;
    CGFloat titleLableH = frame.size.height;
    CGFloat titleLableW =frame.size.width+TrackerSettingViewBorder;
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(titleLableX, titleLableY, titleLableW, titleLableH)];
    
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = title;
    [self.bgScrollView addSubview:titleLable];
    
    
    CGFloat comBoxX = CGRectGetMaxX(titleLable.frame);
    CGFloat comBoxY = titleLableY;
    CGFloat comBoxH = titleLableH;
    CGFloat comBoxW = titleLableW+TrackerSettingViewBorder/2;
    
    LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(comBoxX, comBoxY, comBoxW, comBoxH)];
    comBox.arrowImgName =@"down_dark0.png";
    comBox.titlesList = [NSMutableArray arrayWithArray:arr];
    comBox.delegate = self;
    comBox.supView = self.bgScrollView;
    comBox.tag = tag;
    [comBox defaultSettings];
    comBox.tableHeight = arr.count*comBoxH;
    [self.bgScrollView addSubview:comBox];

}
/**
 *  add ScrollView
 */
-(void)addScrollView
{
    _bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:self.view.bounds];
    _bgScrollView.showsVerticalScrollIndicator = NO;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_bgScrollView];
    _bgScrollView.backgroundColor = [UIColor clearColor];
    //从plist文件中获取数据
    NSString*path = [[NSBundle mainBundle] pathForResource:@"TrackerDropDownListSetting.plist" ofType:nil];
    _dataList = [NSMutableArray arrayWithContentsOfFile:path];
    
    for (int i = 0; i<_dataList.count; i++) {
        //data
        NSArray*data = _dataList[i][@"data"];
        //title
        NSString*title = _dataList[i][@"title"];
        [self addDropDownListWithFrame:CGRectMake(TrackerSettingViewBorder, TrackerSettingViewBorder+(35)*i, 5*TrackerSettingViewBorder, TrackerSettingViewBorder+4) Data:data title:title tag:i+TrackerDropDownListTag];
    }

}
#pragma mark -LMComBoxViewDelegate
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
    BOOL flag = false;
    switch (_combox.tag-TrackerDropDownListTag) {
        case UIDropDownListTypeUserType:
            _userTypeIndex = index;
            flag = true;
        case UIDropDownListTypeHealthStatus:
            if (!flag) {
                _healthTypeIndex = index;
            }
            if (_userTypeIndex == 0 && _healthTypeIndex == 0) { //baby
                [self.temperatureRangeSlider setLowerValue:55 upperValue:67 animated:YES];
                [self.pmRangeSlider setLowerValue:35 upperValue:97 animated:YES];
                [self.AQIRangeSlider setLowerValue:45 upperValue:87 animated:YES];
            }else if(_userTypeIndex == 1 && _healthTypeIndex == 1){// normal
                [self.temperatureRangeSlider setLowerValue:35 upperValue:97 animated:YES];
                [self.pmRangeSlider setLowerValue:15 upperValue:117 animated:YES];
                [self.AQIRangeSlider setLowerValue:45 upperValue:77 animated:YES];
            }else if(_userTypeIndex == 1 &&_healthTypeIndex == 2){// Children
                [self.temperatureRangeSlider setLowerValue:45 upperValue:77 animated:YES];
                [self.pmRangeSlider setLowerValue:25 upperValue:107 animated:YES];
                [self.AQIRangeSlider setLowerValue:43 upperValue:87 animated:YES];
            }else{
//                [self.temperatureRangeSlider setLowerValue:65 upperValue:87 animated:YES];
//                [self.pmRangeSlider setLowerValue:55 upperValue:97 animated:YES];
//                [self.AQIRangeSlider setLowerValue:25 upperValue:113 animated:YES];
            }
            [self rangeSliderAction:self.temperatureRangeSlider];

            break;
        case UIDropDownListTypeTemperatureUnit:

            TLog(@"----UIDropDownListTypeTemperatureUnit");
            if (!index) { //C
                [self.temperatureRangeSlider setLowerValue:55 upperValue:97 animated:YES];
            
            }else{// F
            
            }
            [self rangeSliderAction:self.temperatureRangeSlider];
            break;
        case UIDropDownListTypeRemindTime:
            TLog(@"----UIDropDownListTypeRemindTime");
            break;
        default:
            break;
    }
}
/**
 *  add RangeSlider
 */
-(void)addRangeSlider
{
    //从plist文件中获取数据
    NSString*path = [[NSBundle mainBundle] pathForResource:@"TrackerRangeSliderSetting.plist" ofType:nil];
    NSMutableArray*arr = [NSMutableArray arrayWithContentsOfFile:path];
    for (int j=0; j<arr.count; j++) {
        [self addRangeSliderWithFrame:CGRectMake(6*TrackerSettingViewBorder, 10*TrackerSettingViewBorder+(60)*j, 8*TrackerSettingViewBorder, TrackerSettingViewBorder*0.5) data:arr[j]  tag:j+TrackerRangeSliderTag];
    }
    
}
/**
 *  add DisconnectButton
 */
-(void)addDisconnectButton
{
    //create setting Button
    CGFloat disconnectBtnW = TrackerWidth-2*TrackerSettingViewBorder;
    CGFloat disconnectBtnX = TrackerSettingViewBorder;
    CGFloat disconnectBtnH =1.5*TrackerSettingViewBorder;
#warning disconnectBtnY
    CGFloat disconnectBtnY =TrackerHeight - disconnectBtnH-5*TrackerSettingViewBorder;
   
    UIButton*disconnectBtn = [[UIButton alloc] initWithFrame:CGRectMake(disconnectBtnX,disconnectBtnY, disconnectBtnW, disconnectBtnH)];
    [disconnectBtn setTitle:@"断开连接" forState:UIControlStateNormal] ;
    disconnectBtn.backgroundColor = [UIColor blueColor];
    [disconnectBtn addTarget:self action:@selector(disconnectBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:disconnectBtn];
}
/**
 *  disconnectBtnAction
 */
-(void)disconnectBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
