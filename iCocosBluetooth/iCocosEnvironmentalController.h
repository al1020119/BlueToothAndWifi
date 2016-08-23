//
//  iCocosEnvironmentalController.h
//  iCocosBluetooth
//
//  Created by tqy on 16/6/3.
//  Copyright © 2016年 iCocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "AsyncSocket.h"

@protocol iCocosBackFromEnviormentDelegate <NSObject>

- (void)clickedbackWithEnviormentToMainViewController;

@end


@interface iCocosEnvironmentalController : UIViewController

@property (nonatomic, copy) NSString *open;

@property (nonatomic,strong)CBCharacteristic *characteristic;
@property (nonatomic,strong)CBPeripheral *currPeripheral;


@property (nonatomic, assign) id<iCocosBackFromEnviormentDelegate> enviormentBackDelegate;


@property (nonatomic, strong) AsyncSocket    *socket;       // socket
@property (nonatomic, copy) NSString    *wifi;       // socket

@end
