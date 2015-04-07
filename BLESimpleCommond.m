//
//  BLESimpleCommond.m
//  iSeed
//
//  Created by Chan Bill on 15/3/2.
//  Copyright (c) 2015年 elias kang. All rights reserved.
//

//阈值问题，需要后期补充算法。
#import "BLESimpleCommond.h"
@interface BleSimpleCommond()

@end

@implementation BleSimpleCommond
{
    COMMOND BleCommond;
    NSData * datae;
    HistoyType history;
        int alllength;
    NSUserDefaults *userDefaults;
    NSString *  locationString;
    NSString *rthistoryPath;
    
    NSString *stepshistoryPath;
    
    
    
    NSFileHandle *fh;
    NSFileHandle *fhand;
    NSString *NAMEFORUSER;
    
    int16_t  pctime;
    int16_t pctimesteps;
    
    int pages;
}
@synthesize bufferDataFor;
@synthesize bufferDataFortwo;
@synthesize rtfilepackageint;
@synthesize stepsfilepackageint;
static int RTtime = 1;
static int SPtime = 1;
int pagessteps;
int alllengthsteps;


-(id)init
{
    self = [super init];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    NAMEFORUSER = [userDefaults objectForKey:USERDEFAULTS_USERNAME];
     bufferDataFortwo = [[NSMutableData alloc] init];
    bufferDataFor = [[NSMutableData alloc]init];
    pctime = 0x01;
    pctimesteps = 0x01;
    return self;
}

-(NSData *)SimpleCommond:(COMMOND)commond
{
    switch (commond) {
        case 1:{                                                //获取电池电量
            Byte arry[] = {0xAA,0x01,0x02,0x00};
            datae = [[NSData alloc] initWithBytes:arry length:4];
            }
            break;
        case 2:{                                                //启动DFU升级
            Byte arry[] = {0xAA,0x05,0x03,0xcd,0x05,0x01,0xdd,0x00};
            datae = [[NSData alloc] initWithBytes:arry length:8];
            }
            break;
//        case 3:{
//            Byte arry[] = {0xAA,0x01,0x02,0x00};              //设置用户id  绑定
//            data = [[NSData alloc] initWithBytes:arry length:4];
//        }
//            break;
//        case 4:{
//            Byte arry[] = {0xAA,0x01,0x02,0x00};              //  解除绑定
//            data = [[NSData alloc] initWithBytes:arry length:4];
//        }
//            break;
        case 5:{                                                //获取设备版本
            Byte arry[] = {0xAA,0x01,0x01,0x00};
            datae = [[NSData alloc] initWithBytes:arry length:4];
        }
            break;
        case 6:{                                                //获取设备时间
            Byte arry[] = {0xAA,0x01,0x06,0x00};
            datae = [[NSData alloc] initWithBytes:arry length:4];
        }
            break;
        case 7:{                                                //同步设备时间
            Byte arry[] = {0xAA,0x05,0x07,0x00,0x00,0x00,0x00,0x00};
            datae = [[NSData alloc] initWithBytes:arry length:9];
        }
            break;
        case 8:{                                                //获取三轴加速度
            Byte arry[] = {0xAA,0x01,0x20,0x00};
            datae = [[NSData alloc] initWithBytes:arry length:4];
        }
            break;
        case 9:{                                                //获取运动步长数据
            Byte arry[] = {0xAA,0x01,0x21,0x00};
            datae = [[NSData alloc] initWithBytes:arry length:4];
        }
            break;
        case 10:{                                                //获取辐射数据
            Byte arry[] = {0xAA,0x01,0x23,0x00};
            datae = [[NSData alloc] initWithBytes:arry length:4];
        }
            break;
        case 11:{                                                //获取静止采样速率
            Byte arry[] = {0xAA,0x01,0x24,0x00};
            datae = [[NSData alloc] initWithBytes:arry length:4];
        }
            break;
        case 12:{                                                //获取所有数据
            Byte arry[] = {0xAA,0x01,0x26,0x00};
            datae = [[NSData alloc] initWithBytes:arry length:4];
        }
            break;
        case 13:{                                                //获取辐射历史长度
            Byte arry[] = {0xAA,0x01,0x40,0x00};
            datae = [[NSData alloc] initWithBytes:arry length:4];
        }
            break;
        case 14:{                                                //获取辐射历史所有数据的校验码
            Byte arry[] = {0xAA,0x01,0x43,0x00};
            datae = [[NSData alloc] initWithBytes:arry length:4];
        }
            break;
        case 15:{                                                //获取步长历史的长度
            Byte arry[] = {0xAA,0x01,0x44,0x00};
            datae = [[NSData alloc] initWithBytes:arry length:4];
        }
            break;
        case 16:{                                                //获取步长历史所有数据的校验码
            Byte arry[] = {0xAA,0x01,0x47,0x00};
            datae = [[NSData alloc] initWithBytes:arry length:4];
        }
            break;
        case 17:{                                                //获取警告方式
            Byte arry[] = {0xAA,0x01,0x0c,0x00};
            datae = [[NSData alloc] initWithBytes:arry length:4];
        }
            break;
        default:
            break;
    }
    

    return datae;
}

