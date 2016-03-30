//
//  TrackerRegisterController.m
//  IDCTracker
//
//  Created by Jack on 20/1/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "TrackerRegisterController.h"

@interface TrackerRegisterController ()
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *backUpEmail;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPWDTF;

@end

@implementation TrackerRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1. add UI
    [self addUI];
    
}
- (void)dealloc
{

    
}
-(void)addUI
{
    self.navigationItem.title = @"注册";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"guiding_"] forBarMetrics:UIBarMetricsDefault];
    
    UIImageView*imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"registerBackground_"];
    [self.view insertSubview:imageView atIndex:0];
    
    //add nickNameTF left View
    self.nickNameTF.leftView = [Tools imageViewWithIcon:@"ID name_"];
    self.nickNameTF.leftViewMode = UITextFieldViewModeAlways;
    
    //add emailTF left View
    self.emailTF.leftView = [Tools imageViewWithIcon:@"email_"];
    self.emailTF.leftViewMode = UITextFieldViewModeAlways;
    
    //add backUpEmail left View
    self.backUpEmail.leftView = [Tools imageViewWithIcon:@"backup email_"];
    self.backUpEmail.leftViewMode = UITextFieldViewModeAlways;
    
    //add passWordTF left View
    self.passWordTF.leftView = [Tools imageViewWithIcon:@"password_"];
    self.passWordTF.leftViewMode = UITextFieldViewModeAlways;
    
    //add confirmPWDTF left View
    self.confirmPWDTF.leftView = [Tools imageViewWithIcon:@"comfirm password_"];
    self.confirmPWDTF.leftViewMode = UITextFieldViewModeAlways;
}
- (IBAction)RegisterBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancleBtnAciton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
