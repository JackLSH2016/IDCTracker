//
//  TrackerPhotoSettingCell.m
//  IDCTracker
//
//  Created by Jack on 19/1/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "TrackerPhotoSettingCell.h"

@interface TrackerPhotoSettingCell()

   
@end

@implementation TrackerPhotoSettingCell

- (void)awakeFromNib {
    // Initialization code
    self.icon.layer.cornerRadius = 25;
    self.icon.layer.masksToBounds = YES;
}

-(void)cellWithTitle:(NSString*)title icon:(NSString*)icon
{
    self.title.text = title;
    if (icon) {
        self.icon.image = [UIImage imageNamed:icon];
    }
}
@end
