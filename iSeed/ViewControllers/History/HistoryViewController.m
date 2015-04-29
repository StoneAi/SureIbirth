//
//  HistoryViewController.m
//  iSeed
//
//  Created by Chan Bill on 14/11/27.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import "HistoryViewController.h"
#import "RESideMenu.h"
#import "Config.h"
#import "XYAlertViewHeader.h"
#import "FLDemoView.h"


#import "AFHTTPClient.h"
#import "AFNetworking.h"
@interface HistoryViewController ()

@end

@implementation HistoryViewController
{
    NSUserDefaults *userDefaults;
    XYLoadingView *loadingview;
    UIPageControl *pageControl;
    UIButton *nextbutton;
    UIButton *lastbutton;
    UIImageView *_headImageView;
   
//    MainiSeedViewController *mainiseedVC;
    UILabel *name;
    FLDemoView *demoView;
    SerndView *serdView;
    UIButton *backbutton;
    NSString *NAMEFORUSER;
    int number[5];
    PMPeriod *mynewPeriod;
    UIButton *calendarbutton;
    int SleepNum;
    Type showtype;
}
@synthesize pageContent;
@synthesize pageview;
@synthesize lv5;
@synthesize lv4;
@synthesize lv3;
@synthesize lv2;
@synthesize lv1;
@synthesize lv5steps;
@synthesize lv4steps;
@synthesize lv3steps;
@synthesize lv2steps;
@synthesize lv1steps;
@synthesize rtlength;
@synthesize steplength;
@synthesize delegate;
static int ComeState;
@synthesize pmCC;
@synthesize mynewPeriod;

-(id)init:(Type)type
{
    self = [super init];
    
    showtype = type;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    userDefaults = [NSUserDefaults standardUserDefaults];
    NAMEFORUSER  = [userDefaults objectForKey:USERDEFAULTS_USERNAME];
    
    serdView = [[Sntmp alloc] initWithFrame:self.view.bounds];
    demoView = [[SnapView alloc] initWithFrame:self.view.bounds];
   dispatch_async(dispatch_get_global_queue(0, 0), ^{
       [self writeInfor:nil];
       [self stepswriteInfor:nil];
   });
    
    
  //  self.navigationController.navigationBar.barTintColor = NAVIGATIONBAR_BACKCOLOR;
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
    
//        demoView = [[SnapView alloc] initWithFrame:self.view.bounds];
//        
//        demoView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
//        [self.view addSubview:demoView];
    NSLog(@"show = %d",showtype);
    if (showtype==1) {
        //scrolview pageController
        [self ShowfaceScollView];
    }
    
}

-(void)ShowfaceScollView
{
    CGFloat hei;
    if (iPhone4) {
        hei = 64;
    }
    else
        hei = 0;
    
    
    pageview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 600)];
    
    demoView.frame = CGRectMake(pageview.frame.origin.x, pageview.frame.origin.y-100, pageview.frame.size.width, pageview.frame.size.height+100);
    serdView.frame = CGRectMake(pageview.frame.origin.x+pageview.frame.size.width, pageview.frame.origin.y-100, pageview.frame.size.width,pageview.frame.size.height+100);
    
    
    [pageview addSubview:demoView];
    [pageview addSubview:serdView];
    pageview.pagingEnabled = NO;
    pageview.contentSize = CGSizeMake(pageview.frame.size.width*2, pageview.frame.size.height+100);
    pageview.showsVerticalScrollIndicator = NO;
    pageview.showsHorizontalScrollIndicator = NO;
    pageview.delegate = self;
    pageview.scrollEnabled =NO;
    
    [self.view addSubview:pageview];
    
    
    
    backbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backbutton setImage:[UIImage imageNamed:HisButtonBackImage] forState:UIControlStateDisabled];
    backbutton.enabled = NO;
    [self.view addSubview:backbutton];
    
    nextbutton = [[UIButton alloc] initWithFrame:CGRectMake(220, CGRectGetHeight(pageview.frame)-80, 80, 80)];
    nextbutton.backgroundColor = [UIColor clearColor];
    [nextbutton addTarget:self action:@selector(nextButton:) forControlEvents:UIControlEventTouchUpInside];
    nextbutton.center = CGPointMake(self.view.center.x, self.view.center.y+240-hei);
    [nextbutton setImage:[UIImage imageNamed:HisRTImage] forState:UIControlStateNormal];
    nextbutton.enabled = YES;
    
    
    backbutton.center = nextbutton.center;
    // backview.center = nextbutton.center;
    [self.view addSubview:nextbutton];
    
    
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(0, 0, 1, 1);
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.currentPage = 0;
    pageControl.numberOfPages = 2;
    pageControl.hidesForSinglePage = NO;
    pageControl.hidden=YES;
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    pageview.backgroundColor = [UIColor whiteColor];
    pageControl.backgroundColor = [UIColor clearColor];
    
    
    calendarbutton = [[UIButton alloc]initWithFrame:CGRectMake(110, 0, 100, 40)];
    [calendarbutton addTarget:self action:@selector(CalendarControllerShow:) forControlEvents:UIControlEventTouchUpInside];
    calendarbutton.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:calendarbutton];
    
    
    //创建监听器
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(changeLoadingViewState:) name:@"LoadingDismiss" object:nil];
    
    if(ComeState==0)
    {
        [demoView setFirstsize:0 sedsize:0 thirdsize:0 foursize:0 fifthsize:0 type:showtypeface];
        [self refresh];
    }


}


