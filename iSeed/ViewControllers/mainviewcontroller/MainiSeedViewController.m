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

@interface MainiSeedViewController ()
@property (strong,nonatomic) NSString *usrname;

@property BLEdebug *currentperipheral;
@end

@implementation MainiSeedViewController
{
    NSThread *thread;
    NSThread *threadAnimation;
    NSTimer *timerAnimation;
    int rtv;
    XYLoadingView *loadingView;
    NSMutableArray *CBperArray;
    NSMutableArray *RssiArray;
    NSUserDefaults *user;
    UILabel *simlabel;
    CBPeripheral *simpleperipheral;
    //TODO elias
    CAShapeLayer* _gaugeCircleLayer1;
    UILabel *ralevellab;
    UILabel *beginnumlab;
    UILabel *endnumlab;
    UILabel *raexplab;
    UILabel *raindexlab;
    UILabel *rawordslab;
    leftMenuViewController *left;
    int rtvv;
   
   // NSMutableArray *arraychar;
   
}
@synthesize customview;
@synthesize my;
@synthesize currentperipheral;
@synthesize animatbutton;
@synthesize refreshbutton;
@synthesize state;
@synthesize DbmLable;
static int i,a1,a2,a3,a4,a5,aver,j;


//- (void) viewDidDisappear
//{
//    [timerAnimation invalidate];
//    timerAnimation = nil;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    rtvv = 1;
    self.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
   // arraychar = [NSMutableArray array];
    //self.view.backgroundColor = [UIColor blueColor];
    _blesta = 0;
    user = [NSUserDefaults standardUserDefaults];
    //TODO elias
    self.view.backgroundColor = [UIColor whiteColor];//[UIColor clearColor];
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
    
    //TODO elias
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    //imageView.image = [UIImage imageNamed:@"homepagebackground1231.png"];
//    [imageView setImage:[UIImage imageNamed:MainViewImage]];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    [self.view addSubview:imageView];                      //背景图片

    
   
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
    /*
    CGRect framera = CGRectMake(40, 90, 240, 240);
    
    customview = [self progressViewWithFrame:framera];
    customview.progressCounter =3 ;
    customview.progressTotal = 10;
    customview.clockwise = NO;
    
    customview.theme.thickness = 35;
    customview.theme.sliceDividerHidden = NO;
    customview.theme.sliceDividerColor = [UIColor whiteColor];
    customview.theme.sliceDividerThickness = 2;
    customview.label.textColor = CircleTextColor;
    customview.label.text = NSLocalizedStringFromTable(@"Mainview_ConnectBLE", @"MyLoaclization" , @"");
    customview.label.font = [UIFont boldSystemFontOfSize:20];
    customview.realtimeShow = YES;
    [self.view addSubview:customview];
    */
    
    //customview.label.center = CGPointMake(self.view.center.x, self.view.center.y+40);
    // customview.label.hidden = YES;
    //customview.backgroundColor = [UIColor colorWithRed:131.0/255 green:204.0/255 blue:210.0/255 alpha:1];
    //customview.fixedringColornums = 60;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *date = [[NSDate alloc]init];
    _DateLabel.text = [NSString stringWithFormat:@"%@",[date dateStringWithFormat:@"yyyy-MM-dd"]];
    _DateLabel.textColor = [UIColor grayColor];
    _DateLabel.font = [UIFont systemFontOfSize:15];
    _DateLabel.alpha = 0.3;
    
    
    animatbutton = [[UIButton alloc]initWithFrame:CGRectMake centrlbutton_size];
   // animatbutton.center = CGPointMake(self.view.center.x, self.view.center.y-40);
    [animatbutton addTarget:self action:@selector(animatbuttonselect) forControlEvents:UIControlEventTouchUpInside];
//    [animatbutton setBackgroundImage:[UIImage imageNamed:@"btn_sync0507.png"] forState:UIControlStateNormal];
//    [animatbutton setTitle:NSLocalizedStringFromTable(@"Mainview_ConnectBLE",@"MyLoaclization" , @"") forState:UIControlStateNormal];
    [self.view addSubview:animatbutton];
    
    
   // UIButton *shareSDKbutton = [[UIButton alloc]initWithFrame:CGRectMake(270, 100, 25, 19)];
    //TODO elias