-(void)GetHistory
{
    [self.delegate SendToDevice:[self SimpleCommond:BleCmGetRtHistoryLength]];
}


-(void)GetHistoryData:(HistoyType)type Section:(section)setion Buff:(unsigned char *)buff
{
    switch (type) {
        case 1:
            [self GetRThistory:setion buff:buff];
            break;
        case 2:
            [self GetStepHistory:setion Buff:buff];
            break;
        default:
            break;
    }

}

-(void)GetRThistory:(section)setion buff:(unsigned char *)buff
{
    switch (setion) {
        case 1:
            [self readfilelength:buff];
            break;
        case 2:
            [self readdatafromfor:buff];
            break;
        case 3:
            [self checkeverydata:buff];
            break;
        default:
            break;
    }


}

-(void)readfilelength:(unsigned char *)buff
{
    
    //余数 余下多少个单数
    alllength = (((buff[3]<<24)&0xff000000)|((buff[4]<<16)&0xff0000)|((buff[5]<<8)&0xff00)|(buff[6]&0xff))*2%1024;
    NSLog(@"余数alllength = %d",alllength);
    rtfilepackageint =(((buff[3]<<24)&0xff000000)|((buff[4]<<16)&0xff0000)|((buff[5]<<8)&0xff00)|(buff[6]&0xff))*2;
    NSLog(@"总共长度为%d",rtfilepackageint);
    if (rtfilepackageint>0) {
        
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYYMMdd"];
        locationString=[dateformatter stringFromDate:senddate];
        NSLog(@"%@",locationString);
        [userDefaults setValue:locationString forKey:USERDEFAULTS_LASTTIMEREFRESH];
        [userDefaults synchronize];
        rthistoryPath = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"RTDIR"] stringByAppendingPathComponent:locationString];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:rthistoryPath]) //如果不存在
        {
            NSData *transformstate= [[NSData alloc]initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
            // NSData *transformstate = [[NSData alloc] initWithBytes:@"0" length:1];
            [fileManager createFileAtPath:rthistoryPath contents:transformstate attributes:nil];
            fh = [NSFileHandle fileHandleForWritingAtPath:rthistoryPath];
            //            [fh writeData:transformstate];
            [fh seekToEndOfFile];
        }
        else
        {
            fh = [NSFileHandle fileHandleForUpdatingAtPath:rthistoryPath];
            [fh seekToEndOfFile];
        }
    }
    //有多少个包
    if ((alllength)>0) {
        pages = (((buff[3]<<24)&0xff000000)|((buff[4]<<16)&0xff0000)|((buff[5]<<8)&0xff00)|(buff[6]&0xff))*2/1024+1;
        
    }
    else
    {
        pages = (((buff[3]<<24)&0xff000000)|((buff[4]<<16)&0xff0000)|((buff[5]<<8)&0xff00)|(buff[6]&0xff))*2/1024;
    }
    
    NSLog(@"一共需要包pages = %d",pages);
    
    if (rtfilepackageint==0) {
        NSLog(@"没有历史文件需要下载！");
        NSNotification *loadviewdiss = [NSNotification notificationWithName:@"LoadingDismiss" object:nil userInfo:@{@"result":@"nodata"}];
        [[NSNotificationCenter defaultCenter] postNotification:loadviewdiss];
    }
    else
    {

        Byte arry[] = {0xAA,0x06,0x41,0x00,0x00,0x00,pctime,0x00,0x00};
        NSData *data1 = [[NSData alloc] initWithBytes:arry length:9];
        [self.delegate SendToDevice:data1];
       // [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
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
        [self.delegate SendToDevice:data1];
      //  [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        pctime++;
    }
    RTtime++;
    
    
}
-(void)checkeverydata:(unsigned char*)buff
{
    NSLog(@"累加和为%d",buff[3]);
    NSLog(@"buffer.length = %ld     rtfint = %d",bufferDataFor.length,rtfilepackageint);
    if (bufferDataFor.length>=rtfilepackageint|bufferDataFor.length>=3072) {
        //        Byte arry[] = {0xAA,0x05,0x43,0x00};
        NSData *data1 = [[NSData alloc] initWithData:[self SimpleCommond:BleCmGetRtHistoryCheck]];
        [self.delegate SendToDevice:data1];
 //       [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"请求全部校验");
        [self actionmove];
        pctime=1;
    }
    else{
        
        Byte arry[] = {0xAA,0x06,0x41,0x00,0x00,0x00,pctime,0x00,0x00};
        NSData *data1 = [[NSData alloc] initWithBytes:arry length:9];
        [self.delegate SendToDevice:data1];
      //  [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"辐射:第%d次请求校验",pctime);
    }
    
}

