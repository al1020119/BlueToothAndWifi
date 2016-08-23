//
//  iCocosEnvironmentalController.m
//  iCocosBluetooth
//
//  Created by tqy on 16/6/3.
//  Copyright © 2016年 iCocos. All rights reserved.
//

#import "iCocosEnvironmentalController.h"
#import "iCocosBuildingController.h"
#import "SVProgressHUD.h"

@interface iCocosEnvironmentalController ()


@property (weak, nonatomic) IBOutlet UIButton *enivormentSwitchBtn;

@property (weak, nonatomic) IBOutlet UIButton *roadBtn;

@property (weak, nonatomic) IBOutlet UIButton *shopSquareBtn;
@property (weak, nonatomic) IBOutlet UIButton *MaingongyuanBtn;

@property (weak, nonatomic) IBOutlet UIButton *mainSquareBtn;


@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
@property (weak, nonatomic) IBOutlet UIButton *enviormentBtn;
@property (weak, nonatomic) IBOutlet UIButton *builddingBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;



@end

@implementation iCocosEnvironmentalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"环境设施";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.enviormentBtn.selected = YES;
    
//    if ([self.open isEqualToString:@"1"]) {
//        self.enivormentSwitchBtn.selected = YES;
//        self.roadBtn.selected = YES;
//        self.shopSquareBtn.selected = YES;
//        self.MaingongyuanBtn.selected = YES;
//        self.mainSquareBtn.selected = YES;
//    }
}


/**
 *  环境总开关
 */
