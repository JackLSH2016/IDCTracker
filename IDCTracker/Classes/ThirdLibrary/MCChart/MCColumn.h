//
//  MCColumn.h
//  MCChartView
//
//  Created by Jack on 22/1/2016.
//  Copyright © 2016 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCColumnModel.h"

@class MCColumn;

@protocol MCColumnDelegate <NSObject>

- (void)mColumnTaped:(MCColumn *)mColumn;

@end


@interface MCColumn : UIView

@property (nonatomic) float grade;

@property (nonatomic,strong) CAShapeLayer * chartLine;

@property (nonatomic, strong) UIColor * barColor;

@property (nonatomic, strong) MCColumnModel *mColumnDataModel;

-(void)rollBack;

@property (weak, nonatomic) id <MCColumnDelegate> delegate;
@end
