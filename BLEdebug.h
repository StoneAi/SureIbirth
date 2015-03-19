//
//  BLEdebug.h
//  BLEdebug
//
//  Created by Chan Bill on 14/11/13.
//  Copyright (c) 2014年 Vipose. All rights reserved.
//
#import <CoreBluetooth/CoreBluetooth.h>
#import "Config.h"
#import <Foundation/Foundation.h>
#import "HistoryViewController.h"
#import "BLESimpleCommond.h"
@protocol BLEdebugDelegate
-(void) didread:(int)label1 label2:(long)label2 label3:(int)label3 states:(int)sta;
-(void)threadrun;

@end
@interface BLEdebug : NSObject <CBPeripheralDelegate,BleSimpleCommondDelegate>
@property CBPeripheral *peripheral;
//@property F *firstview;
@property id<BLEdebugDelegate> delegate;
+(CBUUID *) uartServiceUUID;
+(CBUUID *) txCharacteristicUUID;
+(CBUUID *) deviceBattyServiceUUID;
@property (assign,nonatomic) int pages;
@property (assign,nonatomic) int alllength;

@property (assign,nonatomic) int rtfilepackageint;
@property (assign,nonatomic) int pagessteps;
@property (assign,nonatomic) int alllengthsteps;

@property (assign,nonatomic) int stepsfilepackageint;

- (BLEdebug *) initwithPeripheral:(CBPeripheral*)peripheral delegate:(id<BLEdebugDelegate>) delegate;
-(void) writeRtValue;
-(void) didconnect;
-(void) diddisconnect;
-(void)WarmingON;
-(void)WarmingOFF;
-(void) clearndata;
-(int)readBattry;
-(void)readShankState;
//-(void) HexToDec;
@end



