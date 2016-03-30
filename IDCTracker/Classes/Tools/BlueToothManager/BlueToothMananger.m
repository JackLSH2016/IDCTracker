//
//  BlueToothMananger.m
//  02-蓝牙
//
//  Created by vera on 15/12/17.
//  Copyright © 2015年 vera. All rights reserved.
//

#import "BlueToothMananger.h"
//蓝牙4.0   iphone4不支持蓝牙4.0


//服务器uuid
static NSString *const kServiceUUID = @"50BD367B-6B17-4E81-B6E9-F62016F26E7B";

@interface BlueToothMananger ()<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    //中心管理角色
    CBCentralManager *_centralManager;
}

/**
 *  保存所有的特征
 */
@property (nonatomic, strong) NSMutableArray *characteristicsArray;

/**
 *  保存所有的扫描到的外部设备
 */
@property (nonatomic, strong) NSMutableArray *peripheralsArray;

/**
 *  连接的外部设备
 */
@property (nonatomic, strong) CBPeripheral *peripheral;
/**
 *  连接的外部成功标志
 */
@property (nonatomic, assign) BOOL isSucesse;

/**
 *  scan hud
 */
@property(nonatomic,strong)MBProgressHUD*scanHud;
@end

@implementation BlueToothMananger
/**
 *  单例
 *
 *  @param uuidstring <#uuidstring description#>
 *
 *  @return <#return value description#>
 */
+ (instancetype)manager
{
    static BlueToothMananger *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });

    return manager;
}
/**
 *  懒加载
 *  @return <#return value description#>
 */
- (NSMutableArray *)characteristicsArray
{
    if (!_characteristicsArray)
    {
        _characteristicsArray = [NSMutableArray array];
    }
    
    return _characteristicsArray;
}
/**
 *  懒加载
 *  @return <#return value description#>
 */
- (NSMutableArray *)peripheralsArray
{
    if (!_peripheralsArray)
    {
        _peripheralsArray = [NSMutableArray array];
    }
    
    return _peripheralsArray;
}

/**
 *  扫描外部设备
 */
- (void)scan
{
    //创建中心角色
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    _scanHud = [Tools HUDActicityText:@"正在扫描中..."];
    CGFloat delay = 30.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _scanHud.hidden = YES;
        [_centralManager stopScan];
        if (self.peripheralsInfo) {
            self.peripheralsInfo(self.peripheralsArray);
        }
        
    });
    
//    _centralManager = [CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
}

/**
 *  发送数据
 */
- (void)sendData
{
    /*
     0x1811 打开  0：打开  1：关闭
     */
    
    //Byte
    //发送数据
    /*
     writeValue:要发送数据
     forCharacteristic:特征
     */
    //[NSData dataWithBytes:<#(nullable const void *)#> length:<#(NSUInteger)#>];
    [self.peripheral writeValue:[@"0" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:[self characteristicWithUUIDString:@"0x1811"] type:CBCharacteristicWriteWithResponse];
}

/**
 *  根据uuid查找特征
 *
 *  @param uuidstring <#uuidstring description#>
 *
 *  @return <#return value description#>
 */
- (CBCharacteristic *)characteristicWithUUIDString:(NSString *)uuidstring
{
    for (CBCharacteristic *c in self.characteristicsArray)
    {
        if ([c.UUID.UUIDString isEqualToString:uuidstring])
        {
            return c;
        }
    }
    
    return nil;
}

#pragma mark - CBCentralManagerDelegate
/**
 *  必须实现的。获取到当前手机的蓝牙状态
 *
 *  @param central <#central description#>
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStateUnsupported)
    {
        _scanHud.hidden = YES;
        [Tools HUDText:@"当前设备不支持蓝牙"];
        return;
    }
    else if (central.state == CBCentralManagerStatePoweredOff)
    {
        _scanHud.hidden = YES;
        [Tools HUDText:@"当前设置蓝牙关闭.提示用户打开蓝牙"];
        return;
    }
    else if (central.state == CBCentralManagerStatePoweredOn)
    {
        NSLog(@"蓝牙已经打开了");
        
        //连接指定的设置
        //CBUUID *uuid = [CBUUID UUIDWithString:kServiceUUID];
        
        //扫描外部设备
        /*
         第1个参数传nil表示扫描所有的设备
         */
        //扫描指定的外设
        //[_centralManager scanForPeripheralsWithServices:@[uuid] options:nil];
        [_centralManager scanForPeripheralsWithServices:nil options:nil];
        
    }
}