/**********************************************************/

-(void)changeLoadingViewState:(NSNotification *)noti
{
   
    [loadingview dismiss];
    if ([[noti.userInfo objectForKey:@"result"] isEqual:@"true"]) {
        XYAlertView *alertView1 = [XYAlertView alertViewWithTitle:NSLocalizedStringFromTable(@"HistoryVC_UpdateOKAlret_Title", @"MyLoaclization" , @"")
                                                          message:nil
                                                          buttons:[NSArray arrayWithObjects:@"OK", nil]
                                                     afterDismiss:^(long buttonIndex) {
                                                         [self writeInfor:nil];
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

                                                         
                                                         
                                                         nextbutton.enabled = YES;
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



#pragma mark 按键响应

- (IBAction)nextButton:(id)sender
{
    //[self changePage:self];
    nextbutton.enabled = NO;
    
    self.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);//将要显示的view按照正常比例显示出来
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; //InOut 表示进入和出去时都启动动画
    [UIView setAnimationDuration:0.8f];//动画时间
    backbutton.transform=CGAffineTransformMakeScale(25.0f, 25.0f);//先让要显示的view放大
    [UIView commitAnimations]; //启动动画
    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(buttonremovebegin) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.6 target:self selector:@selector(buttonremoveend) userInfo:nil repeats:NO];
}
-(void)buttonremovebegin
{
    self.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);//将要显示的view按照正常比例显示出来
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; //InOut 表示进入和出去时都启动动画
    [UIView setAnimationDuration:0.8f];//动画时间
    backbutton.transform=CGAffineTransformMakeScale(1.0f, 1.0f);//先让要显示的view最小直至消失
    [UIView commitAnimations]; //
    [self changePage:self];
}
-(void)buttonremoveend
{
    nextbutton.enabled = YES;
}

-(void)rmalert
{
    [FVCustomAlertView hideAlertFromView:self.view fading:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
//    [self writeInfor];
//    [self stepswriteInfor];
    

}
-(void)viewDidAppear:(BOOL)animated
{
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    int page = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    pageControl.currentPage =page;
}
-(void) changePage:(id)sender
{

    NSInteger page = pageControl.currentPage;
    
    if (pageControl.currentPage==0) {
           page = 1;
        pageControl.currentPage++;
    [nextbutton setImage:[UIImage imageNamed:HisStepImage] forState:UIControlStateNormal];
    }
    else if (pageControl.currentPage==1) {
        page=0;
        pageControl.currentPage--;
         [nextbutton setImage:[UIImage imageNamed:HisRTImage] forState:UIControlStateNormal];
       
    }
    if (page==0) {
      //  self.navigationItem.title = @"辐射";
        //pageControl.currentPage=0;
        
    }
    else if(page==1){
       // self.navigationItem.title = @"计步";
        
        //pageControl.currentPage=1;
    }
    CGRect bounds = pageview.bounds;
    bounds.origin.x = CGRectGetWidth(bounds)*page;
    bounds.origin.y = -40;
    
    [pageview scrollRectToVisible:bounds animated:NO];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 切视图方法
-(void)findState:(int)state
{
    ComeState=state;
    NSLog(@"state get = %d",state);
}
#pragma mark 读文件
-(void)writeInfor:(NSString *)RTpath
{
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
    rtlength = mydata.length;
    if (rtlength==0|rtlength==1) {
        
    
    }
    else{
        ComeState=1;
    
    int array[rtlength/2];
    
    for (int i=0; i<(mydata.length-1)/2; i++) {
    array[i]=((byte[i*2+2]<<8)&0xff00)|(byte[i*2+1]&0xff);
      //  NSLog(@"array[%d]=%d",i,array[i]);
        if (array[i]!=0&&array[i]<=160){
                lv1++;
        }
        else if(array[i] == 0)
        {
            SleepNum++;
        }
        else if (array[i]>160&&array[i]<=260)
        {
            lv2++;
        }
        else if (array[i]>260&&array[i]<=310)
        {
            lv3++;
        }
        else if (array[i]>310&&array[i]<=360)
        {
            lv4++;
        }
        else if (array[i]>360)
        {
            if (array[i]!=0xffff) {
                lv5++;
            }
           else
           {
               SleepNum++;
               NSLog(@"去除一个休眠数");
               NSLog(@"共去除休眠数%d个",SleepNum);
           }
        }
        
    }
    }
    NSLog(@"共去除休眠数%d个",SleepNum);
    NSLog(@"lv1 = %d,lv2 = %d,lv3 = %d,lv4 = %d,lv5 = %d",lv1,lv2,lv3,lv4,lv5);
    SleepNum =0;
    
    [fh closeFile];
    [self readRTHistoryFromBle];
    //    demoView = [[SnapView alloc] initWithFrame:self.view.bounds];
    
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
    steplength = mydata.length;
    if (steplength==0|steplength==1) {
        
    }else{
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
    NSLog(@"步长 lv1 = %f,lv2 = %f,lv3 = %f,lv4 = %d,lv5 = %d",lv1steps,lv2steps,lv3steps,lv4steps,lv5steps);
    
    
    [fh closeFile];
    [self readStepHistoryFromBle];
    //    serdView = [[Sntmp alloc] initWithFrame:self.view.bounds];
}

//分配历史图形大小
-(void)readRTHistoryFromBle
{
    
    int all = 100;

    float tmp1 = (float)lv1/(float)(lv1+lv2+lv3+lv4+lv5);
    float tmp2 = (float)lv2/(float)(lv1+lv2+lv3+lv4+lv5);
    float tmp3 = (float)lv3/(float)(lv1+lv2+lv3+lv4+lv5);
    float tmp4 = (float)lv4/(float)(lv1+lv2+lv3+lv4+lv5);
    float tmp5 = (float)lv5/(float)(lv1+lv2+lv3+lv4+lv5);
    
  //  NSLog(@"tmp1=%f,tmp2=%f,tmp3=%f,tmp4=%f,tmp5=%f,bug = %f",tmp1,tmp2,tmp3,tmp4,tmp5,bug);
    long rtlv1 = tmp1*all;
    long rtlv2 = tmp2*all;
    long rtlv3 = tmp3*all;
    long rtlv4 = tmp4*all;
    long rtlv5 = tmp5*all;
    NSLog(@"rtlv = %ld,%ld,%ld,%ld,%ld",rtlv1,rtlv2,rtlv3,rtlv4,rtlv5);
    if (rtlv1+rtlv2+rtlv3+rtlv4+rtlv5!=100) {
        rtlv1=rtlv1+100-(rtlv1+rtlv2+rtlv3+rtlv4+rtlv5);
    }
    if (rtlength==0|rtlength==1) {
        [demoView setFirstsize:0 sedsize:0 thirdsize:0 foursize:0 fifthsize:0 type:showtypeface];
    }
    else{
//        [demoView setFirstsize:0 sedsize:0 thirdsize:20 foursize:30 fifthsize:50 type:showtypeface];
    [demoView setFirstsize:rtlv1 sedsize:rtlv2 thirdsize:rtlv3 foursize:rtlv4 fifthsize:rtlv5 type:showtypeface];
    }
//    [demoView setFirstsize:50];
//    [demoView setSedsize:50];
//    [demoView setThirdsize:20];
//    [demoView setFourthsize:15];
//    [demoView setFifthsize:15];
    lv1=0;lv2=0;lv3=0;lv4=0;lv5=0;
 
}
-(void)readStepHistoryFromBle
{
    int all = 100;
    float bug =(float)lv1steps/lv3steps;
    float tmp1 = (float)lv1steps/lv3steps;
    float tmp2 = (float)lv2steps/lv3steps;
    float tmp3 = (float)lv3steps/lv3steps;

    long steplv1 = tmp1*all;
    long steplv2 = tmp2*all;
    long steplv3 = tmp3*all;
    
    steplv2 = steplv3-steplv1;
    if (steplv3-steplv1<0) {
        steplv2=0;
    }
    
    NSLog(@"步长：%ld,%ld,%ld,%f",steplv1,steplv2,steplv3,bug);

    if (steplength==0|steplength==1) {
        [serdView setSize:0 Sedsize:0 Thirdsize:0];
    }
    else
        [serdView setSize:steplv1 Sedsize:steplv2 Thirdsize:lv3steps];
    lv1steps=0;lv2steps=0;lv3steps=0;lv4steps=0;lv5steps=0;
   
    
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
                                                                 
                                                                 
                                                                 [self.delegate readhistory];
                                                                 
                                                                 
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
                                                        
                                                    
                                                         [self.delegate readhistory];
                                                         
                                                         
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



@end
