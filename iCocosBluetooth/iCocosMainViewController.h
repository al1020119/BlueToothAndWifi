//
//  iCocosMainViewController.h
//  BabyBluetoothAppDemo
//
//  Created by tqy on 16/6/5.
//  Copyright © 2016年 刘彦玮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "PeripheralInfo.h"
#import "SVProgressHUD.h"  
#import "PeripheralInfo.h"
//#import "CharacteristicViewController.h"

#import "AsyncSocket.h"

@interface iCocosMainViewController : UIViewController{
@public
    BabyBluetooth *baby;
}

@property __block NSMutableArray *services;
@property(strong,nonatomic)CBPeripheral *currPeripheral;

@property (nonatomic, strong) AsyncSocket    *socket;       // socket
@property (nonatomic, copy) NSString    *wifi;       // socket


@property (nonatomic, copy) NSString    *blue;       // socket

@end
