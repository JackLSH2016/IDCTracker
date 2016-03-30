//
//  TrackerCommon.h
//  IDCTracker
//
//  Created by Jack on 19/1/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#ifndef TrackerCommon_h
#define TrackerCommon_h
#import "AppDelegate.h"

#define appdelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define TrackerWidth [UIScreen mainScreen].bounds.size.width
#define TrackerHeight [UIScreen mainScreen].bounds.size.height



// RGB（0x??????）
#define kColorRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//定义变量的TrackerString。string文件
#define TrackerString @"TrackString"

// 3.自定义Log
//#define NSLog(format, ...) do { \
//fprintf(stderr, " %s\n", \
//        [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
//        __LINE__, __func__); \
//(NSLog)((format), ##__VA_ARGS__); \
//fprintf(stderr, "-------\n"); \
//} while (0)

#ifdef DEBUG
#define TLog(...) NSLog(__VA_ARGS__)
#else
#define TLog(...)
#endif

#import "UIImage+JL.h"
#import "UIBarButtonItem+JL.h"
#import "NSDate+BFKit.h"
#import "UIView+SetRect.h"
#import "UIFont+Fonts.h"
//thirdlibrary

#import "gcd.h"
//tool
#import "Tools.h"

#endif /* TrackerCommon_h */
