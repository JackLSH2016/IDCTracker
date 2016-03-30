//
//  MCColumnModel.h
//  MCChartView
//
//  Created by Jack on 22/1/2016.
//  Copyright © 2016 zhmch0329. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCColumnModel : NSObject
@property (strong, nonatomic) NSString *label;
@property (nonatomic) float value;
@property (nonatomic) NSInteger index;
@property (nonatomic, strong) NSString *unit;

- (id)initWithLabel:(NSString *)label
              value:(float)vaule
              index:(NSInteger)index;
@end
