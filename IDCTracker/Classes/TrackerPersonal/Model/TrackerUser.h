//
//  TrackerUser.h
//  IDCTracker
//
//  Created by Jack on 19/1/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackerUser : NSObject
/**
 *  name
 */
@property(strong,nonatomic)NSString*name;
/**
 *  telephone
 */
@property(strong,nonatomic)NSString*telephone;
/**
 *  icon
 */
@property(strong,nonatomic)NSString*icon;
/**
 *  accountName
 */
@property(strong,nonatomic)NSString*accountName;
/**
 *  password
 */
@property(strong,nonatomic)NSString*password;

@end
