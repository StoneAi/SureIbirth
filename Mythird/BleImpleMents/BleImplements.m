//
//  BleImplements.m
//  nordicBLEdemo
//
//  Created by Chan Bill on 15/3/18.
//  Copyright (c) 2015年 Vipose. All rights reserved.
//

#import "BleImplements.h"

@interface BleImplements()
@property CBService *uartService;
@property CBCharacteristic *rxCharacteristic;
@property CBCharacteristic *txCharacteristic;
@property int rtfilepackageint;
@property int stepsfilepackageint;
@end


@implementation BleImplements
{
    NSMutableData *bufferDataFor;
    NSMutableData *bufferDataFortwo;
    NSUserDefaults *user;
    int16_t  pctime;
    int16_t pctimesteps;
    
}
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

static int RTtime = 1;
static int SPtime = 1;
@synthesize rtfilepackageint;
@synthesize stepsfilepackageint;



- (BleImplements *) initwithPeripheral:(CBPeripheral*) peripheral delegate:(id<BleImplementsDelegate>) delegate
{
    user = [NSUserDefaults standardUserDefaults];
    _peripheral = peripheral;
    _peripheral.delegate = self;
    _delegate = delegate;
    NSLog(@"peripheral: Did initPeripheral!");
    bufferDataFortwo = [[NSMutableData alloc] init];
    bufferDataFor = [[NSMutableData alloc]init];
    pctime = 0x01;
    pctimesteps = 0x01;
    return self;
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
            
            [self.peripheral discoverCharacteristics:@[self.class.hardwareRevisionStringUUID] forService:s];
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
        }
        else if ([c.UUID isEqual:self.class.rxCharacteristicUUID])
        {
            NSLog(@"peripheral: found RX characteristic!");
            self.rxCharacteristic = c;
            [self.peripheral setNotifyValue:YES forCharacteristic:self.rxCharacteristic];
        }
    }
    
    
}


-(void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"error receiving notification for characteristic %@: %@",characteristic,error);
        return;
    }
    
    //收到下位机命令
    NSLog(@"peripheral: received data from a charcteristic!");
    if (characteristic == self.rxCharacteristic) {
        
        unsigned char *bufferr = (unsigned char *)[[characteristic value] bytes];
        
        NSLog(@"commd=%d",bufferr[2]);
        [self GetData:bufferr];
        
    }
}


-(void)didconnect
{
    [_peripheral discoverServices:@[self.class.uartServiceUUID,self.class.deviceInformationServiceUUID]];
    NSLog(@" Did start connected.");

}
-(void) diddisconnect
{



}






-(void)GetData:(unsigned char *)buff
{
    switch (buff[2]) {
        case 0x81: //获取软硬版本
            NSLog(@"buff[5] = %d",bufferr[5]);
            NSLog(@"buff[6] = %d",bufferr[6]);
            NSString * version = [NSString stringWithFormat:@"%d.%d",bufferr[5],bufferr[6]];
            NSLog(@"version = %@",version);
//            NSLog(@"save = %@",[user objectForKey:@"version"]);
//            if ([[user objectForKey:@"version"] isEqual:version]) {
//                AppDelegateAccessor.isFirmwareNeedUpdate = NO;
//                NSLog(@"不需要更新固件");
//            }
//            else
//            {
//                AppDelegateAccessor.isFirmwareNeedUpdate = YES;
//                NSLog(@"固件需要更新");
//            }

            break;
        case 0x82: //获取设备电池电量
            [user setObject:[NSString stringWithFormat:@"%d",buff[3]] forKey:@"Battay"];
            [user synchronize];
            break;
        case 0xa1: //获取运动数据
            [self.delegate ReadStepValue:[NSString stringWithFormat:@"%d",[self ReadValue:buff]]];
            break;
        case 0xa3: // 获取辐射数据
            [self.delegate ReadRtValue:[NSString stringWithFormat:@"%d",[self ReadValue:buff]]];
            break;
         // 获取辐射历史
        case 0xc0:
            [self readfilelength:buff];
            break;
        case 0xc1:
            [self readdatafromfor:buff];
            break;
        case 0xc2:
            [self checkeverydata:buff];
            break;
        case 0xc3:
            [self checkeverydata:buff];
            break;
            
            //获取运动历史
        case 0xc4:
            [self readMovelength:buff];
            break;
        case 0xc5:
            [self stepsreaddatafromfor:buff];
            break;
        case 0xc6:
            [self stepscheckeverydata:buff];
            break;
        case 0xc7:
            [self stepscheckeverydata:buff];
            break;
            
            
        default:
            break;
    }







}