//    UIButton *shareSDKbutton = [[UIButton alloc]initWithFrame:CGRectMake(270, 100, 25, 19)];
//    [shareSDKbutton setImage:[UIImage imageNamed:MainViewShareImage] forState:UIControlStateNormal];
//    [shareSDKbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [self.view addSubview:shareSDKbutton];
//    
//    [shareSDKbutton addTarget:self action:@selector(shareToFD) forControlEvents:UIControlEventTouchUpInside];
    
//单位Label
   // DbmLable = [[UILabel alloc]initWithFrame:CGRectMake(60, 450, 200, 50)];
   // DbmLable.font = [UIFont boldSystemFontOfSize:10];
    //TODO elias
    DbmLable = [[UILabel alloc]initWithFrame:CGRectMake(182, 276, 61, 21)];//187 316 303
    DbmLable.font = [UIFont boldSystemFontOfSize:9];
    //DbmLable.center = CGPointMake(self.view.center.x+48, self.view.center.y-25);
    DbmLable.textAlignment = NSTextAlignmentCenter;
    DbmLable.textColor = [UIColor lightGrayColor];
    DbmLable.text = @"mW/㎡";
    [self.view addSubview:DbmLable];
    DbmLable.hidden = YES;
 
 //DbmLabel
   // simlabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 200, 100, 40)];
    //simlabel.font = [UIFont systemFontOfSize:25];
    //TODO elias
    simlabel = [[UILabel alloc] initWithFrame:CGRectMake(124, 276, 70, 21)];//120 316 244
    simlabel.font = [UIFont boldSystemFontOfSize:17.0];
    simlabel.textColor = [UIColor colorWithRed:60.0/255.0 green:184.0/255.0 blue:120.0/255.0 alpha:1.0];//[UIColor colorWithRed:17.0/225.0 green:255.0/255.0 blue:249.0/255.0 alpha:1.0];
    //simlabel.center = CGPointMake(self.view.center.x, self.view.center.y-30);
    simlabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:simlabel];
    
    //TODO elias
    rawordslab = [[UILabel alloc] initWithFrame:CGRectMake(115, 154, 90, 21)]; //214
    //raindexlab.font = [UIFont boldSystemFontOfSize:71.0];
    rawordslab.font = [UIFont systemFontOfSize:17.0];
    rawordslab.text = NSLocalizedStringFromTable(@"Mainview_liveindex", @"MyLoaclization" , @"");
    rawordslab.textColor = [UIColor lightGrayColor];
    //raindexlab.center = CGPointMake(self.view.center.x, self.view.center.y-30);
    rawordslab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:rawordslab];
    
    
    raindexlab = [[UILabel alloc] initWithFrame:CGRectMake(90, 170, 140, 80)];//237
    //raindexlab.font = [UIFont boldSystemFontOfSize:71.0];
    raindexlab.font = [UIFont systemFontOfSize:17.0];
    raindexlab.text = NSLocalizedStringFromTable(@"Mainview_ConnectBLE", @"MyLoaclization" , @"");
    raindexlab.textColor = CircleTextColor;
    //raindexlab.center = CGPointMake(self.view.center.x, self.view.center.y-30);
    raindexlab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:raindexlab];
    
    
    ralevellab = [[UILabel alloc] initWithFrame:CGRectMake(127, 298, 67, 21)];//338
    ralevellab.font = [UIFont systemFontOfSize:17.0];
   // ralevellab.text = @"SAFE";
    ralevellab.textColor =  [UIColor colorWithRed:60.0/255.0 green:184.0/255.0 blue:120.0/255.0 alpha:1.0]; // [UIColor colorWithRed:17.0/225.0 green:255.0/255.0 blue:249.0/255.0 alpha:1.0];
    //ralevellab.center = CGPointMake(self.view.center.x, self.view.center.y-30);
    ralevellab.textAlignment = NSTextAlignmentCenter;
    ralevellab.hidden = YES;
    [self.view addSubview:ralevellab];
    
    beginnumlab = [[UILabel alloc] initWithFrame:CGRectMake(69, 327, 10, 21)];//367
    beginnumlab.font = [UIFont systemFontOfSize:17.0];
    beginnumlab.text = @"0";
    beginnumlab.textColor = [UIColor lightGrayColor];
    //[UIColor colorWithRed:170.0/225.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0]
    //beginnumlab.center = CGPointMake(self.view.center.x, self.view.center.y-30);
    beginnumlab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:beginnumlab];
    
    endnumlab = [[UILabel alloc] initWithFrame:CGRectMake(226, 327, 39, 21)];//367
    endnumlab.font = [UIFont systemFontOfSize:17.0];
    endnumlab.text = @"100+";
    endnumlab.textColor = [UIColor lightGrayColor];
    //[UIColor colorWithRed:170.0/225.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0]
    //endnumlab.center = CGPointMake(self.view.center.x, self.view.center.y-30);
    endnumlab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:endnumlab];
    
    raexplab = [[UILabel alloc] initWithFrame:CGRectMake(83, 327, 154, 21)]; //367
    raexplab.font = [UIFont systemFontOfSize:11.0];
    raexplab.text = @"ENJOY YOUR TIME";
    raexplab.textColor = [UIColor lightGrayColor];
    //[UIColor colorWithRed:170.0/225.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0]
    //raexplab.center = CGPointMake(self.view.center.x, self.view.center.y-30);
    raexplab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:raexplab];
    
    _belowrauplabel.text = NSLocalizedStringFromTable(@"Mainview_ra_uplabel", @"MyLoaclization" , @"");
    _belowrabelowlable.text = NSLocalizedStringFromTable(@"Mainview_ra_belowlable", @"MyLoaclization" , @"");
    _belowstepuplab.text = NSLocalizedStringFromTable(@"Mainview_step_uplable", @"MyLoaclization" , @"");
    _belowstepbelowlab.text = NSLocalizedStringFromTable(@"Mainview_step_belowlable", @"MyLoaclization" , @"");
    [self circlelayinit];
    
