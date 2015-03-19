//
//  MainiSeedViewController.m
//  iSeed
//
//  Created by elias kang on 14-11-26.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import "MainiSeedViewController.h"
#import "RESideMenu.h"
#import "XYAlertViewHeader.h"
#import "Sntmp.h"
#import "FVCustomAlertView.h"
#import "AFNetworkReachabilityManager.h"
#import "AppDelegate.h"
#import "SPView.h"
@interface MainiSeedViewController ()
@property (strong,nonatomic) NSString *usrname;

@property BLEdebug *currentperipheral;
@end

@implementation MainiSeedViewController
{
    NSThread *thread;
    int rtv;
    XYLoadingView *loadingView;
    NSMutableArray *CBperArray;
    NSMutableArray *RssiArray;
    NSUserDefaults *user;
    UILabel *simlabel;
    NSMutableArray *arraychar;
    SPView *Spcharview;
}
@synthesize customview;
@synthesize my;
@synthesize currentperipheral;
@synthesize animatbutton;
@synthesize refreshbutton;
@synthesize state;
static int i,a1,a2,a3,a4,a5,aver,j;
//post用法
- (void)postHttpUrl:(NSString *)urlString postInfo:(NSDictionary *)info state:(int)state
//
{
    NSURL * url = [NSURL URLWithString:@"http://115.29.205.2:8080/PregnantHealth"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    
    [httpClient postPath:urlString parameters:info success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        //系统自带JSON解析
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"ok result = %@",[resultDic objectForKey:@"result"]);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"由于网络原因失败error = %@",error.localizedDescription);
        
    }];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    arraychar = [NSMutableArray array];
    //self.view.backgroundColor = [UIColor blueColor];
    _blesta = 0;
    user = [NSUserDefaults standardUserDefaults];
    self.view.backgroundColor = [UIColor clearColor];
    NSInteger bluethState = self.my.state;
    CBperArray = [[NSMutableArray alloc]init];
    RssiArray = [[NSMutableArray alloc]init];
    switch (bluethState) {
        case 4:
        {
            //手机蓝牙处于关闭状态
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedStringFromTable(@"alert_OpenPhoneBluetooth_Message",@"MyLoaclization" , @"") delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"alert_OpenPhoneBluetooth_CancelButtonTittle",@"MyLoaclization" , @"") otherButtonTitles:nil, nil];
            
            [alert show];
            return;
            break;
        }
        case 5:
        {
            //蓝牙处于打开状态
            break;
        }
            
        default:
            break;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    //imageView.image = [UIImage imageNamed:@"homepagebackground1231.png"];
    [imageView setImage:[UIImage imageNamed:MainViewImage]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:imageView];                      //背景图片

    
   
    // Do any additional setup after loading the view from its nib.
    //[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    /*****************蓝牙********************/
    self.my = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    /****************************************/

  
    //导航栏视图设置   左按键设置  自定义的图标
        UIButton *lbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        lbutton.frame = CGRectMake(0, 0, 20,16 ); //(0, 0, 12, 16)
        UIImage *icon3 = [UIImage imageNamed:RidemenuButtonImage ];
        CGSize itemSize3 = CGSizeMake(15, 15);
        UIGraphicsBeginImageContextWithOptions(itemSize3, NO ,0.0);
        CGRect imageRect3 = CGRectMake(0.0, 0.0, itemSize3.width, itemSize3.height);
        [icon3 drawInRect:imageRect3];
        icon3 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        [lbutton setBackgroundImage:icon3 forState:UIControlStateNormal]; //modify 1204
       [lbutton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:lbutton];
        self.navigationItem.leftBarButtonItem=leftButton;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"Navigation_Rightbutton_Titil",@"MyLoaclization" , @"") style:UIBarButtonItemStylePlain target:self action:@selector(disconnectBle)];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
     //self.navigationController.navigationBar.barTintColor = NAVIGATIONBAR_BACKCOLOR;
    //title字体颜色和返回键设置
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
       
    //圆环配置
    CGRect framera = CGRectMake(40, 90, 240, 240);
    
    customview = [self progressViewWithFrame:framera];
    customview.progressCounter =3 ;
    customview.progressTotal = 10;
    customview.clockwise = NO;
    
    customview.theme.thickness = 30;
    customview.theme.sliceDividerHidden = NO;
    customview.theme.sliceDividerColor = [UIColor whiteColor];
    customview.theme.sliceDividerThickness = 2;
    customview.label.textColor = [UIColor colorWithRed:165.0/255 green:175.0/255 blue:176.0/255 alpha:1];
    customview.label.text = NSLocalizedStringFromTable(@"Mainview_ConnectBLE", @"MyLoaclization" , @"");
    customview.label.font = [UIFont boldSystemFontOfSize:20];
    // customview.label.hidden = YES;
    customview.realtimeShow = YES;
    //customview.backgroundColor = [UIColor colorWithRed:131.0/255 green:204.0/255 blue:210.0/255 alpha:1];
    //customview.fixedringColornums = 60;
    [self.view addSubview:customview];
    
    
    animatbutton = [[UIButton alloc]initWithFrame:CGRectMake centrlbutton_size];
    [animatbutton addTarget:self action:@selector(animatbuttonselect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:animatbutton];
    
    
   // UIButton *shareSDKbutton = [[UIButton alloc]initWithFrame:CGRectMake(270, 100, 25, 19)];
    UIButton *shareSDKbutton = [[UIButton alloc]initWithFrame:CGRectMake(270, 100, 25, 19)];
    [shareSDKbutton setImage:[UIImage imageNamed:MainViewShareImage] forState:UIControlStateNormal];
    [shareSDKbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.view addSubview:shareSDKbutton];
    
    [shareSDKbutton addTarget:self action:@selector(shareToFD) forControlEvents:UIControlEventTouchUpInside];
    

 
    simlabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 200, 40, 40)];
    simlabel.font = [UIFont systemFontOfSize:25];
    simlabel.center = CGPointMake(self.view.center.x, self.view.center.y-30);
    simlabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:simlabel];
    
}

