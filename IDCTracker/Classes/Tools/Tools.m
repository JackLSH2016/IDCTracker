//
//  Tools.m
//  IDCTracker
//
//  Created by admin on 16/2/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "Tools.h"


@implementation Tools
+ (NSDictionary *)getTodayDate
{
    //获取今天的日期
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay;
    
    NSDateComponents *components = [calendar components:unit fromDate:today];
//    NSString *year = [NSString stringWithFormat:@"%ld", [components year]];
//    NSString *month = [NSString stringWithFormat:@"%02ld", [components month]];
//    NSString *day = [NSString stringWithFormat:@"%02ld", [components day]];
    
    NSMutableDictionary *todayDic = [[NSMutableDictionary alloc] init];
    [todayDic setObject:[NSNumber numberWithLong:[components year]] forKey:@"year"];
    [todayDic setObject:[NSNumber numberWithLong:[components month]] forKey:@"month"];
    [todayDic setObject:[NSNumber numberWithLong:[components day]] forKey:@"day"];
    
    return todayDic;
}

+ (UIButton *)createButtonWithPoint:(CGPoint)point imageName:(NSString *)imageName selectedImageName:(NSString*)selectedImageName target:(id)target selector:(SEL)selector
{
    UIButton*button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    
    button.frame = CGRectMake(point.x,point.y,button.currentBackgroundImage.size.width,button.currentBackgroundImage.size.height);
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (MBProgressHUD *)HUDText:(NSString *)message
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:appdelegate.window];
    
    // 将hud添加到window上显示
    [appdelegate.window addSubview:hud];
    
    // 纯文本提示
    hud.mode = MBProgressHUDModeText;
    
    // 提示的文字
    hud.labelText = message;
    
    // 遮盖层
    //hud.dimBackground = YES;
    
    // 提示框的大小
    hud.margin = 15;
    
    // 设置y轴偏移量，默认是所加视图的中间位置
    hud.yOffset = 200.0f;
    
    // 当消失的时候移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 显示
    [hud show:YES];
    
    // 延迟N秒后隐藏
    [hud hide:YES afterDelay:2];
    
    return hud;
}

+ (MBProgressHUD *)HUDActicityText:(NSString *)message
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:appdelegate.window];
    
    [appdelegate.window addSubview:hud];
    
    hud.labelText = message;
    
    hud.removeFromSuperViewOnHide = YES;
    
    // 遮盖层
    hud.dimBackground = YES;
    hud.margin = 10;
    [hud show:YES];
    
    //[hud hide:YES afterDelay:5];
    
    return hud;
}
+ (UIView *)imageViewWithIcon:(NSString *)icon
{
    UIView*view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    view.layer.mask = [self maskForRect:view.bounds];
    UIImageView*imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    imageView.center = view.center;
    [view addSubview:imageView];
    view.backgroundColor = kColorRGB(0x2ca58b);
    return view;
}
+(CAShapeLayer *)maskForRect:(CGRect)rect
{
    CAShapeLayer *layerMask = [CAShapeLayer layer];
    UIRectCorner corners = 5;
    
    layerMask.path = [UIBezierPath bezierPathWithRoundedRect:rect
                                           byRoundingCorners:corners
                                                 cornerRadii:CGSizeMake(5, 5)].CGPath;
    return layerMask;
}

@end