-(void)actionmove
{
    
    //    Byte arry[] = {0xAA,0x01,0x44,0x00};
    //    NSData *data = [[NSData alloc] initWithBytes:arry length:4];
    NSData *data1 = [[NSData alloc] initWithData:[self SimpleCommond:BleCmGetStepHistoryLength]];
    [self.delegate SendToDevice:data1];
   // [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
    NSLog(@"Clearn:  RTdata: WithOutResponse is already sendmessage!");
    NSLog(@"请求下位机发送运动历史数据");
  
}

-(void)GetStepHistory:(section)setion Buff:(unsigned char *)buff
{
    switch (setion) {
        case 1:
            [self readMovelength:buff];
            break;
        case 2:
            [self stepsreaddatafromfor:buff];
            break;
        case 3:
            [self stepscheckeverydata:buff];
            break;
        default:
            break;
    }

}


-(void)readMovelength:(unsigned char *)buff
{
    alllengthsteps = (((buff[3]<<24)&0xff000000)|((buff[4]<<16)&0xff0000)|((buff[5]<<8)&0xff00)|(buff[6]&0xff))*2%1024;
    NSLog(@"步长 余数alllength = %d",alllengthsteps);
    stepsfilepackageint =(((buff[3]<<24)&0xff000000)|((buff[4]<<16)&0xff0000)|((buff[5]<<8)&0xff00)|(buff[6]&0xff))*2;
    NSLog(@"步长 总共长度为%d",stepsfilepackageint);
    if (stepsfilepackageint>0) {
        stepshistoryPath = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"SPDIR"]stringByAppendingPathComponent:locationString];
        
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:stepshistoryPath]) //如果不存在
        {
            // NSData *transformstate= [[NSData alloc] initWithBase64EncodedString:@"1234" options:NSUTF8StringEncoding];
            //  NSData *transformstate = [[NSData alloc] initWithBytes:@"0" length:1];
            //  [fileManager createFileAtPath:stepshistoryPath contents:nil attributes:nil];
            [fileManager createFileAtPath:stepshistoryPath contents:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
            fhand = [NSFileHandle fileHandleForWritingAtPath:stepshistoryPath];
            //        [fhand writeData:transformstate];
            [fhand seekToEndOfFile];
        }
        else
        {
            fhand = [NSFileHandle fileHandleForUpdatingAtPath:stepshistoryPath];
            [fhand seekToEndOfFile];
        }
    }
    //有多少个包
    if ((alllengthsteps)>0) {
        pagessteps = (((buff[3]<<24)&0xff000000)|((buff[4]<<16)&0xff0000)|((buff[5]<<8)&0xff00)|(buff[6]&0xff))*2/1024+1;
        
    }
    else
    {
        pagessteps = (((buff[3]<<24)&0xff000000)|((buff[4]<<16)&0xff0000)|((buff[5]<<8)&0xff00)|(buff[6]&0xff))*2/1024;
    }
    
    NSLog(@"步长 一共需要包pages = %d",pagessteps);
    
    if (pagessteps==0) {
        NSLog(@"步长 没有历史文件需要下载！");
        
    }
    else
    {
        
        
        
        Byte arry[] = {0xAA,0x06,0x45,0x00,0x00,0x00,pctimesteps,0x00,0x00};
        NSData *data = [[NSData alloc] initWithBytes:arry length:9];
        [self.delegate SendToDevice:data];
        //remove 2015 0114
     //   [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
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
        [self.delegate SendToDevice:data];
    //    [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"计步:第%d次请求校验",pctimesteps);
        pctimesteps++;
    }
    SPtime++;
    
}
-(void)stepscheckeverydata:(unsigned char*)buff
{
    NSLog(@"步长 累加和为%d",buff[3]);
    
    if (bufferDataFortwo.length>=stepsfilepackageint|bufferDataFortwo.length>=3072) {
        //        Byte arry[] = {0xAA,0x05,0x47,0x00};
        //        NSData *data = [[NSData alloc] initWithBytes:arry length:4];
        NSData *data = [[NSData alloc] initWithData:[self SimpleCommond:BleCmGetStepHistoryCheck]];
        [self.delegate SendToDevice:data];
     //   [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"步长 请求全部校验");
        // [self.delegate stepswriteInfor];
        //[self savedata];
        [self datachange];
        NSNotification *loadviewdiss = [NSNotification notificationWithName:@"LoadingDismiss" object:nil userInfo:@{@"result":@"true"}];
        [[NSNotificationCenter defaultCenter] postNotification:loadviewdiss];
        pctimesteps=1;
    }
    else{
        Byte arry[] = {0xAA,0x06,0x45,0x00,0x00,0x00,pctimesteps,0x00,0x00};
        NSData *data = [[NSData alloc] initWithBytes:arry length:9];
        [self.delegate SendToDevice:data];
      //  [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
    }
    
    
}


