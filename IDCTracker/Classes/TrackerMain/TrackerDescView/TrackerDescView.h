//
//  TrackerDescView.h
//  IDTTracker
//
//  Created by Jack on 25/1/2016.
//  Copyright (c) 2016年 idt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TrackerPMInfo;

@interface TrackerDescView : UIView
+ (instancetype)trackerDescView;

@property (nonatomic, strong) TrackerPMInfo *tracker;
@end
