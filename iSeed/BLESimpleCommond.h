//
//  BLESimpleCommond.h
//  iSeed
//
//  Created by Chan Bill on 15/3/2.
//  Copyright (c) 2015年 elias kang. All rights reserved.
//

#ifndef iSeed_BLESimpleCommond_h
#define iSeed_BLESimpleCommond_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Config.h"
@class BleSimpleCommond;

@protocol BleSimpleCommondDelegate
-(void)SendToDevice:(NSData *)data;
@end


@interface BleSimpleCommond : NSObject
@property id<BleSimpleCommondDelegate> delegate;
typedef enum
{
    RTHistory = 1,
    StepHistory = 2
}HistoyType;

typedef enum
{
    Bigan = 1,
    Read = 2,
    Check = 3
}section;


typedef enum
{
    BleCmGetBattay = 1,
    BleCmBiganDFU = 2,
    BleCmSetUserID = 3,
    BleCmRemoveUserID = 4,
    BleCmGetDeviceVersion = 5,
    
    BleCmGetDeviceTime = 6,
    BleCmSetDeviceTime = 7,
    
    BleCmGetXYZAcceleration = 8,
    BleCmGetStepNum = 9,
    BleCmGetRTData = 10,
    BleCmGetSaveDataSpeed = 11,
    BleCmGetAllData = 12,
    BleCmGetRtHistoryLength = 13,
    BleCmGetRtHistoryCheck = 14,
    BleCmGetStepHistoryLength = 15,
    BleCmGetStepHistoryCheck = 16,
    BleCmGetShankeMode = 17
}COMMOND;

@property(nonatomic,strong)NSMutableData *bufferDataFortwo;
@property(nonatomic,strong)NSMutableData *bufferDataFor;
@property (assign,nonatomic) int rtfilepackageint;
@property (assign,nonatomic) int stepsfilepackageint;

-(void)GetHistoryData:(HistoyType)type Section:(section)setion Buff:(unsigned char *)buff;
-(void)clearalldata;
-(NSData *)SimpleCommond:(COMMOND)commond;


@end
#endif
