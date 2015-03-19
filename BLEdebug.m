//
//  BLEdebug.m
//  BLEdebug
//
//  Created by Chan Bill on 14/11/13.
//  Copyright (c) 2014年 Vipose. All rights reserved.
//


#import "BLEdebug.h"

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
         NSLog(@"Firmwareversion = %@",[NSString stringWithFormat:@"%@",[characteristic value]]);
       
        unsigned char *bufferr = (unsigned char *)[[characteristic value] bytes];
        int version1 = bufferr[0];
        int version2 = bufferr[1];
        int version3 = bufferr[2];
        int version4 = bufferr[3];
        int version0 = (version1&0xff)|((version2<<8)&0xff00)|((version3<<16)&0xff0000)|((version4<<24)&0xff000000);
        version = [NSString stringWithFormat:@"%d",version0];
        NSLog(@"version = %@",version);
        NSMutableData *data = [NSMutableData data];
        NSKeyedArchiver * arch = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [arch encodeObject:version forKey:@"version"];//版本号
        
        [arch finishEncoding];
        [data writeToFile:makeConfig atomically:YES];
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
#pragma mark 历史解析方法
//*****************************辐射历史开始*********************************
//-(void)readfilelength:(unsigned char *)buff
//{
//    
//    //余数 余下多少个单数
//    _alllength = (((buff[3]<<24)&0xff000000)|((buff[4]<<16)&0xff0000)|((buff[5]<<8)&0xff00)|(buff[6]&0xff))*2%1024;
//    NSLog(@"余数alllength = %d",_alllength);
//    rtfilepackageint =(((buff[3]<<24)&0xff000000)|((buff[4]<<16)&0xff0000)|((buff[5]<<8)&0xff00)|(buff[6]&0xff))*2;
//    NSLog(@"总共长度为%d",rtfilepackageint);
//    if (rtfilepackageint>0) {
//        
//        NSDate *  senddate=[NSDate date];
//        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//        [dateformatter setDateFormat:@"YYYYMMdd"];
//        locationString=[dateformatter stringFromDate:senddate];
//        NSLog(@"%@",locationString);
//        [userDefaults setValue:locationString forKey:USERDEFAULTS_LASTTIMEREFRESH];
//        [userDefaults synchronize];
//        rthistoryPath = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"RTDIR"] stringByAppendingPathComponent:locationString];
//        
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        if(![fileManager fileExistsAtPath:rthistoryPath]) //如果不存在
//        {
//            NSData *transformstate= [[NSData alloc]initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
//            // NSData *transformstate = [[NSData alloc] initWithBytes:@"0" length:1];
//            [fileManager createFileAtPath:rthistoryPath contents:transformstate attributes:nil];
//            fh = [NSFileHandle fileHandleForWritingAtPath:rthistoryPath];
//            //            [fh writeData:transformstate];
//            [fh seekToEndOfFile];
//        }
//        else
//        {
//            fh = [NSFileHandle fileHandleForUpdatingAtPath:rthistoryPath];
//            [fh seekToEndOfFile];
//        }
//    }
//    //有多少个包
//    if ((_alllength)>0) {
//        pages = (((buff[3]<<24)&0xff000000)|((buff[4]<<16)&0xff0000)|((buff[5]<<8)&0xff00)|(buff[6]&0xff))*2/1024+1;
//        
//    }
//    else
//    {
//        pages = (((buff[3]<<24)&0xff000000)|((buff[4]<<16)&0xff0000)|((buff[5]<<8)&0xff00)|(buff[6]&0xff))*2/1024;
//    }
//    
//    NSLog(@"一共需要包pages = %d",pages);
//    
//    if (rtfilepackageint==0) {
//        NSLog(@"没有历史文件需要下载！");
//        NSNotification *loadviewdiss = [NSNotification notificationWithName:@"LoadingDismiss" object:nil userInfo:@{@"result":@"nodata"}];
//        [[NSNotificationCenter defaultCenter] postNotification:loadviewdiss];
//    }
//    else
//    {
//        
//        
//        
//        Byte arry[] = {0xAA,0x06,0x41,0x00,0x00,0x00,pctime,0x00,0x00};
//        NSData *data = [[NSData alloc] initWithBytes:arry length:9];
//        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
//        NSLog(@"请求发送第一个包");
//        
//        
//    }
//    
//}
//
//-(void)readdatafromfor:(unsigned char*)buff
//{
//    
//    int ret = (buff[1]-1);
//    if (ret!=16) {
//        NSLog(@"辐射：收到最后一次数据");
//    }
//    else
//        NSLog(@"辐射：收到第%d次数据",RTtime);
//    
//    
//    int array[ret];
//    for (int i = 0; i<ret; i++) {
//        array[i]=buff[i+3];
//    }
//    if (bufferDataFor.length<rtfilepackageint) {
//        [bufferDataFor appendBytes:array length:ret];
//    }
//    NSLog(@"buffer.length = %ld     rtfint = %d",bufferDataFor.length,rtfilepackageint);
//    if ((bufferDataFor.length%1024==0&&bufferDataFor.length>0)|(bufferDataFor.length>=rtfilepackageint)) {
//        Byte arry[] = {0xAA,0x05,0x42,0x00,0x00,0x00,pctime,0x00};
//        NSLog(@"pctime = %hd",pctime);
//        NSData *data = [[NSData alloc] initWithBytes:arry length:8];
//        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
//        pctime++;
//    }
//    RTtime++;
//    
//    
//}
////需要补充校验
//-(void)checkeverydata:(unsigned char*)buff
//{
//        NSLog(@"累加和为%d",buff[3]);
//    NSLog(@"buffer.length = %ld     rtfint = %d",bufferDataFor.length,rtfilepackageint);
//    if (bufferDataFor.length>=rtfilepackageint) {
////        Byte arry[] = {0xAA,0x05,0x43,0x00};
//        NSData *data = [[NSData alloc] initWithData:[Commond SimpleCommond:BleCmGetRtHistoryCheck]];
//        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
//        NSLog(@"请求全部校验");
//         [self actionmove];
//         pctime=1;
//    }
//    else{
//    
//        Byte arry[] = {0xAA,0x06,0x41,0x00,0x00,0x00,pctime,0x00,0x00};
//        NSData *data = [[NSData alloc] initWithBytes:arry length:9];
//        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
//        NSLog(@"辐射:第%d次请求校验",pctime);
//    }
//    
//}
//
//
-(void)checkcrc:(unsigned char*)buff
{
    NSLog(@"整个文件累加和为%d",buff[3]);
    
}
//************************************辐射历史结束***********************************