#pragma mark BleCommond

-(void) writeRtValue
{
    Byte arry[] = {0xAA,0x01,0x23,0x00};
    NSData *data = [[NSData alloc] initWithBytes:arry length:4];
    [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
    
}

-(void)WTBattay
{
    Byte arry[] = {0xAA,0x01,0x02,0x00};
    NSData *data = [[NSData alloc] initWithBytes:arry length:4];
    [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
}

-(void)WtFirmware
{
    Byte arry[] = {0xAA,0x01,0x01,0x00};
    NSData *data = [[NSData alloc] initWithBytes:arry length:4];
    [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];

}


-(void)Warming:(BOOL)IsOn
{
    if (IsOn) {
        Byte arry[] = {0xAA,0x08,0x0D,0x01,0x05,0x02,0x00,0x00,0x00,0x00,0x00};
        NSData *data = [[NSData alloc] initWithBytes:arry length:11];
        
        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
    }
    else{
        Byte arry[] = {0xAA,0x08,0x0D,0x00,0x05,0x02,0x00,0x00,0x00,0x00,0x00};
        NSData *data = [[NSData alloc] initWithBytes:arry length:11];
     
        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}


-(void)SetDuf
{
    Byte arry[] = {0xAA,0x05,0x03,0xcd,0x05,0x01,0xdd,0x00};
    NSData* data = [[NSData alloc] initWithBytes:arry length:8];
    [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
}



-(void)GetHistory
{
    Byte arry[] = {0xAA,0x01,0x40,0x00};
    NSData* data = [[NSData alloc] initWithBytes:arry length:4];
    [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
}


#pragma mark 历史数据解析方法

-(void)readfilelength:(unsigned char *)buff
{
    
    rtfilepackageint =(((buff[3]<<24)&0xff000000)|((buff[4]<<16)&0xff0000)|((buff[5]<<8)&0xff00)|(buff[6]&0xff))*2;
    if (rtfilepackageint>0) {
        Byte arry[] = {0xAA,0x06,0x41,0x00,0x00,0x00,pctime,0x00,0x00};
        NSData *data1 = [[NSData alloc] initWithBytes:arry length:9];
        [self.peripheral writeValue:data1 forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"请求发送第一个包");
    }
  
}



-(void)readdatafromfor:(unsigned char*)buff
{
    
    int ret = (buff[1]-1);
    if (ret!=16) {
        NSLog(@"辐射：收到最后一次数据");
    }
    else
        NSLog(@"辐射：收到第%d次数据",RTtime);
    
    
    int array[ret];
    for (int i = 0; i<ret; i++) {
        array[i]=buff[i+3];
    }
    if (bufferDataFor.length<rtfilepackageint) {
        [bufferDataFor appendBytes:array length:ret];
    }
    NSLog(@"buffer.length = %ld     rtfint = %d",bufferDataFor.length,rtfilepackageint);
    if ((bufferDataFor.length%1024==0&&bufferDataFor.length>0)|(bufferDataFor.length>=rtfilepackageint)) {
        Byte arry[] = {0xAA,0x05,0x42,0x00,0x00,0x00,pctime,0x00};
        NSLog(@"pctime = %hd",pctime);
        NSData *data1 = [[NSData alloc] initWithBytes:arry length:8];
        [self.peripheral writeValue:data1 forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        //  [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        pctime++;
    }
    RTtime++;
    
}
-(void)checkeverydata:(unsigned char*)buff
{
    NSLog(@"累加和为%d",buff[3]);
    NSLog(@"buffer.length = %ld     rtfint = %d",bufferDataFor.length,rtfilepackageint);
    if (bufferDataFor.length>=rtfilepackageint) {
        Byte arry[] = {0xAA,0x05,0x43,0x00};
        NSData *data1 = [[NSData alloc] initWithBytes:arry length:4];
        [self.peripheral writeValue:data1 forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        //       [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"请求全部校验");
        [self actionmove];
        pctime=1;
    }
    else{
        
        Byte arry[] = {0xAA,0x06,0x41,0x00,0x00,0x00,pctime,0x00,0x00};
        NSData *data1 = [[NSData alloc] initWithBytes:arry length:9];
        [self.peripheral writeValue:data1 forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        //  [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"辐射:第%d次请求校验",pctime);
    }
    
}

-(void)actionmove
{
    
        Byte arry[] = {0xAA,0x01,0x44,0x00};
        NSData *data = [[NSData alloc] initWithBytes:arry length:4];
//    NSData *data1 = [[NSData alloc] initWithData:[self SimpleCommond:BleCmGetStepHistoryLength]];
//    [self.delegate SendToDevice:data1];
     [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
    NSLog(@"Clearn:  RTdata: WithOutResponse is already sendmessage!");
    NSLog(@"请求下位机发送运动历史数据");
    
}

-(void)readMovelength:(unsigned char *)buff
{
 
    stepsfilepackageint =(((buff[3]<<24)&0xff000000)|((buff[4]<<16)&0xff0000)|((buff[5]<<8)&0xff00)|(buff[6]&0xff))*2;
    NSLog(@"步长 总共长度为%d",stepsfilepackageint);
    if (stepsfilepackageint>0) {
        Byte arry[] = {0xAA,0x06,0x45,0x00,0x00,0x00,pctimesteps,0x00,0x00};
        NSData *data = [[NSData alloc] initWithBytes:arry length:9];
        
        //remove 2015 0114
        [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"步长 请求发送第一个包");

    }
}

-(void)stepsreaddatafromfor:(unsigned char*)buff
{
    
    
    int ret = (buff[1]-1);
    if (ret!=16) {
        NSLog(@"步长 收到最后一次不完整的的数据");
    }
    else
        
        NSLog(@"步长 收到第%d次数据",SPtime);
    
    int array[ret];
    
    for (int i = 0; i<ret; i++) {
        array[i]=buff[i+3];
    }
    if (bufferDataFortwo.length<stepsfilepackageint) {
        [bufferDataFortwo appendBytes:array length:ret];
    }
    
    if (bufferDataFortwo.length%1024==0|bufferDataFortwo.length>=stepsfilepackageint) {
        Byte arry[] = {0xAA,0x05,0x46,0x00,0x00,0x00,pctimesteps,0x00};
        NSData *data = [[NSData alloc] initWithBytes:arry length:8];
            [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"计步:第%d次请求校验",pctimesteps);
        pctimesteps++;
    }
    SPtime++;
    
}
-(void)stepscheckeverydata:(unsigned char*)buff
{
    NSLog(@"步长 累加和为%d",buff[3]);
    
    if (bufferDataFortwo.length>=stepsfilepackageint) {
                Byte arry[] = {0xAA,0x05,0x47,0x00};
                NSData *data = [[NSData alloc] initWithBytes:arry length:4];
           [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"步长 请求全部校验");
        [self.delegate ReadHistory:bufferDataFor Steps:bufferDataFortwo];
        pctimesteps=1;
        [self clearalldata];
    }
    else{
        Byte arry[] = {0xAA,0x06,0x45,0x00,0x00,0x00,pctimesteps,0x00,0x00};
        NSData *data = [[NSData alloc] initWithBytes:arry length:9];
        
          [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
    }
    
    
}

-(void)clearalldata
{
    [bufferDataFor resetBytesInRange:NSMakeRange(0, [bufferDataFor length])];
    [bufferDataFor setLength:0];
    
    [bufferDataFortwo resetBytesInRange:NSMakeRange(0, [bufferDataFor length])];
    [bufferDataFortwo setLength:0];
    
    // bufferDataFortwo = nil;
    rtfilepackageint = 0;
    stepsfilepackageint = 0;
    pctimesteps = 1;
    pctime = 1;
    RTtime = 1;
    SPtime = 1;
    
}

-(int) ReadValue:(unsigned char *)buffer
{
    unsigned char * cfg = (unsigned char *)buffer;
    int num1,num2,num3,num4;
    // NSLog(@"辐射值");
    
    
    num1 = (cfg[3]<<8&0xff00)|(cfg[4]&0xff);
    num2 = (cfg[5]<<8&0xff00)|(cfg[6]&0xff);
    num3 = (cfg[7]<<8&0xff00)|(cfg[8]&0xff);
    num4 = (cfg[9]<<8&0xff00)|(cfg[10]&0xff);
    NSLog(@"num1 = %d",num1);
    return num1;
}



@end
