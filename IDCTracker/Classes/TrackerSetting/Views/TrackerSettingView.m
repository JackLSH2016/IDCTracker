//
//  TrackerSettingView.m
//  IDCTracker
//
//  Created by Jack on 19/1/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "TrackerSettingView.h"
#import "LMComBoxView.h"


#define TrackerSettingViewBorder 20

@interface TrackerSettingView()<LMComBoxViewDelegate>



/**
 *  showing data
 */
@property(strong,nonatomic)NSArray*dataList;
/**
 *  title
 */
@property(strong,nonatomic)NSString*title;
/**
 *  iconName
 */
@property(strong,nonatomic)NSString*iconName;
@end

@implementation TrackerSettingView

- (instancetype)initWithFrame:(CGRect)frame withArr:(NSArray*)arr iconName:(NSString*)iconName withTitle:(NSString*)title
{
    if (self = [super initWithFrame:frame]) {
        
        self.dataList = arr;
        self.iconName = iconName;
        self.title = title;
       
        
        //1.setUpBgScrollView
        [self setUpBgScrollView];
        
    }
    return self;
}


/**
 *  setUpBgScrollView
 */
-(void)setUpBgScrollView
{
    
    CGFloat titleLableX = self.frame.origin.x;
    CGFloat titleLableY = 0;
    CGFloat titleLableH = 1.5*TrackerSettingViewBorder;
    CGFloat titleLableW = 5*TrackerSettingViewBorder;
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(titleLableX, titleLableY, titleLableW, titleLableH)];
    
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = self.title;
    [self addSubview:titleLable];
    
    
    CGFloat comBoxX = CGRectGetMaxX(titleLable.frame)+TrackerSettingViewBorder;
    CGFloat comBoxY = titleLableY;
    CGFloat comBoxH = titleLableH;
    CGFloat comBoxW = titleLableW;
    
    LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(comBoxX, comBoxY, comBoxW, comBoxH)];
    comBox.backgroundColor = [UIColor redColor];
    comBox.layer.cornerRadius = 8;
    comBox.layer.masksToBounds = YES;
    //@"down_dark0.png"
    comBox.arrowImgName =self.iconName;
    comBox.titlesList = [NSMutableArray arrayWithArray:self.dataList];
    comBox.delegate = self;
    comBox.supView = self;
    [comBox defaultSettings];
    comBox.backgroundColor = [UIColor redColor];
    comBox.tableHeight = self.dataList.count*comBoxH;
    [self addSubview:comBox];
}
#pragma mark -LMComBoxViewDelegate
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
}


@end