//    UIButton* butt = [[UIButton alloc]initWithFrame:CGRectMake(50, 420, 50, 50) ];
//    butt.backgroundColor = [UIColor blackColor];
//    [butt addTarget:self action:@selector(bu) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:butt];
    
}

-(void)circlelayinit
{
    CGPoint arcCenter = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)-60);
   
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path addArcWithCenter:arcCenter radius:CGRectGetWidth(self.view.bounds) / 3.0f startAngle:(3.0f * M_PI/4) endAngle:(3.0f * M_PI/4) + (6.0f * M_PI/4) clockwise:YES];
    CAShapeLayer* _gaugeCircleLayer = [CAShapeLayer layer];
    _gaugeCircleLayer.lineWidth = 2;
    _gaugeCircleLayer.fillColor = [UIColor clearColor].CGColor;
    _gaugeCircleLayer.strokeColor = [UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:0.3].CGColor;
    _gaugeCircleLayer.strokeStart = 0;
    _gaugeCircleLayer.strokeEnd = 1;
    _gaugeCircleLayer.path = path.CGPath;
    _gaugeCircleLayer.lineCap = kCALineCapRound;
    [self.view.layer addSublayer:_gaugeCircleLayer];
    
    UIBezierPath *Truepath = [UIBezierPath bezierPath];
    [Truepath addArcWithCenter:arcCenter radius:CGRectGetWidth(self.view.bounds) / 3.0f startAngle:(3.0f * M_PI/4) endAngle:(3.0f * M_PI/4) + (6.0f * M_PI/4) clockwise:YES];
    _gaugeCircleLayer1 = [CAShapeLayer layer];
    _gaugeCircleLayer1.lineWidth = 10;
    _gaugeCircleLayer1.fillColor = [UIColor clearColor].CGColor;
    _gaugeCircleLayer1.strokeColor = [UIColor colorWithRed:60.0/255.0 green:184.0/255.0 blue:120.0/255.0 alpha:1.0].CGColor;//[UIColor colorWithRed:17.0/225.0 green:255.0/255.0 blue:249.0/255.0 alpha:1.0].CGColor;
    _gaugeCircleLayer1.strokeStart = 0;
    _gaugeCircleLayer1.strokeEnd = 0.0;
    _gaugeCircleLayer1.path = Truepath.CGPath;
    _gaugeCircleLayer1.lineCap = kCALineCapRound;
    [self.view.layer addSublayer:_gaugeCircleLayer1];
}

