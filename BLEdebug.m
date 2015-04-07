//
//  BLEdebug.m
//  BLEdebug
//
//  Created by Chan Bill on 14/11/13.
//  Copyright (c) 2014年 Vipose. All rights reserved.
//


#import "BLEdebug.h"
#import "AppDelegate.h"
@interface BLEdebug()
@property CBService *uartService;
@property CBCharacteristic *rxCharacteristic;
@property CBCharacteristic *txCharacteristic;
@property CBCharacteristic *battyCharacteristic;
@property CBCharacteristic *firmwareCharacteristic;
@end

@implementation BLEdebug
{
    HistoryViewController *historyVC;
    NSUserDefaults *userDefaults;
    
    NSString *rthistoryPath;
    NSMutableData *bufferDataFortwo;
    NSString *stepshistoryPath;
    
    NSMutableData *bufferDataFor;
    NSString *makeConfig;
    NSString *version;
    NSString *  locationString;
    NSFileHandle *fh;
    NSFileHandle *fhand;
    NSString *NAMEFORUSER;
    int bat;
    int16_t  pctime;
    int16_t pctimesteps;
    BleSimpleCommond *Commond;
    
}
@synthesize peripheral = _peripheral;
@synthesize delegate = _delegate;
@synthesize uartService = _uartService;
@synthesize rxCharacteristic = _rxCharacteristic;
@synthesize txCharacteristic = _txCharacteristic;
@synthesize battyCharacteristic = _battyCharacteristic;
@synthesize pages;
@synthesize rtfilepackageint;
@synthesize firmwareCharacteristic = _firmwareCharacteristic;

@synthesize pagessteps;
@synthesize stepsfilepackageint;

static int readtimes;
static int RTtime = 1;
static int SPtime = 1;
static int readtimessteps;

int stepsfilepackageint = 0;

static  int choices = 0;


dispatch_queue_t serialqueue;
+(CBUUID *) uartServiceUUID
{
    return [CBUUID UUIDWithString:@"6e40fff0-b5a3-f393-e0a9-e50e24dcca9e"];
    
}
+(CBUUID *) txCharacteristicUUID
{
    
    return [CBUUID UUIDWithString:@"6e40fff1-b5a3-f393-e0a9-e50e24dcca9e"];
}
+(CBUUID *) rxCharacteristicUUID
{
    
    return [CBUUID UUIDWithString:@"6e40fff2-b5a3-f393-e0a9-e50e24dcca9e"];
}
+(CBUUID *) deviceInformationServiceUUID
{
    return [CBUUID UUIDWithString:@"180A"];
    
}
+(CBUUID *) hardwareRevisionStringUUID
{
    return [CBUUID UUIDWithString:@"2a29"];
}
+(CBUUID *) firmwareRevisionStringUUID
{
    return [CBUUID UUIDWithString:@"2a26"];
}

+(CBUUID *) deviceBattyServiceUUID
{
    return [CBUUID UUIDWithString:@"180f"];
    
}
+(CBUUID *) BattyCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"2a19"];
}
#pragma mark 十六进制转十进制方法
#pragma mark 初始化方法
- (BLEdebug *) initwithPeripheral:(CBPeripheral*) peripheral delegate:(id<BLEdebugDelegate>) delegate
{
    userDefaults = [NSUserDefaults standardUserDefaults];
    NAMEFORUSER = [userDefaults objectForKey:USERDEFAULTS_USERNAME];
    Commond  = [[BleSimpleCommond alloc]init];
    Commond.delegate = self;
    bufferDataFortwo = [[NSMutableData alloc] init];
    makeConfig = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER] stringByAppendingPathComponent:@"makeConfig"];
       _peripheral = peripheral;
    _peripheral.delegate = self;
    _delegate = delegate;
    NSLog(@"peripheral: Did initPeripheral!");
    bufferDataFor = [[NSMutableData alloc]init];
    pctime = 0x01;
    pctimesteps = 0x01;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(DFU) name:@"DFU" object:nil];
    
    
    return self;
}
-(void)DFU
{
    Byte arry[] = {0xAA,0x05,0x03,0xcd,0x05,0x01,0xdd,0x00};
    NSData *data = [[NSData alloc] initWithBytes:arry length:8];
    [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];

}


