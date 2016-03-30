//
//  TrackerHeadView.m
//  IDCTracker
//
//  Created by admin on 17/2/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "TrackerHeadView.h"


#define viewBorderWith 20

@interface TrackerHeadView()
/**
 *  为了计算位置
 */
@property(weak,nonatomic)UIButton*leftButton;
/**
 *  为了计算位置
 */
@property(weak,nonatomic)UIImageView*iconView;

@end

@implementation TrackerHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        //1. add left button
        [self addLeftButton];
        
        //2. add icon
        [self addIconView];
        
        //3. get date
        NSDictionary*dateDict = [Tools getTodayDate];
        
        //3.1 add year label
        CGFloat yearLabelX = CGRectGetMaxX(_iconView.frame)+viewBorderWith;
        CGFloat yearLabelY = viewBorderWith;
        CGFloat yearLabelW = 50+viewBorderWith;
        CGFloat yearLabelH = 20;
        _yearLabel = [self addDateLabelWithFrame:CGRectMake(yearLabelX, yearLabelY, yearLabelW, yearLabelH) text:[NSString stringWithFormat:@"%@年",dateDict[@"year"]] fontSzie:20.f];
        _yearCount = [dateDict[@"year"] longValue];
        
        //3.2 add month label
        CGFloat monthLabelX = yearLabelX;
        CGFloat monthLabelY = CGRectGetMaxY(_yearLabel.frame);
        CGFloat monthLabelW = yearLabelW;
        CGFloat monthLabelH = yearLabelH+viewBorderWith/2;
        
        _monthLabel = [self addDateLabelWithFrame:CGRectMake(monthLabelX, monthLabelY, monthLabelW, monthLabelH) text:[NSString stringWithFormat:@"%@月",dateDict[@"month"]] fontSzie:25.f];
         _monthCount = [dateDict[@"month"] longValue];
        _monthLabel.textAlignment = NSTextAlignmentRight;
        //3.3 add down button
        [self addDownButton];
        
        //3.4 add day label
        
        CGFloat dayLabelX = CGRectGetMaxX(_yearLabel.frame)+viewBorderWith/2;
        CGFloat dayLabelY = yearLabelY+5;
        CGFloat dayLabelH = self.bounds.size.height-2*viewBorderWith;
        CGFloat dayLabelW = dayLabelH+viewBorderWith;
        _dayLabel = [self addDateLabelWithFrame:CGRectMake(dayLabelX, dayLabelY, dayLabelW, dayLabelH) text:[NSString stringWithFormat:@"%@",dateDict[@"day"]] fontSzie:75.f];
        _dayCount = [dateDict[@"day"] longValue];
        
        //4. add right button
        [self addRightButton];

    }
    return self;
}

/**
 *  增加左键
 */
-(void)addLeftButton
{
    CGFloat leftButtonX = viewBorderWith;
    CGFloat leftButtonY = self.bounds.size.height/2-viewBorderWith/2;
    UIButton*leftButton = [Tools createButtonWithPoint:CGPointMake(leftButtonX, leftButtonY) imageName:@"arrowLeft" selectedImageName:nil target:self selector:@selector(leftButtonClick)];
    [self addSubview:leftButton];
    self.leftButton = leftButton;
}
/**
 *  追加icon
 */
-(void)addIconView
{
    CGFloat iconViewX = CGRectGetMaxX(_leftButton.frame)+viewBorderWith;
    CGFloat iconViewY = CGRectGetMinY(_leftButton.frame);
    CGFloat iconViewW = self.middleY;
    CGFloat iconViewH = iconViewW;
    UIImageView*iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH)];
    iconView.layer.cornerRadius = 25;
    iconView.layer.masksToBounds = YES;
    iconView.backgroundColor = [UIColor yellowColor];
    [self addSubview:iconView];
    self.iconView = iconView;
}
/**
 *  增加缩放的label
 *
 *  @param frame    fram
 *  @param text     显示内容
 *  @param fontSzie 字体大小
 *
 *  @return label
 */
- (ScaleLabel *)addDateLabelWithFrame:(CGRect)frame text:(NSString*)text fontSzie:(CGFloat)fontSzie
{

    ScaleLabel *label      = [[ScaleLabel alloc] initWithFrame:frame];
    label.text             = text;
    label.startScale       = 0.3f;
    label.endScale         = 2.f;
    label.backedLabelColor = [UIColor blackColor];
    label.colorLabelColor  = [UIColor cyanColor];
    label.font             = [UIFont AvenirLightWithFontSize:fontSzie];
    
    [[GCDQueue mainQueue] execute:^{
        [label startAnimation];
    } afterDelay:NSEC_PER_SEC * 1];
    [self addSubview:label];

    return label;
}
/**
 *  增加下拉日历按钮
 */
