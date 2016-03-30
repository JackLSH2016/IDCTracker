//
//  TrackerAnnotation.m
//  IDTTracker
//
//  Created by Jack on 25/1/2016.
//  Copyright (c) 2016年 idt. All rights reserved.
//

#import "TrackerAnnotation.h"
#import "TrackerPMInfo.h"

@implementation TrackerAnnotation

- (void)setTracker:(TrackerPMInfo *)tracker
{
    _tracker = tracker;
    self.coordinate = tracker.coordinate;
}
@end