//动画
-(void)changeValue:(float)value
{
    _gaugeCircleLayer1.strokeEnd = value;
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.5f;
    // pathAnimation.fromValue = [NSNumber numberWithFloat:self.value];
    // pathAnimation.toValue = [NSNumber numberWithFloat:value];
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_gaugeCircleLayer1 addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    
}

-(void)bu
{
//    NSMutableDictionary *paramare = [[NSMutableDictionary alloc] init];
//    [paramare setObject:@"2015-04-03" forKey:@"fileName"];
//    [self postHttpUrl:@"downloadRadiationFile.jsp" postInfo:nil state:0];
//    
    
    
    [self.currentperipheral DFU];
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
    if (thread!=nil) {
        [thread cancel];
       
    }

    
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
                [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(scanTimer) userInfo:nil repeats:NO];
                [self.my scanForPeripheralsWithServices:@[BLEdebug.uartServiceUUID] options:@{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}];
         //       [self.my scanForPeripheralsWithServices:nil options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerScanOptionAllowDuplicatesKey, nil]];
                NSLog(@"wait connect peripheral! ");
//                customview.label.font = [UIFont systemFontOfSize:20.0];
//                customview.label.text = NSLocalizedStringFromTable(@"Button_ScanforBle_Title",@"MyLoaclization" , @"");
                
                //TODO elias
                raindexlab.font = [UIFont systemFontOfSize:20.0];
                raindexlab.text = NSLocalizedStringFromTable(@"Button_ScanforBle_Title",@"MyLoaclization" , @"");
                
                // [self.my scanForPeripheralsWithServices:@[BLEdebug.deviceBattyServiceUUID] options:@{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}];
                
                XYLoadingView *loadingView1 = XYShowLoading(NSLocalizedStringFromTable(@"Loading_Title",@"MyLoaclization" , @""));
                thread = [[NSThread alloc]initWithTarget:self selector:@selector(runthread) object:nil];
               
                // threadAnimation = [[NSThread alloc]initWithTarget:self selector:@selector(runthreadAnimation) object:nil];
                // timerAnimation = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runthreadAnimation) userInfo:nil repeats:YES];
                 //[thread cancel];
                [loadingView1 performSelector:@selector(dismiss) withObject:nil afterDelay:6];
                
                
                
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
    BOOL isold = NO;
    
    
    //优先连接以前连接过的设备,如果没有则优先选择连接信号强度最强的设备
    if (CBperArray.count>0) {
        NSLog(@"array = %@",CBperArray);
        for (CBPeripheral *b in CBperArray) {  //优先保存过的mac
            if ([[NSString stringWithFormat:@"%@",b.identifier] isEqual:[user objectForKey:USERDEFAULTS_BLENAME]]) {
                myperipheral = b;
                NSLog(@"连接上以保存过的ble");
                isold = YES;
             
            }
            
        }

    }
    /**********************************/
        if (!isold) {
        
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
            myperipheral = [CBperArray objectAtIndex:0];
        }
        else if (CBperArray.count == 1)
        {
            myperipheral = [CBperArray objectAtIndex:0];
        }
        
        NSLog(@"connect id = %@",myperipheral.identifier);
    }
    
    if (myperipheral!=nil) {
        [user setObject:[NSString stringWithFormat:@"%@",myperipheral.identifier] forKey:USERDEFAULTS_BLENAME]; //保存mac地址
        [user synchronize];
        
        self.currentperipheral = [[BLEdebug alloc] initwithPeripheral:myperipheral delegate:self];
        simpleperipheral = myperipheral;
        [self.my connectPeripheral:myperipheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
        _blesta=1;
    }
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(BleisState) userInfo:nil repeats:NO];
    
    [CBperArray removeAllObjects];
    [RssiArray removeAllObjects];
}
-(void)BleisState
{
    if (_blesta==0) {
        //customview.label.text =NSLocalizedStringFromTable(@"Button_DisscanforBle_Title",@"MyLoaclization" , @"");
        
        //TODO elias
        raindexlab.text = NSLocalizedStringFromTable(@"Button_DisscanforBle_Title",@"MyLoaclization" , @"");
        animatbutton.enabled = YES;
    }
    
    

}

