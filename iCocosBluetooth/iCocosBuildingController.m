//
//  iCocosBuildingController.m
//  iCocosBluetooth
//
//  Created by tqy on 16/6/3.
//  Copyright © 2016年 iCocos. All rights reserved.
//

#import "iCocosBuildingController.h"
#import "iCocosEnvironmentalController.h"

@interface iCocosBuildingController ()

@property (weak, nonatomic) IBOutlet UIButton *builddingBtn;

@property (weak, nonatomic) IBOutlet UIButton *shangyeBtn;

@property (weak, nonatomic) IBOutlet UIButton *jiudianBtn;

@property (weak, nonatomic) IBOutlet UIButton *gongyuBtn;

@property (weak, nonatomic) IBOutlet UIButton *denglangBtn;


@property (weak, nonatomic) IBOutlet UIButton *SwitchOpenBtn;



@property (weak, nonatomic) IBOutlet UIButton *enviorment;

@property (weak, nonatomic) IBOutlet UIButton *buildding;

@property (weak, nonatomic) IBOutlet UIButton *back;


@end

@implementation iCocosBuildingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"建筑设施";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.buildding.selected = YES;
    
//    if ([self.open isEqualToString:@"1"]) {
//        self.builddingBtn.selected = YES;
//        self.shangyeBtn.selected = YES;
//        self.jiudianBtn.selected = YES;
//        self.gongyuBtn.selected = YES;
//        self.denglangBtn.selected = YES;
//    }
    
    self.buildding.selected = NO;
}

/**
 *  建筑总开关
 */
