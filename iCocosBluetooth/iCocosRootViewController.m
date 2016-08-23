//
//  iCocosRootViewController.m
//  BabyBluetoothAppDemo
//
//  Created by tqy on 16/6/5.
//  Copyright © 2016年 刘彦玮. All rights reserved.
//

#import "iCocosRootViewController.h"
#import "SearchBlueViewController.h"

#import "iCocosBuildingController.h"
#import "iCocosEnvironmentalController.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

#import "AsyncSocket.h"


@interface iCocosRootViewController ()<AsyncSocketDelegate, iCocosBackFromBuilddingDelegate, iCocosBackFromEnviormentDelegate>

@property (nonatomic, strong) AsyncSocket    *socket;       // socket
@property (nonatomic, copy  ) NSString       *socketHost;   // socket的Host
@property (nonatomic, assign) UInt16         socketPort;    // socket的prot
@property (nonatomic, retain) NSTimer        *connectTimer; // 计时器


@property (nonatomic, copy) NSString *wifi;



@property (weak, nonatomic) IBOutlet UIButton *swithBtn;

@property (weak, nonatomic) IBOutlet UIButton *enviormentBtn;

@property (weak, nonatomic) IBOutlet UIButton *builddingBtn;

@property (weak, nonatomic) IBOutlet UIButton *exitBtn;

@property (weak, nonatomic) IBOutlet UIButton *wifibtn;




@end

@implementation iCocosRootViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"链接" style:UIBarButtonItemStylePlain target:self action:@selector(Connect)];
    
    self.title = @"智能多媒体沙盘控制系统";
    
    self.wifibtn.hidden = YES;
    
    [self socketConnectHost];
}

- (void)Connect
{
    SearchBlueViewController *search = [[SearchBlueViewController alloc] init];
    search.socket = self.socket;
    search.wifi = self.wifi;
    [self.navigationController pushViewController:search animated:YES];
//    [self presentViewController:search animated:YES completion:nil];
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
    if ([self.wifi isEqualToString:@"1"]) {
        
        if (sender.selected) {
            self.enviormentBtn.selected = NO;
            self.builddingBtn.selected = NO;
            
            
            Byte byte[] = {0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff};
            NSData   *dataStream  = [NSData dataWithBytes:&byte length:sizeof(byte)];
            [self.socket writeData:dataStream withTimeout:1 tag:1];
        } else {
            
            self.enviormentBtn.selected = YES;
            self.builddingBtn.selected = YES;
            
            Byte byte[] = {0x05, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0xff};
            NSData   *dataStream  = [NSData dataWithBytes:&byte length:sizeof(byte)];
            [self.socket writeData:dataStream withTimeout:1 tag:1];
        }
        
        sender.selected = !sender.isSelected;
    } else {
        [SVProgressHUD showInfoWithStatus:@"请先链接设备"];
    }
    
    
}


/**
 *  环境
 */
- (IBAction)enviromentClicked:(UIButton *)sender {
    if ([self.wifi isEqualToString:@"1"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        iCocosEnvironmentalController *vc = [storyboard instantiateViewControllerWithIdentifier:@"enviroment"];
        vc.socket = self.socket;
        vc.wifi = self.wifi;
        
//        if (sender.selected) {
//            vc.open = @"1";
//        } else {
//            vc.open = @"0";
//        }
    
        
        vc.enviormentBackDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [SVProgressHUD showInfoWithStatus:@"请先链接蓝牙或者Wifi"];
    }
}


/**
 *  建筑
 */
- (IBAction)builddingClicked:(UIButton *)sender {
    if ([self.wifi isEqualToString:@"1"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        iCocosBuildingController *vc = [storyboard instantiateViewControllerWithIdentifier:@"buildding"];
        vc.socket = self.socket;
        vc.wifi = self.wifi;
        
//        if (sender.selected) {
//            vc.open = @"1";
//        } else {
//            vc.open = @"0";
//        }
        
        
        vc.builddingBackDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [SVProgressHUD showInfoWithStatus:@"请先链接蓝牙或者Wifi"];
    }
    
    
}

/**
 *  退出
 */
- (IBAction)exitClicked:(id)sender {
    [SVProgressHUD showInfoWithStatus:@"退出成功"];
    
    NSLog(@"\n\n%s==========退出======", __func__);
    
    if ([self.wifi isEqualToString:@"1"]) {
        
        self.enviormentBtn.selected = NO;
        self.builddingBtn.selected = NO;
        self.swithBtn.selected = NO;
        
        Byte byte[] = {0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff};
        NSData   *dataStream  = [NSData dataWithBytes:&byte length:sizeof(byte)];
        [self.socket writeData:dataStream withTimeout:1 tag:1];
    }
}

// socket连接
-(void)socketConnectHost{
    self.socket    = [[AsyncSocket alloc] initWithDelegate:self];
    NSError *error = nil;
    [self.socket connectToHost:@"192.168.4.1" onPort:5000 withTimeout:3 error:&error];
    
}

/**
 *  Wifi链接
 */
#pragma mark  - 连接成功回调
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString     *)host port:(UInt16)port
{
    NSLog(@"socket连接成功");
    
    [SVProgressHUD showSuccessWithStatus:@"Wifi链接成功,欢迎使用"];
    
    self.wifibtn.hidden = NO;
    
    self.wifi = @"1";
}


- (void)clickedbackWithEnviormentToMainViewController
{
    self.builddingBtn.selected = NO;
    self.enviormentBtn.selected = NO;
    self.swithBtn.selected = NO;
    
    Byte byte[] = {0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff};
    NSData   *dataStream  = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [self.socket writeData:dataStream withTimeout:1 tag:1];
}

- (void)clickedbackWithBuilddingToMainViewController
{
    self.builddingBtn.selected = NO;
    self.enviormentBtn.selected = NO;
    self.swithBtn.selected = NO;
    
    Byte byte[] = {0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff};
    NSData   *dataStream  = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [self.socket writeData:dataStream withTimeout:1 tag:1];
}

- (void)dealloc
{
    
    Byte byte[] = {0x05,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xff};
    
    NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    
    [self.socket writeData:adata withTimeout:1 tag:1]; 
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
    //读取服务
    //    baby.channel(channelOnCharacteristicView).characteristicDetails(self.currPeripheral,self.characteristic);
    
    self.builddingBtn.selected = NO;
    self.enviormentBtn.selected = NO;
    self.swithBtn.selected = NO;
    
}



@end
