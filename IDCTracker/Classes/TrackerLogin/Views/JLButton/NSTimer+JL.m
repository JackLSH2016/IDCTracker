//
//  NSTimer+JL.m
//  loginButton
//
//  Created by admin on 9/3/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "NSTimer+JL.h"

@implementation NSTimer (JL)

+(NSTimer *)scheduleWithDelay:(NSTimeInterval)delay hander:(void (^)(NSTimer *timer))hander
{
    NSTimeInterval fireDate = delay +CFAbsoluteTimeGetCurrent();

    CFRunLoopTimerRef timerRef =CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, ^(CFRunLoopTimerRef timer) {
        if (hander) {
            hander((__bridge id)timer);
        }
    });
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), timerRef, kCFRunLoopCommonModes);
    NSTimer *timer = (__bridge id)timerRef;
    return timer;
}

@end
