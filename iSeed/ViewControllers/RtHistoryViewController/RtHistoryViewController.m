//
//  RtHistoryViewController.m
//  iSeed
//
//  Created by Nico on 15/5/6.
//  Copyright (c) 2015年 elias kang. All rights reserved.
//

#import "RtHistoryViewController.h"
#import "PNplot.h"
#import "RESideMenu.h"
@interface RtHistoryViewController ()

@end

@implementation RtHistoryViewController
{
    CAShapeLayer* _gaugeCircleLayer1;
    NSUserDefaults *userDefaults;
    XYLoadingView *loadingview;
    PMPeriod *mynewPeriod;
    NSString *NAMEFORUSER;
    UIButton *calendarbutton;
    int hourtime;
    int time;
    NSMutableArray *Averagearrary;
    int allaverage;
    PNplot *polts;
    //TODO elias
    UILabel *raindextext;
    UILabel *ralevelnum;
    //UILabel *beginnumlab;
    //UILabel *endnumlab;
    UILabel *nodatalabtext;
   // UILabel *rastatuslab;

}

@synthesize pmCC;
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    Averagearrary = [NSMutableArray array];
    userDefaults = [NSUserDefaults standardUserDefaults];
    NAMEFORUSER  = [userDefaults objectForKey:USERDEFAULTS_USERNAME];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    //title格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyyMMdd"];
    NSDate *destDate= [dateFormatter dateFromString:[userDefaults objectForKey:USERDEFAULTS_LASTTIMEREFRESH]];
    if (destDate==nil) {
        NSDate *date = [[NSDate alloc]init];
        self.navigationItem.title = [NSString stringWithFormat:@"<   %@   >",[date dateStringWithFormat:@"yyyy-MM-dd"]];
    }
    else
        self.navigationItem.title = [NSString stringWithFormat:@"<   %@   >",[destDate dateStringWithFormat:@"yyyy-MM-dd"]];
    

    
    [_Sync1Button setTitle:NSLocalizedStringFromTable(@"stepsHistory_startsynctext", @"MyLoaclization" , @"") forState:UIControlStateNormal];
    
    
    
    UIButton *lbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    lbutton.frame = CGRectMake(0, 0, 20,15 ); //(0, 0, 12, 16)
    UIImage *icon3 = [UIImage imageNamed:RidemenuButtonImage];
    CGSize itemSize3 = CGSizeMake(15, 15);
    UIGraphicsBeginImageContextWithOptions(itemSize3, NO ,0.0);
    CGRect imageRect3 = CGRectMake(0.0, 0.0, itemSize3.width, itemSize3.height);
    [icon3 drawInRect:imageRect3];
    icon3 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [lbutton setBackgroundImage:icon3 forState:UIControlStateNormal];
    [lbutton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:lbutton];
    self.navigationItem.leftBarButtonItem=leftButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"HistoryVC_RightButton_Title", @"MyLoaclization" , @"") style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    
    calendarbutton = [[UIButton alloc]initWithFrame:CGRectMake(110, 0, 100, 40)];
    [calendarbutton addTarget:self action:@selector(CalendarControllerShow:) forControlEvents:UIControlEventTouchUpInside];
    calendarbutton.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:calendarbutton];
    
    //创建监听器
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(changeLoadingViewState:) name:@"LoadingDismiss" object:nil];
    
    [self circlelayinit];
    // Do any additional setup after loading the view from its nib.
    
    //TODO elias
    raindextext = [[UILabel alloc] initWithFrame:CGRectMake(100, 134, 120, 21)];
    //raindexlab.font = [UIFont boldSystemFontOfSize:71.0];
    raindextext.font = [UIFont systemFontOfSize:17.0];
    raindextext.text = NSLocalizedStringFromTable(@"rtHistory_rtindex", @"MyLoaclization" , @"");
    raindextext.textColor = [UIColor lightGrayColor];
    //raindexlab.center = CGPointMake(self.view.center.x, self.view.center.y-30);
    raindextext.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:raindextext];
    
    
