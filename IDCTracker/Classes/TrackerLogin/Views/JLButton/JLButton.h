//
//  JLButton.h
//  loginButton
//
//  Created by admin on 9/3/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JLButton : UIButton
/**
 *  layer的颜色
 */
@property(strong,nonatomic)UIColor*layerColor;
/**
 *  动画时间
 */
@property(assign,nonatomic)NSTimeInterval shrinkDuration;
/**
 *  开始加载动画
 */
-(void)startLoadingAnimation;
/**
 *  请求成功结束动画
 *  @param completion block
 */
-(void)startFinishAnimationCompletion:(void(^)())completion;
/**
 *  请求失败结束动画
 */
-(void)returnToOriginalState;
@end
