//
//  TrackerAnnotation.h
//  IDTTracker
//
//  Created by Jack on 25/1/2016.
//  Copyright (c) 2016年 idt. All rights reserved.
//  tracker大头针的模型

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@class TrackerPMInfo;

@interface TrackerAnnotation : NSObject <MAAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) TrackerPMInfo *tracker;

@property (nonatomic, assign, getter = isShowDesc) BOOL showDesc;
@end