//    beginnumlab = [[UILabel alloc] initWithFrame:CGRectMake(69, 367, 10, 21)];
//    beginnumlab.font = [UIFont systemFontOfSize:17.0];
//    beginnumlab.text = @"0";
//    beginnumlab.textColor = [UIColor colorWithRed:170.0/225.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
//    //beginnumlab.center = CGPointMake(self.view.center.x, self.view.center.y-30);
//    beginnumlab.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:beginnumlab];
//    
//    endnumlab = [[UILabel alloc] initWithFrame:CGRectMake(226, 367, 39, 21)];
//    endnumlab.font = [UIFont systemFontOfSize:17.0];
//    endnumlab.text = @"100+";
//    endnumlab.textColor = [UIColor colorWithRed:170.0/225.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
//    //endnumlab.center = CGPointMake(self.view.center.x, self.view.center.y-30);
//    endnumlab.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:endnumlab];
    
    ralevelnum = [[UILabel alloc] initWithFrame:CGRectMake(90, 163, 140, 80)];
    ralevelnum.font = [UIFont boldSystemFontOfSize:71.0];
    ralevelnum.text = @"0";
    ralevelnum.textColor =  [UIColor colorWithRed:60.0/255.0 green:184.0/255.0 blue:120.0/255.0 alpha:1.0]; // [UIColor colorWithRed:17.0/225.0 green:255.0/255.0 blue:249.0/255.0 alpha:1.0];
    //ralevellab.center = CGPointMake(self.view.center.x, self.view.center.y-30);
    ralevelnum.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:ralevelnum];
    
    nodatalabtext = [[UILabel alloc] initWithFrame:CGRectMake(126, 434, 68, 21)];
    nodatalabtext.font = [UIFont systemFontOfSize:17.0];
    nodatalabtext.text = NSLocalizedStringFromTable(@"rtHistory_nodatatext", @"MyLoaclization" , @"");
    nodatalabtext.textColor =  [UIColor lightGrayColor]; // [UIColor colorWithRed:17.0/225.0 green:255.0/255.0 blue:249.0/255.0 alpha:1.0];
    //ralevellab.center = CGPointMake(self.view.center.x, self.view.center.y-30);
    nodatalabtext.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nodatalabtext];
    
    _Statelabel.hidden = YES;
    
    
    _Myzhuview.labelfont = 10;
    _Myzhuview.ymax = 100;
    _Myzhuview.xCount = 2;
    _Myzhuview.yCount = 4;
    polts = [[PNplot alloc]init];
    
    polts.linesColor = [UIColor colorWithRed:173.0/255 green:223.0/255 blue:180.0/255 alpha:1];
    polts.AxisColor = [UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:0.3];
    polts.lineWidth = 15;
    
    [self writeInfor:nil];
}




-(void)circlelayinit
{
    CGPoint arcCenter = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)-80);
    
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


-(void)changeLoadingViewState:(NSNotification *)noti
{
    
    [loadingview dismiss];
    if ([[noti.userInfo objectForKey:@"result"] isEqual:@"true"]) {
        XYAlertView *alertView1 = [XYAlertView alertViewWithTitle:NSLocalizedStringFromTable(@"HistoryVC_UpdateOKAlret_Title", @"MyLoaclization" , @"")
                                                          message:nil
                                                          buttons:[NSArray arrayWithObjects:@"OK", nil]
                                                     afterDismiss:^(long buttonIndex) {
                                                         [self writeInfor:nil];
                                                       
                                                         NSDate *date = [[NSDate alloc]init];
                                                         self.navigationItem.title = [NSString stringWithFormat:@"<   %@   >",[date dateStringWithFormat:@"yyyy-MM-dd"]];
                                                         //上传历史文件到服务器
                                                         // [self sendHistory];
                                                         NSString *rthistoryPath = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:NAMEFORUSER] stringByAppendingPathComponent:@"RTDIR"]stringByAppendingPathComponent:[userDefaults objectForKey:USERDEFAULTS_LASTTIMEREFRESH]];
                                                         
                                                         NSFileManager *fileManager = [NSFileManager defaultManager];
                                                         if([fileManager fileExistsAtPath:rthistoryPath]) //如果存在
                                                         {
                                                             NSLog(@"文件存在");
                                                             [self sendHistory];
                                                         }
                                                         else
                                                         {
                                                             NSLog(@"文件不存在");
                                                         }
                                                         
                                                         
                                                         
                                                       //  nextbutton.enabled = YES;
                                                         NSLog(@"button index: %ld pressed!", buttonIndex);
                                                     }];
        [alertView1 show];
    }
    if ([[noti.userInfo objectForKey:@"result"] isEqual:@"nodata"]) {
        XYAlertView *alertView1 = [XYAlertView alertViewWithTitle:NSLocalizedStringFromTable(@"HistoryVC_IbirthstoneNoData", @"MyLoaclization" , @"")
                                                          message:nil
                                                          buttons:[NSArray arrayWithObjects:@"OK", nil]
                                                     afterDismiss:^(long buttonIndex) {
                                                         
                                                     }];
        [alertView1 show];
    }
    
}


