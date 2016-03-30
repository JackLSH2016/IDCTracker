//
//  BlueToothMananger.h
//  02-蓝牙
//
//  Created by vera on 15/12/17.
//  Copyright © 2015年 vera. All rights reserved.
//http://www.jianshu.com/p/a5e25206df39 数据转换

#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>

typedef void(^connectSuccess)(BOOL isSuccess);

typedef void(^getPeripheralsInfo)(NSArray*array);

@interface BlueToothMananger : NSObject

+ (instancetype)manager;

/**
 *  扫描外部设备
 */
- (void)scan;

/**
 *  连接设备
 */
- (void)connectToDevice:(CBPeripheral *)peripheral;

@property(copy,nonatomic)connectSuccess block;
@property(strong,nonatomic)getPeripheralsInfo peripheralsInfo;
@end
