//
//  TrackerPersonalController.m
//  IDTTracker
//
//  Created by Jack on 15/1/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "TrackerPersonalController.h"
#import "TrackerPhotoSettingCell.h"
#import "TrackerOtherSettingCell.h"
#import "TrackerPersonalDetailController.h"
#import "TrackerChangePWDController.h"
#import "TrackerLoginController.h"
#import "TrackerFooterHistoryList.h"
#import "TrackerMainController.h"
#import "TrackerVC.h"

@class MapKit;

static NSString * photoCellID = @"photoCell";
static NSString * otherCellID = @"otherCell";

@interface TrackerPersonalController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)NSArray*dataList;

@property(strong,nonatomic)UIImageView *icon;

@property(strong,nonatomic)UITableView*tableView;
@end

@implementation TrackerPersonalController

- (void)viewDidLoad {
    [super viewDidLoad];

    //添加UI
    [self addGroup];
    //1. add first section
    NSArray*firstArr = @[NSLocalizedStringFromTable(@"iconTitle", TrackerString, nil),
                         NSLocalizedStringFromTable(@"nameTitle", TrackerString, nil),
                         NSLocalizedStringFromTable(@"telephoneTitle", TrackerString, nil)];
    //2. add second section
    NSArray*secondArr = @[NSLocalizedStringFromTable(@"changgePasswordTitle", TrackerString, nil),
                          NSLocalizedStringFromTable(@"historicalTrack", TrackerString, nil)];
    _dataList = @[firstArr, secondArr];
    //_dataList = @[@"头像",@"昵称",@"手机号",@"修改密码"];
}
- (void)setIcon:(UIImageView *)icon
{
    _icon = icon;
    _icon.layer.cornerRadius = 25;
    _icon.layer.masksToBounds = YES;
}
/**
 *  add ui
 */
-(void)addGroup
{
    self.navigationItem.title = @"个人信息";
    
    //create save Button
    UIButton*saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = kColorRGB(0xf7f7f7);
    //register cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TrackerPhotoSettingCell" bundle:nil] forCellReuseIdentifier:photoCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"TrackerOtherSettingCell" bundle:nil] forCellReuseIdentifier:otherCellID];
    
    //add logout btn
    UIButton*logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, TrackerWidth-30, 30)];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    logoutBtn.backgroundColor = [UIColor redColor];
    [logoutBtn addTarget:self action:@selector(logoutBtnAction) forControlEvents:UIControlEventTouchUpInside];

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TrackerWidth, 100)];
    [bottomView addSubview:logoutBtn];
    self.tableView.tableFooterView = bottomView;
}
#pragma mark saveBtnAction
-(void)saveBtnAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark returnBtnAction
/**
 *  重写父类returnBtnAction
 */
-(void)returnBtnAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)logoutBtnAction
{
    for (UIView*view in appdelegate.window.subviews) {
        [view removeFromSuperview];
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *loginVc = [storyboard instantiateViewControllerWithIdentifier:@"login"];
    
    appdelegate.window.rootViewController = loginVc;
}

- (void)dealloc
{
    NSLog(@"TrackerPersonalController dealloc");
}
#pragma mark 代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        TrackerPhotoSettingCell*cell = [tableView dequeueReusableCellWithIdentifier:photoCellID forIndexPath:indexPath];
        [cell cellWithTitle:_dataList[indexPath.section][indexPath.row] icon:nil];
        return cell;
    }else{
        
        TrackerOtherSettingCell*cell = [tableView dequeueReusableCellWithIdentifier:otherCellID forIndexPath:indexPath];
        cell.title.text = _dataList[indexPath.section][indexPath.row];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 56.0f;
    }else{
        return 50.0f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TrackerPhotoSettingCell*cell = (TrackerPhotoSettingCell*)[tableView cellForRowAtIndexPath:indexPath];
            self.icon = cell.icon;
            [self setIcon];
        }else{
            TrackerPersonalDetailController*pdc = [[TrackerPersonalDetailController alloc] init];
            pdc.navTitle = _dataList[indexPath.section][indexPath.row];
            pdc.reblock = ^(NSString*valueStr,NSIndexPath*path,NSString*navTitle){
                TrackerOtherSettingCell*cell =(TrackerOtherSettingCell*)[tableView cellForRowAtIndexPath:indexPath];
                cell.content.text = valueStr;
            };
            [self.navigationController pushViewController:pdc animated:YES];
        }

    }else{
        if (indexPath.row == 0) {
            TrackerChangePWDController*pwd = [[TrackerChangePWDController alloc] init];
            pwd.navTitle = _dataList[indexPath.section][indexPath.row];
            [self.navigationController pushViewController:pwd animated:YES];
        }else{
            //history tracker
            TrackerVC*tvc = [[TrackerVC alloc] init];
            tvc.navTitle = _dataList[indexPath.section][indexPath.row];
            [self.navigationController pushViewController:tvc animated:YES];
        }
        
    }
}
#pragma mark -设置图片
-(void)setIcon
{
    UIAlertController*ac = [UIAlertController alertControllerWithTitle:@"请选择要上传的图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction*cancleButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction*photoButton = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotoLibrary];
    }];
    UIAlertAction*cameraButton = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }];
    
    [ac addAction:cancleButton];
    [ac addAction:photoButton];
    [ac addAction:cameraButton];
    [self presentViewController:ac animated:YES completion:nil];
    
}

/**
 *  打开相机
 */
- (void)openCamera
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

/**
 *  打开相册
 */
- (void)openPhotoLibrary
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}
#pragma mark -UIImagePickerController代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //UIImage
    // 1.销毁picker控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    //设置图片
 //   _hud = [Tools HUDActicityText:@"设置图片中..."];
    self.icon.image = info[UIImagePickerControllerOriginalImage];
//    //把图片发送把服务器
//    AFHTTPRequestOperationManager*mag = [AFHTTPRequestOperationManager manager];
//    //用户名
//    NSString*userName = [self.reModel.username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    NSString*url = [NSString stringWithFormat:kUpIconUrl,userName,self.reModel.passWord];
//    [mag POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        NSData*data = UIImageJPEGRepresentation(self.iconView.image, 0.000001);
//        [formData appendPartWithFileData:data name:@"filename" fileName:@"123.jpg" mimeType:@"image/jpeg"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if ([responseObject[@"code"] isEqualToString:@"200"]) {
//            self.reModel.avatar = responseObject[@"data"];
//        }
//        _hud.hidden = YES;
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        _hud.hidden = YES;
//    }];
    
}


@end