/**
 *  已经扫描到外部设备会触发
 *
 *  @param central           <#central description#>
 *  @param peripheral        <#peripheral description#>
 *  @param advertisementData <#advertisementData description#>
 *  @param RSSI              <#RSSI description#> <NSString *, id>
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //RSSI:(Received Signal Strength Indication) 接收的信号强度指示。
    
    //打印外部设备名字
    NSLog(@"%@",peripheral.name);
    //&& peripheral.state == CBPeripheralStateDisconnected
    if (![self.peripheralsArray containsObject:peripheral])
    {
        NSLog(@"---%@----%ld",self.peripheralsArray,self.peripheralsArray.count);
        //将扫描到满足要求的蓝牙外设添加到数组中保存
        [self.peripheralsArray addObject:peripheral];
         NSLog(@"---%@----%ld",self.peripheralsArray,self.peripheralsArray.count);
        //连接扫描到外部设备
        //[central connectPeripheral:peripheral options:nil];
    }
}
/**
 *  连接设备
 */
- (void)connectToDevice:(CBPeripheral *)peripheral
{
    [_centralManager connectPeripheral:peripheral options:nil];

}

/**
 *  连接外部设备成功
 *
 *  @param central    <#central description#>
 *  @param peripheral <#peripheral description#>
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    self.isSucesse = true;
    if (self.block) {
        self.block(self.isSucesse);
    }
    //1.保存当前连接的外部设备对象
    self.peripheral = peripheral;
    //2.设置代理
    self.peripheral.delegate = self;
    //3.扫描外设中的服务，
    [self.peripheral discoverServices:nil];
}

/**
 *  连接外部设备失败
 *
 *  @param central    <#central description#>
 *  @param peripheral <#peripheral description#>
 *  @param error      <#error description#>
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    self.isSucesse = false;
    if (self.block) {
        self.block(self.isSucesse);
    }
    NSLog(@"%@",error);
}

#pragma mark - CBPeripheralDelegate
/**
 *  发现服务触发
 *
 *  @param uuidstring <#uuidstring description#>
 *
 *  @return <#return value description#>
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error
{
    //获取外设中所有服务器
    NSArray *services = peripheral.services;
    NSLog(@"^^^^^%@-------%ld",services,services.count);
    //遍历外设所有的服务
    for (CBService *service in services)
    {
        //扫描每个服务中的特征,nil代表所有的特征
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error
{
    //获取指定所有特征
    NSArray *characteristics = service.characteristics;
    NSLog(@"^^^^^%@-------%ld",characteristics,characteristics.count);
    //遍历所有的特征
    for (CBCharacteristic *characteristic in characteristics)
    {
        //保存特征
        [self.characteristicsArray addObject:characteristic];
    }
}

/**
 *  didUpdateValueForCharacteristic
 *
 *  @param peripheral     <#peripheral description#>
 *  @param characteristic <#characteristic description#>
 *  @param error          <#error description#>
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    
    NSLog(@"收到外设数据会自动触发");
}

/*!
 *  @method peripheral:didWriteValueForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a {@link writeValue:forCharacteristic:type:} call, when the <code>CBCharacteristicWriteWithResponse</code> type is used.
 */
//发送数据成功会触发
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    if (error)
    {
        NSLog(@"发送失败");
    }
    else
    {
        NSLog(@"成功");
    }
}


@end
