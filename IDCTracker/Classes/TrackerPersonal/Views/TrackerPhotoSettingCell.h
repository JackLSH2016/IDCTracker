//
//  TrackerPhotoSettingCell.h
//  IDCTracker
//
//  Created by Jack on 19/1/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackerPhotoSettingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
-(void)cellWithTitle:(NSString*)title icon:(NSString*)icon;
@end
