//
//  TrackerAnnotationView.m
//  IDTTracker
//
//  Created by Jack on 25/1/2016.
//  Copyright (c) 2016年 idt. All rights reserved.
//

#import "TrackerAnnotationView.h"
#import "TrackerAnnotation.h"
#import "TrackerPMInfo.h"

@implementation TrackerAnnotationView

+ (instancetype)annotationViewWithMapView:(MAMapView *)mapView
{
    static NSString *ID = @"tracker";
    // 从缓存池中取出可以循环利用的大头针view
    TrackerAnnotationView *annoView = (TrackerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[TrackerAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
    }
    return annoView;
}

- (void)setAnnotation:(id<MAAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    TrackerAnnotation *anno = annotation;
    self.image = [UIImage imageNamed:anno.tracker.icon];
}

@end
