//
//  MCBarChartView.m
//  zhixue_parents
//
//  Created by zhmch0329 on 15/8/17.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import "MCBarChartView.h"
#import "MCChartInformationView.h"


#define RGBA(r,g,b,a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)      RGBA(r,g,b,1.0f)

#define BAR_CHART_TOP_PADDING 30
#define BAR_CHART_LEFT_PADDING 40
#define BAR_CHART_RIGHT_PADDING 8
#define BAR_CHART_TEXT_HEIGHT 40

#define BAR_WIDTH_DEFAULT 20.0

#define PADDING_SECTION_DEFAULT 10.0
#define PADDING_BAR_DEFAULT 1.0

#define ColumnWidth  30
#define ColumnBorder 15

CGFloat static const kChartViewUndefinedCachedHeight = -1.0f;

@interface MCBarChartView ()<MCColumnDelegate>



@property(nonatomic,assign) NSInteger index;

@property (nonatomic, assign) NSUInteger sections;
@property (nonatomic, assign) CGFloat paddingSection;
@property (nonatomic, assign) CGFloat paddingBar;
@property (nonatomic, assign) CGFloat barWidth;

@property (nonatomic, assign) CGFloat cachedMaxHeight;
@property (nonatomic, assign) CGFloat cachedMinHeight;

@end

@implementation MCBarChartView {
    UIColor *_chartBackgroundColor;
    
    
    CGFloat _chartHeight;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    CGFloat width = self.bounds.size.width;
    _chartHeight = self.bounds.size.height - BAR_CHART_TOP_PADDING - BAR_CHART_TEXT_HEIGHT;
    
    _numberOfYAxis = 6;
    _cachedMaxHeight = kChartViewUndefinedCachedHeight;
    _cachedMinHeight = kChartViewUndefinedCachedHeight;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(BAR_CHART_LEFT_PADDING, 0, width - BAR_CHART_RIGHT_PADDING - BAR_CHART_LEFT_PADDING, CGRectGetHeight(self.bounds))];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];

}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.chartDataSource == nil) {
        [self reloadData];
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawCoordinateWithContext:context];
}

#pragma mark - Draw Coordinate

- (void)drawCoordinateWithContext:(CGContextRef)context {
    CGFloat width = self.bounds.size.width;
    
    CGContextSetStrokeColorWithColor(context, _colorOfYAxis.CGColor);
    CGContextMoveToPoint(context, BAR_CHART_LEFT_PADDING - 1, BAR_CHART_TOP_PADDING - 1);
    CGContextAddLineToPoint(context, BAR_CHART_LEFT_PADDING - 1, BAR_CHART_TOP_PADDING + _chartHeight + 1);
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, _colorOfXAxis.CGColor);
    CGContextMoveToPoint(context, BAR_CHART_LEFT_PADDING - 1, BAR_CHART_TOP_PADDING + _chartHeight + 1);
    CGContextAddLineToPoint(context, width - BAR_CHART_RIGHT_PADDING + 1, BAR_CHART_TOP_PADDING + _chartHeight + 1);
    CGContextStrokePath(context);
}

#pragma mark - Height

- (CGFloat)normalizedHeightForRawHeight:(MCColumnModel*)model {
    
    CGFloat value = model.value;
    CGFloat maxHeight = [self.maxValue floatValue];
    return value/maxHeight * _chartHeight;
}

- (id)maxValue {
    if (_maxValue == nil) {
        if ([self cachedMaxHeight] != kChartViewUndefinedCachedHeight) {
            _maxValue = @([self cachedMaxHeight]);
        }
    }
    return _maxValue;
}

- (CGFloat)cachedMinHeight {
    if(_cachedMinHeight == kChartViewUndefinedCachedHeight) {
        NSArray *chartValues = [NSMutableArray arrayWithArray:_chartDataSource];
        for (MCColumnModel *model in chartValues) {
            CGFloat height = model.value;
            if (height < _cachedMinHeight) {
                _cachedMinHeight = height;
            }

        }
    }
    return _cachedMinHeight;
}

