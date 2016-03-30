//
//  ViewController.m
//  
//
//  Created by wordoor－z on 16/1/14.
//  Copyright © 2016年 wzx. All rights reserved.
//

#import "WZXPopViewController.h"

@interface WZXPopViewController ()



@end

@implementation WZXPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.title = @"111";
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)createPopVCWithRootVC:(UIViewController *)rootVC andPopView:(UIView *)popView
{
    _rootVC = rootVC;
    _popView = popView;
    [self createUI];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    _rootVC.view.frame = self.view.bounds;
   _rootVC.view.backgroundColor = [UIColor yellowColor];
    _rootview = _rootVC.view;
    //设置popView的阴影效果
    _popView.layer.shadowColor = [UIColor blackColor].CGColor;
    _popView.layer.shadowOffset = CGSizeMake(0, -2);
    _popView.layer.shadowRadius = 5.0f;
    _popView.layer.shouldRasterize = YES;
    _popView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    _popView.layer.shadowOpacity = 0.8;
   [self addChildViewController:_rootVC];
    [self.view addSubview:_rootview];
    
    //rootVC上的maskView
    _maskView = ({
        UIView * maskView = [[UIView alloc]initWithFrame:self.view.bounds];
        maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        maskView.alpha = 0;
        maskView;
    });
     [_rootview addSubview:_maskView];
}

- (void)close
{
    
    CGRect frame = _popView.frame;
    frame.origin.y += frame.size.height;
    CGFloat duration = 0.5;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //maskView隐藏
        [_maskView setAlpha:0.f];
        //popView下降
        _popView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //变为初始值
            [_rootview.layer setTransform:CATransform3DIdentity];
            
        } completion:^(BOOL finished) {
            
            //移除
             [_popView removeFromSuperview];
        }];
        
    }];
    
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
       
        //和上个动画同时进行 感觉更丝滑
        [_rootview.layer setTransform:[self firstTransform]];
       
    } completion:^(BOOL finished) {
        
    }];

    
}

- (void)show
{
    [[UIApplication sharedApplication].windows[0] addSubview:_popView];
    
    CGRect frame = _popView.frame;
    frame.origin.y -= frame.size.height;
    CGFloat duration = 0.5;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_rootview.layer setTransform:[self firstTransform]];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [_rootview.layer setTransform:[self secondTransform]];
            //显示maskView
            [_maskView setAlpha:0.5f];
            //popView上升
            _popView.frame = frame;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
   
}


- (CATransform3D)firstTransform{
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    //带点缩小的效果
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    //绕x轴旋转
    t1 = CATransform3DRotate(t1, 15.0 * M_PI/180.0, 1, 0, 0);
    return t1;
    
}

- (CATransform3D)secondTransform{
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = [self firstTransform].m34;
    //向上移
    t2 = CATransform3DTranslate(t2, 0, self.view.frame.size.height * (-0.08), 0);
    //第二次缩小
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    return t2;
}
@end
