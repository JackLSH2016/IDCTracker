//
//  TrackerDescAnnotationView.m
//  IDTTracker
//
//  Created by Jack on 25/1/2016.
//  Copyright (c) 2016年 idt. All rights reserved.
//

#import "TrackerDescAnnotationView.h"
#import "TrackerDescView.h"
#import "TrackerDescAnnotation.h"


@interface TrackerDescAnnotationView()
@property (nonatomic, weak) TrackerDescView *descView;
@end

@implementation TrackerDescAnnotationView

+ (instancetype)annotationViewWithMapView:(MAMapView *)mapView
{
    static NSString *ID = @"taungou_desc";
    TrackerDescAnnotationView *annoView = (TrackerDescAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[TrackerDescAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
    }
    return annoView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        TrackerDescView *descView = [TrackerDescView trackerDescView];
        descView.y = 35;
        [self addSubview:descView];
        self.descView = descView;
        
        self.frame = CGRectMake(0, 0, descView.frame.size.width, descView.frame.size.height+25);
    }
    return self;
}

- (void)setAnnotation:(id<MAAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    TrackerDescAnnotation *anno = annotation;
    self.descView.tracker = anno.tracker;
}


@end
