//
//  DFUViewController.h
//  iSeed
//
//  Created by Chan Bill on 15/1/26.
//  Copyright (c) 2015年 elias kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFUOperations.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "ScannerDelegate.h"
@interface DFUViewController : UIViewController<DFUOperationsDelegate,ScannerDelegate,CBCentralManagerDelegate>
@property (strong, nonatomic) CBCentralManager *bluetoothManager;
@end