-(void) diddisconnect
{
    //断连后判断文件是否传完  全局
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.3];
    notification.alertBody = NSLocalizedStringFromTable(@"BleAlreadyDisconnect", @"MyLoaclization" , @"");
    
       NSLog(@"int = %d",rtfilepackageint);
    if (rtfilepackageint) {
        if (bufferDataFor.length<rtfilepackageint |bufferDataFortwo.length<stepsfilepackageint) {
            // 未传完完数据的通知
           notification.alertBody = NSLocalizedStringFromTable(@"BleAlreadyDisconnectUpdate", @"MyLoaclization" , @"");
            
            //针对historyviewcontroller的loadingview
            NSNotification *loadviewdiss = [NSNotification notificationWithName:@"LoadingDismiss" object:nil userInfo:@{@"result":@"false"}];
            //notificationWithName:@"LoadingDismiss" object:nil
            [[NSNotificationCenter defaultCenter] postNotification:loadviewdiss];
        }
        
    }
    else
    {
        NSNotification *loadviewdiss = [NSNotification notificationWithName:@"LoadingDismiss" object:nil userInfo:@{@"result":@"false"}];
        //notificationWithName:@"LoadingDismiss" object:nil
        [[NSNotificationCenter defaultCenter] postNotification:loadviewdiss];
        NSLog(@"进入了断链通知");
    }
    
    //断连 提出通知
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    //[[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    [userDefaults setObject:@"0" forKey:USERDEFAULTS_BLESTATE];
    [userDefaults synchronize];
    
    [Commond clearalldata];
    
    rtfilepackageint = 0;
//    bufferDataFortwo = nil;
//    bufferDataFor = nil;
    [bufferDataFor resetBytesInRange:NSMakeRange(0, [bufferDataFor length])];
    [bufferDataFor setLength:0];
    
    [bufferDataFortwo resetBytesInRange:NSMakeRange(0, [bufferDataFor length])];
    [bufferDataFortwo setLength:0];
    
    readtimes = 0;
    readtimessteps=0;
    pctime=1;
    pctimesteps=1;
    RTtime = 1;
    SPtime = 1;
    _alllength = 0;
    NSLog(@"断开连接");
}
-(void) didconnect
{
    [_peripheral discoverServices:@[self.class.uartServiceUUID,self.class.deviceInformationServiceUUID,self.class.deviceBattyServiceUUID]];
    NSLog(@" Did start connected.");
   
}
#pragma mark 写操作
-(void) writeRtValue
{
//    Byte arry[] = {0xAA,0x01,0x23,0x00};
//    NSData *data = [[NSData alloc] initWithBytes:arry length:4];
    NSData *data = [[NSData alloc] initWithData:[Commond SimpleCommond:BleCmGetRTData]];
    if ((self.txCharacteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) != 0)
    {
        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
        NSLog(@"RTdata: WithOutResponse is already sendmessage!");
    }
    else if ((self.txCharacteristic.properties & CBCharacteristicPropertyWrite) != 0)
    {
        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"RTdata: WithResponse is already sendmessage!");
    }
    else{
        NSLog(@"sendmessage is faild!");
    }
    
}

-(void)WarmingON
{
    Byte arry[] = {0xAA,0x08,0x0D,0x01,0x05,0x02,0x00,0x00,0x00,0x00,0x00};
    NSData *data = [[NSData alloc] initWithBytes:arry length:11];
    if ((self.txCharacteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) != 0)
    {
        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
        NSLog(@"Warming:  RTdata: WithResponse is already sendmessage!");
         NSLog(@"震动开关：开");
           }
    else if ((self.txCharacteristic.properties & CBCharacteristicPropertyWrite) != 0)
    {
        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
       NSLog(@"Warming:  RTdata: WithOutResponse is already sendmessage!");
         NSLog(@"震动开关：开");
    }
    else{
        NSLog(@"sendmessage is faild!");
    }

    
   

}
-(void)WarmingOFF
{
    Byte arry[] = {0xAA,0x08,0x0D,0x00,0x05,0x02,0x00,0x00,0x00,0x00,0x00};
    NSData *data = [[NSData alloc] initWithBytes:arry length:11];
    if ((self.txCharacteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) != 0)
    {
        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
        NSLog(@"Warming: WithOutResponse is already sendmessage!");
         NSLog(@"震动开关：关");
    }
    else if ((self.txCharacteristic.properties & CBCharacteristicPropertyWrite) != 0)
    {
        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"Warming: WithResponse is already sendmessage!");
         NSLog(@"震动开关：关");
    }
    else{
        NSLog(@"sendmessage is faild!");
    }
   
}

