//
//  SpHistoryViewController.m
//  iSeed
//
//  Created by Nico on 15/5/8.
//  Copyright (c) 2015年 elias kang. All rights reserved.
//

#import "SpHistoryViewController.h"
#import "XYAlertView.h"
#import "RESideMenu.h"
#import <QuartzCore/QuartzCore.h>
@interface SpHistoryViewController ()

@end

@implementation SpHistoryViewController
{
    CAShapeLayer* _gaugeCircleLayer1;
    NSUserDefaults *userDefaults;
    XYLoadingView *loadingview;
    PMPeriod *mynewPeriod;
    NSString *NAMEFORUSER;
    UIButton *calendarbutton;
    //TODO elias
    UILabel *stepsindextext;
    UILabel *stepslevelnum;
    //UILabel *nodatalabtext;
    UILabel *calorietext;
    UILabel *metretext;
    UILabel *steppuretext;
    UILabel *arrivaltext;
    UILabel *suggestiontext;

}
@synthesize pmCC;
@synthesize lv1steps;
@synthesize lv2steps;
@synthesize lv3steps;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
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
    
    //_SyncButton.titleLabel.text=NSLocalizedStringFromTable(@"stepsHistory_startsynctext", @"MyLoaclization" , @"");
    [_SyncButton setTitle:NSLocalizedStringFromTable(@"stepsHistory_startsynctext", @"MyLoaclization" , @"") forState:UIControlStateNormal];
    
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
    stepsindextext = [[UILabel alloc] initWithFrame:CGRectMake(110, 168, 100, 21)]; //126 68
    //raindexlab.font = [UIFont boldSystemFontOfSize:71.0];
    stepsindextext.font = [UIFont systemFontOfSize:13.0];
    stepsindextext.text = NSLocalizedStringFromTable(@"stepsHistory_stepsindex", @"MyLoaclization" , @"");
    stepsindextext.textColor = [UIColor lightGrayColor];
    //raindexlab.center = CGPointMake(self.view.center.x, self.view.center.y-30);
    stepsindextext.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:stepsindextext];
    
    calorietext = [[UILabel alloc] initWithFrame:CGRectMake(135, 273, 51, 21)];
    //raindexlab.font = [UIFont boldSystemFontOfSize:71.0];
    calorietext.font = [UIFont systemFontOfSize:13.0];
    calorietext.text = NSLocalizedStringFromTable(@"stepsHistory_calorie", @"MyLoaclization" , @"");
    calorietext.textColor = [UIColor blackColor];
    //raindexlab.center = CGPointMake(self.view.center.x, self.view.center.y-30);
    calorietext.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:calorietext];
    
    metretext = [[UILabel alloc] initWithFrame:CGRectMake(90, 331, 30, 21)]; //17
    //raindexlab.font = [UIFont boldSystemFontOfSize:71.0];
    metretext.font = [UIFont systemFontOfSize:11.0];
    metretext.text = NSLocalizedStringFromTable(@"stepsHistory_metre", @"MyLoaclization" , @"");
    metretext.textColor = [UIColor lightGrayColor];
    //raindexlab.center = CGPointMake(self.view.center.x, self.view.center.y-30);
    metretext.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:metretext];
    
    steppuretext = [[UILabel alloc] initWithFrame:CGRectMake(197, 331, 30, 21)];
    //raindexlab.font = [UIFont boldSystemFontOfSize:71.0];
    steppuretext.font = [UIFont systemFontOfSize:11.0];
    steppuretext.text = NSLocalizedStringFromTable(@"stepsHistory_steps", @"MyLoaclization" , @"");
    steppuretext.textColor = [UIColor lightGrayColor];
    //raindexlab.center = CGPointMake(self.view.center.x, self.view.center.y-30);
    steppuretext.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:steppuretext];
    
    arrivaltext = [[UILabel alloc] initWithFrame:CGRectMake(115, 391, 90, 21)]; //126 68
    //raindexlab.font = [UIFont boldSystemFontOfSize:71.0];
    arrivaltext.font = [UIFont boldSystemFontOfSize:13.0]; //16
    arrivaltext.text = NSLocalizedStringFromTable(@"stepsHistory_arrival", @"MyLoaclization" , @"");
    arrivaltext.textColor = [UIColor lightGrayColor];
    //raindexlab.center = CGPointMake(self.view.center.x, self.view.center.y-30);
    arrivaltext.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:arrivaltext];
    
    suggestiontext = [[UILabel alloc] initWithFrame:CGRectMake(35, 461, 251, 21)];
    //raindexlab.font = [UIFont boldSystemFontOfSize:71.0];
    suggestiontext.font = [UIFont boldSystemFontOfSize:10.0];
    suggestiontext.text = NSLocalizedStringFromTable(@"stepsHistory_suggestiontext", @"MyLoaclization" , @"");
    suggestiontext.textColor = [UIColor lightGrayColor];
    //raindexlab.center = CGPointMake(self.view.center.x, self.view.center.y-30);
    suggestiontext.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:suggestiontext];
    
