//
//  TrackerDescView.m
//  IDTTracker
//
//  Created by Jack on 25/1/2016.
//  Copyright (c) 2016年 idt. All rights reserved.
//

#import "TrackerDescView.h"
#import "TrackerPMInfo.h"

@interface TrackerDescView()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation TrackerDescView

+ (instancetype)trackerDescView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TrackerDescView" owner:nil options:nil] lastObject];
}

- (void)setTracker:(TrackerPMInfo *)tracker
{
    _tracker = tracker;
    self.iconView.image = [UIImage imageNamed:tracker.image];
    self.descLabel.text = tracker.desc;
}
@end
