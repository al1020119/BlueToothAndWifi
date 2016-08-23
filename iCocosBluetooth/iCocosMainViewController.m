//
//  iCocosMainViewController.m
//  BabyBluetoothAppDemo
//
//  Created by tqy on 16/6/5.
//  Copyright © 2016年 刘彦玮. All rights reserved.
//
#import "iCocosMainViewController.h"
#define width [UIScreen mainScreen].bounds.size.width
#define height [UIScreen mainScreen].bounds.size.height
#define isIOS7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define navHeight ( isIOS7 ? 64 : 44)  //导航栏高度
#define channelOnCharacteristicView @"CharacteristicView"
#define channelOnPeropheralView @"peripheralView"

#import "iCocosEnvironmentalController.h"
#import "iCocosBuildingController.h"

#import "DejalActivityView.h"




@interface iCocosMainViewController ()<iCocosBackFromBuilddingDelegate, iCocosBackFromEnviormentDelegate>


@property (nonatomic,strong)CBCharacteristic *characteristic;

@property (weak, nonatomic) IBOutlet UIButton *switchOpen;

@property (weak, nonatomic) IBOutlet UIButton *enviormentBtn;

@property (weak, nonatomic) IBOutlet UIButton *builddingBtn;

@property (weak, nonatomic) IBOutlet UIButton *exitBtn;

@property (weak, nonatomic) IBOutlet UIButton *blueBtn;

@property (weak, nonatomic) IBOutlet UIButton *wifiBtn;

@end

@implementation iCocosMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    **********************************************
//    // 建立一个Socket实体并连接到本地服务器的7777端口
//    _client = [[AsyncSocket alloc] initWithDelegate:self];
//    NSError *err = nil;
//    if (![_client connectToHost:@"127.0.0.1" onPort:7777 withTimeout:1.0f error:&err]) {
//        NSLog(@"client net:%@", err);
//    }
    
    if ([self.wifi isEqualToString:@"1"]) {
        self.wifiBtn.hidden = NO;
    } else {
        self.wifiBtn.hidden = YES;
    }
    
    
    self.title = @"智能多媒体沙盘控制系统";
    
    //初始化
    self.services = [[NSMutableArray alloc]init];
    [self babyDelegate];

    //开始扫描设备
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
//    [SVProgressHUD showInfoWithStatus:@"准备连接设备"];
    [SVProgressHUD showInfoWithStatus:@"准备连接设备" maskType:SVProgressHUDMaskTypeBlack];
    //    //导航右侧菜单
        UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [navRightBtn setFrame:CGRectMake(0, 0, 30, 30)];
        [navRightBtn setTitle:@"😸" forState:UIControlStateNormal];
        [navRightBtn.titleLabel setTextColor:[UIColor blackColor]];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navRightBtn];
        [navRightBtn addTarget:self action:@selector(navRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //读取服务
    baby.channel(channelOnCharacteristicView).characteristicDetails(self.currPeripheral,self.characteristic);
}


//退出时断开连接
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
}

- (void)navRightBtnClick
{
    [SVProgressHUD showSuccessWithStatus:@"已经链接成功"];
}

//babyDelegate
-(void)babyDelegate{
    
    __weak typeof(self)weakSelf = self;
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
    
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]];
        
        [DejalActivityView removeView];
    }];
    
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接失败",peripheral.name]];
    }];
    
    //设置设备断开连接的委托
    [baby setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--断开失败",peripheral.name]];
    }];
    
//    设置发现设备的Services的委托
        [baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
            for (CBService *s in peripheral.services) {
                ///插入section到tableview
                [weakSelf insertSectionToTableView:s];
            }
    
            [rhythm beats];
        }];
        //设置发现设service的Characteristics的委托
        [baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
            NSLog(@"===service name:%@",service.UUID);
            //插入row到tableview
            [weakSelf insertRowToTableView:service];
    
        }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //读取rssi的委托
    [baby setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
        NSLog(@"setBlockOnDidReadRSSI:RSSI:%@",RSSI);
    }];
    
    
    //设置beats break委托
    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsBreak call");
        
        //如果完成任务，即可停止beat,返回bry可以省去使用weak rhythm的麻烦
        //        if (<#condition#>) {
        //            [bry beatsOver];
        //        }
        
    }];
    
    //设置beats over委托
    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsOver call");
    }];
    
//    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
//    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
//    /*连接选项->
//     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
//     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
//     CBConnectPeripheralOptionNotifyOnNotificationKey:
//     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
//     */
//    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
//                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
//                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    
    
    //设置写数据成功的block
    [baby setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"setBlockOnDidWriteValueForCharacteristicAtChannel characteristic:%@ and new value:%@",characteristic.UUID, characteristic.value);
    }];
    
    //设置通知状态改变的block
    [baby setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"uid:%@,isNotifying:%@",characteristic.UUID,characteristic.isNotifying?@"on":@"off");
    }];
    
    
    
    //设置写数据成功的block
    [baby setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"setBlockOnDidWriteValueForCharacteristicAtChannel characteristic:%@ and new value:%@",characteristic.UUID, characteristic.value);
    }];
    
}

