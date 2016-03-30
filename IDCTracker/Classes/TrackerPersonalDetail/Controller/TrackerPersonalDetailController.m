//
//  TrackerPersonalDetailController.m
//  IDCTracker
//
//  Created by Jack on 19/1/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "TrackerPersonalDetailController.h"

@interface TrackerPersonalDetailController ()
@property(strong,nonatomic)UITextField*tf;
@end

@implementation TrackerPersonalDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI
{
    self.navigationItem.title = self.navTitle;
    
    _tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, TrackerWidth, 50)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tf];
    UIView*view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, TrackerWidth, 1)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    _tf.text = self.tfStr;
    
    //设置保存按钮
    UIButton*button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [button setTitle:@"存储" forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_tf becomeFirstResponder];
}
-(void)saveBtnClick
{
    //&& ![Helper justMobile:_tf.text]
    if ([_navTitle isEqualToString:@"电话"] ) {
        UIAlertController*ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请填写正确的手机号码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*confirmButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:confirmButton];
        [self presentViewController:ac animated:YES completion:nil];
    }else{
        if (self.reblock) {
            self.reblock(_tf.text,self.indexpath,self.navTitle);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
