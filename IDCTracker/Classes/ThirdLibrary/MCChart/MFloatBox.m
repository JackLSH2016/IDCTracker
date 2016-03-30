//
//  EFloatBox.m
//  EChart
//
//  Created by Efergy China on 17/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import "MFloatBox.h"
//#import "EColor.h"


@implementation MFloatBox


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}


- (id)initWithPosition:(CGPoint)point
                 value:(float)value
                  unit:(NSString *)unit
                 title:(NSString *)title
             imageName:(NSString*)imageName
{
    self = [self initWithFrame:CGRectMake(point.x, point.y, 80, 60)];
    if (self)
    {
        _title = title;
        _value = value;
        _unit = unit;
        UIImage*image = [UIImage resizedImageWithName:imageName left:0.5 top:0.5];
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.image = image;
        [self addSubview:_imageView];
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -10, self.imageView.bounds.size.width, self.imageView.bounds.size.height)];


        
        [self.imageView addSubview:self.contentLabel];
        self.contentLabel.text = [self makeString];
        //self.backgroundColor = EBlueGreenColor;
        self.layer.cornerRadius = 3.0;
        //[self setFont:[UIFont systemFontOfSize:10.0f]];
        [self.contentLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Regular" size:10.0f]];
        [self.contentLabel setTextColor: [UIColor blackColor]];
        [self.contentLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self sizeToFit];
    }
    return self;
    
    
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize resultSize = [super sizeThatFits:size];
    resultSize = CGSizeMake(resultSize.width + 8, resultSize.height + 4);
    return resultSize;
}


- (void)setValue:(float)value
{
    _value = value;
    self.contentLabel.text = [self makeString];
}

- (NSString *)makeString
{
    NSString *finalText = nil;
    if (_title)
    {
        [self.contentLabel setNumberOfLines:2];
        if (_unit)
        {
            finalText = [_title stringByAppendingString:[[NSString stringWithFormat:@"\n%.1f ", _value] stringByAppendingString:_unit]];
        }
        else
        {
            finalText = [_title stringByAppendingString:[NSString stringWithFormat:@"\n%.1f", _value]];
        }
    }
    else
    {
        [self.contentLabel setNumberOfLines:1];
        if (_unit)
        {
            finalText = [[NSString stringWithFormat:@"%.1f ", _value] stringByAppendingString:_unit];
        }
        else
        {
            finalText = [NSString stringWithFormat:@"%.1f", _value];
        }
    }
    
    return finalText;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