-(void)runthread
{
     [self.currentperipheral readBattry];
    [self.currentperipheral readFirm];
    while (![NSThread currentThread].isCancelled) {
        [self changevalue];
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//          [self changeValue:rtvv];
//             [_gaugeCircleLayer1 setNeedsDisplay];
//        });
       
        [NSThread sleepForTimeInterval:1];
    
    }
    
    
}

-(void)runthreadAnimation
{
  //while (![NSThread currentThread].isCancelled) {
    
       
  //}
    
//     while (![NSThread currentThread].isCancelled) {
//        // [NSThread sleepForTimeInterval:1];
//     [self changeValue:rtvv];
//         
//        
//     }
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
    animatbutton.hidden = NO;
//    customview.label.text = NSLocalizedStringFromTable(@"Button_DisconnectBle_Title",@"MyLoaclization" , @"");
//    customview.label.font = [UIFont systemFontOfSize:20];
    
    //TODO elias
    raindexlab.text = NSLocalizedStringFromTable(@"Button_DisconnectBle_Title",@"MyLoaclization" , @"");
    raindexlab.font = [UIFont systemFontOfSize:15];
    
    [thread cancel];
    
//    [threadAnimation cancel];
    
    refreshbutton.enabled = NO;
    [loadingView dismiss];
    
   // [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(connectagain) userInfo:nil repeats:NO];
    
  //  [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:@"蓝牙连接已断开"];
}
//重连
//-(void)connectagain
//{
//    NSLog(@"重连");
//    self.currentperipheral = [[BLEdebug alloc] initwithPeripheral:simpleperipheral delegate:self];
//    [self.my connectPeripheral:simpleperipheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
//  //  [self.my connectPeripheral:simpleperipheral options:nil];
//    thread = [[NSThread alloc]initWithTarget:self selector:@selector(runthread) object:nil];
//
//}


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
   
      //TODO elias
      // int rtvv;
    if (j<6) {
       rtvv= [self fun:rtv flag:j];
        j++;
    }
    else
       rtvv= [self fun:rtv flag:0];
    float rtvvfloat = (float)rtvv/100;
    
    //TODO elias
    dispatch_async(dispatch_get_main_queue(), ^{
        [self changeValue:rtvvfloat];
        
        [_gaugeCircleLayer1 layoutIfNeeded];
    });
    
    if (rtvv>65) {
//        customview.label.textColor = [UIColor redColor];
//        customview.label.text =[NSString stringWithFormat:NSLocalizedStringFromTable(@"Mainview_Danger",@"MyLoaclization" , @"")];
//        customview.label.font = [UIFont boldSystemFontOfSize:32];
    
        
        //TODO elias
        ralevellab.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Mainview_Danger",@"MyLoaclization" , @"")];
        ralevellab.textColor = [UIColor colorWithRed:240.0/255.0 green:90.0/255.0 blue:33.0/255.0 alpha:1.0];
        raindexlab.text = [NSString stringWithFormat:@"%d",rtvv];
        raindexlab.font = [UIFont boldSystemFontOfSize:71.0];
        
        simlabel.textColor = [UIColor colorWithRed:240.0/255.0 green:90.0/255.0 blue:33.0/255.0 alpha:1.0];
        _gaugeCircleLayer1.strokeColor = [UIColor colorWithRed:240.0/255.0 green:90.0/255.0 blue:33.0/255.0 alpha:1.0].CGColor;
    }
    else{
//        customview.label.text =[NSString stringWithFormat:NSLocalizedStringFromTable(@"Mainview_Safe",@"MyLoaclization" , @"")];
//        customview.label.font = [UIFont boldSystemFontOfSize:32];
//        customview.label.textColor = [UIColor colorWithRed:165.0/255 green:175.0/255 blue:176.0/255 alpha:1];
        
        //TODO elias
        ralevellab.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Mainview_Safe",@"MyLoaclization" , @"")];
        ralevellab.textColor = [UIColor colorWithRed:60.0/255.0 green:184.0/255.0 blue:120.0/255.0 alpha:1.0];//[UIColor colorWithRed:17.0/225.0 green:255.0/255.0 blue:249.0/255.0 alpha:1.0];
        raindexlab.text = [NSString stringWithFormat:@"%d",rtvv];
        raindexlab.font = [UIFont boldSystemFontOfSize:71.0];
        
        simlabel.textColor = [UIColor colorWithRed:165.0/255 green:175.0/255 blue:176.0/255 alpha:1];
        _gaugeCircleLayer1.strokeColor = [UIColor colorWithRed:60.0/255.0 green:184.0/255.0 blue:120.0/255.0 alpha:1.0].CGColor;
    }
   // simlabel.text = [NSString stringWithFormat:@"%d",rtvv];
     simlabel.text = [NSString stringWithFormat:@"%.2f",[self returnDbm:(float)label1*3600/1024/1000]];
   
    NSLog(@"RTV = %d",rtv);
    NSLog(@"rtvv = %d",rtvv);
  
   
   // [customview setfixedRingone:rtvv/5*3];
    
     //  DbmLable.text = [NSString stringWithFormat:@"%.2f mW/㎡",[self returnDbm:(float)label1*3600/1024/1000]];
  //  simlabel.hidden = YES;
    DbmLable.hidden = NO;
    
    
}