-(void)shareToFD
{
   // NSString *title = [[NSString alloc]initWithFormat:@"我现在正在使用iBirthstone"];
   //NSLog(@"enabledRemoteNotificationTypes = %@",[[UIApplication sharedApplication] currentUserNotificationSettings]);
    
    UIImage *image = [UIImage imageNamed:ShareSDKImage];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:NSLocalizedStringFromTable(@"Mainview_ShareText",@"MyLoaclization" , @""),rtv]
                                       defaultContent:[NSString stringWithFormat:NSLocalizedStringFromTable(@"Mainview_ShareText",@"MyLoaclization" , @""),rtv]
                                                image:[ShareSDK jpegImageWithImage:image quality:1.0]
                                                title:@"Vipsoe"
                                                  url:@"http://www.vipose.com"
                                          description:[NSString stringWithFormat:NSLocalizedStringFromTable(@"Mainview_ShareText",@"MyLoaclization" , @""),rtv]
                                            mediaType:SSPublishContentMediaTypeNews];
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
                                          content:INHERIT_VALUE
                                            title:[NSString stringWithFormat:NSLocalizedStringFromTable(@"Mainview_ShareText",@"MyLoaclization" , @""),rtv]
                                              url:@"http://www.vipose.com/#link_down"
                                            image:INHERIT_VALUE
                                     musicFileUrl:INHERIT_VALUE
                                          extInfo:INHERIT_VALUE
                                         fileData:INHERIT_VALUE
                                     emoticonData:INHERIT_VALUE];
    [publishContent addQQUnitWithType:INHERIT_VALUE content:INHERIT_VALUE title:[NSString stringWithFormat:NSLocalizedStringFromTable(@"Mainview_ShareText",@"MyLoaclization" , @""),rtv] url:@"http://www.vipose.com/#link_down" image:INHERIT_VALUE];
    
    id<ISSContainer> container = [ShareSDK container];
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiTimeline,ShareTypeQQ,nil];
    //   [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state1, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state1 == SSResponseStateSuccess)
                                {
                                    [FVCustomAlertView showDefaultDoneAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Mainview_SharesuccesText",@"MyLoaclization" , @"")];
                                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
                                }
                                else if (state1 == SSResponseStateFail)
                                {
                                    [FVCustomAlertView showDefaultDoneAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Mainview_SharefaileText",@"MyLoaclization" , @"")];
                                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
                                }
                            }];
    


}

//-(void)changeLoadingViewState:(NSNotification *)noti
//{
//
//    NSLog(@"你好啊");
//
//}

-(EKCustomProgressView *)progressViewWithFrame:(CGRect)frame
{
    EKCustomProgressView *view = [[EKCustomProgressView alloc]initWithFrame:frame];
    view.center = CGPointMake(self.view.center.x, self.view.center.y);
    
    return view;
}


