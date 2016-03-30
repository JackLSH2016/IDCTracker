//
//  NSTimer+JL.h
//  loginButton
//
//  Created by admin on 9/3/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (JL)

+(NSTimer *)scheduleWithDelay:(NSTimeInterval)delay hander:(void(^)(NSTimer*timer))hander;

@end
