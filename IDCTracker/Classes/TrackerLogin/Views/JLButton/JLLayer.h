//
//  JLLayer.h
//  loginButton
//
//  Created by admin on 9/3/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface JLLayer : CAShapeLayer

@property(strong,nonatomic)UIColor*spinnerColor;

- (instancetype)initWithFrame:(CGRect)frame;
/**
 *  显示动画
 */
-(void)showAnimation;

/**
 * 停止动画
 */
- (void)stopAnimation;
@end
