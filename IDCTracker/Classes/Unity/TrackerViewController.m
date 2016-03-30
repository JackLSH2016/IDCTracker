//
//  TrackerViewController.m
//  IDCTracker
//
//  Created by admin on 25/1/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "TrackerViewController.h"

@interface TrackerViewController ()

@end

@implementation TrackerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"guiding_"] forBarMetrics:UIBarMetricsDefault];
    //create return Button
    UIButton*returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [returnBtn setImage:[UIImage imageNamed:@"return sign_"] forState:UIControlStateNormal];
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [returnBtn addTarget:self action:@selector(returnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    
    
    if ([UIDevice currentDevice].systemVersion.floatValue >7.0) {
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

}

#pragma mark returnBtnAction
-(void)returnBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