-(void)SendToDevice:(NSData *)data
{
    [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
    NSLog(@"代理：请求发送命令");
}


-(void) clearndata
{
    
    
//    Byte arry[] = {0xAA,0x01,0x40,0x00};
//    NSData *data = [[NSData alloc] initWithBytes:arry length:4];
    NSData *data = [[NSData alloc] initWithData:[Commond SimpleCommond:BleCmGetRtHistoryLength]];
    [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
    NSLog(@"Clearn:  RTdata: WithOutResponse is already sendmessage!");
    NSLog(@"请求下位机发送辐射历史数据");
    
}

-(void)actionmove
{
    
//    Byte arry[] = {0xAA,0x01,0x44,0x00};
//    NSData *data = [[NSData alloc] initWithBytes:arry length:4];
    NSData *data = [[NSData alloc] initWithData:[Commond SimpleCommond:BleCmGetStepHistoryLength]];
    [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
    NSLog(@"Clearn:  RTdata: WithOutResponse is already sendmessage!");
    NSLog(@"请求下位机发送运动历史数据");
 
}

-(void)readShankState
{
//    Byte arry[] = {0xAA,0x01,0x0c,0x00};
//    NSData *data = [[NSData alloc] initWithBytes:arry length:4];
    NSData *data = [[NSData alloc] initWithData:[Commond SimpleCommond:BleCmGetShankeMode]];
    if ((self.txCharacteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) != 0)
    {
        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
        NSLog(@"ReadShankeState: WithOutResponse is already sendmessage!");
        NSLog(@"请求下位机发送振动状态");
    }
    else if ((self.txCharacteristic.properties & CBCharacteristicPropertyWrite) != 0)
    {
        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"ReadShankeState: WithOutResponse is already sendmessage!");
        NSLog(@"请求下位机发送振动状态");    }
    else{
        NSLog(@"ShankeState:  sendmessage is faild!");
    }
    
}

#pragma mark 解析的方法
-(void) realRT:(unsigned char *)buffer
{
    unsigned char * cfg = (unsigned char *)buffer;
     int num1,num2,num3,num4;
   // NSLog(@"辐射值");
    
 
    num1 = (cfg[3]<<8&0xff00)|(cfg[4]&0xff);
    num2 = (cfg[5]<<8&0xff00)|(cfg[6]&0xff);
    num3 = (cfg[7]<<8&0xff00)|(cfg[8]&0xff);
    num4 = (cfg[9]<<8&0xff00)|(cfg[10]&0xff);
    NSLog(@"num1 = %d",num1);
     [self.delegate didread:num1 label2:num2 label3:num3 states:3];
}
-(void) readshanke:(unsigned char *)buffer;
{
    NSLog(@"下位机 振动开关为%d",buffer[3]);
//    NSString *state = [NSString stringWithFormat:@"%d",buffer[3]];
//    NSMutableData *data = [NSMutableData data];
//    NSKeyedArchiver * arch = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
//    [arch encodeObject:state forKey:@"shankstate"];//电池电量
//    [arch finishEncoding];
//    [data writeToFile:makeConfig atomically:YES];
    [userDefaults setObject:[NSString stringWithFormat:@"%d",buffer[3]] forKey:USERDEFAULTS_SHANKE];

}

#pragma mark 实例化蓝牙自动运行的方法
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"error discovering services: %@",error);
    }

    for(CBService *s in [peripheral services])
    {
        
        if ([s.UUID isEqual:self.class.uartServiceUUID]) {
            NSLog(@"peripheral:  already found correct services!");
            self.uartService = s;
            
            [self.peripheral discoverCharacteristics:@[self.class.txCharacteristicUUID, self.class.rxCharacteristicUUID] forService:s];
            
        }
        else if ([s.UUID isEqual:self.class.deviceInformationServiceUUID])
        {
            
            [self.peripheral discoverCharacteristics:@[self.class.firmwareRevisionStringUUID] forService:s];
        }
        else if([s.UUID isEqual:self.class.deviceBattyServiceUUID])
        {
            [self.peripheral discoverCharacteristics:@[self.class.BattyCharacteristicUUID] forService:s];

        }
        
    }
    
}

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", error);
        return;
    }
    for(CBCharacteristic *c in [service characteristics])
    {
        if ([c.UUID isEqual:self.class.txCharacteristicUUID]) {
            NSLog(@"peripheral: found TX characteristic!");
            self.txCharacteristic = c;
            [self readShankState];
        }
        else if ([c.UUID isEqual:self.class.rxCharacteristicUUID])
        {
            NSLog(@"peripheral: found RX characteristic!");
            self.rxCharacteristic = c;
            [self.peripheral setNotifyValue:YES forCharacteristic:self.rxCharacteristic];
            [self.delegate threadrun];
        }
        else if ([c.UUID isEqual:self.class.BattyCharacteristicUUID])
        {
            NSLog(@"peripheral: found BT characteristic!");
            self.battyCharacteristic = c;
            [self.peripheral setNotifyValue:YES forCharacteristic:self.battyCharacteristic];
            //[self readBattry];
        }
        else if ([c.UUID isEqual:self.class.firmwareRevisionStringUUID])
        {
            NSLog(@"peripheral: found FM characteristic!");
            self.firmwareCharacteristic = c;
           // [self.peripheral setNotifyValue:YES forCharacteristic:self.firmwareCharacteristic];
            [self readFirmwareversion];
            
        }
     

    }
    
    
}
-(void) peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    
    
    

}


