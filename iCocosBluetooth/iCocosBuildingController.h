//
//  iCocosBuildingController.h
//  iCocosBluetooth
//
//  Created by tqy on 16/6/3.
//  Copyright © 2016年 iCocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "AsyncSocket.h"


@protocol iCocosBackFromBuilddingDelegate <NSObject>

- (void)clickedbackWithBuilddingToMainViewController;

@end

@interface iCocosBuildingController : UIViewController

@property (nonatomic, copy) NSString *open;

@property (nonatomic,strong)CBCharacteristic *characteristic;
@property (nonatomic,strong)CBPeripheral *currPeripheral;

@property (nonatomic, assign) id<iCocosBackFromBuilddingDelegate> builddingBackDelegate;


@property (nonatomic, strong) AsyncSocket    *socket;       // socket
@property (nonatomic, copy) NSString    *wifi;       // socket

@end
