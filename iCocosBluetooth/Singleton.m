//
//  Singleton.m
//  BabyBluetoothAppDemo
//
//  Created by tqy on 16/6/5.
//  Copyright © 2016年 刘彦玮. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

+(Singleton *) sharedInstance
{
    
    static Singleton *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstace = [[self alloc] init];
    });
    
    return sharedInstace;
}

@end