-(void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"error receiving notification for characteristic %@: %@",characteristic,error);
        return;
    }

    
    //收到下位机命令
  
    NSLog(@"peripheral: received data from a charcteristic!");
    
    
    if (characteristic == self.firmwareCharacteristic) {

    }
    
    if (characteristic == self.battyCharacteristic)
    {
       // unsigned char *bufferr = (unsigned char *)[[characteristic value] bytes];
       // NSString *battrytmp = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",[characteristic value]]];
        NSLog(@"characteristic = %@",[NSString stringWithFormat:@"%@",[characteristic value]] );
       // NSLog(@"buffer[0] = %d,bufferr[1] = %d",bufferr[0],bufferr[1]);
        // int batty = bufferr[0];
 
       //归档
     //    NSString *battry = [NSString stringWithFormat:@"%d",batty];
        
        
    }
    
    if (characteristic == self.rxCharacteristic) {
        
        unsigned char *bufferr = (unsigned char *)[[characteristic value] bytes];
        
        if (bufferr[2]==193) {
            choices++;
            NSLog(@"choices = %d",choices);
        }
        NSLog(@"commd=%d",bufferr[2]);
        switch (bufferr[2]) {
            case 0x81:
                NSLog(@"buff[5] = %d",bufferr[5]);
                NSLog(@"buff[6] = %d",bufferr[6]);
                version = [NSString stringWithFormat:@"%d.%d",bufferr[5],bufferr[6]];
                NSLog(@"version = %@",version);
                NSLog(@"save = %@",[userDefaults objectForKey:@"version"]);
           //     AppDelegateAccessor.isFirmwareNeedUpdate = YES;
                if ([[userDefaults objectForKey:@"version"] isEqual:version]) {
                    AppDelegateAccessor.isFirmwareNeedUpdate = NO;
                    NSLog(@"不需要更新固件");
                }
                else
                {
                    AppDelegateAccessor.isFirmwareNeedUpdate = YES;
                    NSLog(@"固件需要更新");
                }
                
                break;
            case 0x8c:
                [self readshanke:(unsigned char *)[[characteristic value]bytes]];
                break;
                
            case 163:
                [self realRT: (unsigned char *)[[characteristic value]bytes]];
                break;
                
                
                          //收到了下位机传上来的关于包长度的数据
            case 192:
                //[self readfilelength:(unsigned char* )[[characteristic value]bytes]];
                [Commond GetHistoryData:RTHistory Section:1 Buff:(unsigned char* )[[characteristic value]bytes]];
                break;
                //收到下位机传上来的每一帧数据
            case 193:
            {
                if (Commond.bufferDataFor.length<Commond.rtfilepackageint) {
                    if (Commond.rtfilepackageint%16) {
                        NSLog(@"辐射:共需要接收%d次数据",Commond.rtfilepackageint/16+1);
                    }
                    else
                        NSLog(@"辐射:共需要接收%d次数据",Commond.rtfilepackageint/16);
                    [Commond GetHistoryData:RTHistory Section:2 Buff:(unsigned char* )[[characteristic value]bytes]];
                }
      
            }
                break;
            case 0x82:
            {
              unsigned char *buff =(unsigned char*)[[characteristic value]bytes];
               bat = buff[3];
                NSLog(@"battry = %d",bat);
                [userDefaults setObject:[NSString stringWithFormat:@"%d",bat] forKey:USERDEFAULTS_BATTRY];
                [userDefaults synchronize];
                
            }
                break;
                
            case 194:
            {
                [Commond GetHistoryData:RTHistory Section:3 Buff:(unsigned char* )[[characteristic value]bytes]];
            }
                break;
            case 195:
            {
                [self checkcrc:(unsigned char*)[[characteristic value]bytes]];
            }
                break;
            case 196:
            {
                [Commond GetHistoryData:StepHistory Section:1 Buff:(unsigned char* )[[characteristic value]bytes]];
            }
                break;
            case 197:
            {
                if (Commond.bufferDataFortwo.length<Commond.stepsfilepackageint) {
                    if (Commond.stepsfilepackageint%16) {
                        NSLog(@"计步:共需要接收%d次数据",Commond.stepsfilepackageint/16+1);
                    }
                    else
                        NSLog(@"计步:共需要接收%d次数据",Commond.stepsfilepackageint/16);
                    
                [Commond GetHistoryData:StepHistory Section:2 Buff:(unsigned char* )[[characteristic value]bytes]];
                }
            }
            
                break;
            case 198:
            {
            
            [Commond GetHistoryData:StepHistory Section:3 Buff:(unsigned char* )[[characteristic value]bytes]];
            
            }
                break;
            case 199:
                
                break;
            default:
                break;
        }
    }
}