- (IBAction)environmentSwitchClicked:(UIButton *)sender {
    
    /**
     *  050101010100000000ff 开
     *  050000000000000000ff 关
     */
    
    if (sender.selected) {
        self.roadBtn.selected = NO;
        self.shopSquareBtn.selected = NO;
        self.MaingongyuanBtn.selected = NO;
        self.mainSquareBtn.selected = NO;
        self.switchBtn.selected = NO;
        
        // Byte数组－> NSData
        Byte byte[] = {0x05,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
    } else {
        self.roadBtn.selected = YES;
        self.shopSquareBtn.selected = YES;
        self.MaingongyuanBtn.selected = YES;
        self.mainSquareBtn.selected = YES;
        // Byte数组－> NSData
        Byte byte[] = {0x05,0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x00,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
    }
    
    sender.selected = !sender.isSelected;
    
    
}


/**
 *  公路
 */
- (IBAction)roadClicked:(UIButton *)sender {
    
    /**
     *  050100000000000000ff 开
     *  050000000000000000ff 开
     */
    
    if (sender.selected) { //公路关
        
        /********/
        
        Byte shangchang;
        if (self.shopSquareBtn.selected) {
            shangchang = 0x01;
        } else {
            shangchang = 0x00;
        }
        
        Byte zhutigongyuan;
        if (self.MaingongyuanBtn.selected) {
            zhutigongyuan = 0x01;
        } else {
            zhutigongyuan = 0x00;
        }
        
        Byte zhutiguangchang;
        if (self.mainSquareBtn.selected) {
            zhutiguangchang = 0x01;
        } else {
            zhutiguangchang = 0x00;
        }
        self.enivormentSwitchBtn.selected = NO;
        self.switchBtn.selected = NO;
        
        
        
        Byte byte[] = {0x05,0x00,shangchang,zhutigongyuan,zhutiguangchang,0x00,0x00,0x00,0x00,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
        
    } else {
        
        Byte shangchang;
        if (self.shopSquareBtn.selected) {
            shangchang = 0x01;
        } else {
            shangchang = 0x00;
        }
        
        Byte zhutigongyuan;
        if (self.MaingongyuanBtn.selected) {
            zhutigongyuan = 0x01;
        } else {
            zhutigongyuan = 0x00;
        }
        
        Byte zhutiguangchang;
        if (self.mainSquareBtn.selected) {
            zhutiguangchang = 0x01;
        } else {
            zhutiguangchang = 0x00;
        }
        
        
        if (shangchang == 0x01 && zhutigongyuan == 0x01 && zhutiguangchang == 0x01) {
            self.enivormentSwitchBtn.selected = YES;
        }
        
        
        Byte byte[] = {0x05,0x01,shangchang,zhutigongyuan,zhutiguangchang,0x00,0x00,0x00,0x00,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
    }
    
    sender.selected = !sender.isSelected;
    
}



/**
 *  商场广场
 */
- (IBAction)shoppingSquareClicked:(UIButton *)sender {
    
    /**
     *  050101000000000000ff 开
     *  050000000000000000ff 开
     */
    if (sender.selected) { //公路关
        
        Byte gonglu;
        if (self.roadBtn.selected) {
            gonglu = 0x01;
        } else {
            gonglu = 0x00;
        }
        
        /********/
        
        Byte zhutigongyuan;
        if (self.MaingongyuanBtn.selected) {
            zhutigongyuan = 0x01;
        } else {
            zhutigongyuan = 0x00;
        }
        
        Byte zhutiguangchang;
        if (self.mainSquareBtn.selected) {
            zhutiguangchang = 0x01;
        } else {
            zhutiguangchang = 0x00;
        }
        
        
        self.enivormentSwitchBtn.selected = NO;
        self.switchBtn.selected = NO;
        
        Byte byte[] = {0x05,gonglu,0x00,zhutigongyuan,zhutiguangchang,0x00,0x00,0x00,0x00,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
        
    } else {
        
        Byte gonglu;
        if (self.roadBtn.selected) {
            gonglu = 0x01;
        } else {
            gonglu = 0x00;
        }
        
        /********/
        
        Byte zhutigongyuan;
        if (self.MaingongyuanBtn.selected) {
            zhutigongyuan = 0x01;
        } else {
            zhutigongyuan = 0x00;
        }
        
        Byte zhutiguangchang;
        if (self.mainSquareBtn.selected) {
            zhutiguangchang = 0x01;
        } else {
            zhutiguangchang = 0x00;
        }
        
        
        if (gonglu == 0x01 && zhutigongyuan == 0x01 && zhutiguangchang == 0x01) {
            self.enivormentSwitchBtn.selected = YES;
        }
        
        
        Byte byte[] = {0x05,gonglu,0x01,zhutigongyuan,zhutiguangchang,0x00,0x00,0x00,0x00,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
    }

    sender.selected = !sender.isSelected;
}



/**
 *  主题公园
 */
- (IBAction)subjectParkClicked:(UIButton *)sender {
    if (sender.selected) { //公路关
        
        Byte gonglu;
        if (self.roadBtn.selected) {
            gonglu = 0x01;
        } else {
            gonglu = 0x00;
        }
        
        Byte shangchang;
        if (self.shopSquareBtn.selected) {
            shangchang = 0x01;
        } else {
            shangchang = 0x00;
        }
        
        /********/
        
        Byte zhutiguangchang;
        if (self.mainSquareBtn.selected) {
            zhutiguangchang = 0x01;
        } else {
            zhutiguangchang = 0x00;
        }
        
        self.enivormentSwitchBtn.selected = NO;
        self.switchBtn.selected = NO;
        
        
        Byte byte[] = {0x05,gonglu,shangchang,0x00,zhutiguangchang,0x00,0x00,0x00,0x00,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
        
    } else {
        
        Byte gonglu;
        if (self.roadBtn.selected) {
            gonglu = 0x01;
        } else {
            gonglu = 0x00;
        }
        
        Byte shangchang;
        if (self.shopSquareBtn.selected) {
            shangchang = 0x01;
        } else {
            shangchang = 0x00;
        }
        
        /********/
        
        Byte zhutiguangchang;
        if (self.mainSquareBtn.selected) {
            zhutiguangchang = 0x01;
        } else {
            zhutiguangchang = 0x00;
        }
        
        
        if (gonglu == 0x01 && shangchang == 0x01 && zhutiguangchang == 0x01) {
            self.enivormentSwitchBtn.selected = YES;
        }
        
        
        Byte byte[] = {0x05,gonglu,shangchang,0x01,zhutiguangchang,0x00,0x00,0x00,0x00,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
    }
    
    sender.selected = !sender.isSelected;
}



/**
 *  主题广场
 */
- (IBAction)subjectSquareClicked:(UIButton *)sender {
    if (sender.selected) { //公路关
        
        
        Byte gonglu;
        if (self.roadBtn.selected) {
            gonglu = 0x01;
        } else {
            gonglu = 0x00;
        }
        
        Byte shangchang;
        if (self.shopSquareBtn.selected) {
            shangchang = 0x01;
        } else {
            shangchang = 0x00;
        }
        
        Byte zhutigongyuan;
        if (self.MaingongyuanBtn.selected) {
            zhutigongyuan = 0x01;
        } else {
            zhutigongyuan = 0x00;
        }
        
        /********/
        self.enivormentSwitchBtn.selected = NO;
        self.switchBtn.selected = NO;
        
        
        Byte byte[] = {0x05,gonglu,shangchang,zhutigongyuan,0x00,0x00,0x00,0x00,0x00,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
        
    } else {
        
        
        Byte gonglu;
        if (self.roadBtn.selected) {
            gonglu = 0x01;
        } else {
            gonglu = 0x00;
        }
        
        Byte shangchang;
        if (self.shopSquareBtn.selected) {
            shangchang = 0x01;
        } else {
            shangchang = 0x00;
        }
        
        Byte zhutigongyuan;
        if (self.MaingongyuanBtn.selected) {
            zhutigongyuan = 0x01;
        } else {
            zhutigongyuan = 0x00;
        }
        
        /********/
        
        
        if (gonglu == 0x01 && shangchang == 0x01 && zhutigongyuan == 0x01) {
            self.enivormentSwitchBtn.selected = YES;
        }
        
        
        Byte byte[] = {0x05,gonglu,shangchang,zhutigongyuan,0x01,0x00,0x00,0x00,0x00,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
    }

    sender.selected = !sender.isSelected;
}




/**
 *  总开关
 */
- (IBAction)switchClicked:(UIButton *)sender {
    
    if (sender.selected) {
        self.enivormentSwitchBtn.selected = NO;
        self.roadBtn.selected = NO;
        self.shopSquareBtn.selected = NO;
        self.MaingongyuanBtn.selected = NO;
        self.mainSquareBtn.selected = NO;
        
        // Byte数组－> NSData
        Byte byte[] = {0x05,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
    } else {
        self.enivormentSwitchBtn.selected = YES;
        self.roadBtn.selected = YES;
        self.shopSquareBtn.selected = YES;
        self.MaingongyuanBtn.selected = YES;
        self.mainSquareBtn.selected = YES;
        // Byte数组－> NSData
        Byte byte[] = {0x05,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
    }
    
    sender.selected = !sender.isSelected;
}



/**
 *  环境
 */
- (IBAction)environmentClicked:(UIButton *)sender {
//    sender.selected = !sender.isSelected;
    [SVProgressHUD showInfoWithStatus:@"请选择"];
}

/**
 *  建筑
 */
- (IBAction)builddingClicked:(UIButton *)sender {

//    sender.selected = !sender.isSelected;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    iCocosBuildingController *vc = [storyboard instantiateViewControllerWithIdentifier:@"buildding"];
    
//    if (sender.selected) {
//        vc.open = @"1";
//    } else {
//        vc.open = @"0";
//    }
    
    vc.characteristic = self.characteristic;
    vc.currPeripheral = self.currPeripheral;
    vc.socket = self.socket;
    vc.wifi = self.wifi;
    
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  返回
 */
- (IBAction)backClicked:(UIButton *)sender {
    
    self.enivormentSwitchBtn.selected = NO;
    self.roadBtn.selected = NO;
    self.shopSquareBtn.selected = NO;
    self.MaingongyuanBtn.selected = NO;
    self.mainSquareBtn.selected = NO;
    self.switchBtn.selected = NO;
    self.enviormentBtn.selected = NO;
    self.builddingBtn.selected = NO;

    // Byte数组－> NSData
    Byte byte[] = {0x05,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xff};
    
    NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    if ([self.wifi isEqualToString:@"1"]) {
        [self.socket writeData:adata withTimeout:1 tag:1];
    } else {
        [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    }
    
    
    if ([self.enviormentBackDelegate respondsToSelector:@selector(clickedbackWithEnviormentToMainViewController)]) {
        [self.enviormentBackDelegate clickedbackWithEnviormentToMainViewController];
    }

    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)dealloc
{
    Byte byte[] = {0x05,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xff};
    
    NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    
    [self.socket writeData:adata withTimeout:1 tag:1];
    [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    Byte byte[] = {0x05,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xff};
    
    NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    
    [self.socket writeData:adata withTimeout:1 tag:1];
    [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    Byte byte[] = {0x05,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xff};
    
    NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    
    [self.socket writeData:adata withTimeout:1 tag:1];
    [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    
}


@end
