//
//  PresentAnimation.h
//  IDCTracker
//
//  Created by admin on 4/3/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PresentAnimation : NSObject<UIViewControllerAnimatedTransitioning>
/**
 *  开始的点
 */
@property(assign,nonatomic)CGPoint startingPoint;
/**
 *  按钮的背景色
 */
@property(strong,nonatomic)UIColor*bubbleColor;
/**
 *   动画时间
 */
@property(assign,nonatomic)NSTimeInterval duration;
@end
