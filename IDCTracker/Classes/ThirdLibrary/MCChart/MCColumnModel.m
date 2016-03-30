//
//  MCColumnModel.m
//  MCChartView
//
//  Created by Jack on 22/1/2016.
//  Copyright © 2016 zhmch0329. All rights reserved.
//

#import "MCColumnModel.h"

@implementation MCColumnModel
- (id)init
{
    self = [super init];
    if (self)
    {
        _label = @"Empty";
        _value = 0;
    }
    return self;
}

- (id)initWithLabel:(NSString *)label
              value:(float)vaule
              index:(NSInteger)index
{
    if (self = [super init])
    {
        if (nil == label)
        {
            _label = @"";
        }
        else
        {
            _label = label;
        }
        _value = vaule;
        _index = index;
    }
    return self;
}

@end
