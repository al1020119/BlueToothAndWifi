//
//  ViewController.h
//  BabyBluetoothAppDemo
//
//  Created by 刘彦玮 on 15/8/1.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "PeripheralViewContriller.h"

#import "AsyncSocket.h"

@interface SearchBlueViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

//@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) AsyncSocket    *socket;       // socket
@property (nonatomic, copy) NSString    *wifi;       // socket


@end