#pragma mark 连接按钮动作
-(void)animatbuttonselect
{
    
        //  NSInteger bluthState = self.my.state;
        NSInteger State = self.my.state;
        switch (State) {
            case 4: //关闭状态
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"Alret_Title",@"MyLoaclization" , @"") message:NSLocalizedStringFromTable(@"Alret_Message",@"MyLoaclization" , @"") delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Alret_Okbutton",@"MyLoaclization" , @"") otherButtonTitles:nil, nil];
                alert.tag = 1;
                [alert show];
                
            }
                
                break;
            case 5:
            {
                [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scanTimer) userInfo:nil repeats:NO];
                [self.my scanForPeripheralsWithServices:@[BLEdebug.uartServiceUUID] options:@{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}];
                NSLog(@"wait connect peripheral! ");
                customview.label.font = [UIFont systemFontOfSize:20.0];
                customview.label.text = NSLocalizedStringFromTable(@"Button_ScanforBle_Title",@"MyLoaclization" , @"");
                // [self.my scanForPeripheralsWithServices:@[BLEdebug.deviceBattyServiceUUID] options:@{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}];
                
                XYLoadingView *loadingView1 = XYShowLoading(NSLocalizedStringFromTable(@"Loading_Title",@"MyLoaclization" , @""));
                
                [loadingView1 performSelector:@selector(dismiss) withObject:nil afterDelay:6];
                thread = [[NSThread alloc]initWithTarget:self selector:@selector(runthread) object:nil];
                
                
                animatbutton.enabled = NO;
                _connectlabel.hidden = YES;
                
            }
                break;
            default:
                break;
        }
    
    
}


-(void)scanTimer
{
    [self.my stopScan];
    CBPeripheral *myperipheral;
    
    if (CBperArray.count>1) {
    do{
        if ([RssiArray objectAtIndex:0]>=[RssiArray objectAtIndex:1]) {
            [CBperArray removeObjectAtIndex:1];
            [RssiArray removeObjectAtIndex:1];
        }
        else{
            [CBperArray removeObjectAtIndex:0];
            [RssiArray removeObjectAtIndex:0];
        }
        i--;
        NSLog(@"rssiarry = %@",RssiArray);
        NSLog(@"CBarray = %@",CBperArray);
        NSLog(@"rcount = %ld  CBcount = %ld",RssiArray.count,CBperArray.count);
    } while (CBperArray.count>1);
     
    }

    myperipheral = [CBperArray objectAtIndex:0];
    NSLog(@"connect id = %@",myperipheral.identifier);
    
    for (CBPeripheral *b in CBperArray) {  //优先保存过的mac
        if ([[NSString stringWithFormat:@"%@",b.identifier] isEqual:[user objectForKey:USERDEFAULTS_BLENAME]]) {
            myperipheral = b;
            NSLog(@"连接上以保存过的ble");
        }
    }
    
    
    
    
    [user setObject:[NSString stringWithFormat:@"%@",myperipheral.identifier] forKey:USERDEFAULTS_BLENAME]; //保存mac地址
    [user synchronize];
    
    self.currentperipheral = [[BLEdebug alloc] initwithPeripheral:myperipheral delegate:self];
    [self.my connectPeripheral:myperipheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(BleisState) userInfo:nil repeats:NO];
    
}
-(void)BleisState
{
    if (_blesta==0) {
        customview.label.text =NSLocalizedStringFromTable(@"Button_DisscanforBle_Title",@"MyLoaclization" , @"");
        animatbutton.enabled = YES;
    }


}

-(void)runthread
{
     [self.currentperipheral readBattry];
    while (![NSThread currentThread].isCancelled) {
        [self changevalue];
       
        [NSThread sleepForTimeInterval:1];
       
    }
    
    
}




-(void)rmalert
{
    [FVCustomAlertView hideAlertFromView:self.view fading:YES];

}




-(void)changevalue
{
    
        [self.currentperipheral writeRtValue];
    
        self.animatbutton.enabled= NO;
}
-(void)disconnectBle
{
    [self.my cancelPeripheralConnection:self.currentperipheral.peripheral];
    self.animatbutton.enabled = YES;
    customview.label.text = NSLocalizedStringFromTable(@"Button_DisconnectBle_Title",@"MyLoaclization" , @"");
    customview.label.font = [UIFont systemFontOfSize:20];
    [thread cancel];
  
    refreshbutton.enabled = NO;
    [loadingView dismiss];
  //  [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:@"蓝牙连接已断开"];
}



