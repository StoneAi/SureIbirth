//
//  BleImplements.h
//  nordicBLEdemo
//
//  Created by Chan Bill on 15/3/18.
//  Copyright (c) 2015年 Vipose. All rights reserved.
//
#import <CoreBluetooth/CoreBluetooth.h>
#import <Foundation/Foundation.h>
@protocol BleImplementsDelegate


-(void)ReadRtValue:(NSString *)Value;
-(void)ReadStepValue:(NSString *)Value;
-(void)ReadHistory:(NSMutableData *)RtData Steps:(NSMutableData *)StepsData;


@end

@interface BleImplements : NSObject<CBPeripheralDelegate>
@property id<BleImplementsDelegate> delegate;

+(CBUUID *) uartServiceUUID;
+(CBUUID *) txCharacteristicUUID;
@property CBPeripheral *peripheral;
-(BleImplements *)initwithPeripheral:(CBPeripheral*)peripheral delegate:(id<BleImplementsDelegate>) delegate;

-(void)WtFirmware;
-(void)writeRtValue;
-(void)GetHistory;
-(void)SetDuf;
-(void)Warming:(BOOL)IsOn;
-(void)WTBattay;
-(void)clearalldata;
-(void) didconnect;
-(void) diddisconnect;
@end