#pragma mark 实例化自动运行方法
-(void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"peripheral name = %@ rssi = %@ id = %@", peripheral.name,RSSI,peripheral.identifier);
    if ([peripheral.name isEqual:@"V0"]|[peripheral.name isEqual:@"iBirthstone"]) {//iBirthstone
        [RssiArray addObject:RSSI];
        [CBperArray addObject:peripheral];
//    [self.my stopScan];
//    self.currentperipheral = [[BLEdebug alloc] initwithPeripheral:peripheral delegate:self];
//    [self.my connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
    }
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if ([peripheral.name isEqual:@"V0"]|[peripheral.name isEqual:@"iBirthstone"]) {
        
    
    [self.currentperipheral didconnect];
    NSLog(@"Did connect peripheral! %@",peripheral.name);
    NSLog(@"Did connect peripheral! %@",peripheral.identifier);
    
    
        
    ralevellab.hidden = NO;    
        
    refreshbutton.enabled = YES;
    _blesta = 1;
    //NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"1" forKey:USERDEFAULTS_BLESTATE];
    [user synchronize];
    self.navigationItem.rightBarButtonItem.enabled =YES;
        animatbutton.hidden=YES;
    }
}
-(void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (error) {
        NSLog(@"Disdisconnect faild! %@",error);
         //[self.currentperipheral diddisconnect];
    }
    [thread cancel];
//    [threadAnimation cancel];
    
    [self.currentperipheral diddisconnect];
    self.animatbutton.enabled = YES;
    [loadingView dismiss];
   // [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:@"蓝牙连接已断开"];
    
//    customview.label.text = NSLocalizedStringFromTable(@"Button_DisconnectBle_Title",@"MyLoaclization" , @"");
//    customview.label.font = [UIFont systemFontOfSize:20];
    
    //TODO elias
    raindexlab.text = NSLocalizedStringFromTable(@"Button_DisconnectBle_Title",@"MyLoaclization" , @"");
    raindexlab.font = [UIFont systemFontOfSize:15.0];
    simlabel.text = @" ";
    
    //[customview setfixedRingone:0];
    
    _blesta=0;
   // NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"0" forKey:USERDEFAULTS_BLESTATE];
    [user synchronize];
    DbmLable.hidden = YES;
    animatbutton.hidden = NO;
    
}
-(void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    if(central.state == CBCentralManagerStatePoweredOn)
    {
    }
}

