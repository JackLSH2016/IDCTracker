//
//  PresentAnimation.m
//  IDCTracker
//
//  Created by admin on 4/3/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "PresentAnimation.h"
#import <POP/POP.h>

@implementation PresentAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController *toVC  = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.frame    = CGRectMake(0,
                              0,
                              CGRectGetWidth(transitionContext.containerView.bounds) ,
                              CGRectGetHeight(transitionContext.containerView.bounds));

    toVC.view.transform = CGAffineTransformMakeScale(0.001, 0.001);
    toVC.view.alpha = 0.f;
   
    CGRect rect = [self frameForBubbleWithPoint:transitionContext.containerView.center size:toVC.view.frame.size startPoint:self.startingPoint];
    
    UIView*tempView = [[UIView alloc] initWithFrame:rect];
    tempView.backgroundColor = self.bubbleColor;
    tempView.layer.cornerRadius = tempView.frame.size.height/2;
    tempView.center = self.startingPoint;
    tempView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    [transitionContext.containerView addSubview:tempView];
    [transitionContext.containerView addSubview:toVC.view];
    
    
    [UIView animateWithDuration:self.duration animations:^{
        tempView.transform = CGAffineTransformIdentity;
        tempView.alpha = 0.f;
        toVC.view.transform = CGAffineTransformIdentity;
        toVC.view.alpha = 1.f;
        toVC.view.center   = CGPointMake(transitionContext.containerView.center.x, transitionContext.containerView.center.y);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:true];
    }];
}

-(CGRect)frameForBubbleWithPoint:(CGPoint)originalCenter size:(CGSize)originalSize startPoint:(CGPoint)startPoint{
    CGFloat lengthX = fmax(startPoint.x, originalSize.width - startPoint.x);
    CGFloat lengthY = fmax(startPoint.y, originalSize.height - startPoint.y);
    CGFloat offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2;    
    return CGRectMake(0, 0, offset, offset);
}
- (NSTimeInterval)duration
{
    if (!_duration) {
        //默认动画时间
        _duration = 0.5f;
    }
    return _duration;
}

-(void)animationOneWithTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC  = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.frame    = CGRectMake(0,
                                    0,
                                    CGRectGetWidth(transitionContext.containerView.bounds) ,
                                    CGRectGetHeight(transitionContext.containerView.bounds));
    toVC.view.center   = CGPointMake(transitionContext.containerView.center.x, -transitionContext.containerView.center.y);
    [transitionContext.containerView addSubview:toVC.view];
    
    POPSpringAnimation *scaleAnimation  = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness     = 20;
    scaleAnimation.fromValue            = [NSValue valueWithCGPoint:CGPointMake(1.4 , 1.6)];
    scaleAnimation.dynamicsMass         = 1.0f;
    scaleAnimation.dynamicsTension      = 100;
    
    POPSpringAnimation *positionAnimation   = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue               = @(transitionContext.containerView.center.y);
    positionAnimation.springBounciness      = 10;
    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
        appdelegate.window.layer.contents = (__bridge id)([UIImage imageNamed:@"loginBackground"].CGImage);
        appdelegate.window.rootViewController = toVC;
    }];
    
    [toVC.view.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    [toVC.view.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}
@end