-(void)datachange
{
    NSDate *  senddate=[NSDate date];
    NSInteger h =[[[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:senddate] hour];
    NSInteger m = [[[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:senddate] minute];
    //计算今天到当前时间最多能保存多少个数据   *2
    NSInteger todaydata = (h*60+m)/6*2;
    
  /********************修改buff的顺序**************************/
    Byte *thisRTByte = (Byte *)[bufferDataFor bytes];
    Byte *thisSPByte = (Byte *)[bufferDataFortwo bytes];
    
    NSMutableData *thisRTdata = [[NSMutableData alloc]init];
    NSMutableData *thisSPdata = [[NSMutableData alloc]init];
    
    int RTarray[bufferDataFor.length];
    
    for (int h = 0; h<bufferDataFor.length; h++) {
        RTarray[h] = thisRTByte[bufferDataFor.length-h];
    }
    [thisRTdata appendBytes:RTarray length:bufferDataFor.length];
    
    int SParray[bufferDataFortwo.length];
    for (int h = 0; h<bufferDataFortwo.length; h++) {
        SParray[h] = thisSPByte[bufferDataFortwo.length-h];
    }
    [thisSPdata appendBytes:SParray length:bufferDataFortwo.length];
    
    
    Byte *thisTimeRTByte = (Byte *)[thisRTdata bytes];
    Byte *thisTimeSPByte = (Byte *)[thisSPdata bytes];
    
    /*************************************************/
    
    
//    Byte *thisTimeRTByte = (Byte *)[bufferDataFor bytes];     3.23remove to
//    Byte *thisTimeSPByte = (Byte *)[bufferDataFortwo bytes];

    
    if (bufferDataFor.length>todaydata) {
  
        Byte todayarry[todaydata];  //今天的数据
        for (NSInteger j = 0; j<todaydata; j++) {
            todayarry[j] = thisTimeRTByte[j];
            //  todayarry[i] = thisTimeRTByte[i];
        }
        NSData *data= [[NSData alloc]initWithBytes:todayarry length:todaydata];
        [fh writeData:data];
        [fh closeFile];
        
        NSFileHandle*fh1 = [NSFileHandle fileHandleForWritingAtPath:rthistoryPath];
        [fh1 seekToFileOffset:0];
        NSData *data1= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
        [fh1 writeData:data1];
        [fh1 closeFile];
        NSLog(@"今天的数据已写完");

        
        
        
    NSInteger pastday = (bufferDataFor.length-todaydata)/480;
    NSInteger lostdata = (bufferDataFor.length-todaydata)%480;
    if (lostdata>0) {
        pastday = pastday+1;
    }
        

        
    for (int i =1; i<pastday; i++) {
        NSInteger y = [[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:senddate] year];
        NSInteger mouth =[[[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:senddate] month];
        NSInteger d =[[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:senddate] day];
        NSString *lastdate = [NSString stringWithFormat:@"%ld",y];
        BOOL runyear = ((y%4==0 && y%100 != 0) || y % 400 == 0) ? true : false;
        
        
        if (d-i<10&&d-i>0) {
            if (mouth<10) {
                lastdate = [NSString stringWithFormat:@"%@0%ld0%ld",lastdate,mouth,d-i];
            }
            else
                lastdate = [NSString stringWithFormat:@"%@%ld0%ld",lastdate,mouth,d-i];
        }
        else if(d-i>=10)
            if (mouth<10) {
                lastdate = [NSString stringWithFormat:@"%@0%ld%ld",lastdate,mouth,d-i];
            }
            else
                lastdate = [NSString stringWithFormat:@"%@%ld%ld",lastdate,mouth,d-i];
        else if(d-i<=0)
        {
            if ((mouth-1<10&&mouth-1>0)&&(mouth-1==1|mouth-1==3|mouth-1==5|mouth-1==7|mouth-1==8|mouth-1==10|mouth-1==12)) {
                lastdate = [NSString stringWithFormat:@"%@0%ld%ld",lastdate,mouth-1,31+d-i];
            }
           else if ((mouth-1<10&&mouth-1>0)&&(mouth-1==4|mouth-1==6|mouth-1==9|mouth-1==11)) {
                lastdate = [NSString stringWithFormat:@"%@0%ld%ld",lastdate,mouth-1,30+d-i];
            }
           else if ((mouth-1<10&&mouth-1>0)&&(mouth-1==2)) {
                if (runyear) {
                  lastdate = [NSString stringWithFormat:@"%@0%ld%ld",lastdate,mouth-1,29+d-i];
                }
                else
                  lastdate = [NSString stringWithFormat:@"%@0%ld%ld",lastdate,mouth-1,28+d-i];
            }
            
            
           else if(mouth-1>=10&&(mouth-1==1|mouth-1==3|mouth-1==5|mouth-1==7|mouth-1==8|mouth-1==10|mouth-1==12)) {
               lastdate = [NSString stringWithFormat:@"%@%ld%ld",lastdate,mouth,31+d-i];
           }
           else if ((mouth-1>=10&&mouth-1>0)&&(mouth-1==4|mouth-1==6|mouth-1==9|mouth-1==11)) {
               lastdate = [NSString stringWithFormat:@"%@0%ld%ld",lastdate,mouth-1,30+d-i];
           }
           else if ((mouth-1>=10&&mouth-1>0)&&(mouth-1==2)) {
               if (runyear) {
                   lastdate = [NSString stringWithFormat:@"%@%ld%ld",lastdate,mouth-1,29+d-i];
               }
               else
                   lastdate = [NSString stringWithFormat:@"%@%ld%ld",lastdate,mouth-1,28+d-i];
           }
           else
               lastdate = [NSString stringWithFormat:@"%ld%ld%ld",y-1,mouth-1+12,31+d-i];
        }
    
         NSString *lastRTpaTH = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"RTDIR"] stringByAppendingPathComponent:lastdate];
        
        
        if (i<pastday-1) {

        Byte lastdayarr[480];
        for (NSInteger j = 0; j<480;j++) {
            lastdayarr[j] = thisTimeRTByte[j+todaydata+480*i];
        }

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSFileHandle *lastdayhandl;
        if(![fileManager fileExistsAtPath:lastRTpaTH]) //如果不存在
        {
            NSData *transformstate= [[NSData alloc]initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
            // NSData *transformstate = [[NSData alloc] initWithBytes:@"0" length:1];
            [fileManager createFileAtPath:lastRTpaTH contents:transformstate attributes:nil];
            lastdayhandl = [NSFileHandle fileHandleForWritingAtPath:lastRTpaTH];
            //                [lastdayhandl writeData:transformstate];
            [lastdayhandl seekToEndOfFile];
        }
        else
        {
            lastdayhandl = [NSFileHandle fileHandleForUpdatingAtPath:lastRTpaTH];
            [lastdayhandl seekToEndOfFile];
        }
        
        NSData *data1= [[NSData alloc]initWithBytes:lastdayarr length:480];
        [lastdayhandl writeData:data1];
        [lastdayhandl closeFile];
            
        NSFileHandle*fh1 = [NSFileHandle fileHandleForWritingAtPath:lastRTpaTH];
        [fh1 seekToFileOffset:0];
        NSData *data2= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
        [fh1 writeData:data2];
        [fh1 closeFile];

            
            
        NSLog(@"第%d天的日期为%@",i+1,lastdate);
        NSLog(@"第%d天的数据已写完",i+1);
        lastdate = nil;
            }
        else
        {
            Byte lastdayarr[bufferDataFor.length-todaydata-480*i];
            for (NSInteger j = 0; j<bufferDataFor.length-480*i-todaydata;j++) {
                lastdayarr[j] = thisTimeRTByte[j+todaydata+480*i];
            }
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSFileHandle *lastdayhandl;
            if(![fileManager fileExistsAtPath:lastRTpaTH]) //如果不存在
            {
                NSData *transformstate= [[NSData alloc]initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
                // NSData *transformstate = [[NSData alloc] initWithBytes:@"0" length:1];
                [fileManager createFileAtPath:lastRTpaTH contents:transformstate attributes:nil];
                lastdayhandl = [NSFileHandle fileHandleForWritingAtPath:lastRTpaTH];
                //                [lastdayhandl writeData:transformstate];
                [lastdayhandl seekToEndOfFile];
            }
            else
            {
                lastdayhandl = [NSFileHandle fileHandleForUpdatingAtPath:lastRTpaTH];
                [lastdayhandl seekToEndOfFile];
            }
            
            NSData *data1= [[NSData alloc]initWithBytes:lastdayarr length:bufferDataFor.length-todaydata-480*i];
            [lastdayhandl writeData:data1];
            [lastdayhandl closeFile];
            
            NSFileHandle*fh1 = [NSFileHandle fileHandleForWritingAtPath:lastRTpaTH];
            [fh1 seekToFileOffset:0];
            NSData *data2= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
            [fh1 writeData:data2];
            [fh1 closeFile];

            
            NSLog(@"最后一天的数据已写完");
        }
      }
    }
    else
    {
        NSData *data= [[NSData alloc]initWithData:bufferDataFor];
        [fh writeData:data];
        [fh closeFile];
        
        NSFileHandle*fh1 = [NSFileHandle fileHandleForWritingAtPath:rthistoryPath];
        [fh1 seekToFileOffset:0];
        NSData *data1= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
        [fh1 writeData:data1];
        [fh1 closeFile];
        
//        NSLog(@"辐射数据长度为%ld",bufferDataFor.length);
//        NSLog(@"只有一天的数据");
//        NSLog(@"今天的数据已写完");
       // NSLog(@"辐射数据为%s",todayarry);
    
    
    
    }
    /*******************计步历史***********************/
    if (bufferDataFortwo.length>todaydata) {
        
        Byte todayarry[todaydata];  //今天的数据
        for (NSInteger i = 0; i<todaydata; i++) {
            todayarry[i] = thisTimeSPByte[i];
        }
        NSData *data= [[NSData alloc]initWithBytes:todayarry length:todaydata];
        [fhand writeData:data];
        [fhand closeFile];
        
        NSFileHandle*fh1 = [NSFileHandle fileHandleForWritingAtPath:stepshistoryPath];
        [fh1 seekToFileOffset:0];
        NSData *data1= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
        [fh1 writeData:data1];
        [fh1 closeFile];
        
        NSLog(@"计步：今天的数据已写完");

        
        
        
        
        NSInteger pastday = (bufferDataFortwo.length-todaydata)/480;
        NSInteger lostdata = (bufferDataFortwo.length-todaydata)%480;
        if (lostdata>0) {
            pastday = pastday+1;
        }
        

        for (int i =1; i<pastday; i++) {
            NSInteger y = [[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:senddate] year];
            NSInteger mouth =[[[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:senddate] month];
            NSInteger d =[[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:senddate] day];
            NSString *lastdate = [NSString stringWithFormat:@"%ld",y];
            BOOL runyear = ((y%4==0 && y%100 != 0) || y % 400 == 0) ? true : false;
            
            
            if (d-i<10&&d-i>0) {
                if (mouth<10) {
                    lastdate = [NSString stringWithFormat:@"%@0%ld0%ld",lastdate,mouth,d-i];
                }
                else
                    lastdate = [NSString stringWithFormat:@"%@%ld0%ld",lastdate,mouth,d-i];
            }
            else if(d-i>=10){
                if (mouth<10) {
                    lastdate = [NSString stringWithFormat:@"%@0%ld%ld",lastdate,mouth,d-i];
                }
                else
                    lastdate = [NSString stringWithFormat:@"%@%ld%ld",lastdate,mouth,d-i];
            }
            else if(d-i<=0)
            {
                if ((mouth-1<10&&mouth-1>0)&&(mouth-1==1|mouth-1==3|mouth-1==5|mouth-1==7|mouth-1==8|mouth-1==10|mouth-1==12)) {
                    lastdate = [NSString stringWithFormat:@"%@0%ld%ld",lastdate,mouth-1,31+d-i];
                }
                else if ((mouth-1<10&&mouth-1>0)&&(mouth-1==4|mouth-1==6|mouth-1==9|mouth-1==11)) {
                    lastdate = [NSString stringWithFormat:@"%@0%ld%ld",lastdate,mouth-1,30+d-i];
                }
                else if ((mouth-1<10&&mouth-1>0)&&(mouth-1==2)) {
                    if (runyear) {
                        lastdate = [NSString stringWithFormat:@"%@0%ld%ld",lastdate,mouth-1,29+d-i];
                    }
                    else
                        lastdate = [NSString stringWithFormat:@"%@0%ld%ld",lastdate,mouth-1,28+d-i];
                }
                
                
                else if(mouth-1>=10&&(mouth-1==1|mouth-1==3|mouth-1==5|mouth-1==7|mouth-1==8|mouth-1==10|mouth-1==12)) {
                    lastdate = [NSString stringWithFormat:@"%@%ld%ld",lastdate,mouth,31+d-i];
                }
                else if ((mouth-1>=10&&mouth-1>0)&&(mouth-1==4|mouth-1==6|mouth-1==9|mouth-1==11)) {
                    lastdate = [NSString stringWithFormat:@"%@0%ld%ld",lastdate,mouth-1,30+d-i];
                }
                else
                    lastdate = [NSString stringWithFormat:@"%ld%ld%ld",y-1,mouth-1+12,31+d-i];
            }
            
            NSString *lastSPpaTH = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"SPDIR"] stringByAppendingPathComponent:lastdate];
            
            
            if (i<pastday-1) {
                
                Byte lastdayarr[480];
                for (NSInteger j = 0; j<480;j++) {
                    lastdayarr[j] = thisTimeSPByte[j+todaydata+480*i];
                }
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSFileHandle *lastdayhandl;
                if(![fileManager fileExistsAtPath:lastSPpaTH]) //如果不存在
                {
                    NSData *transformstate= [[NSData alloc]initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
                    // NSData *transformstate = [[NSData alloc] initWithBytes:@"0" length:1];
                    [fileManager createFileAtPath:lastSPpaTH contents:transformstate attributes:nil];
                    lastdayhandl = [NSFileHandle fileHandleForWritingAtPath:lastSPpaTH];
                    //                [lastdayhandl writeData:transformstate];
                    [lastdayhandl seekToEndOfFile];
                }
                else
                {
                    lastdayhandl = [NSFileHandle fileHandleForUpdatingAtPath:lastSPpaTH];
                    [lastdayhandl seekToEndOfFile];
                }
                
                NSData *data1= [[NSData alloc]initWithBytes:lastdayarr length:480];
                [lastdayhandl writeData:data1];
                [lastdayhandl closeFile];
                
                NSFileHandle*fh1 = [NSFileHandle fileHandleForWritingAtPath:lastSPpaTH];
                [fh1 seekToFileOffset:0];
                NSData *data2= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
                [fh1 writeData:data2];
                [fh1 closeFile];
                
                
                
                NSLog(@"计步：第%d天的日期为%@",i+1,lastdate);
                NSLog(@"计步：第%d天的数据已写完",i+1);
                lastdate = nil;
            }
            else
            {
                Byte lastdayarr[bufferDataFortwo.length-todaydata-480*i];
                for (NSInteger j = 0; j<bufferDataFortwo.length-480*i-todaydata;j++) {
                    lastdayarr[j] = thisTimeSPByte[j+todaydata+480*i];
                }
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSFileHandle *lastdayhandl;
                if(![fileManager fileExistsAtPath:lastSPpaTH]) //如果不存在
                {
                    NSData *transformstate= [[NSData alloc]initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
                    // NSData *transformstate = [[NSData alloc] initWithBytes:@"0" length:1];
                    [fileManager createFileAtPath:lastSPpaTH contents:transformstate attributes:nil];
                    lastdayhandl = [NSFileHandle fileHandleForWritingAtPath:lastSPpaTH];
                    //                [lastdayhandl writeData:transformstate];
                    [lastdayhandl seekToEndOfFile];
                }
                else
                {
                    lastdayhandl = [NSFileHandle fileHandleForUpdatingAtPath:lastSPpaTH];
                    [lastdayhandl seekToEndOfFile];
                }
                
                NSData *data1= [[NSData alloc]initWithBytes:lastdayarr length:bufferDataFortwo.length-todaydata-480*i];
                [lastdayhandl writeData:data1];
                [lastdayhandl closeFile];
                
                NSFileHandle*fh1 = [NSFileHandle fileHandleForWritingAtPath:lastSPpaTH];
                [fh1 seekToFileOffset:0];
                NSData *data2= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
                [fh1 writeData:data2];
                [fh1 closeFile];
                
                
                NSLog(@"计步：最后一天的数据已写完");
            }
        }
    }
    else
    {
        
        Byte lastdayarr[bufferDataFortwo.length];
        for (NSInteger j = 0; j<bufferDataFortwo.length;j++) {
            lastdayarr[j] = thisTimeSPByte[j];
        }

        
        
        NSData *data1= [[NSData alloc]initWithData:bufferDataFortwo];
        [fhand writeData:data1];
        [fhand closeFile];
        
        NSFileHandle*fh1 = [NSFileHandle fileHandleForWritingAtPath:stepshistoryPath];
        [fh1 seekToFileOffset:0];
        NSData *data12= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
        [fh1 writeData:data12];
        [fh1 closeFile];

        //NSLog(@"计步数据为%s",todayarry);
//        NSLog(@"计步数据长度为%ld",bufferDataFortwo.length);
//        NSLog(@"计步：只有一天数据");
//        NSLog(@"计步：今天的数据已写完");
        
        
        
    }
    
    
    
    
   [self clearalldata];
}


-(void)clearalldata
{
    fhand = nil;
    fh = nil;
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


@end