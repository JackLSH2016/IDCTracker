//
//  DetaialInfoViewController.m
//  textlanya
//
//  Created by jack1 on 15/12/31.
//  Copyright (c) 2015年 jack1. All rights reserved.
//

#import "DetaialInfoViewController.h"
#import "BlueToothMananger.h"
@interface DetaialInfoViewController ()

@end

@implementation DetaialInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    [[BlueToothMananger manager] connectToDevice:self.peripheral];
    
    [BlueToothMananger manager].block = ^(BOOL isSuccese){
        if (isSuccese) {
            UIAlertController*ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"连接成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction*confirmButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [ac addAction:confirmButton];
            [self presentViewController:ac animated:YES completion:nil];
        }else{
            UIAlertController*ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"连接失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction*confirmButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [ac addAction:confirmButton];
            [self presentViewController:ac animated:YES completion:nil];
        }
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
