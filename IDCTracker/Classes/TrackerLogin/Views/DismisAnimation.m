//
//  DismisAnimation.m
//  IDCTracker
//
//  Created by admin on 4/3/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "DismisAnimation.h"
#import <POP/POP.h>

@implementation DismisAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC  = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [UIView animateWithDuration:0.5f animations:^{
        fromVC.view.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}
-(void)animationOneWithTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC  = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    POPSpringAnimation *scaleAnimation  = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness     = 20;
    scaleAnimation.toValue            = [NSValue valueWithCGPoint:CGPointMake(0.4 , 0.6)];
    
    
    POPSpringAnimation *positionAnimation   = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue               = @(-fromVC.view.layer.position.y);
    // positionAnimation.springBounciness      = 10;
    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
        //
        
        appdelegate.window.rootViewController = toVC;
    }];
    
    [fromVC.view.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

@end