- (IBAction)builddingSwitchClicked:(UIButton *)sender {
    
    if (sender.selected) { //关
        
        self.builddingBtn.selected = NO;
        self.shangyeBtn.selected = NO;
        self.jiudianBtn.selected = NO;
        self.gongyuBtn.selected = NO;
        self.denglangBtn.selected = NO;
        
        sender.selected = NO;
        self.SwitchOpenBtn.selected = NO;
        
        // Byte数组－> NSData
        Byte byte[] = {0x05,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
    } else {
 
        self.builddingBtn.selected = YES;
        self.shangyeBtn.selected = YES;
        self.jiudianBtn.selected = YES;
        self.gongyuBtn.selected = YES;
        self.denglangBtn.selected = YES;
        
        sender.selected = YES;
        
        // Byte数组－> NSData
        // Byte数组－> NSData
        Byte byte[] = {0x05,0x00,0x00,0x00,0x00,0x01,0x01,0x01,0x01,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
    }
    
    
//    sender.selected = !sender.isSelected;
}


/**
 *  商业
 */
- (IBAction)commerceClicked:(UIButton *)sender {
    if (sender.selected) { //公路关
        
        Byte jiudian;
        if (self.jiudianBtn.selected) {
            jiudian = 0x01;
        } else {
            jiudian = 0x00;
        }
        
        Byte gongyu;
        if (self.gongyuBtn.selected) {
            gongyu = 0x01;
        } else {
            gongyu = 0x00;
        }
        
        Byte denglang;
        if (self.denglangBtn.selected) {
            denglang = 0x01;
        } else {
            denglang = 0x00;
        }
        
        /********/
        self.builddingBtn.selected = NO;
        self.SwitchOpenBtn.selected = NO;
        
        
        Byte byte[] = {0x05,0x00,0x00,0x00,0x00,0x00,jiudian,gongyu,denglang,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
        
    } else {
        
        
        Byte jiudian;
        if (self.jiudianBtn.selected) {
            jiudian = 0x01;
        } else {
            jiudian = 0x00;
        }
        
        Byte gongyu;
        if (self.gongyuBtn.selected) {
            gongyu = 0x01;
        } else {
            gongyu = 0x00;
        }
        
        Byte denglang;
        if (self.denglangBtn.selected) {
            denglang = 0x01;
        } else {
            denglang = 0x00;
        }
        
        /********/
        
        if (jiudian == 0x01 && gongyu == 0x01 && denglang == 0x01) {
            self.builddingBtn.selected = YES;
        }
        
        
        Byte byte[] = {0x05,0x00,0x00,0x00,0x00,0x01,jiudian,gongyu,denglang,0xff};
        
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
 *  酒店
 */
- (IBAction)hotelClicked:(UIButton *)sender {
    if (sender.selected) { //公路关
        
        Byte shangye;
        if (self.shangyeBtn.selected) {
            shangye = 0x01;
        } else {
            shangye = 0x00;
        }
        
        Byte gongyu;
        if (self.gongyuBtn.selected) {
            gongyu = 0x01;
        } else {
            gongyu = 0x00;
        }
        
        Byte denglang;
        if (self.denglangBtn.selected) {
            denglang = 0x01;
        } else {
            denglang = 0x00;
        }
        
        /********/
        self.builddingBtn.selected = NO;
        self.SwitchOpenBtn.selected = NO;
        
        
        Byte byte[] = {0x05,0x00,0x00,0x00,0x00,shangye,0x00,gongyu,denglang,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
        
    } else {
        
        Byte shangye;
        if (self.shangyeBtn.selected) {
            shangye = 0x01;
        } else {
            shangye = 0x00;
        }
        
        Byte gongyu;
        if (self.gongyuBtn.selected) {
            gongyu = 0x01;
        } else {
            gongyu = 0x00;
        }
        
        Byte denglang;
        if (self.denglangBtn.selected) {
            denglang = 0x01;
        } else {
            denglang = 0x00;
        }
        
        /********/
        
        /********/
        
        if (shangye == 0x01 && gongyu == 0x01 && denglang == 0x01) {
            self.builddingBtn.selected = YES;
        }
        
        
        
        Byte byte[] = {0x05,0x00,0x00,0x00,0x00,shangye,0x01,gongyu,denglang,0xff};
        
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
 *  公寓
 */
- (IBAction)apartmentClicked:(UIButton *)sender {
    if (sender.selected) { //公路关
        
        Byte shangye;
        if (self.shangyeBtn.selected) {
            shangye = 0x01;
        } else {
            shangye = 0x00;
        }
        
        Byte jiudian;
        if (self.jiudianBtn.selected) {
            jiudian = 0x01;
        } else {
            jiudian = 0x00;
        }
        
        Byte denglang;
        if (self.denglangBtn.selected) {
            denglang = 0x01;
        } else {
            denglang = 0x00;
        }
        
        /********/
        self.builddingBtn.selected = NO;
        self.SwitchOpenBtn.selected = NO;
        
        
        Byte byte[] = {0x05,0x00,0x00,0x00,0x00,shangye,jiudian,0x00,denglang,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
        
    } else {
        
        Byte shangye;
        if (self.shangyeBtn.selected) {
            shangye = 0x01;
        } else {
            shangye = 0x00;
        }
        
        Byte jiudian;
        if (self.jiudianBtn.selected) {
            jiudian = 0x01;
        } else {
            jiudian = 0x00;
        }
        
        Byte denglang;
        if (self.denglangBtn.selected) {
            denglang = 0x01;
        } else {
            denglang = 0x00;
        }
        
        /********/
        
        /********/
        
        if (jiudian == 0x01 && jiudian == 0x01 && denglang == 0x01) {
            self.builddingBtn.selected = YES;
        }
        
        
        
        Byte byte[] = {0x05,0x00,0x00,0x00,0x00,shangye,jiudian,0x01,denglang,0xff};
        
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
 *  廊灯
 */
- (IBAction)corridorLampClicked:(UIButton *)sender {
    if (sender.selected) { //公路关
        
        Byte shangye;
        if (self.shangyeBtn.selected) {
            shangye = 0x01;
        } else {
            shangye = 0x00;
        }
        
        Byte jiudian;
        if (self.jiudianBtn.selected) {
            jiudian = 0x01;
        } else {
            jiudian = 0x00;
        }
        
        Byte gongyu;
        if (self.gongyuBtn.selected) {
            gongyu = 0x01;
        } else {
            gongyu = 0x00;
        }
        
        /********/
        self.builddingBtn.selected = NO;
        self.SwitchOpenBtn.selected = NO;
        
        
        Byte byte[] = {0x05,0x00,0x00,0x00,0x00,shangye,jiudian,gongyu,0x00,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
        
    } else {
        
        Byte shangye;
        if (self.shangyeBtn.selected) {
            shangye = 0x01;
        } else {
            shangye = 0x00;
        }
        
        Byte jiudian;
        if (self.jiudianBtn.selected) {
            jiudian = 0x01;
        } else {
            jiudian = 0x00;
        }
        
        Byte gongyu;
        if (self.gongyuBtn.selected) {
            gongyu = 0x01;
        } else {
            gongyu = 0x00;
        }
        
        /********/
        
        /********/
        
        if (jiudian == 0x01 && gongyu == 0x01 && gongyu == 0x01) {
            self.builddingBtn.selected = YES;
        }
        
        
        
        Byte byte[] = {0x05,0x00,0x00,0x00,0x00,shangye,jiudian,gongyu,0x01,0xff};
        
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
        self.builddingBtn.selected = NO;
        self.shangyeBtn.selected = NO;
        self.jiudianBtn.selected = NO;
        self.gongyuBtn.selected = NO;
        self.denglangBtn.selected = NO;
        
        // Byte数组－> NSData
        Byte byte[] = {0x05,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xff};
        
        NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        if ([self.wifi isEqualToString:@"1"]) {
            [self.socket writeData:adata withTimeout:1 tag:1];
        } else {
            [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
    } else {
        self.builddingBtn.selected = YES;
        self.shangyeBtn.selected = YES;
        self.jiudianBtn.selected = YES;
        self.gongyuBtn.selected = YES;
        self.denglangBtn.selected = YES;
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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    iCocosEnvironmentalController *vc = [storyboard instantiateViewControllerWithIdentifier:@"enviroment"];
    
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
 *  建筑：这里不需要点击
 */
- (IBAction)builddingClicked:(UIButton *)sender {
//    sender.selected = !sender.isSelected;
}



/**
 *  返回:返回到主控制器
 */
- (IBAction)backClicked:(UIButton *)sender {
    
    self.builddingBtn.selected = NO;
    self.shangyeBtn.selected = NO;
    self.jiudianBtn.selected = NO;
    self.gongyuBtn.selected = NO;
    self.denglangBtn.selected = NO;
    self.SwitchOpenBtn.selected = NO;
    self.enviorment.selected = NO;
    self.builddingBtn.selected = NO;
    
    Byte byte[] = {0x05,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xff};
    
    NSData *adata = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    if ([self.wifi isEqualToString:@"1"]) {
        [self.socket writeData:adata withTimeout:1 tag:1];
    } else {
        [self.currPeripheral writeValue:adata forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    }
    
    if ([self.builddingBackDelegate respondsToSelector:@selector(clickedbackWithBuilddingToMainViewController)]) {
        [self.builddingBackDelegate clickedbackWithBuilddingToMainViewController];
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
