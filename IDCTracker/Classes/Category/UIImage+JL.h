//
//  UIImage+MJ.h
//  IDTTracker
//
//  Created by Jack on 15/1/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JL)
/**
 *  加载图片
 *
 *  @param name 图片名
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
@end
