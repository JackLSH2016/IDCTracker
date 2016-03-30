//
//  DetaialInfoViewController.h
//  textlanya
//
//  Created by jack1 on 15/12/31.
//  Copyright (c) 2015年 jack1. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CBPeripheral;

@interface DetaialInfoViewController : UIViewController

/**
 *  连接的外部设备
 */
@property (nonatomic, strong) CBPeripheral *peripheral;

@end
