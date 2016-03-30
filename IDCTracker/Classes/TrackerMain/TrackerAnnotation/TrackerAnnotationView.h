//
//  TrackerAnnotationView.h
//  IDTTracker
//
//  Created by Jack on 25/1/2016.
//  Copyright (c) 2016年 idt. All rights reserved.
//  tracker大头针

#import <MAMapKit/MAMapKit.h>

@interface TrackerAnnotationView : MAAnnotationView
+ (instancetype)annotationViewWithMapView:(MAMapView *)mapView;
@end
