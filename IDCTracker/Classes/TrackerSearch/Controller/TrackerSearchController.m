//
//  TrackerSearchController.m
//  IDCTracker
//
//  Created by Jack on 18/1/2016.
//  Copyright © 2016 idt. All rights reserved.
//

#import "TrackerSearchController.h"
#import "BlueToothMananger.h"
#import "DetaialInfoViewController.h"

@interface TrackerSearchController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *peripheralsArray;
@end

@implementation TrackerSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //1.开始扫描
    [[BlueToothMananger manager] scan];
    
    [BlueToothMananger manager].peripheralsInfo = ^(NSArray*array)
    {
        for (CBPeripheral*peripheral in array) {
            [self.peripheralsArray addObject:peripheral];
        }
        [self.myTableView reloadData];
    };
    [self setUI];
    self.peripheralsArray =[NSMutableArray array];

}

- (void)setUI
{
    self.navigationItem.title = @"扫描设备";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource  =self;
    [self.view addSubview:self.myTableView];
}

#pragma mark - tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.peripheralsArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellId = @"cellID";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    CBPeripheral *model = _peripheralsArray[indexPath.row];
    cell.textLabel.text = model.name;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetaialInfoViewController*dvc = [[DetaialInfoViewController alloc] init];
    dvc.peripheral = _peripheralsArray[indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
