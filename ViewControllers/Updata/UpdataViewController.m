//
//  UpdataViewController.m
//  iSeed
//
//  Created by Chan Bill on 14/11/27.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import "UpdataViewController.h"
#import "AppDelegate.h"
#import "AFNetworkReachabilityManager.h"
@interface UpdataViewController ()
{
    NSString *appVersion;
    UIImageView *AppNeedUpdate ;
    UIImageView *FirmNeedUpdate;
    BOOL isnet;
    UILabel*FirmVersion;
    UILabel *AppVersion;
}

@end

@implementation UpdataViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    
    
    
    
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStringFromTable(@"SettingVC_Update", @"MyLoaclization" , @"");//SettingVC_Update
    [self initWithView];
    
    
    [self isNetwork];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initWithView
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    //imageView.image = [UIImage imageNamed:@"homepagebackground1231.png"];
    [imageView setImage:[UIImage imageNamed:MainViewImage]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:imageView];
    
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 170, 320, 1)];
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 293, 320, 1)];
    UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(29, 232, 320, 1)];
    view1.backgroundColor = [UIColor lightGrayColor];
    view2.backgroundColor = [UIColor lightGrayColor];
    view3.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    [self.view addSubview:view3];
    
    FirmVersion = [[UILabel alloc] initWithFrame:CGRectMake(234, 256, 50, 16)];
    FirmVersion.textAlignment = NSTextAlignmentLeft;
    FirmVersion.font = [UIFont systemFontOfSize:15];
    FirmVersion.text = [NSString stringWithFormat:@"V%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"version"]];
    
    AppVersion = [[UILabel alloc]initWithFrame:CGRectMake(234, 195, 50, 16)];
    AppVersion.textAlignment = NSTextAlignmentLeft;
    AppVersion.font = [UIFont systemFontOfSize:15];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    AppVersion.text = [NSString stringWithFormat:@"V%@",[infoDic objectForKey:@"CFBundleVersion"] ];
    
    
    
    
    UIImageView *imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(279, 194, 8, 15)];
    UIImageView*imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(279, 256, 9, 15)];
    AppNeedUpdate = [[UIImageView alloc] initWithFrame:CGRectMake(234, 195, 36, 16)];
    FirmNeedUpdate = [[UIImageView alloc]initWithFrame:CGRectMake(234, 256, 36, 16)];
    
    FirmNeedUpdate.image = [UIImage imageNamed:@"pic_new"];
    AppNeedUpdate.image = [UIImage imageNamed:@"pic_new"];
    FirmNeedUpdate.hidden = YES;
    AppNeedUpdate.hidden = YES;
    
    [imageview1 setImage:[UIImage imageNamed:@"btn_arrow0"]];
    [imageview2 setImage:[UIImage imageNamed:@"btn_arrow0"]];
    
    
    
    [self.view addSubview:imageview1];
    [self.view addSubview:imageview2];
    [self.view addSubview: AppNeedUpdate];
    [self.view addSubview:FirmNeedUpdate];
    [self.view addSubview:FirmVersion];
    [self.view addSubview:AppVersion];
    
    UILabel *Applabel = [[UILabel alloc] initWithFrame:CGRectMake(29, 191, 220, 21)];
    UILabel *Firmlabel = [[UILabel alloc]initWithFrame:CGRectMake(29, 253, 220, 21)];
    Applabel.text = NSLocalizedStringFromTable(@"UpDate_APPupdate", @"MyLoaclization" , @"");
    Firmlabel.text = NSLocalizedStringFromTable(@"UpDate_FirmWareupdate", @"MyLoaclization" , @"");
    Applabel.textColor = [UIColor blackColor];
    Firmlabel.textColor = [UIColor blackColor];
    [self.view addSubview:Applabel];
    [self.view addSubview:Firmlabel];
    
    UIButton *IsappUpdate = [[UIButton alloc] initWithFrame:CGRectMake(5, 179, 310, 47)];
    UIButton *IsfirmUpdate = [[UIButton alloc] initWithFrame:CGRectMake(4, 240, 310, 47)];
    IsfirmUpdate.backgroundColor = [UIColor clearColor];
    IsappUpdate.backgroundColor = [UIColor clearColor];
    [IsappUpdate addTarget:self action:@selector(isAppUpdate:) forControlEvents:UIControlEventTouchUpInside];
    [IsfirmUpdate addTarget:self action:@selector(isFirmUpdate:) forControlEvents:UIControlEventTouchUpInside];
    IsappUpdate.enabled = YES;
    IsfirmUpdate.enabled = YES;
    
    [self.view addSubview:IsappUpdate];
    [self.view addSubview:IsfirmUpdate];
    
    [self NeedUpdate];
    NSLog(@"firm=  %d",AppDelegateAccessor.isFirmwareNeedUpdate);

}

