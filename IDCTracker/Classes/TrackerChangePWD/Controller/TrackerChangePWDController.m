//
//  TrackerChangePWDController.m
//  IDCTracker
//
//  Created by Jack on 19/1/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "TrackerChangePWDController.h"

#define kRegistBorder 20

@interface TrackerChangePWDController ()

@end

@implementation TrackerChangePWDController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addUI];
}
-(void)addUI
{
    self.view.backgroundColor = kColorRGB(0xf7f7f7);
    self.navigationItem.title = self.navTitle;

    //原密码
    UITextField*originalTF = [[UITextField alloc]initWithFrame:CGRectMake(kRegistBorder, kRegistBorder, TrackerWidth-2*kRegistBorder, 30)];
    originalTF.backgroundColor = [UIColor whiteColor];
    //self.emailTF = emailTF;
    originalTF.placeholder = @"请输入原密码";
    originalTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:originalTF];
    //密码
    UITextField*passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(originalTF.frame.origin.x,CGRectGetMaxY(originalTF.frame)+kRegistBorder, TrackerWidth-2*kRegistBorder, 30)];
    passwordTF.backgroundColor = [UIColor whiteColor];
    //self.passwordTF = passwordTF;
    passwordTF.placeholder = @"请输入新密码";
    passwordTF.secureTextEntry = YES;
    passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:passwordTF];
    //第二次密码
    UITextField*secondPasswordTF = [[UITextField alloc]initWithFrame:CGRectMake(passwordTF.frame.origin.x,CGRectGetMaxY(passwordTF.frame)+kRegistBorder, TrackerWidth-2*kRegistBorder, 30)];
    secondPasswordTF.backgroundColor = [UIColor whiteColor];
    //self.secondPasswordTF = secondPasswordTF;
    secondPasswordTF.placeholder = @"请再次输入新密码";
    secondPasswordTF.secureTextEntry = YES;
    secondPasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:secondPasswordTF];
    
    //确认按钮
    CGFloat confirmBtnW = passwordTF.bounds.size.width-4*kRegistBorder;
    CGFloat confirmBtnX = CGRectGetMinX(passwordTF.frame)+2*kRegistBorder;
    CGFloat confirmBtnY = CGRectGetMaxY(secondPasswordTF.frame)+3*kRegistBorder;
    
    CGFloat confirmBtnH = 30;
    UIButton*confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(confirmBtnX, confirmBtnY, confirmBtnW, confirmBtnH)];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    confirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.backgroundColor = kColorRGB(0x950020);
    confirmBtn.layer.cornerRadius = 5;
    confirmBtn.layer.masksToBounds = YES;
    [self.view addSubview:confirmBtn];
}
/**
 *  confirm password change
 */
-(void)confirmBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