//    stepslevelnum = [[UILabel alloc] initWithFrame:CGRectMake(90, 163, 140, 80)];
//    stepslevelnum.font = [UIFont boldSystemFontOfSize:71.0];
//    stepslevelnum.text = @"0";
//    stepslevelnum.textColor =  [UIColor colorWithRed:60.0/255.0 green:184.0/255.0 blue:120.0/255.0 alpha:1.0]; // [UIColor colorWithRed:17.0/225.0 green:255.0/255.0 blue:249.0/255.0 alpha:1.0];
//    //ralevellab.center = CGPointMake(self.view.center.x, self.view.center.y-30);
//    stepslevelnum.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:stepslevelnum];
    
//    nodatalabtext = [[UILabel alloc] initWithFrame:CGRectMake(122, 416, 76, 21)];
//    nodatalabtext.font = [UIFont systemFontOfSize:17.0];
//    nodatalabtext.text = NSLocalizedStringFromTable(@"rtHistory_nodatatext", @"MyLoaclization" , @"");
//    nodatalabtext.textColor =  [UIColor lightGrayColor]; // [UIColor colorWithRed:17.0/225.0 green:255.0/255.0 blue:249.0/255.0 alpha:1.0];
//    //ralevellab.center = CGPointMake(self.view.center.x, self.view.center.y-30);
//    nodatalabtext.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:nodatalabtext];
    _AllprogressView.layer.cornerRadius = 10;
    _precessView.layer.cornerRadius = 10;
    // _gaugeCircleLayer1.masksToBounds = YES;
   // _gaugeCircleLayer1.cornerRadius = 8;
    
    _Nodatalabel.text = NSLocalizedStringFromTable(@"stepsHistory_progressbarnodata", @"MyLoaclization" , @"");
    
    //TODO elias
//    NSString *stepshistoryPath = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:NAMEFORUSER] stringByAppendingPathComponent:@"SPDIR"]stringByAppendingPathComponent:[userDefaults objectForKey:USERDEFAULTS_LASTTIMEREFRESH]];
  //  [self stepswriteInfor:stepshistoryPath];
    [self stepswriteInfor:nil];

    
}

