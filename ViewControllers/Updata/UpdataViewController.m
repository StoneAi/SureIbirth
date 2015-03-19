//
//  UpdataViewController.m
//  iSeed
//
//  Created by Chan Bill on 14/11/27.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import "UpdataViewController.h"
#import "AppDelegate.h"
@interface UpdataViewController ()
{
    NSString *appVersion;
    UIImageView *AppNeedUpdate ;
    UIImageView *FirmNeedUpdate;
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
    self.navigationItem.title = @"版本更新";
    [self initWithView];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initWithView
{
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 170, 320, 1)];
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 293, 320, 1)];
    UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(29, 232, 320, 1)];
    view1.backgroundColor = [UIColor lightGrayColor];
    view2.backgroundColor = [UIColor lightGrayColor];
    view3.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    [self.view addSubview:view3];
    
    UIImageView *imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(279, 194, 8, 15)];
    UIImageView*imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(279, 256, 9, 15)];
    AppNeedUpdate = [[UIImageView alloc] initWithFrame:CGRectMake(234, 195, 36, 16)];
    FirmNeedUpdate = [[UIImageView alloc]initWithFrame:CGRectMake(234, 256, 36, 16)];
    
    
    [imageview1 setImage:[UIImage imageNamed:@"btn_arrow0"]];
    [imageview2 setImage:[UIImage imageNamed:@"btn_arrow0"]];
    
    [self.view addSubview:imageview1];
    [self.view addSubview:imageview2];
    [self.view addSubview: AppNeedUpdate];
    [self.view addSubview:FirmNeedUpdate];
    
    UILabel *Applabel = [[UILabel alloc] initWithFrame:CGRectMake(29, 191, 220, 21)];
    UILabel *Firmlabel = [[UILabel alloc]initWithFrame:CGRectMake(29, 253, 110, 21)];
    Applabel.text = @"iBirthstone App版本更新";
    Firmlabel.text = @"蓝牙固件更新";
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
    

}

-(void)isAppUpdate:(id)sender
{
    if (!AppDelegateAccessor.isAppNeedUpdate) {
        XYAlertView *alert = [XYAlertView alertViewWithTitle:nil message:@"当前已经是最新版本!" buttons:[NSArray arrayWithObjects:@"确定",  nil] afterDismiss:^(long buttonIndex) {
            
        }];
        [alert show];
    }
    else{
        NSURL *url = [NSURL URLWithString:AppDelegateAccessor.appUpdateURL];//[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/wan-zhuan-quan-cheng/id%i?mt=8",iFeverAPPID]];
        [[UIApplication sharedApplication]openURL:url];
    }
    NSLog(@"app更新");

}
-(void)isFirmUpdate:(id)sender
{
    
    NSNotification *loadviewdiss = [NSNotification notificationWithName:@"DFU" object:nil userInfo:@{@"result":@"false"}];
    //notificationWithName:@"LoadingDismiss" object:nil
    [[NSNotificationCenter defaultCenter] postNotification:loadviewdiss];
    
    [self.navigationController pushViewController:[[DFUViewController alloc] init] animated:YES];
    
    
    
    
    NSLog(@"固件更新");
}
-(void)NeedUpdate
{   //app是否需要更新
    if (AppDelegateAccessor.isAppNeedUpdate) {
        AppNeedUpdate.image = [UIImage imageNamed:@"pic_new"];
    }
    else
        AppNeedUpdate.hidden = YES;

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