- (CGFloat)cachedMaxHeight {
    if (_cachedMaxHeight == kChartViewUndefinedCachedHeight) {
        NSArray *chartValues = [NSMutableArray arrayWithArray:_chartDataSource];
        for (MCColumnModel *model in chartValues) {
            CGFloat height = model.value;
            if (height > _cachedMaxHeight) {
                _cachedMaxHeight = height;
            }
        }
    }
    return _cachedMaxHeight+10;
}

#pragma mark - Reload Data
- (void)reloadData {
    [self reloadDataWithAnimate:YES];
}

- (void)reloadDataWithAnimate:(BOOL)animate {
    [self reloadChartDataSource];
    [self reloadChartYAxis];
    [self reloadBarWithAnimate:animate];
}

- (void)reloadChartDataSource {
    _cachedMaxHeight = kChartViewUndefinedCachedHeight;
    _cachedMinHeight = kChartViewUndefinedCachedHeight;
    
    _sections = _chartDataSource.count;

    
    _paddingSection = PADDING_SECTION_DEFAULT;
    if ([self.delegate respondsToSelector:@selector(paddingForSectionInBarChartView:)]) {
        _paddingSection = [self.delegate paddingForSectionInBarChartView:self];
    }
    _barWidth = BAR_WIDTH_DEFAULT;
    if ([self.delegate respondsToSelector:@selector(barWidthInBarChartView:)]) {
        _barWidth = [self.delegate barWidthInBarChartView:self];
    }

 
    CGFloat contentWidth = _paddingSection;
    for (NSUInteger i = 0; i < _sections; i ++) {
        contentWidth += _barWidth ;
        contentWidth += _paddingSection;
    }
    _scrollView.contentSize = CGSizeMake(contentWidth, 0);
}

- (void)reloadChartYAxis {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    CGFloat chartYOffset = _chartHeight + BAR_CHART_TOP_PADDING;
    CGFloat unitHeight = _chartHeight/_numberOfYAxis;
    CGFloat unitValue = [self.maxValue floatValue]/_numberOfYAxis;
    for (NSInteger i = 0; i <= _numberOfYAxis; i ++) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, chartYOffset - unitHeight * i - 10, BAR_CHART_LEFT_PADDING - 2, 20)];
        textLabel.textColor = _colorOfYText;
        textLabel.textAlignment = NSTextAlignmentRight;
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.numberOfLines = 0;
        textLabel.text = [NSString stringWithFormat:@"%.0f", unitValue * i];
        [self addSubview:textLabel];
    }
}
- (void)reloadChartXAxis {
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    for (NSInteger i = 0; i < _sections; i ++) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake((15+ColumnWidth) * i+10 ,CGRectGetMaxY(_scrollView.frame)-40, ColumnWidth+4, 20)];
        textLabel.textColor = _colorOfXText;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.numberOfLines = 0;
        textLabel.text = self.XTitleArray[i];
        [self.scrollView addSubview:textLabel];
    }
}

- (void)reloadBarWithAnimate:(BOOL)animate {
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_scrollView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    NSArray *array = _chartDataSource;
    for (NSInteger index = 0; index < array.count; index ++) {
            MCColumnModel*model = array[index];
            [self normalizedHeightForRawHeight:model];
            int num = 10;
            MCColumn *mColumn = [[MCColumn alloc] initWithFrame:CGRectMake(num + (index *(ColumnWidth+15)),ColumnWidth, ColumnWidth, self.frame.size.height-7*num)];
    
            mColumn.grade = model.value / [_maxValue floatValue];
            mColumn.mColumnDataModel = _chartDataSource[index];
            mColumn.backgroundColor = [UIColor clearColor];
            if ([self.delegate respondsToSelector:@selector(barChartView:colorOfBarInSection:index:)]) {
                mColumn.barColor = [self.delegate barChartView:self colorOfBarInSection:0 index:index];
            } else {
                mColumn.barColor = [UIColor redColor];
            }
            [mColumn setDelegate:self];
            [_scrollView addSubview:mColumn];
    }
   
    [self reloadChartXAxis];
}
- (void)mColumnTaped:(MCColumn *)mColumn
{
    [self.delegate barChartView:self didSelectBarmCcolumn:mColumn];
}
@end