-(void)isAppUpdate:(id)sender
{
    if (!AppDelegateAccessor.isAppNeedUpdate) {
        XYAlertView *alert = [XYAlertView alertViewWithTitle:nil message:NSLocalizedStringFromTable(@"UpDate_Alret_Titil", @"MyLoaclization" , @"") buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"APPSure", @"MyLoaclization" , @""),  nil] afterDismiss:^(long buttonIndex) {
            
        }];
        [alert show];
        AppNeedUpdate.hidden=YES;
        AppVersion.hidden = NO;
    }
    else{
        NSURL *url = [NSURL URLWithString:AppDelegateAccessor.appUpdateURL];//[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/wan-zhuan-quan-cheng/id%i?mt=8",iFeverAPPID]];
        [[UIApplication sharedApplication]openURL:url];
    }
    NSLog(@"app更新");

}
-(void)isFirmUpdate:(id)sender
{
    
    if (!AppDelegateAccessor.isFirmwareNeedUpdate) {
        FirmNeedUpdate.hidden = YES;
        FirmVersion.hidden = NO;
        XYAlertView *alert = [XYAlertView alertViewWithTitle:nil message:NSLocalizedStringFromTable(@"UpDate_Alret_Titil", @"MyLoaclization" , @"") buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"APPSure", @"MyLoaclization" , @""),  nil] afterDismiss:^(long buttonIndex) {
            
        }];
        [alert show];
    }
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_BLESTATE] isEqual:@"0"])
    {
        XYAlertView *alert = [XYAlertView alertViewWithTitle:nil message:NSLocalizedStringFromTable(@"HistoryVC_ConnectBLE", @"MyLoaclization" , @"") buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"APPSure", @"MyLoaclization" , @""),  nil] afterDismiss:^(long buttonIndex) {
            
        }];
        [alert show];
  
    }
    else if (!isnet)
    {
        XYAlertView *alert = [XYAlertView alertViewWithTitle:nil message:NSLocalizedStringFromTable(@"InforVCAlretNet_Message", @"MyLoaclization" , @"") buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"APPSure", @"MyLoaclization" , @""),  nil] afterDismiss:^(long buttonIndex) {
            
        }];
        [alert show];
    
    }
    else{
        //一键升级
        NSNotification *loadviewdiss = [NSNotification notificationWithName:@"DFU" object:nil userInfo:@{@"result":@"false"}];
        //notificationWithName:@"LoadingDismiss" object:nil
        [[NSNotificationCenter defaultCenter] postNotification:loadviewdiss];
        
        [self.navigationController pushViewController:[[DFUViewController alloc] init] animated:YES];
    }
    
    
    
    NSLog(@"固件更新");
}
-(void)NeedUpdate
{   //app是否需要更新
    if (AppDelegateAccessor.isFirmwareNeedUpdate) {
        FirmNeedUpdate.hidden = NO;
        FirmVersion.hidden = YES;
    }
    else
    {
        FirmNeedUpdate.hidden = YES;
        FirmVersion.hidden = NO;
    }
    
    if (AppDelegateAccessor.isAppNeedUpdate) {
        AppNeedUpdate.hidden = NO;
        AppVersion.hidden = YES;
    }
    else
    {
        AppNeedUpdate.hidden = YES;
        AppVersion.hidden = NO;
    }

}

-(void)isNetwork
{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld", status);
        if (status) {
            isnet = YES;
        }
        else
            isnet = NO;
    }];
    //[[AFNetworkReachabilityManager sharedManager] stopMonitoring];
   // return isnet;
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
