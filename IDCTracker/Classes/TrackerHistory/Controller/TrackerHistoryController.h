//
//  TrackerHistoryController.h
//  IDCTracker
//
//  Created by Jack on 20/1/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackerViewController.h"

typedef void(^callBack)(UIButton*button);

@interface TrackerHistoryController : TrackerViewController
/**
 *  select which segement
 */
@property(assign,nonatomic) int segementIndex;

@end