-(void)loadData{
    [SVProgressHUD showInfoWithStatus:@"开始连接设备"];
    baby.having(self.currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    //    baby.connectToPeripheral(self.currPeripheral).begin();
}
//mark -插入table数据
-(void)insertSectionToTableView:(CBService *)service{
    NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
    PeripheralInfo *info = [[PeripheralInfo alloc]init];
    [info setServiceUUID:service.UUID];
    [self.services addObject:info];
//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:self.services.count-1];
//    [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)insertRowToTableView:(CBService *)service{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    int sect = -1;
    for (int i=0;i<self.services.count;i++) {
        PeripheralInfo *info = [self.services objectAtIndex:i];
        if (info.serviceUUID == service.UUID) {
            sect = i;
        }
    }
    if (sect != -1) {
        PeripheralInfo *info =[self.services objectAtIndex:sect];
        for (int row=0;row<service.characteristics.count;row++) {
            CBCharacteristic *c = service.characteristics[row];
            [info.characteristics addObject:c];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:sect];
            [indexPaths addObject:indexPath];
            NSLog(@"add indexpath in row:%d, sect:%d",row,sect);
        }
        PeripheralInfo *curInfo =[self.services objectAtIndex:sect];
        NSLog(@"%@",curInfo.characteristics);
//        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//  按钮点击
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/**
 *  总开关
 */
- (IBAction)switchClicked:(UIButton *)sender {
    /**
     *  050101010101010101ff 开
     *  050000000000000000ff 关
     */
    
    CBCharacteristic *characteristic = [[[self.services lastObject] characteristics] objectAtIndex:0];

    
    if (sender.selected) { //已经被选中了，取消选中,关
        self.switchOpen.selected = NO;
        self.enviormentBtn.selected = NO;
        self.builddingBtn.selected = NO;
        
        // Byte数组－> NSData
        Byte byte[] = {0x05,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        }
        
    } else { //开
        self.switchOpen.selected = YES;
        self.enviormentBtn.selected = YES;
        self.builddingBtn.selected = YES;
        
        // Byte数组－> NSData
        Byte byte[] = {0x05,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0xff};
         
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        }
        
    }
}


/**
 *  环境
 */
- (IBAction)enviromentClicked:(UIButton *)sender {
    
    NSLog(@"\n\n%s==========环境======", __func__);
//    [SVProgressHUD showInfoWithStatus:@"请先链接设备"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    iCocosEnvironmentalController *vc = [storyboard instantiateViewControllerWithIdentifier:@"enviroment"];
    
    vc.enviormentBackDelegate = self;
    
//    if (sender.selected) {
//        vc.open = @"1";
//    } else {
//        vc.open = @"0";
//    }
    
    CBCharacteristic *characteristic = [[[self.services lastObject] characteristics] objectAtIndex:0];
    
    vc.characteristic = characteristic;
    vc.currPeripheral = self.currPeripheral;
    
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 *  建筑
 */
- (IBAction)builddingClicked:(UIButton *)sender {
//    [SVProgressHUD showInfoWithStatus:@"请先链接设备"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    iCocosBuildingController *vc = [storyboard instantiateViewControllerWithIdentifier:@"buildding"];
    
    vc.builddingBackDelegate = self;
    
//    if (sender.selected) {
//        vc.open = @"1";
//    } else {
//        vc.open = @"0";
//    }
    
    CBCharacteristic *characteristic = [[[self.services lastObject] characteristics] objectAtIndex:0];
    
    vc.characteristic = characteristic;
    vc.currPeripheral = self.currPeripheral;
    
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  退出
 */
- (IBAction)exitClicked:(UIButton *)sender {
    [SVProgressHUD showInfoWithStatus:@"退出成功"];
    
    self.switchOpen.selected = NO;
    self.enviormentBtn.selected = NO;
    self.builddingBtn.selected = NO;
    
    CBCharacteristic *characteristic = [[[self.services lastObject] characteristics] objectAtIndex:0];

    // Byte数组－> NSData
    Byte byte[] = {0x05,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xff};
    
    NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    
    if ([self.wifi isEqualToString:@"1"]) {
        [self.socket writeData:adata withTimeout:1 tag:1];
    } else {
        
        [self.currPeripheral writeValue:adata forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
    
}

- (void)clickedbackWithEnviormentToMainViewController
{
    self.enviormentBtn.selected = NO;
    self.builddingBtn.selected = NO;
    self.switchOpen.selected = NO;
    
    // Byte数组－> NSData
    Byte byte[] = {0x05,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xff};
    
    CBCharacteristic *characteristic = [[[self.services lastObject] characteristics] objectAtIndex:0];

    
    NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    if ([self.wifi isEqualToString:@"1"]) {
        [self.socket writeData:adata withTimeout:1 tag:1];
    } else {
        [self.currPeripheral writeValue:adata forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)clickedbackWithBuilddingToMainViewController
{
    self.builddingBtn.selected = NO;
    self.enviormentBtn.selected = NO;
    self.switchOpen.selected = NO;
    
    CBCharacteristic *characteristic = [[[self.services lastObject] characteristics] objectAtIndex:0];

    
    // Byte数组－> NSData
    Byte byte[] = {0x05,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xff};
    
    NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    
    if ([self.wifi isEqualToString:@"1"]) {
        [self.socket writeData:adata withTimeout:1 tag:1];
    } else {
        [self.currPeripheral writeValue:adata forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //读取服务
    //    baby.channel(channelOnCharacteristicView).characteristicDetails(self.currPeripheral,self.characteristic);
    
    self.builddingBtn.selected = NO;
    self.enviormentBtn.selected = NO;
    self.switchOpen.selected = NO;
    
}



- (void)dealloc
{
    
    Byte byte[] = {0x05,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xff};
    
    NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    
    [self.socket writeData:adata withTimeout:1 tag:1];
    [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    
}



@end
