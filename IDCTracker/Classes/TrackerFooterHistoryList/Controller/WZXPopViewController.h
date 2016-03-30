//
//  ViewController.h
//  
//
//  Created by wordoor－z on 16/1/14.
//  Copyright © 2016年 wzx. All rights reserved.
//
#import "TrackerViewController.h"

@interface WZXPopViewController : TrackerViewController

/**
 *  弹出的view
 */
@property(nonatomic,strong) UIView * popView;

/**
 *  rootview
 */
@property(nonatomic,strong) UIView * rootview;

/**
 *  rootVC
 */
@property(nonatomic,strong) UIViewController * rootVC;

/**
 *  maskView
 */
@property(nonatomic,strong) UIView * maskView;

/**
 *  初始化 rootVC 根VC， popView 弹出的view
 */
- (void)createPopVCWithRootVC:(UIViewController *)rootVC andPopView:(UIView *)popView;

- (void)close;
- (void)show;
@end

