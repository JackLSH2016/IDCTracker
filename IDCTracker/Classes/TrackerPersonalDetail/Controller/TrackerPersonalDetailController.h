//
//  TrackerPersonalDetailController.h
//  IDCTracker
//
//  Created by Jack on 19/1/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackerViewController.h"

typedef void(^reback)(NSString*valueStr,NSIndexPath*path,NSString*navTitle);

@interface TrackerPersonalDetailController : TrackerViewController
@property(strong,nonatomic)NSString*navTitle;

@property(strong,nonatomic)NSIndexPath*indexpath;
/**textFeild显示的内容*/
@property(strong,nonatomic)NSString*tfStr;

@property(strong,nonatomic)reback reblock;
@end
