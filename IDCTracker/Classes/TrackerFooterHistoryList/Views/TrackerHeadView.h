//
//  TrackerHeadView.h
//  IDCTracker
//
//  Created by admin on 17/2/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleLabel.h"

typedef void(^reloadData)(NSString*dateStr);

@protocol TrackerHeadViewDelegate <NSObject>
/**
 *  显示日历按钮点击
 */
-(void)headViewCalenderShowButtonClick;

@end

@interface TrackerHeadView : UIView

@property(weak,nonatomic)id<TrackerHeadViewDelegate>delegate;
/**
 *  year
 */
@property(strong,nonatomic)ScaleLabel*yearLabel;
/**
 *  month
 */
@property(strong,nonatomic)ScaleLabel*monthLabel;
/**
 *  day
 */
@property(strong,nonatomic)ScaleLabel*dayLabel;
/**
 *  year count
 */
@property(assign,nonatomic)long yearCount;
/**
 *  month count
 */
@property(assign,nonatomic)long monthCount;
/**
 *  day Count
 */
@property(assign,nonatomic)long dayCount;
/**
 *  refresh data block
 */
@property(strong,nonatomic) reloadData block;
@end