-(void)threadrun
{
   //[thread cancel];
    dispatch_sync(dispatch_get_global_queue(0,0), ^{
  
        [thread start];

    });
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        timerAnimation = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runthreadAnimation) userInfo:nil repeats:YES];
//    });

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

-(NSInteger )getblestate
{
    //NSLog(@"%ld",mainVC.blesta);
    return _blesta;
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
-(void)GetDelegate:(leftMenuViewController *)Controller
{
    left = Controller;
    
}

- (IBAction)RadiationButton:(id)sender {
    RtHistoryViewController *history =[[RtHistoryViewController alloc]init];
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:history]
                                                 animated:NO];
    history.delegate = self;
    [self.sideMenuViewController hideMenuViewController];
}

- (IBAction)WalkButton:(id)sender {
    SpHistoryViewController *history =[[SpHistoryViewController alloc] init];
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:history]
                                                 animated:NO];
    history.delegate = self;
    [self.sideMenuViewController hideMenuViewController];
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


//dBm转换
-(float)returnDbm:(float)v
{
    float Dbm ;
    
    if (v<=0.071) {
        return 0.1;
    }
    else if (v>0.071&v<0.079)
    {
        return 0.126;
    }
    else if (v>0.079&v<=0.089)
    {
        return 0.16;
    }
    
    else if (v>0.089&v<=0.1)
    {
        return 0.2;
    }
    
    else if (v>0.1&v<=0.112)
    {
        return 0.25;
    }
    
    else if (v>0.112&v<=0.126)
    {
        return 0.32;
    }
    
    else if (v>0.126&v<=0.141)
    {
        return 0.4;
    }
    else if (v>0.141&v<=0.158)
    {
        return 0.5;
    }
    else if (v>0.158&v<=0.178)
    {
        return 0.63;
    }
    else if (v>0.178&v<=0.199)
    {
        return 0.79;
    }
    else if (v>0.199&v<=0.224)
    {
        return 1;
    }
    else if (v>0.224&v<=0.251)
    {
        return 1.25;
    }
    else if (v>0.251&v<=0.282)
    {
        return 1.6;
    }
    else if (v>0.282&v<=0.316)
    {
        return 2;
    }
    else if (v>0.316&v<=0.354)
    {
        return 2.5;
    }
    else if (v>0.354&v<=0.398)
    {
        return 3.2;
    }
    else if (v>0.398&v<=0.446)
    {
        return 4;
    }
    else if (v>0.446&v<=0.501)
    {
        return 5;
    }
    else if (v>0.501&v<=0.56)
    {
        return 6.3;
    }
    else if (v>0.56&v<=0.63)
    {
        return 8;
    }
    else if (v>0.63&v<=0.71)
    {
        return 10;
    }
    else if (v>0.71&v<=0.79)
    {
        return 12.6;
    }
    else if (v>0.79&v<=0.89)
    {
        return 16;
    }
    else if (v>0.89&v<=1)
    {
        return 20;
    }
    else if (v>1&v<=1.12)
    {
        return 25;
    }
    else if (v>1.12&v<=1.26)
    {
        return 32;
    }
    else if (v>1.26&v<=1.41)
    {
        return 40;
    }
    else if (v>1.41&v<=1.58)
    {
        return 50;
    }
    else if (v>1.58&v<=1.78)
    {
        return 63;
    }
    else if (v>1.78&v<=1.99)
    {
        return 79;
    }
    else if (v>1.99&v<=2.24)
    {
        return 100;
    }
    return Dbm;
}



//post用法
- (void)postHttpUrl:(NSString *)urlString postInfo:(NSDictionary *)info state:(int)state
//
{
    NSURL * url = [NSURL URLWithString:@"http://120.24.237.180:8080/PregnantHealth"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    
    [httpClient getPath:urlString parameters:info success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        //系统自带JSON解析
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"ok result = %@",resultDic);
        
        //  NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://120.24.237.180:8080/PregnantHealth/upload/radiation/109/2015-04-02"]]];
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://120.24.237.180:8080/upload/radiation/109/2015-04-02"]]];
     //   NSLog(@"data.length = %ld",data.length);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"由于网络原因失败error = %@",error.localizedDescription);
        
    }];
    
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
