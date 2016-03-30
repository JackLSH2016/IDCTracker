//
//  TrackerMainController.m
//  IDTTracker
//
//  Created by Jack on 15/1/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "TrackerMainController.h"
#import "TrackerPersonalController.h"
#import "TrackerSearchController.h"
#import "TrackerSettingController.h"
#import "TrackerHistoryController.h"
#import "TrackerButton.h"


//map
#import "TrackerAnnotation.h"
#import "TrackerAnnotationView.h"
#import "TrackerDescAnnotation.h"
#import "TrackerDescAnnotationView.h"
#import "TrackerPMInfo.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>


#define TrackerBtnTag 333



@interface TrackerMainController ()<MAMapViewDelegate,AMapLocationManagerDelegate>

@property(weak,nonatomic)MAMapView*mapView;

@property(strong,nonatomic)AMapLocationManager*locationManager;

@property(strong,nonatomic)NSArray*mapArray;

@end

@implementation TrackerMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    //self.view.backgroundColor = kColorRGB(0xf4814e);
    //add nav
    
    [self loadNav];


    
}

- (AMapLocationManager *)locationManager
{
    if (!_locationManager) {
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return _locationManager;
}
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    //NSLog(@"location:{lat:%f; lon:%f; accuracy:%@} ---%@", location.coordinate.latitude, location.coordinate.longitude, location.description,manager);
    TrackerPMInfo *tg1 = [[TrackerPMInfo alloc] init];
    tg1.desc = @"PM2.5:15";
    tg1.icon = @"landmark_owner";
    tg1.image = @"me";
    tg1.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    TrackerAnnotation *anno = [[TrackerAnnotation alloc] init];
    anno.tracker = tg1;
    [self.mapView addAnnotation:anno];
}
-(void)testBtnAction
{
    for (TrackerPMInfo *tracker in self.mapArray) {
        TrackerAnnotation *anno = [[TrackerAnnotation alloc] init];
        anno.tracker = tracker;
        [self.mapView addAnnotation:anno];
    }
}

- (NSArray *)mapArray
{
    if (!_mapArray) {
        TrackerPMInfo *tg1 = [[TrackerPMInfo alloc] init];
        tg1.desc = @"PM2.5:15";
        tg1.icon = @"landmark_owner";
        tg1.image = @"me";
        tg1.coordinate = CLLocationCoordinate2DMake(39.988141, 116.312760);
        
        TrackerPMInfo *tg2 = [[TrackerPMInfo alloc] init];
        tg2.desc = @"PM2.5:24";
        tg2.icon = @"landmark_other";
        tg2.image = @"other";
        tg2.coordinate = CLLocationCoordinate2DMake(39.888241, 116.352762);
        
        TrackerPMInfo *tg3 = [[TrackerPMInfo alloc] init];
        tg3.desc = @"PM2.5:24";
        tg3.icon = @"landmark_other";
        tg3.image = @"other";
        tg3.coordinate = CLLocationCoordinate2DMake(39.788341, 116.412764);
        
        _mapArray = @[tg1, tg2,tg3];
        
    }
    return _mapArray;
}

/**
 *  add nav
 */

- (void)loadNav
{
 
    UIImageView*imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_dark0"]];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [imageView addGestureRecognizer:tap];
    self.navigationItem.titleView = imageView;
    
    //create userIcon Button
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"userIcon" highIcon:nil target:self action:@selector(userBtnAction)];
    
    //create setting Button and search Button
    UIBarButtonItem*settingBar = [UIBarButtonItem itemWithIcon:@"setting_" highIcon:nil target:self action:@selector(settingBtnAction)];
    UIBarButtonItem*searchBar = [UIBarButtonItem itemWithIcon:@"searching_" highIcon:nil target:self action:@selector(searchBtnAction)];
    UIView*view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    UIBarButtonItem*holderBar = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    self.navigationItem.rightBarButtonItems =@[settingBar,holderBar,searchBar];
}

-(void)tapAction
{
    TrackerHistoryController*thc = [[TrackerHistoryController alloc] init];
    thc.segementIndex = 4;
    [self.navigationController pushViewController:thc animated:YES];

}
/**
 *  userBtn Action
 */
- (void)userBtnAction
{
    TrackerPersonalController*pc = [[TrackerPersonalController alloc] init];
    UINavigationController*nav = [[UINavigationController alloc] initWithRootViewController:pc];
    [self presentViewController:nav animated:YES completion:nil];
    
}
/**
 *  searchBtn Action
 */
- (void)searchBtnAction
{
    TrackerSearchController*sc = [[TrackerSearchController alloc] init];
    [self.navigationController pushViewController:sc animated:YES];
}
/**
 *  settingBtn Action
 */
- (void)settingBtnAction
{
    TrackerSettingController*sc = [[TrackerSettingController alloc] init];
    [self.navigationController pushViewController:sc animated:YES];
}
- (void)dealloc
{
    NSLog(@"TrackerMainController dealloc");
}
/**
 *  add map
 */
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view, typically from a nib.
    //配置用户Key
    [MAMapServices sharedServices].apiKey = @"ed38fb973877e657b379bfce7840656d";
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    
   // [self.view addSubview:_mapView];
    
    //add buttons
    [self loadButtons];
    
    [self testBtnAction];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//    {
