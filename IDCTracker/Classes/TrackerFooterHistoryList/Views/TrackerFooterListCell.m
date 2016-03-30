//
//  TrackerFooterListCell.m
//  IDCTracker
//
//  Created by admin on 17/2/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "TrackerFooterListCell.h"
#import <pop/POP.h>

@implementation TrackerFooterListCell

- (void)awakeFromNib {
    // Initialization code

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (self.highlighted) {
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration = 0.1;
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.95, 0.95)];
        [self.contentLbl pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    } else {
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        scaleAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
        scaleAnimation.springBounciness = 20.f;
        [self.contentLbl pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    }
}
@end
