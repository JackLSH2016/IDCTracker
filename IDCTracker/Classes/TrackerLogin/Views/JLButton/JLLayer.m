//
//  JLLayer.m
//  loginButton
//
//  Created by admin on 9/3/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "JLLayer.h"

@implementation JLLayer

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super init]) {
        self.cornerRadius = (frame.size.height/2)*0.5;
        self.frame = CGRectMake(0, 0, frame.size.height, frame.size.height);
        self.position = CGPointMake(frame.size.height/2, frame.size.height/2);
        self.path = [UIBezierPath bezierPathWithArcCenter:self.position radius:self.cornerRadius startAngle:0 - M_PI_2 endAngle:M_PI * 2 - M_PI_2 clockwise:YES].CGPath;
        self.fillColor = [UIColor clearColor].CGColor;
        self.strokeColor = [UIColor whiteColor].CGColor;
        self.lineWidth = 1;
        self.strokeEnd = 0.4;
        self.opacity = 0.f;
    }
    return self;
}
-(void)showAnimation
{
    self.opacity = 1.f;
    CABasicAnimation* rotate =[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.fromValue = 0;
    rotate.toValue = @(M_PI * 2);
    rotate.duration = 0.4;
    rotate.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    rotate.repeatCount = HUGE;
    rotate.fillMode = kCAFillModeForwards;
    rotate.removedOnCompletion = false;
    [self addAnimation:rotate forKey:nil];
}
- (void)stopAnimation
{
    self.opacity = 0.f;
    [self removeAllAnimations];
}
- (void)setSpinnerColor:(UIColor *)spinnerColor
{
    _spinnerColor = spinnerColor;
    self.strokeColor = spinnerColor.CGColor;
}

@end
