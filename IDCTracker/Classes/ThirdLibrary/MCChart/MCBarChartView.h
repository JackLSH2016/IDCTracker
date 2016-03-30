//
//  MCBarChartView.h
//  zhixue_parents
//
//  Created by zhmch0329 on 15/8/17.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCColumnModel.h"
#import "MCColumn.h"

@class MCBarChartView;
@class UITableView;

@protocol MCBarChartViewDelegate <NSObject>

@optional
- (void)barChartView:(MCBarChartView *)barChartView didSelectBarmCcolumn:(MCColumn*)mCcolumn;

- (CGFloat)barWidthInBarChartView:(MCBarChartView *)barChartView;

- (CGFloat)paddingForSectionInBarChartView:(MCBarChartView *)barChartView;
- (UIColor *)barChartView:(MCBarChartView *)barChartView colorOfBarInSection:(NSInteger)section index:(NSInteger)index;

- (CGFloat)paddingForBarInBarChartView:(MCBarChartView *)barChartView;


@end

@interface MCBarChartView : UIView

@property (nonatomic, weak) id<MCBarChartViewDelegate> delegate;

/// 最大值，如果未设置计算数据源中的最大值
@property (nonatomic, strong) id maxValue;
/// y轴数据标记个数
@property (nonatomic, assign) NSInteger numberOfYAxis;
/// y轴数据单位
//@property (nonatomic, copy) NSString *unitOfYAxis;
/// y轴的颜色
@property (nonatomic, strong) UIColor *colorOfYAxis;
/// y轴文本数据颜色
@property (nonatomic, strong) UIColor *colorOfYText;
/// x轴的颜色
@property (nonatomic, strong) UIColor *colorOfXAxis;
/// x轴文本数据颜色
@property (nonatomic, strong) UIColor *colorOfXText;
/**
 *  show data
 */
@property (nonatomic, strong) NSArray *chartDataSource;
/**
 *  X title
 */
@property (nonatomic, strong) NSArray *XTitleArray;

@property(strong,nonatomic)UIScrollView *scrollView;
- (void)reloadData;
- (void)reloadDataWithAnimate:(BOOL)animate;

@end