-(void)circlelayinit
{
    CGPoint arcCenter = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)-50);
    
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
    _gaugeCircleLayer1.strokeEnd = 0.1;
   _gaugeCircleLayer1.lineCap = kCALineCapRound;
    _gaugeCircleLayer1.path = Truepath.CGPath;
    
    
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
                                                         [self stepswriteInfor:nil];
                                                         
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
    [self stepswriteInfor:[NSString stringWithFormat:@"%@"
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


-(void)stepswriteInfor:(NSString *)SPpath
{
    NSString *stepshistoryPath = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:NAMEFORUSER] stringByAppendingPathComponent:@"SPDIR"]stringByAppendingPathComponent:[userDefaults objectForKey:USERDEFAULTS_LASTTIMEREFRESH]];   //默认读取上次更新后的历史文件
    
    if (SPpath!=nil) {
        stepshistoryPath = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"SPDIR"]stringByAppendingPathComponent:SPpath];
    }
    
    NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:stepshistoryPath];
    
    NSData *mydata = [fh readDataToEndOfFile];
    Byte *byte = (Byte *)[mydata bytes];
    NSInteger steplength = mydata.length;
    if (steplength==0|steplength==1) {
        
        _CalorieLabel.hidden = YES;
        _SyncButton.hidden = NO;
        _Nodatalabel.hidden = NO;
        _precessView.hidden = YES;
        lv1steps = 0;;
        _miterlabel.hidden = YES;
        _stepslabel.hidden = YES;
      //  [self changeValue:0];
        
        
    }else{
        _CalorieLabel.hidden =NO;
        _SyncButton.hidden = YES;
        _Nodatalabel.hidden = YES;
        _precessView.hidden = NO;
        _stepslabel.hidden = NO;
        _miterlabel.hidden = NO;
        
        
        
        int array[steplength/2];
        int num = 0;
        int time = 0;
        for (int i=0; i<(mydata.length-1)/2; i++) {
            array[i]=((byte[i*2+2]<<8)&0xff00)|(byte[i*2+1]&0xff);
            if (array[i]!=0) {
                num = num+array[i];
                time++;
            }
        }
        float mi = (float)num*0.4*[[userDefaults objectForKey:USERDEFAULTS_HIGH] integerValue]/100;
        NSLog(@"mi = %f",mi);
        _stepslabel.text = [NSString stringWithFormat:@"%d",num];
        _miterlabel.text = [NSString stringWithFormat:@"%d",(int)mi];
        float calori =0.003*[[userDefaults objectForKey:USERDEFAULTS_HIGH] integerValue]+([[userDefaults objectForKey:USERDEFAULTS_WEIGHT] floatValue])*0.45+0.16*(num/(6*time))+0.39*6*time;
        if (time==0) {
            calori =0;
        }
        
        //热量＝体表面积×基础代谢率（BMR）×16
        //体表面积＝0.0061身高（cm)+0.0128体重 (kg)-0.1603
        //基础代谢率：女性 18～19岁36.8kcal/(m平方*h)；20～30岁为35.1kcal(m平方*h)；31～40为35.0kcal/(m平方*h）
        
        NSLog(@"这一天总共消耗了%f卡路里",calori);
        lv1steps = calori;//消耗的卡路里
    }
    //计算出应该消耗的卡路里
    if ([[userDefaults objectForKey:USERDEFAULTS_AGE] integerValue]<20) {
        lv3steps = (0.000061*[[userDefaults objectForKey:USERDEFAULTS_HIGH] integerValue]+0.0128*[[userDefaults objectForKey:USERDEFAULTS_WEIGHT] floatValue]-0.1603)*36.8*16;
    }
    else if([[userDefaults objectForKey:USERDEFAULTS_AGE] integerValue]<31&&[[userDefaults objectForKey:USERDEFAULTS_AGE] integerValue]>=20)
    {
        lv3steps = (0.000061*[[userDefaults objectForKey:USERDEFAULTS_HIGH] integerValue]+0.0128*[[userDefaults objectForKey:USERDEFAULTS_WEIGHT] floatValue]-0.1603)*35.1*16;
    }
    else if([[userDefaults objectForKey:USERDEFAULTS_AGE] integerValue]<41&&[[userDefaults objectForKey:USERDEFAULTS_AGE] integerValue]>=31)
    {
        lv3steps = (0.000061*[[userDefaults objectForKey:USERDEFAULTS_HIGH] integerValue]+0.0128*[[userDefaults objectForKey:USERDEFAULTS_WEIGHT] floatValue]-0.1603)*35.0*16;
    }
    else if([[userDefaults objectForKey:USERDEFAULTS_AGE] integerValue]>=41)
    {
        lv3steps = (0.000061*[[userDefaults objectForKey:USERDEFAULTS_HIGH] integerValue]+0.0128*[[userDefaults objectForKey:USERDEFAULTS_WEIGHT] floatValue]-0.1603)*35.0*16;
    }
    if (lv3steps>lv1steps) {
        lv2steps = lv3steps-lv1steps;
    }
    else
    {
        lv2steps=0;     //还需要消耗的卡路里
    }
    
    NSLog(@"lv3steps = %f",lv3steps);
   // NSLog(@"步长 lv1 = %f,lv2 = %f,lv3 = %f,lv4 = %d,lv5 = %d",lv1steps,lv2steps,lv3steps,lv4steps,lv5steps);
    
    [self readStepHistoryFromBle];
    [fh closeFile];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"66666666666");
    
        //[_precessView layoutIfNeeded];
//    });
    
    
    //    serdView = [[Sntmp alloc] initWithFrame:self.view.bounds];
}

-(void)readStepHistoryFromBle
{
 
    if (lv1steps/lv3steps>1) {
        [self changeValue:1];
    }
    else
        [self changeValue:lv1steps/lv3steps];
    
//    if (_precessView.frame.size.width==1) {
//        _precessView.frame = CGRectMake(0, 0, lv1steps/lv3steps*(_AllprogressView.frame.size.width), _AllprogressView.frame.size.height);
//    }
    
    _CalorieLabel.text = [NSString stringWithFormat:@"%d",(int)lv1steps];
    NSLog(@"lv1 = %.f  lv3 = %.f",lv1steps,lv3steps);
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(tmp) userInfo:nil repeats:NO];
   // [self CaloriesGotoRectView:lv1steps/lv3steps];
    
}
-(void)tmp
{
    [self CaloriesGotoRectView:lv1steps/lv3steps];
}

-(void)CaloriesGotoRectView:(float)num    //卡路里进度条
{
    NSTimeInterval animationDuration=0.7f;
    [UIView beginAnimations:@"CaloriesGoto" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = _AllprogressView.frame.size.width;
    float height = _AllprogressView.frame.size.height;
    
    CGRect rect=CGRectMake(0.0f,0.0f,width*num,height);
    _precessView.frame=rect;
    
    [UIView commitAnimations];
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
        NSLog(@"ok  = %@",resultDic);
      //  NSLog(@"ok result = %@",[resultDic objectForKey:@"result"]);
        
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

- (IBAction)Sync:(id)sender {
    [self refresh];
}
@end
