//
//  JLButton.m
//  loginButton
//
//  Created by admin on 9/3/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "JLButton.h"
#import "JLLayer.h"
#import "NSTimer+JL.h"

typedef void(^completion)();

@interface JLButton()

@property(strong,nonatomic)JLLayer*JLShapeLayer;
/**
 *  用于保存按钮的文字
 */
@property(strong,nonatomic)NSString*cachedTitle;
/**
 *  完成时的block
 */
@property(strong,nonatomic)completion completionBlock;
/**
 *  用于保存layer的cornerRadius
 */
@property(assign,nonatomic)CGFloat layerCornerRadius;
@end

@implementation JLButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.JLShapeLayer.spinnerColor = self.layerColor;
        //默认动画时间
        self.shrinkDuration = 0.1;
    }
    return self;
}

/**
 *  开始加载动画
 */
-(void)startLoadingAnimation
{
    self.layerCornerRadius = self.layer.cornerRadius;
    self.cachedTitle = self.titleLabel.text;
    [self setTitle:@"" forState:UIControlStateNormal];
    [UIView animateWithDuration:self.shrinkDuration animations:^{
        self.layer.cornerRadius = self.frame.size.height / 2;
    } completion:^(BOOL finished) {
        [self shrink];

        [NSTimer scheduleWithDelay:self.shrinkDuration-0.25 hander:^(NSTimer *timer) {
            [self.JLShapeLayer showAnimation];
        }];
        
    }];


}
/**
 *  结束动画
 *  @param completion block
 */
-(void)startFinishAnimationCompletion:(void(^)())completion
{
    self.completionBlock = completion;
    [self.JLShapeLayer stopAnimation];
    [self expand];
    //处理动画结束后的后续处理
    [NSTimer scheduleWithDelay:1 hander:^(NSTimer *timer) {
        [self returnToOriginalState];
         self.completionBlock();
    }];
}

/**
 *  重载判断动画是否结束
 */
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CABasicAnimation* animation = (CABasicAnimation*)anim;
    if ([animation.keyPath isEqualToString:@"transform.scale"]) {
        //处理动画结束后的后续处理
        self.completionBlock();
        [NSTimer scheduleWithDelay:1 hander:^(NSTimer *timer) {
            [self returnToOriginalState];
        }];
    }
}
/**
 *  返回到原始状态
 */
-(void)returnToOriginalState{
    
    self.layer.cornerRadius = self.layerCornerRadius;
    [self.layer removeAllAnimations];
    [self setTitle:self.cachedTitle forState:UIControlStateNormal];
    [self.JLShapeLayer stopAnimation];
}
/**
 *  缩放按钮动画
 */
-(void)expand
{
    CABasicAnimation*expandAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnim.fromValue = @(1.0);
    expandAnim.toValue = @(26.0);
    expandAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.95 :0.02 :1 :0.05];
    expandAnim.duration = 0.3;
    expandAnim.delegate = self;
    expandAnim.fillMode = kCAFillModeForwards;
    expandAnim.removedOnCompletion = false;
    [self.layer addAnimation:expandAnim forKey:nil];

}
/**
 *  按钮变为圆形动画
 */
-(void)shrink{
    CABasicAnimation* shrinkAnim = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    shrinkAnim.fromValue =@(self.frame.size.width);
    shrinkAnim.toValue = @(self.frame.size.height);
    shrinkAnim.duration = self.shrinkDuration;
    shrinkAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    shrinkAnim.fillMode = kCAFillModeForwards;
    shrinkAnim.removedOnCompletion = false;
    [self.layer addAnimation:shrinkAnim forKey:nil];

}
- (JLLayer *)JLShapeLayer
{
    if (!_JLShapeLayer) {
        _JLShapeLayer = [[JLLayer alloc] initWithFrame:self.bounds];
        [self.layer addSublayer:_JLShapeLayer];
    }
    return _JLShapeLayer;
}

- (void)setLayerColor:(UIColor *)layerColor
{
    _layerColor = layerColor;
    self.JLShapeLayer.spinnerColor = layerColor;
}
@end