-(void)sendHistory
{
    
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:[userDefaults objectForKey:USERDEFAULTS_USERNAME] forKey:@"account"];
    [parameters setValue:[userDefaults objectForKey:USERDEFAULTS_PASSWD] forKey:@"password"];
    NSString *order = @"login.jsp";
    [self postHttpUrl:order postInfo:parameters state:0];
}


#pragma mark 日历代理

-(void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    mynewPeriod = newPeriod;
    if (mynewPeriod!=pmCC.period) {
        [calendarController dismissCalendarAnimated:YES];
        
    }
    
}
-(void)calendarControllerDidDismissCalendar:(PMCalendarController *)calendarController
{
    self.navigationItem.title = [NSString stringWithFormat:@"<   %@   >"
                                 , [mynewPeriod.endDate dateStringWithFormat:@"yyyy-MM-dd"]];
    calendarbutton.enabled = YES;
    
    //日期选择的响应
    [self writeInfor:[NSString stringWithFormat:@"%@"
                      , [mynewPeriod.endDate dateStringWithFormat:@"yyyyMMdd"]]];
    
}
-(void)CalendarControllerShow:(id)sender
{
    calendarbutton.enabled = NO;
    self.pmCC = [[PMCalendarController alloc] init];
    pmCC.delegate = self;
    pmCC.mondayFirstDayOfWeek = YES;
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(110, 20, 100, 50)];
    [self.view addSubview:back];
    
    [pmCC presentCalendarFromView:back
         permittedArrowDirections:PMCalendarArrowDirectionAny
                         animated:YES];
    /*    [pmCC presentCalendarFromRect:[sender frame]
     inView:[sender superview]
     permittedArrowDirections:PMCalendarArrowDirectionAny
     animated:YES];*/
    [self calendarController:pmCC didChangePeriod:pmCC.period];
    
}




-(void)writeInfor:(NSString *)RTpath
{
    [self clear];
    //0127 rthistoryPath two init? USERDEFAULTS_LASTTIMEREFRESH is used??
    NSString *rthistoryPath  = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"RTDIR"]stringByAppendingPathComponent:[userDefaults objectForKey:USERDEFAULTS_LASTTIMEREFRESH]];   //默认读取上次更新后的历史文件
    //NSString *rthistoryPath  = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:[NSString stringWithFormat:@"RT%@",[userDefaults objectForKey:USERDEFAULTS_LASTTIMEREFRESH]]];   //默认读取上次更新后的历史文件
    
    NSLog(@"上次登录的时间为%@",[userDefaults objectForKey:USERDEFAULTS_LASTTIMEREFRESH]);
    if (RTpath!=nil) {
        rthistoryPath = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"RTDIR"]stringByAppendingPathComponent:RTpath];
    }
    
    
    
    
    
    NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:rthistoryPath];
    NSData *mydata = [fh readDataToEndOfFile];
    //  int byte[mydata.length] =
    
    Byte *byte = (Byte *)[mydata bytes];
   NSInteger rtlength = mydata.length;
    if (rtlength==0|rtlength==1) {
        [Averagearrary addObject:@"0"];
       // _Nodatalabel.hidden = NO;
        _Dbmlabel.hidden = YES;
       // _Zhishulabel.hidden = YES;
        _Danweilabel.hidden = YES;
        _Sync1Button.hidden = NO;
        //TODO elias
        nodatalabtext.hidden = NO;
        ralevelnum.hidden = YES;
        _Statelabel.hidden = YES;
    }
    else{
        //_Nodatalabel.hidden = YES;
       // _Zhishulabel.hidden = NO;
        _Statelabel.hidden = NO;
        _Dbmlabel.hidden = NO;
        _Danweilabel.hidden = NO;
        _Sync1Button.hidden = YES;
        //TODO elias
        nodatalabtext.hidden = YES;
        ralevelnum.hidden = NO;
        int array[rtlength/2];
        int hournum = 0;
        int allnum = 0;
        int truetime = 0;
        int truehourtime = 0;
        for (int i=0; i<(mydata.length-1)/2; i++) {
            array[i]=((byte[i*2+2]<<8)&0xff00)|(byte[i*2+1]&0xff);
            
                time++;
                if (array[i]==255|array[i]==0) {
                    array[i]=0;
                }
                else
                {
                    truetime++;
                    NSLog(@"array[%d]=%d",i,array[i]);

                }
                
                allnum += array[i];
                if (time%20!=0) {
                    hournum+=array[i];
                }
                else
                {
                    hournum+=array[i];
                    if (Averagearrary.count<12) {
                        [Averagearrary addObject:[NSString stringWithFormat:@"%d",[self Allaveragereturn:(hournum/truetime)]]];
                    }
                    
                    time=0;
                    hourtime ++;
                    truehourtime +=truetime;
                    truetime=0;
                     hournum = 0;
                }
            

            
        }
        truehourtime +=truetime;
        allaverage = allnum/truehourtime;
        if (((mydata.length-1)/2-20*hourtime)<20) {
            if (Averagearrary.count<12) {
            [Averagearrary addObject:[NSString stringWithFormat:@"%d",[self Allaveragereturn:(hournum/truetime)]]];
            }
            
        }
        
    }
    
   // NSLog(@"共去除休眠数%d个",SleepNum);
  //  NSLog(@"lv1 = %d,lv2 = %d,lv3 = %d,lv4 = %d,lv5 = %d",lv1,lv2,lv3,lv4,lv5);
   // SleepNum =0;
    
    [fh closeFile];
    [self readRTHistoryFromBle];
    //    demoView = [[SnapView alloc] initWithFrame:self.view.bounds];
    
}