//******************************************计步历史开始***************************************
//文件长度
//-(void)readMovelength:(unsigned char *)buff
//{
//    _alllengthsteps = (((buff[3]<<24)&0xff000000)|((buff[4]<<16)&0xff0000)|((buff[5]<<8)&0xff00)|(buff[6]&0xff))*2%1024;
//    NSLog(@"步长 余数alllength = %d",_alllengthsteps);
//    stepsfilepackageint =(((buff[3]<<24)&0xff000000)|((buff[4]<<16)&0xff0000)|((buff[5]<<8)&0xff00)|(buff[6]&0xff))*2;
//    NSLog(@"步长 总共长度为%d",stepsfilepackageint);
//    if (stepsfilepackageint>0) {
//        stepshistoryPath = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"SPDIR"]stringByAppendingPathComponent:locationString];
//    
//       
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if(![fileManager fileExistsAtPath:stepshistoryPath]) //如果不存在
//    {
//       // NSData *transformstate= [[NSData alloc] initWithBase64EncodedString:@"1234" options:NSUTF8StringEncoding];
//      //  NSData *transformstate = [[NSData alloc] initWithBytes:@"0" length:1];
//      //  [fileManager createFileAtPath:stepshistoryPath contents:nil attributes:nil];
//        [fileManager createFileAtPath:stepshistoryPath contents:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
//        fhand = [NSFileHandle fileHandleForWritingAtPath:stepshistoryPath];
////        [fhand writeData:transformstate];
//        [fhand seekToEndOfFile];
//    }
//    else
//    {
//        fhand = [NSFileHandle fileHandleForUpdatingAtPath:stepshistoryPath];
//        [fhand seekToEndOfFile];
//    }
//    }
//    //有多少个包
//    if ((_alllengthsteps)>0) {
//        pagessteps = (((buff[3]<<24)&0xff000000)|((buff[4]<<16)&0xff0000)|((buff[5]<<8)&0xff00)|(buff[6]&0xff))*2/1024+1;
//        
//    }
//    else
//    {
//        pagessteps = (((buff[3]<<24)&0xff000000)|((buff[4]<<16)&0xff0000)|((buff[5]<<8)&0xff00)|(buff[6]&0xff))*2/1024;
//    }
//    
//    NSLog(@"步长 一共需要包pages = %d",pagessteps);
//    
//    if (pagessteps==0) {
//        NSLog(@"步长 没有历史文件需要下载！");
//        
//    }
//    else
//    {
//        
//        
//        
//        Byte arry[] = {0xAA,0x06,0x45,0x00,0x00,0x00,pctimesteps,0x00,0x00};
//        NSData *data = [[NSData alloc] initWithBytes:arry length:9];
//        //remove 2015 0114
//        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
//        NSLog(@"步长 请求发送第一个包");
//        
//        
//    }
//    
//}
//
//-(void)stepsreaddatafromfor:(unsigned char*)buff
//{
//    
//   
//    int ret = (buff[1]-1);
//    if (ret!=16) {
//        NSLog(@"步长 收到最后一次不完整的的数据");
//    }
//    else
//        
//        NSLog(@"步长 收到第%d次数据",SPtime);
//    
//    int array[ret];
//    
//    for (int i = 0; i<ret; i++) {
//        array[i]=buff[i+3];
//    }
//    if (bufferDataFortwo.length<stepsfilepackageint) {
//        [bufferDataFortwo appendBytes:array length:ret];
//    }
//    
//    if (bufferDataFortwo.length%1024==0|bufferDataFortwo.length>=stepsfilepackageint) {
//        Byte arry[] = {0xAA,0x05,0x46,0x00,0x00,0x00,pctimesteps,0x00};
//        NSData *data = [[NSData alloc] initWithBytes:arry length:8];
//        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
//        NSLog(@"计步:第%d次请求校验",pctimesteps);
//        pctimesteps++;
//    }
//    SPtime++;
//
//}
//-(void)stepscheckeverydata:(unsigned char*)buff
//{
//    NSLog(@"步长 累加和为%d",buff[3]);
//    
//    if (bufferDataFortwo.length>=stepsfilepackageint) {
////        Byte arry[] = {0xAA,0x05,0x47,0x00};
////        NSData *data = [[NSData alloc] initWithBytes:arry length:4];
//        NSData *data = [[NSData alloc] initWithData:[Commond SimpleCommond:BleCmGetStepHistoryCheck]];
//        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
//        NSLog(@"步长 请求全部校验");
//        // [self.delegate stepswriteInfor];
//        [self savedata];
//        NSNotification *loadviewdiss = [NSNotification notificationWithName:@"LoadingDismiss" object:nil userInfo:@{@"result":@"true"}];
//        [[NSNotificationCenter defaultCenter] postNotification:loadviewdiss];
//        pctimesteps=1;
//    }
//    else{
//        Byte arry[] = {0xAA,0x06,0x45,0x00,0x00,0x00,pctimesteps,0x00,0x00};
//        NSData *data = [[NSData alloc] initWithBytes:arry length:9];
//        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
//    }
//    
//    
//}
////*****************************计步历史结束*********************************
//
//
//
-(int)readBattry
{
//    Byte arry[] = {0xAA,0x01,0x02,0x00};
    NSData *data = [[NSData alloc] initWithData:[Commond SimpleCommond:BleCmGetBattay]];
    [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
   // NSLog(@"bat = %d",bat);
    return bat;

}
//
//
//
-(void)readFirmwareversion
{

    CBCharacteristic *characteristic = self.firmwareCharacteristic;
    
    [self.peripheral readValueForCharacteristic:characteristic];

    
}
//-(void)savedata
//{
//    //分解数据 分批保存到不同文件中
//    NSDate *  senddate=[NSDate date];
//    
//    NSInteger y = [[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:senddate] year];
//    
//    NSInteger mouth =[[[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:senddate] month];
//    
//    
//    NSInteger d =[[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:senddate] day];
//    
//    NSString *lastdate = [NSString stringWithFormat:@"%ld",y];
//    if (mouth<10) {
//        lastdate = [NSString stringWithFormat:@"%@0%ld",lastdate,mouth];
//        //   [lastdate stringByAppendingString:[NSString stringWithFormat:@"0%ld",mouth]];
//    }
//    else
//        lastdate = [NSString stringWithFormat:@"%@%ld",lastdate,mouth];
//    //  [lastdate stringByAppendingString:[NSString stringWithFormat:@"%ld",mouth]];
//    
//    if (d-1<10) {
//        lastdate = [NSString stringWithFormat:@"%@0%ld",lastdate,d-1];
//        //  [lastdate stringByAppendingString:[NSString stringWithFormat:@"0%ld",d-1]];
//    }
//    else
//        lastdate = [NSString stringWithFormat:@"%@%ld",lastdate,d-1];
//    // [lastdate stringByAppendingString:[NSString stringWithFormat:@"%ld",d-1]];
//    
//    NSString *threedate =   [NSString stringWithFormat:@"%ld",y];
//    if (mouth<10) {
//        threedate = [NSString stringWithFormat:@"%@0%ld",threedate,mouth];
//        //  [threedate stringByAppendingString:[NSString stringWithFormat:@"0%ld",mouth]];
//    }
//    else
//        threedate = [NSString stringWithFormat:@"%@%ld",threedate,mouth];
//    // [threedate stringByAppendingString:[NSString stringWithFormat:@"%ld",mouth]];
//    
//    if (d-2<10) {
//        threedate = [NSString stringWithFormat:@"%@0%ld",threedate,d-2];
//        //[threedate stringByAppendingString:[NSString stringWithFormat:@"0%ld",d-2]];
//    }
//    else
//        threedate = [NSString stringWithFormat:@"%@%ld",threedate,d-2];
//    //  [threedate stringByAppendingString:[NSString stringWithFormat:@"%ld",d-2]];
//    
//    NSLog(@"lastdate = %@,threedate = %@",lastdate,threedate);
//    NSInteger h =[[[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:senddate] hour];
//    NSInteger m = [[[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:senddate] minute];
//    //计算今天到当前时间最多能保存多少个数据   *2
//    NSInteger todaydata = (h*60+m)/6*2;
//    NSLog(@"今天需要保存的数据为%ld",todaydata);
//    NSLog(@"接收辐射长度为%ld",bufferDataFor.length);
//    /****************辐射历史数据处理********************************/
//    Byte *thisTimeRTByte = (Byte *)[bufferDataFor bytes];     //
//    
//    //判断当收到数据大于今天最多保存数据量时的处理
//    if (bufferDataFor.length>todaydata) {
//        /***********************今天的文件中只保存今天的数据**************************************/
//        Byte todayarry[todaydata];  //今天的数据
//        for (NSInteger i = 0; i<todaydata; i++) {
//            todayarry[i] = thisTimeRTByte[i+bufferDataFor.length-todaydata];
//        }
//        NSData *data= [[NSData alloc]initWithBytes:todayarry length:todaydata];
//        [fh writeData:data];
//        [fh closeFile];
//        
//        NSFileHandle*fh1 = [NSFileHandle fileHandleForWritingAtPath:rthistoryPath];
//        [fh1 seekToFileOffset:0];
//        NSData *data1= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [fh1 writeData:data1];
//        [fh1 closeFile];
//        NSLog(@"今天的数据已写完");
//        /**********************************根据数据大小将数据分别保存到前几天的文件中*******************************************/
//        
//        if (bufferDataFor.length-todaydata<=480) {    //只多出一天的数据
//            NSLog(@"多出了1天的数据");
//            Byte lastdayarr[bufferDataFor.length-todaydata];   //前一天的数据
//            for (NSInteger i = 0; i<bufferDataFor.length-todaydata;i++) {
//                lastdayarr[i] = thisTimeRTByte[i];
//            }
//            NSString *lastRTpaTH = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"RTDIR"] stringByAppendingPathComponent:lastdate];
//            
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            NSFileHandle *lastdayhandl;
//            if(![fileManager fileExistsAtPath:lastRTpaTH]) //如果不存在
//            {
//                NSData *transformstate= [[NSData alloc]initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
//                // NSData *transformstate = [[NSData alloc] initWithBytes:@"0" length:1];
//                [fileManager createFileAtPath:lastRTpaTH contents:transformstate attributes:nil];
//                lastdayhandl = [NSFileHandle fileHandleForWritingAtPath:lastRTpaTH];
//                //                [lastdayhandl writeData:transformstate];
//                [lastdayhandl seekToEndOfFile];
//                
//            }
//            else
//            {
//                lastdayhandl = [NSFileHandle fileHandleForUpdatingAtPath:lastRTpaTH];
//                [lastdayhandl seekToEndOfFile];
//            }
//            //写进前一天的文件中
//            NSData *data1= [[NSData alloc]initWithBytes:lastdayarr length:bufferDataFor.length-todaydata];
//            [lastdayhandl writeData:data1];
//            [lastdayhandl closeFile];
//            
//            NSFileHandle*fh1 = [NSFileHandle fileHandleForWritingAtPath:lastRTpaTH];
//            [fh1 seekToFileOffset:0];
//            NSData *data2= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
//            [fh1 writeData:data2];
//            [fh1 closeFile];
//            
//            NSLog(@"多出了1天的数据：写完");
//        }
//        
//        //多出2天的数据
//        //if (bufferDataFor.length-todaydata>480&&bufferDataFor.length-todaydata<=960) {
//        if (bufferDataFor.length-todaydata>480) {
//            NSLog(@"多出了2天的数据");
//            //写进前一天的文件中
//            Byte lastdayarr[480];
//            for (NSInteger i = 0; i<480;i++) {
//                lastdayarr[i] = thisTimeRTByte[i+bufferDataFor.length-todaydata-480];
//            }
//            NSString *lastRTpaTH = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"RTDIR"] stringByAppendingPathComponent:lastdate];
//            
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            NSFileHandle *lastdayhandl;
//            if(![fileManager fileExistsAtPath:lastRTpaTH]) //如果不存在
//            {
//                NSData *transformstate= [[NSData alloc]initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
//                //  NSData *transformstate = [[NSData alloc] initWithBytes:@"0" length:1];
//                [fileManager createFileAtPath:lastRTpaTH contents:transformstate attributes:nil];
//                lastdayhandl = [NSFileHandle fileHandleForWritingAtPath:lastRTpaTH];
//                //                [lastdayhandl writeData:transformstate];                [lastdayhandl seekToEndOfFile];
//            }
//            else
//            {
//                lastdayhandl = [NSFileHandle fileHandleForUpdatingAtPath:lastRTpaTH];
//                [lastdayhandl seekToEndOfFile];
//            }
//            
//            NSData *data= [[NSData alloc]initWithBytes:lastdayarr length:480];
//            [lastdayhandl writeData:data];
//            [lastdayhandl closeFile];
//            
//            NSFileHandle*fh1 = [NSFileHandle fileHandleForWritingAtPath:lastRTpaTH];
//            [fh1 seekToFileOffset:0];
//            NSData *data2= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
//            [fh1 writeData:data2];
//            [fh1 closeFile];
//            NSLog(@"2天数据:前一天写完");
//            
//            //写进大前天的文件中
//            Byte thirdayarr[bufferDataFor.length-todaydata-480];
//            for (NSInteger i = 0; i<bufferDataFor.length-todaydata-480;i++) {
//                thirdayarr[i] = thisTimeRTByte[i];
//            }
//            NSString *thirRTpaTH = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"RTDIR"] stringByAppendingPathComponent:threedate];
//            
//            NSFileManager *fileManager1 = [NSFileManager defaultManager];
//            NSFileHandle *lastdayhandl1;
//            if(![fileManager1 fileExistsAtPath:thirRTpaTH]) //如果不存在
//            {
//                NSData *transformstate= [[NSData alloc]initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
//                //  NSData *transformstate = [[NSData alloc] initWithBytes:@"0" length:1];
//                [fileManager1 createFileAtPath:thirRTpaTH contents:transformstate attributes:nil];
//                lastdayhandl1 = [NSFileHandle fileHandleForWritingAtPath:thirRTpaTH];
//                //                 [lastdayhandl1 writeData:transformstate];
//                [lastdayhandl1 seekToEndOfFile];
//            }
//            else
//            {
//                lastdayhandl1 = [NSFileHandle fileHandleForUpdatingAtPath:thirRTpaTH];
//                [lastdayhandl1 seekToEndOfFile];
//            }
//            //写进前一天的文件中
//            NSData *data1= [[NSData alloc]initWithBytes:thirdayarr length:bufferDataFor.length-todaydata-480];
//            [lastdayhandl1 writeData:data1];
//            [lastdayhandl1 closeFile];
//            
//            NSFileHandle*fh2 = [NSFileHandle fileHandleForWritingAtPath:thirRTpaTH];
//            [fh2 seekToFileOffset:0];
//            NSData *data3= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
//            [fh2 writeData:data3];
//            [fh2 closeFile];
//            NSLog(@"2天数据:大前天写完");
//        }
//        
//        
//        
//    }
//    else{
//        NSData *data= [[NSData alloc]initWithData:bufferDataFor];
//        [fh writeData:data];
//        [fh closeFile];
//        
//        NSFileHandle*fh1 = [NSFileHandle fileHandleForWritingAtPath:rthistoryPath];
//        [fh1 seekToFileOffset:0];
//        NSData *data1= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [fh1 writeData:data1];
//        [fh1 closeFile];
//        
//        NSLog(@"只有一天数据写完");
//    }
//    /****************辐射历史数据处理完毕********************************/
//    
//    
//    /****************计步历史数据处理********************************/
//    
//    NSLog(@"计步：需要接收的长度为%ld",bufferDataFortwo.length);
//    Byte *thisTimeSPByte = (Byte *)[bufferDataFortwo bytes];     //
//    
//    //判断当收到数据大于今天最多保存数据量时的处理
//    if (bufferDataFortwo.length>todaydata) {
//        /***********************今天的文件中只保存今天的数据**************************************/
//        Byte todayarry[todaydata];  //今天的数据
//        for (NSInteger i = 0; i<todaydata; i++) {
//            todayarry[i] = thisTimeSPByte[i+bufferDataFortwo.length-todaydata];
//        }
//        NSData *data= [[NSData alloc]initWithBytes:todayarry length:todaydata];
//        [fhand writeData:data];
//        [fhand closeFile];
//        
//        NSFileHandle*fh1 = [NSFileHandle fileHandleForWritingAtPath:stepshistoryPath];
//        [fh1 seekToFileOffset:0];
//        NSData *data1= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [fh1 writeData:data1];
//        [fh1 closeFile];
//        
//        NSLog(@"计步：今天的数据已写完");
//        /**********************************根据数据大小将数据分别保存到前几天的文件中*******************************************/
//        
//        if (bufferDataFortwo.length-todaydata<=480) {    //只多出一天的数据
//            NSLog(@"计步：多出了1天的数据");
//            Byte lastdayarr[bufferDataFortwo.length-todaydata];   //前一天的数据
//            for (NSInteger i = 0; i<bufferDataFortwo.length-todaydata;i++) {
//                lastdayarr[i] = thisTimeSPByte[i];
//            }
//            NSString *lastSPpaTH = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"SPDIR"] stringByAppendingPathComponent:lastdate];
//            
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            NSFileHandle *lastdayhandl;
//            if(![fileManager fileExistsAtPath:lastSPpaTH]) //如果不存在
//            {
//                NSData *transformstate= [[NSData alloc]initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
//                //  NSData *transformstate = [[NSData alloc] initWithBytes:@"0" length:1];
//                [fileManager createFileAtPath:lastSPpaTH contents:transformstate attributes:nil];
//                lastdayhandl = [NSFileHandle fileHandleForWritingAtPath:lastSPpaTH];
//                //                 [lastdayhandl writeData:transformstate];
//                [lastdayhandl seekToEndOfFile];
//            }
//            else
//            {
//                lastdayhandl = [NSFileHandle fileHandleForUpdatingAtPath:lastSPpaTH];
//                [lastdayhandl seekToEndOfFile];
//            }
//            //写进前一天的文件中
//            NSData *data1= [[NSData alloc]initWithBytes:lastdayarr length:bufferDataFortwo.length-todaydata];
//            [lastdayhandl writeData:data1];
//            [lastdayhandl closeFile];
//            
//            NSFileHandle*fh1 = [NSFileHandle fileHandleForWritingAtPath:lastSPpaTH];
//            [fh1 seekToFileOffset:0];
//            NSData *data2= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
//            [fh1 writeData:data2];
//            [fh1 closeFile];
//            
//            NSLog(@"计步：多出了1天的数据：写完");
//        }
//        
//        //多出2天的数据
//        //if (bufferDataFortwo.length-todaydata>480&&bufferDataFortwo.length-todaydata<=960) {
//        if (bufferDataFortwo.length-todaydata>480) {
//            NSLog(@"计步：多出了2天的数据");
//            //写进前一天的文件中
//            Byte lastdayarr[480];
//            for (NSInteger i = 0; i<480;i++) {
//                lastdayarr[i] = thisTimeSPByte[i+bufferDataFortwo.length-todaydata-480];
//            }
//            NSString *lastSPpaTH = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"SPDIR"] stringByAppendingPathComponent:lastdate];
//            
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            NSFileHandle *lastdayhandl;
//            if(![fileManager fileExistsAtPath:lastSPpaTH]) //如果不存在
//            {
//                NSData *transformstate= [[NSData alloc]initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
//                //  NSData *transformstate = [[NSData alloc] initWithBytes:@"0" length:1];
//                [fileManager createFileAtPath:lastSPpaTH contents:transformstate attributes:nil];
//                lastdayhandl = [NSFileHandle fileHandleForWritingAtPath:lastSPpaTH];
//                //                 [lastdayhandl writeData:transformstate];
//                [lastdayhandl seekToEndOfFile];
//            }
//            else
//            {
//                lastdayhandl = [NSFileHandle fileHandleForUpdatingAtPath:lastSPpaTH];
//                [lastdayhandl seekToEndOfFile];
//            }
//            
//            NSData *data= [[NSData alloc]initWithBytes:lastdayarr length:480];
//            [lastdayhandl writeData:data];
//            [lastdayhandl closeFile];
//            
//            
//            NSFileHandle*fh1 = [NSFileHandle fileHandleForWritingAtPath:lastSPpaTH];
//            [fh1 seekToFileOffset:0];
//            NSData *data2= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
//            [fh1 writeData:data2];
//            [fh1 closeFile];
//            NSLog(@"计步：2天数据:前一天写完");
//            
//            //写进大前天的文件中
//            Byte thirdayarr[bufferDataFortwo.length-todaydata-480];
//            for (NSInteger i = 0; i<bufferDataFortwo.length-todaydata-480;i++) {
//                thirdayarr[i] = thisTimeSPByte[i];
//            }
//            NSString *thirSPpaTH = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"SPDIR"] stringByAppendingPathComponent:threedate];
//            
//            NSFileManager *fileManager1 = [NSFileManager defaultManager];
//            NSFileHandle *lastdayhandl1;
//            if(![fileManager1 fileExistsAtPath:thirSPpaTH]) //如果不存在
//            {
//                NSData *transformstate= [[NSData alloc]initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
//                // NSData *transformstate = [[NSData alloc] initWithBytes:@"0" length:1];
//                [fileManager1 createFileAtPath:thirSPpaTH contents:transformstate attributes:nil];
//                lastdayhandl1 = [NSFileHandle fileHandleForWritingAtPath:thirSPpaTH];
//                //                 [lastdayhandl writeData:transformstate];
//                [lastdayhandl1 seekToEndOfFile];
//            }
//            else
//            {
//                lastdayhandl1 = [NSFileHandle fileHandleForUpdatingAtPath:thirSPpaTH];
//                [lastdayhandl1 seekToEndOfFile];
//            }
//            //写进前一天的文件中
//            NSData *data1= [[NSData alloc]initWithBytes:thirdayarr length:bufferDataFortwo.length-todaydata-480];
//            [lastdayhandl1 writeData:data1];
//            [lastdayhandl1 closeFile];
//            
//            
//            NSFileHandle*fh2 = [NSFileHandle fileHandleForWritingAtPath:lastSPpaTH];
//            [fh2 seekToFileOffset:0];
//            NSData *data3= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
//            [fh2 writeData:data3];
//            [fh2 closeFile];
//            NSLog(@"计步：2天数据:大前天写完");
//        }
//    }
//    else{
//        NSData *data1= [[NSData alloc]initWithData:bufferDataFortwo];
//        [fhand writeData:data1];
//        [fhand closeFile];
//        
//        NSFileHandle*fh1 = [NSFileHandle fileHandleForWritingAtPath:stepshistoryPath];
//        [fh1 seekToFileOffset:0];
//        NSData *data12= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [fh1 writeData:data12];
//        [fh1 closeFile];
//        
//        NSLog(@"计步：只有一天数据写完");
//    }
//    
//    /****************计步历史数据处理完毕********************************/
//   // bufferDataFor = nil;
//    [bufferDataFor resetBytesInRange:NSMakeRange(0, [bufferDataFor length])];
//    [bufferDataFor setLength:0];
//    
//    [bufferDataFortwo resetBytesInRange:NSMakeRange(0, [bufferDataFor length])];
//    [bufferDataFortwo setLength:0];
//
//   // bufferDataFortwo = nil;
//    rtfilepackageint = 0;
//    stepsfilepackageint = 0;
//    pctimesteps = 1;
//    pctime = 1;
//    RTtime = 1;
//    SPtime = 1;
//    _alllength = 0;
//    
//}
@end






