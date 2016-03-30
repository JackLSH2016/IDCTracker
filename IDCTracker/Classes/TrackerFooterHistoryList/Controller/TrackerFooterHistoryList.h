//
//  TrackerFooterHistoryList.h
//  IDCTracker
//
//  Created by admin on 17/2/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "TrackerViewController.h"

typedef void(^calenderShowButtonClick)();

@interface TrackerFooterHistoryList : TrackerViewController


@property(strong,nonatomic)calenderShowButtonClick calenderShowButtonClickBlock;


@property(strong,nonatomic)NSDate*selectedDate;

@end
