//
//  TrackerLoginController.m
//  IDTTracker
//
//  Created by Jack on 15/1/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "TrackerLoginController.h"
#import "TrackerMainController.h"
#import "TrackerRegisterController.h"
#import "TrackerForgetPWDController.h"
#import "JLButton.h"

//动画
#import "PresentAnimation.h"
#import "DismisAnimation.h"

@interface TrackerLoginController ()<UIViewControllerTransitioningDelegate>


@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet JLButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPWDButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@end

@implementation TrackerLoginController

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    PresentAnimation*animation = [PresentAnimation new];
    animation.startingPoint = self.loginButton.center;
    animation.bubbleColor = self.loginButton.backgroundColor;
    animation.duration = 2.f;
    return animation;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismisAnimation new];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    //1. add backGroundImage
    UIImageView*imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"loginBackground"];
    [self.view insertSubview:imageView atIndex:0];
    
    //2. add accountTF left image
    self.accountTF.leftView = [Tools imageViewWithIcon:@"ID"];
    self.accountTF.leftViewMode = UITextFieldViewModeAlways;
   
    //3. add passwordTF left image

    self.passwordTF.leftView = [Tools imageViewWithIcon:@"LoginPWD"];
    self.passwordTF.leftViewMode = UITextFieldViewModeAlways;
    

    //[self.view setNeedsLayout];
    //[self.view layoutIfNeeded];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.accountTF.transform = CGAffineTransformMakeTranslation(375, 0);
    self.passwordTF.transform = CGAffineTransformMakeTranslation(375, 0);
    self.loginButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
    //self.loginButton.transform = CGAffineTransformMakeRotation(M_PI_4);
    self.iconImage.transform = CGAffineTransformMakeTranslation(0, -200);
    self.registerButton.alpha = 0.f;
    self.forgetPWDButton.alpha = 0.f;
    self.loginButton.layer.cornerRadius = 8.f;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [UIView animateWithDuration:1.0 animations:^{
        self.accountTF.transform = CGAffineTransformIdentity;
        self.passwordTF.transform = CGAffineTransformIdentity;
        self.iconImage.transform = CGAffineTransformIdentity;
    }];

    CGFloat delay = 1.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.registerButton.alpha = 1.f;
        self.forgetPWDButton.alpha = 1.f;
        //注册用户按钮
        [self titleAnimationWith:self.registerButton];
        //忘记密码按钮
        [self titleAnimationWith:self.forgetPWDButton];
    });
    //登录按钮
    [self scaleAnimationWith:self.loginButton];

    //self.loginButton
}
/**
 *  按钮回弹动画效果
 *
 *  @param button button
 */
-(void)scaleAnimationWith:(UIButton*)button
{
    [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:1.0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
            button.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
}
/**
 *   按钮上的文字从左到右动画展现
 *
 *  @param button button
 */
-(void)titleAnimationWith:(UIButton*)button
{
    CGPathRef beginPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 0, button.frame.size.height)].CGPath;
    CGPathRef endPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0,button.frame.size.width ,button.frame.size.height)].CGPath;
    
    CAShapeLayer*buttonLayer = [[CAShapeLayer alloc] init];
    buttonLayer.path = endPath;
    buttonLayer.fillColor = [UIColor whiteColor].CGColor;
    button.layer.mask = buttonLayer;
    
    CABasicAnimation*animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration = 1.0;
    animation.beginTime = CACurrentMediaTime();
    animation.fromValue =(__bridge id _Nullable)(beginPath);
    animation.toValue = (__bridge id _Nullable)(endPath);
    [buttonLayer addAnimation:animation forKey:@"path"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)loginAction:(JLButton *)sender
{
    
    // 1.验证帐号
    NSString *account = self.accountTF.text;
    if (account.length == 0) {
        [self showError:@"请输入帐号"];
        return;
    }
    
    // 2.验证密码
    NSString *password = self.passwordTF.text;
    if (password.length == 0) {
        [self showError:@"请输入密码"];
        return;
    }
    
    // 3.发送请求
    self.view.userInteractionEnabled = NO;
    sender.layerColor = [UIColor greenColor];
    [sender startLoadingAnimation];
    CGFloat delay = 2.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 4.登录完毕（请求完毕）
        
        self.view.userInteractionEnabled = YES;
        
        // 5.账号密码同时为123才是正确
        if (![account isEqualToString:@"123"] || ![password isEqualToString:@"123"]) {
            [self showError:@"输入的帐号或者密码不正确"];
            [sender returnToOriginalState];
            return;
        }

        // 6.登录成功
        //结束动画
        [sender startFinishAnimationCompletion:^{
#warning 跳转到主页
            TrackerMainController*mc = [[TrackerMainController alloc] init];
            UINavigationController*nav = [[UINavigationController alloc] initWithRootViewController:mc];
            self.view.window.rootViewController = nav;
        }];

    });

}
//- (void)dealloc
//{
//    TLog(@"TrackerLoginController dealloc );
//}
/**
 *  显示错误信息
 *
 *  @param errorMsg 错误信息的内容
 */
- (void)showError:(NSString *)errorMsg
{
    // 1.弹框提醒
    UIAlertController*ac = [UIAlertController alertControllerWithTitle:errorMsg message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction*confirmButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:confirmButton];
    [self presentViewController:ac animated:YES completion:nil];
    
    // 2.抖动
    CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animation];
    shakeAnim.keyPath = @"transform.translation.x";
    shakeAnim.duration = 0.15;
    CGFloat delta = 15;
    shakeAnim.values = @[@0, @(-delta), @(delta), @0];
    shakeAnim.repeatCount = 2;
    [self.layerView.layer addAnimation:shakeAnim forKey:nil];
}

- (IBAction)forgetPassWord:(UIButton *)sender
{
    
    TrackerForgetPWDController*fvc = [[TrackerForgetPWDController alloc] init];
    UINavigationController*nav = [[UINavigationController alloc] initWithRootViewController:fvc];
//    nav.transitioningDelegate = self;
//    nav.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:nav animated:YES completion:nil];
}
- (IBAction)registerAction:(UIButton *)sender
{
    
    TrackerRegisterController*rvc = [[TrackerRegisterController alloc] init];
    UINavigationController*nav = [[UINavigationController alloc] initWithRootViewController:rvc];
//    nav.transitioningDelegate = self;
//    nav.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:nav animated:YES completion:nil];
}

@end
