//
//  TrackerFooterHistory.m
//  IDCTracker
//
//  Created by admin on 15/2/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "TrackerFooterHistory.h"
#import <MapKit/MapKit.h>
#import "Tracking.h"

@interface TrackerFooterHistory ()<MAMapViewDelegate,TrackingDelegate>
@property(strong,nonatomic)MAMapView*mapView;

@property (nonatomic, strong) Tracking *tracking;
@end

@implementation TrackerFooterHistory
#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if (annotation == self.tracking.annotation)
    {
        static NSString *trackingReuseIndetifier = @"trackingReuseIndetifier";
        
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:trackingReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:trackingReuseIndetifier];
        }
        
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"ball"];
        
        return annotationView;
    }
    
    return nil;
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if (overlay == self.tracking.polyline)
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 8.f;
        polylineView.strokeColor = [UIColor redColor];
        return polylineView;
    }
    
    return nil;
}

#pragma mark - TrackingDelegate

- (void)willBeginTracking:(Tracking *)tracking
{
    TLog(@"%s", __func__);
}

- (void)didEndTracking:(Tracking *)tracking
{
    TLog(@"%s", __func__);
}

#pragma mark - Handle Action

- (void)handleRunAction
{
    if (self.tracking == nil)
    {
        [self setupTracking];
    }
    
    [self.tracking execute];
}

#pragma mark - Setup

/* 构建mapView. */
- (void)setupMapView
{
    [MAMapServices sharedServices].apiKey = @"ed38fb973877e657b379bfce7840656d";
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
}

/* 构建轨迹回放. */
- (void)setupTracking
{
    //NSString *trackingFilePath = [[NSBundle mainBundle] pathForResource:@"GuGong" ofType:@"tracking"];
    NSData *trackingData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"running_record" ofType:@"json"]];
    // NSData *trackingData = [NSData dataWithContentsOfFile:trackingFilePath];
    //NSLog(@"=====%@",trackingData);
    
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:trackingData options:NSJSONReadingAllowFragments error:nil];
    
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D *)malloc(dataArray.count * sizeof(CLLocationCoordinate2D));
    // CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D *)malloc(trackingData.length);
    for (int i = 0; i < dataArray.count; i++)
    {
        @autoreleasepool
        {
            NSDictionary * data = dataArray[i];
            coordinates[i].latitude = [data[@"latitude"] doubleValue];
            coordinates[i].longitude = [data[@"longtitude"] doubleValue];
            
        }
    }
    
    
    /* 提取轨迹原始数据. */
    // [trackingData getBytes:coordinates length:trackingData.length];
    
    /* 构建tracking. */ //trackingData.length / sizeof(CLLocationCoordinate2D)
    self.tracking = [[Tracking alloc] initWithCoordinates:coordinates count:dataArray.count];
    self.tracking.delegate = self;
    self.tracking.mapView  = self.mapView;
    self.tracking.duration = 5.f;
    self.tracking.edgeInsets = UIEdgeInsetsMake(50, 50, 50, 50);
}

- (void)setupNavigationBar
{
    self.title = @"轨迹回放";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Run"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleRunAction)];
}
#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationBar];
    
    [self setupMapView];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.mapView.frame = self.view.bounds;
}
@end
