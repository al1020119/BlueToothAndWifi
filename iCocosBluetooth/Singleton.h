//
//  Singleton.h
//  BabyBluetoothAppDemo
//
//  Created by tqy on 16/6/5.
//  Copyright © 2016年 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
// Singleton.h
#import "AsyncSocket.h"

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t onceToken = 0; \
__strong static id sharedInstance = nil; \
dispatch_once(&onceToken, ^{ \
sharedInstance = block(); \
}); \
return sharedInstance; \

@interface Singleton : NSObject

+ (Singleton *)sharedInstance;

@end