//分配历史图形大小
-(void)readRTHistoryFromBle
{
     ralevelnum.text  = [NSString stringWithFormat:@"%d",[self Allaveragereturn:allaverage]];
   // _Zhishulabel.text = [NSString stringWithFormat:@"%d",[self Allaveragereturn:allaverage]];
    //_Dbmlabel.text = [NSString stringWithFormat:@"%.2f",(float)allaverage*3600/1024/1000];
    _Dbmlabel.text = [NSString stringWithFormat:@"%.2f",[self returnDbm:(float)allaverage*3600/1024/1000]];
    NSLog(@"average = %d",allaverage);
    if ([self Allaveragereturn:allaverage]>=67) {
       // _Zhishulabel.textColor = [UIColor redColor];
        ralevelnum.textColor = [UIColor redColor];
        _Statelabel.textColor = [UIColor redColor];
        _Statelabel.text = NSLocalizedStringFromTable(@"rtHistory_rtstateNO", @"MyLoaclization" , @"");
       
    }
    else
    {
        //_Zhishulabel.textColor = [UIColor lightGrayColor];
        ralevelnum.textColor = [UIColor lightGrayColor];
        _Statelabel.textColor = [UIColor colorWithRed:60.0/255 green:184.0/255 blue:120.0/255 alpha:1];
        _Statelabel.text = NSLocalizedStringFromTable(@"rtHistory_rtstateOK", @"MyLoaclization" , @"");
    
    }
    [self ZhishuchangeValue:(float)[self Allaveragereturn:allaverage]/100];
    polts.plottingValues = Averagearrary;
    
    [_Myzhuview addPlot:polts];
    
    NSLog(@"数据为%lu",(unsigned long)Averagearrary.count);
     NSLog(@"数据为%@",Averagearrary);
  //  [self clear];
}

-(void)clear
{
    allaverage = 0;
    [Averagearrary removeAllObjects];
    [_Myzhuview clearPlot];
    hourtime = 0;
    time = 0;

}


-(int)Allaveragereturn:(int)all
{
   // NSLog(@"all = %d",all);
    int rtv = 0;
    if (all<100 ){
        
        rtv = 0;
    }
    else if (all>400)
    {
      
        rtv = 100;
    }
    else
    {
        //rtvalue = (label1-100)/5;
        rtv = (all-100)/3;
        
    }
    return rtv;
}

-(void)ZhishuchangeValue:(float)value
{
    _gaugeCircleLayer1.strokeEnd = value;
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.5f;
    // pathAnimation.fromValue = [NSNumber numberWithFloat:self.value];
    // pathAnimation.toValue = [NSNumber numberWithFloat:value];
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_gaugeCircleLayer1 addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
}



