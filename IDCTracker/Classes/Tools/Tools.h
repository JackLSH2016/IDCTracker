//
//  Tools.h
//  IDCTracker
//
//  Created by admin on 16/2/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

@interface Tools : NSObject
/**
 *  获取今天的日期
 */
+ (NSDictionary *)getTodayDate;
/**
 创建一个同图片一样大小的按钮
 */
+(UIButton*)createButtonWithPoint:(CGPoint)point imageName:(NSString *)imageName selectedImageName:(NSString*)selectedImageName target:(id)target selector:(SEL)selector;
/**
 MBProgress纯文本提示
 */
+ (MBProgressHUD *)HUDText:(NSString *)message;

/**
 带菊花和文字提示
 */
+ (MBProgressHUD *)HUDActicityText:(NSString *)message;
/**
 *  快速创建一个UItextFeild的leftView的UIImageView
 *
 *  @param icon   图片
 */
+ (UIView *)imageViewWithIcon:(NSString *)icon;

@end
