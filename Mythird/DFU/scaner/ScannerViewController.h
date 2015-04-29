//
//  ScannerViewController.h
//  nRF Toolbox
//
//  Created by Aleksander Nowakowski on 16/12/13.
//  Copyright (c) 2013 Nordic Semiconductor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#include "ScannerDelegate.h"

@interface ScannerViewController : UIView < UITableViewDelegate, UITableViewDataSource>
- (id)init:(NSMutableArray *)periphera;
-(void)setPeripherals:(NSMutableArray *)myperipherals;
@property (strong, nonatomic) id <ScannerDelegate> delegate;
@property (strong, nonatomic) CBUUID *filterUUID;
@property (strong, nonatomic) NSMutableArray *peripherals;
/*!
 * Cancel button has been clicked
 */
- (IBAction)didCancelClicked:(id)sender;

@end