//        // requestWhenInUseAuthorization 使用期间授权
//        // requestAlwaysAuthorization 永久授权，如果需要在后台定位，那么需要明确告诉用户当前app在后台定位，可能会加快电池的消耗等
//        
//        [self.locationManager requestWhenInUseAuthorization];
//    }
    // 开始定位用户的位置
    
    [AMapLocationServices sharedServices].apiKey = @"ed38fb973877e657b379bfce7840656d";
    [self.locationManager startUpdatingLocation];

}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //1.移除子视图
    for (UIView*view in self.view.subviews) {
        [view removeFromSuperview];
    }
    //2.停止定位服务
    [_locationManager stopUpdatingLocation];
}
#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[TrackerAnnotation class]]) {
        // 创建大头针view
        TrackerAnnotationView *annoView = [TrackerAnnotationView annotationViewWithMapView:mapView];
        // 传递模型
        annoView.annotation = annotation;
        return annoView;
    } else if ([annotation isKindOfClass:[TrackerDescAnnotation class]]) {
        // 创建大头针view
        TrackerDescAnnotationView *annoView = [TrackerDescAnnotationView annotationViewWithMapView:mapView];
        // 传递模型
        annoView.annotation = annotation;
        return annoView;
    }
    return nil;
}

/**
 *  clearAnnotation
 */
-(void)clearAnnotation
{
    for (id annotation in _mapView.annotations) {
        if ([annotation isKindOfClass:[TrackerDescAnnotation class]]) {
            [_mapView removeAnnotation:annotation];
        } else if ([annotation isKindOfClass:[TrackerAnnotation class]]) {
            TrackerAnnotation *trackerAnno = annotation;
            trackerAnno.showDesc = NO;
        }
    }
}
/**
 *  选中了某一个大头针
 */

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if ([view isKindOfClass:[TrackerAnnotationView class]])  {
        TrackerAnnotation *anno = view.annotation;
        if (anno.showDesc) return;
        
        // 1.删除以前的TrackerDescAnnotation
        [self clearAnnotation];

        // 2.添加新的TrackerDescAnnotation
        anno.showDesc = YES;
        
        // 在这颗被点击的大头针上面, 添加一颗用于描述的大头针
        TrackerDescAnnotation *descAnno = [[TrackerDescAnnotation alloc] init];
        descAnno.tracker = anno.tracker;
        [mapView addAnnotation:descAnno];
    } else if ([view isKindOfClass:[TrackerDescAnnotationView class]]) {
#warning 跳转控制器代码
        TrackerDescAnnotation *anno = view.annotation;
        NSLog(@"跳转控制器---%@", anno.tracker.desc);
    }
}
#pragma mark - MAMapViewDelegate

/**
 *  当用户的位置更新，就会调用（不断地监控用户的位置，调用频率特别高）
 *http://api.openweathermap.org/data/2.5/weather?id=2172797&appid=44db6a862fba0b067b1930da0d769e98 *  @param userLocation 表示地图上蓝色那颗大头针的数据
 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    userLocation.title = @"天朝帝都";
    userLocation.subtitle = @"是个非常牛逼的地方！";
    //userLocation.location.coordinate
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    NSLog(@"%f %f", center.latitude, center.longitude);
    
    // 设置地图的中心点（以用户所在的位置为中心点）
    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    // 设置地图的显示范围
    MACoordinateSpan span = MACoordinateSpanMake(0.021321, 0.019366);
    MACoordinateRegion region = MACoordinateRegionMake(center, span);
    [mapView setRegion:region animated:YES];
}
/**
 *  add buttons
 */
- (void)loadButtons
{
    NSArray*iconName = @[@"degree_",@"humidity_",@"AQI_",@"pm2.5_icon_"];
    NSArray*iconSelectedName = @[@"degree_pressed",@"humidity_pressed",@"AQI_pressed",@"pm2.5_icon_pressed"];
    NSArray*titles = @[@"10~15℃",@"75",@"50.4",@"26"];
    for (int i = 0; i<4 ; i++) {
        CGFloat btnW = 50;
        CGFloat btnH = btnW+20;
        CGFloat btnX = 20+(btnW+25)*i;
        CGFloat btnY = TrackerHeight-100-btnH;
        
        TrackerButton*btn = [[TrackerButton alloc] init];
        btn.center = CGPointMake(btnX, TrackerHeight);
        [btn setImage:[UIImage imageNamed:iconName[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:iconSelectedName[i]] forState:UIControlStateHighlighted];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.tag = i+ TrackerBtnTag;
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //动画效果
        [UIView animateWithDuration:1 delay:0.04f*i usingSpringWithDamping:0.5f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
           btn.frame = CGRectMake(btnX,btnY, btnW, btnH);
            
        } completion:^(BOOL finished) {
            
        }];
        [self.view addSubview:btn];

    }
}
/**
 *  temperature click function
 */
-(void)BtnClick:(UIButton*)btn
{

    TrackerHistoryController*thc = [[TrackerHistoryController alloc] init];
    thc.segementIndex =(int)btn.tag - TrackerBtnTag;
    [self.navigationController pushViewController:thc animated:YES];
}

@end