#pragma mark 蓝牙模块
//打印方法
-(void) didread:(int)label1 label2:(long)label2 label3:(int)label3 states:(int)sta
{
    int rtvalue = (float)label1/1.317;
    rtv = 0;
    if (label1<100 ){
        rtvalue = 1;
        rtv = 1;
    }
    else if (label1>400)
    {
        rtvalue = 60;
        rtv = 100;
    }
    else
    {
        rtvalue = (float)(label1-100)/5;
        rtv = (label1-100)/3;
        
    }
   

       int rtvv;
    if (j<6) {
       rtvv= [self fun:rtv flag:j];
        j++;
    }
    else
       rtvv= [self fun:rtv flag:0];
    if (rtvv>65) {
        customview.label.textColor = [UIColor redColor];
        customview.label.text =[NSString stringWithFormat:NSLocalizedStringFromTable(@"Mainview_Danger",@"MyLoaclization" , @"")];
        customview.label.font = [UIFont boldSystemFontOfSize:32];
        simlabel.textColor = [UIColor redColor];
    }
    else{
        customview.label.text =[NSString stringWithFormat:NSLocalizedStringFromTable(@"Mainview_Safe",@"MyLoaclization" , @"")];
        customview.label.font = [UIFont boldSystemFontOfSize:32];
        customview.label.textColor = [UIColor colorWithRed:165.0/255 green:175.0/255 blue:176.0/255 alpha:1];
        simlabel.textColor = [UIColor colorWithRed:165.0/255 green:175.0/255 blue:176.0/255 alpha:1];
    }
    simlabel.text = [NSString stringWithFormat:@"%d",rtvv];
   // NSInteger RTvalue = rtvv;
    NSLog(@"RTV = %d",rtv);
    NSLog(@"rtvv = %d",rtvv);
    [arraychar addObject:[NSString stringWithFormat:@"%d",rtvv]];
  
    [customview setfixedRingone:rtvv/5*3];
}

#pragma mark 实例化自动运行方法
-(void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"peripheral name = %@ rssi = %@ id = %@", peripheral.name,RSSI,peripheral.identifier);
    if ([peripheral.name isEqual:@"V0"]) {
        [RssiArray addObject:RSSI];
        [CBperArray addObject:peripheral];
//    [self.my stopScan];
//    self.currentperipheral = [[BLEdebug alloc] initwithPeripheral:peripheral delegate:self];
//    [self.my connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
    }
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if ([peripheral.name isEqual:@"V0"]) {
        
    
    [self.currentperipheral didconnect];
    NSLog(@"Did connect peripheral! %@",peripheral.name);
    NSLog(@"Did connect peripheral! %@",peripheral.identifier);
    
    
        
        
        
    refreshbutton.enabled = YES;
    _blesta = 1;
    //NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"1" forKey:USERDEFAULTS_BLESTATE];
    [user synchronize];
    self.navigationItem.rightBarButtonItem.enabled =YES;
        
    }
}
-(void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (error) {
        NSLog(@"Disdisconnect faild! %@",error);
         //[self.currentperipheral diddisconnect];
    }
    [thread cancel];
    
    [self.currentperipheral diddisconnect];
    self.animatbutton.enabled = YES;
    [loadingView dismiss];
   // [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:@"蓝牙连接已断开"];
    customview.label.text = NSLocalizedStringFromTable(@"Button_DisconnectBle_Title",@"MyLoaclization" , @"");
    customview.label.font = [UIFont systemFontOfSize:20];
    _blesta=0;
   // NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"0" forKey:USERDEFAULTS_BLESTATE];
    [user synchronize];
    
    
}
-(void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    if(central.state == CBCentralManagerStatePoweredOn)
    {
    }
}

-(void)threadrun
{
   
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        [thread start];
        
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
   UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

-(void)blehistory
{
    [self.currentperipheral clearndata];
    NSLog(@"历史界面更新历史");
}

-(void)WarmingON
{
    [self.currentperipheral WarmingON];
}
-(void)WarmingOFF
{
    [self.currentperipheral WarmingOFF];

}

-(int)readbat
{
    return [self.currentperipheral readBattry];
}

-(int)fun:(int)a flag:(int)flag
{
    int a_return = 0;
    switch(flag){
    case 5:
            a1 = a;
            a_return = a1;
            aver = (a1+a2+a3+a4+a5)/5;
            break;
    case 4:
        a2 = a;
            a_return = a2;
            break;
    case 3:
        a3 = a;
            a_return = a3;
            break;
    case 2:
        a4 = a;
            a_return = a4;
            break;
    case 1:
        
        a5 = a;
            a_return = a5;
        
            break;
    case 0:
        {
            
            
            if (abs(a-aver)<6)
            {
                a5 = a4;
                a4 = a3;
                a3 = a2;
                a2 = a1;
                a1 = a;
                a_return = a1;
            }else
            { i++;
                
                if(i==2){
                    i=0;
                    a5 = a4;
                    a4 = a3;
                    a3 = a2;
                    a2 = a1;
                    a1 = a;
                    a_return =a ;
                    
                    
                }else{
                    a_return = a1;
                    
                }
            
            
        }
    }
            break;
    }
    return  a_return;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
