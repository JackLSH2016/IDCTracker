//
//  TrackerForgetPWDController.m
//  IDCTracker
//
//  Created by Jack on 20/1/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "TrackerForgetPWDController.h"
#import "JKCountDownButton.h"

@interface TrackerForgetPWDController ()
@property (weak, nonatomic) IBOutlet JKCountDownButton *countButton;

@end

@implementation TrackerForgetPWDController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"忘记密码";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"guiding_"] forBarMetrics:UIBarMetricsDefault];
}
- (IBAction)cancleBtnAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)confirmBtnAction:(UIButton *)sender
{
    //发送请求
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)countButtonClick:(JKCountDownButton *)sender {
 
    sender.enabled = NO;
    //button type要 设置成custom 否则会闪动
    [sender startWithSecond:60];
    [sender didChange:^NSString *(JKCountDownButton *countDownButton, int second) {
        NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
        return title;
    }];
    [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        return @"点击重新获取";
        
    }];

}

@end