-(void)addDownButton
{
    CGFloat downButtonX = CGRectGetMaxX(_monthLabel.frame)-viewBorderWith*1.5;
    CGFloat downButtonY = CGRectGetMaxY(_monthLabel.frame);
    UIButton*downButton = [Tools createButtonWithPoint:CGPointMake(downButtonX, downButtonY) imageName:@"down_dark0" selectedImageName:nil target:self selector:@selector(downButtonClick:)];
    [self addSubview:downButton];
}
/**
 *  增加右键
 */
-(void)addRightButton
{
    CGFloat rightButtonX = TrackerWidth-1.5*viewBorderWith;
    CGFloat rightButtonY = CGRectGetMidY(_leftButton.frame);
    UIButton*rightButton = [Tools createButtonWithPoint:CGPointMake(rightButtonX, rightButtonY) imageName:@"arrowRight" selectedImageName:nil target:self selector:@selector(rightButtonClick)];
    [self addSubview:rightButton];
}
-(void)downButtonClick:(UIButton*)sender
{
    [self.delegate headViewCalenderShowButtonClick];

}

-(void)leftButtonClick
{
    if (--_dayCount) {
        self.dayLabel.text = [NSString stringWithFormat:@"%ld",_dayCount];
    }else{
        if (--_monthCount) {
            self.monthLabel.text = [NSString stringWithFormat:@"%ld月",_monthCount];
            if (_monthCount == 2) {
                //判断是否为闰年
                if (_yearCount%400 == 0||(_yearCount%4 ==0 && _yearCount%100 != 0)) {
                    self.dayLabel.text = @"29";
                    _dayCount = 29;
                }else{
                    self.dayLabel.text = @"28";
                    _dayCount = 28;
                }
            }else if( _monthCount == 1 || _monthCount == 3 || _monthCount == 5 || _monthCount == 7 || _monthCount == 8
                     || _monthCount == 10 || _monthCount == 12){
                self.dayLabel.text = @"31";
                _dayCount = 31;
            }else{
                self.dayLabel.text = @"30";
                _dayCount = 30;
            }
        }else{
            self.yearLabel.text = [NSString stringWithFormat:@"%ld年",--_yearCount];
            self.monthLabel.text = @"12月";
            _monthCount = 12;
            self.dayLabel.text = @"31";
            _dayCount = 31;
        }
    }
    //刷新数据
    if (self.block) {

        self.block([NSString  stringWithFormat:@"%ld-%02ld-%02ld",_yearCount,_monthCount,_dayCount]);
    }
}
-(void)rightButtonClick
{
    if (++_dayCount <= 28) {
        self.dayLabel.text = [NSString stringWithFormat:@"%ld",_dayCount];
    }else{
        ++_dayCount;
        if (_monthCount == 2) {
            //判断是否为闰年
            if (_yearCount%400 == 0||(_yearCount%4 ==0 && _yearCount%100 != 0)) {
                if (_dayCount != 29) {
                    self.monthLabel.text = @"3月";
                    _monthCount = 3;
                    self.dayLabel.text = @"1";
                    _dayCount = 1;
                }else{
                    self.dayLabel.text = @"29";
                    _dayCount = 29;
                }
            }else{
                self.monthLabel.text = @"3月";
                _monthCount = 3;
                self.dayLabel.text = @"1";
                _dayCount = 1;
            }
        }else if( _monthCount == 1 || _monthCount == 3 || _monthCount == 5 || _monthCount == 7 || _monthCount == 8
                 || _monthCount == 10 || _monthCount == 12){
            if (_dayCount <= 31) {
                 self.dayLabel.text = [NSString stringWithFormat:@"%ld",++_dayCount];
            }else{
                if (_monthCount == 12) {
                    self.dayLabel.text = @"1";
                    _dayCount = 1;
                    self.monthLabel.text = @"1月";
                    _monthCount = 1;
                    self.yearLabel.text = [NSString stringWithFormat:@"%ld年",++_yearCount];
                }else{
                    self.monthLabel.text = [NSString stringWithFormat:@"%ld月",++_monthCount];
                    self.dayLabel.text = @"1";
                    _dayCount = 1;
                }
            }
        }else{
            if (_dayCount <= 30) {
                self.dayLabel.text = @"30";
                _dayCount = 30;
            }else{
                self.monthLabel.text = [NSString stringWithFormat:@"%ld月",++_monthCount];
                self.dayLabel.text = @"1";
                _dayCount = 1;
            }
        }
    }
    //刷新数据
    if (self.block) {
        self.block([NSString  stringWithFormat:@"%ld-%02ld-%02ld",_yearCount,_monthCount,_dayCount]);
    }
}
@end