-(void)checkcrc:(unsigned char*)buff
{
    NSLog(@"整个文件累加和为%d",buff[3]);
    
}
-(int)readBattry
{
//    Byte arry[] = {0xAA,0x01,0x02,0x00};
    NSData *data = [[NSData alloc] initWithData:[Commond SimpleCommond:BleCmGetBattay]];
    if ((self.txCharacteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) != 0)
    {
        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
        NSLog(@"RTdata: WithOutResponse is already sendmessage!");
    }
    else if ((self.txCharacteristic.properties & CBCharacteristicPropertyWrite) != 0)
    {
        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"RTdata: WithResponse is already sendmessage!");
    }
    return bat;

}

-(void)readFirm
{
    NSData *data = [[NSData alloc] initWithData:[Commond SimpleCommond:BleCmGetDeviceVersion]];
    if ((self.txCharacteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) != 0)
    {
        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
        NSLog(@"RTdata: WithOutResponse is already sendmessage!");
    }
    else if ((self.txCharacteristic.properties & CBCharacteristicPropertyWrite) != 0)
    {
        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"RTdata: WithResponse is already sendmessage!");
    }
}
//
//
//
-(void)readFirmwareversion
{

    CBCharacteristic *characteristic = self.firmwareCharacteristic;
    
    [self.peripheral readValueForCharacteristic:characteristic];

    
}

@end






