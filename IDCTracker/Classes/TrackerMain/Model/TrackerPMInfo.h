//
//  Tracker.h
//  IDTTracker
//
//  Created by Jack on 25/1/2016.
//  Copyright (c) 2016年 idt. All rights reserved.
//  tracker模型

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TrackerPMInfo : NSObject
/**
 *  描述
 */
@property (nonatomic, copy) NSString *desc;
/**
 *  图标
 */
@property (nonatomic, copy) NSString *icon;
/**
 *  配图
 */
@property (nonatomic, copy) NSString *image;
/**
 *  团购的位置
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end
