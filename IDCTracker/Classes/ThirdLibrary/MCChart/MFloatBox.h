//
//  EFloatBox.h
//  EChart
//
//  Created by Efergy China on 17/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFloatBox : UIView
@property (nonatomic) float value;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *title;
@property(strong,nonatomic)UILabel*contentLabel;
@property(strong,nonatomic)UIImageView*imageView;
- (id)initWithPosition:(CGPoint)point
                 value:(float)value
                  unit:(NSString *)unit
                 title:(NSString *)title
             imageName:(NSString*)imageName;
@end