-(void)refresh
{
    float system_version =  [[[UIDevice currentDevice] systemVersion] floatValue];
    if (system_version>=8.0) {
        UIUserNotificationSettings *mySet = [[UIApplication sharedApplication] currentUserNotificationSettings]; //获取通知中心应用的状态
        if(mySet.types == UIUserNotificationTypeNone)
        {
            NSLog(@"enabledRemoteNotificationTypes = %@",[[UIApplication sharedApplication] currentUserNotificationSettings]);
            XYAlertView *alertView2 = [XYAlertView alertViewWithTitle:NSLocalizedStringFromTable(@"HistoryVC_Alret_PushTitle", @"MyLoaclization" , @"")
                                       /* 消息提示  是否接受我的背包发的推送消息？ */                                    message:NSLocalizedStringFromTable(@"HistoryVC_Alret_Pushmessage", @"MyLoaclization" , @"")
                                                              buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"HistoryVC_Alret_SureButton", @"MyLoaclization" , @""), nil]
                                                         afterDismiss:^(long buttonIndex) {
                                                             NSLog(@"button index: %ld pressed!", buttonIndex);
                                                         }];
            
            [alertView2 show];
            
        }
        else if ([self.delegate getblestate]==0) {
            XYAlertView *alertView1 = [XYAlertView alertViewWithTitle:NSLocalizedStringFromTable(@"HistoryVC_ConnectBLE", @"MyLoaclization" , @"")
                                                              message:nil
                                                              buttons:[NSArray arrayWithObjects:@"OK", nil]
                                                         afterDismiss:^(long buttonIndex) {
                                                             NSLog(@"button index: %ld pressed!", buttonIndex);
                                                         }];
            [alertView1 show];
            //[[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil]];
            
        }
        else{
            loadingview = [XYLoadingView loadingViewWithMessage:NSLocalizedStringFromTable(@"HistoryVC_Loading_Title", @"MyLoaclization" , @"")];
            
            
            XYAlertView *alertView2 = [XYAlertView alertViewWithTitle:NSLocalizedStringFromTable(@"HistoryVC_Alret_Title", @"MyLoaclization" , @"")
                                                              message:NSLocalizedStringFromTable(@"HistoryVC_Alret_Message", @"MyLoaclization" , @"")
                                                              buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"HistoryVC_Alret_SureButton", @"MyLoaclization" , @""), NSLocalizedStringFromTable(@"HistoryVC_Alret_CancleButton", @"MyLoaclization" , @""), nil]
                                                         afterDismiss:^(long buttonIndex) {
                                                             if (buttonIndex == 0){
                                                                 
                                                                 
                                                                 [loadingview show];
                                                                 
                                                                 
                                                                 [self.delegate blehistory];
                                                                 
                                                                 
                                                             }
                                                             if(buttonIndex == 1)
                                                                 [loadingview dismiss];
                                                             NSLog(@"button index: %ld pressed!", buttonIndex);
                                                         }];
            
            [alertView2 show];
        }
        
        
        
    }
    else{
        
        if ([self.delegate getblestate]==0) {
            XYAlertView *alertView1 = [XYAlertView alertViewWithTitle:NSLocalizedStringFromTable(@"HistoryVC_ConnectBLE", @"MyLoaclization" , @"")
                                                              message:nil
                                                              buttons:[NSArray arrayWithObjects:@"OK", nil]
                                                         afterDismiss:^(long buttonIndex) {
                                                             NSLog(@"button index: %ld pressed!", buttonIndex);
                                                         }];
            [alertView1 show];
            //[[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil]];
            
        }
        else{
            loadingview = [XYLoadingView loadingViewWithMessage:NSLocalizedStringFromTable(@"HistoryVC_Loading_Title", @"MyLoaclization" , @"")];
            
            
            XYAlertView *alertView2 = [XYAlertView alertViewWithTitle:NSLocalizedStringFromTable(@"HistoryVC_Alret_Title", @"MyLoaclization" , @"")
                                                              message:NSLocalizedStringFromTable(@"HistoryVC_Alret_Message", @"MyLoaclization" , @"")
                                                              buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"HistoryVC_Alret_SureButton", @"MyLoaclization" , @""), NSLocalizedStringFromTable(@"HistoryVC_Alret_CancleButton", @"MyLoaclization" , @""), nil]
                                                         afterDismiss:^(long buttonIndex) {
                                                             if (buttonIndex == 0){
                                                                 
                                                                 
                                                                 [loadingview show];
                                                                 
                                                                 
                                                                 [self.delegate blehistory];
                                                                 
                                                                 
                                                             }
                                                             if(buttonIndex == 1)
                                                                 [loadingview dismiss];
                                                             NSLog(@"button index: %ld pressed!", buttonIndex);
                                                         }];
            
            [alertView2 show];
        }
    }
}
- (void)postHttpUrl:(NSString *)urlString postInfo:(NSDictionary *)info state:(int)state
//
{
    NSURL * url = [NSURL URLWithString:@"http://120.24.237.180:8080/PregnantHealth"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    
    [httpClient postPath:urlString parameters:info success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        //系统自带JSON解析
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"ok result = %@",[resultDic objectForKey:@"result"]);
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMdd";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *str1 = [formatter stringFromDate:[NSDate date]];
        
        //辐射历史文件地址
        NSString *rthistoryPath  = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"RTDIR"]stringByAppendingPathComponent:str];
        NSData *RTdata=[NSData dataWithContentsOfFile:rthistoryPath];
        
        
        // NSLog(@"今日的数据:历史辐射的地址为%@,NSDATA为%@",rthistoryPath,RTdata);
        //计步历史文件地址
        NSString *stepshistoryPath = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:NAMEFORUSER] stringByAppendingPathComponent:@"SPDIR"]stringByAppendingPathComponent:str];
        NSData *SPdata=[NSData dataWithContentsOfFile:stepshistoryPath];
        
        /********************上传辐射历史文件******************************/
        dispatch_queue_t urls_queue = dispatch_queue_create("transformRT", NULL);
        dispatch_async(urls_queue, ^{
            //上传辐射历史文件
            
            NSUserDefaults *usr = [NSUserDefaults standardUserDefaults];
            NSString *MatherPath =[NSString stringWithFormat:@"%@/Documents/%@/RTDIR",NSHomeDirectory(),[usr objectForKey:USERDEFAULTS_USERNAME]];
            NSArray* filelist = [self obtainAllFilesName:[NSString stringWithFormat:@"%@/Documents/%@/RTDIR",NSHomeDirectory(),[usr objectForKey:USERDEFAULTS_USERNAME]]];
            
            for (NSString *FileName in filelist) {
                NSString *RTPath = [NSString stringWithFormat:@"%@/%@",MatherPath,FileName];
                NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:RTPath];
                NSData *STATEDATA = [fh readDataOfLength:2];
                Byte *byte = (Byte *)[STATEDATA bytes];
                NSLog(@"byte[0]= %hhu,byte[1] = %hhu",byte[0],byte[1]);
                if (byte[0]==48) {
                    NSMutableDictionary *RTparameters = [[NSMutableDictionary alloc]init];
                    [RTparameters setObject:str1 forKey:@"uploadTime"];
                    NSLog(@"RTparameters = %@",RTparameters);
                    
                    // something
                    NSString *RTorder =@"uploadRadiationFile.jsp";
                    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:RTorder parameters:RTparameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                        
                        [formData appendPartWithFileData:RTdata name:str1 fileName:str1 mimeType:@"multipart/form-data; boundary=Boundary+0xAbCdEfGbOuNdArY"];
                        // [formData appendPartWithFormData:RTdata name:str];
                        NSLog(@"进入了block中");
                        
                        
                    }];
                    // 3. operation包装的urlconnetion
                    
                    
                    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                    [httpClient.operationQueue addOperation:op];
                    
                    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSString *requestTmp = [NSString stringWithString:operation.responseString];
                        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                        //系统自带JSON解析
                        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                        NSLog(@"resultDic = %@",resultDic);
                        NSLog(@"上传result = %@",[resultDic objectForKey:@"result"]);
                        
                        if ([[resultDic objectForKey:@"result"] isEqual:@"true"]) {
                            NSLog(@"上传完成");
                            //将标志位置1
                            
                            NSFileHandle*fh = [NSFileHandle fileHandleForWritingAtPath:RTPath];
                            [fh seekToFileOffset:0];
                            NSData *data1= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"1"] dataUsingEncoding:NSUTF8StringEncoding]];
                            [fh writeData:data1];
                            [fh closeFile];
                            
                            fh = [NSFileHandle fileHandleForReadingAtPath:RTPath];
                            
                            NSLog(@"byte[0] = %@",[fh readDataOfLength:1]);
                            
                        }
                        if ([[resultDic objectForKey:@"result"] isEqual:@"false"]) {
                            NSLog(@"上传失败");
                        }
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                        NSLog(@"上传失败->%@", error);
                        
                    }];
                    
                }
                
            }
            
        });
        
        
        /*********************上传计步历史文件***************************/
        dispatch_queue_t urls_queue1 = dispatch_queue_create("transformSP", NULL);
        dispatch_async(urls_queue1, ^{
            
            NSString *MatherPath =[NSString stringWithFormat:@"%@/Documents/%@/SPDIR",NSHomeDirectory(),[userDefaults objectForKey:USERDEFAULTS_USERNAME]];
            NSArray* filelist = [self obtainAllFilesName:[NSString stringWithFormat:@"%@/Documents/%@/SPDIR",NSHomeDirectory(),[userDefaults objectForKey:USERDEFAULTS_USERNAME]]];
            for (NSString *FileName in filelist) {
                NSString *SPPath = [NSString stringWithFormat:@"%@/%@",MatherPath,FileName];
                NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:SPPath];
                NSData *STATEDATA = [fh readDataOfLength:2];
                Byte *byte = (Byte *)[STATEDATA bytes];
                NSLog(@"SPbyte[0]= %hhu,SPbyte[1] = %hhu",byte[0],byte[1]);
                if (byte[0]==48) {
                    //上传计步历史文件
                    NSMutableDictionary *SPparameters = [[NSMutableDictionary alloc]init];
                    //NSDictionary * RTparameters = @{@"uploadTime":str1};
                    // [RTparameters setObject:@"2015-02-03" forKey:@"uploadTime"];
                    [SPparameters setObject:str1 forKey:@"uploadTime"];
                    NSLog(@"SPparameters = %@",SPparameters);
                    
                    // something
                    NSString *SPorder =@"uploadCalorieFile.jsp";
                    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:SPorder parameters:SPparameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                        
                        [formData appendPartWithFileData:SPdata name:str1 fileName:str1 mimeType:@"multipart/form-data; boundary=Boundary+0xAbCdEfGbOuNdArY"];
                        // [formData appendPartWithFormData:RTdata name:str];
                        NSLog(@"进入了block中");
                        NSLog(@"formData = %@",formData);
                        
                    }];
                    // 3. operation包装的urlconnetion
                    
                    NSLog(@"request = %@",request.allHTTPHeaderFields);
                    
                    
                    
                    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                    [httpClient.operationQueue addOperation:op];
                    
                    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSString *requestTmp = [NSString stringWithString:operation.responseString];
                        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                        //系统自带JSON解析
                        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                        NSLog(@"resultDic = %@",resultDic);
                        NSLog(@"上传result = %@",[resultDic objectForKey:@"result"]);
                        
                        if ([[resultDic objectForKey:@"result"] isEqual:@"true"]) {
                            NSLog(@"卡路里，上传完成");
                            
                            
                            NSFileHandle*fh = [NSFileHandle fileHandleForWritingAtPath:SPPath];
                            [fh seekToFileOffset:0];
                            NSData *data1= [[NSData alloc] initWithData:[[NSString stringWithFormat:@"1"] dataUsingEncoding:NSUTF8StringEncoding]];
                            [fh writeData:data1];
                            [fh closeFile];
                            
                            
                            fh = [NSFileHandle fileHandleForReadingAtPath:SPPath];
                            NSLog(@"SPbyte[0] = %@",[fh readDataOfLength:1]);
                            
                        }
                        if ([[resultDic objectForKey:@"result"] isEqual:@"false"]) {
                            NSLog(@"卡路里，上传失败");
                        }
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                        NSLog(@"卡路里，上传失败->%@", error);
                        
                    }];
                    
                    
                }
            }
            
            
            
        });
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"由于网络原因失败error = %@",error.localizedDescription);
        
    }];
    
}
-(NSArray *)obtainAllFilesName:(NSString *)directoryString
{
    
    NSFileManager *temFM = [NSFileManager defaultManager];//创建文件管理器
    
    if (directoryString)
        
    {
        
        NSArray *temFilesArray = [temFM subpathsAtPath:directoryString];//获取该目录下的所有文件名
        
        return temFilesArray;
        
    }
    else
        return nil;
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)SyncButton:(id)sender {
    [self refresh];
}
@end
