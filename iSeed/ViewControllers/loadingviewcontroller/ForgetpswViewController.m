//
//  ForgetpswViewController.m
//  iSeed
//
//  Created by Chan Bill on 15/3/20.
//  Copyright (c) 2015年 elias kang. All rights reserved.
//

#import "ForgetpswViewController.h"
#import "XYAlertView.h"
#import "AFHTTPClient.h"
#import "Config.h"
#import "AFNetworkReachabilityManager.h"
#import "FVCustomAlertView.h"
@interface ForgetpswViewController ()

@end

@implementation ForgetpswViewController
{   XYLoadingView *loading;
    NSUserDefaults *userDefaults;
    UIButton *returnbutton;
    UITextField *phonenum;
    UITextField *checknum;
    UITextField *passwd;
    UITextField *checkpasswd;
    UIButton *getchecknum;
    UIButton *aggetchecknum;
    UIView *twoview;
    UIButton *registbutton;
    AFHTTPClient *Client;
    NSString *BaseURLString;
    NSString *num;
    NSString *check;
    NSString *pwd;
    NSString *pwdcheck;
    NSString *NAMEFORUSER;
    NSString *imageDir;
    int i;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    BaseURLString = @"http://120.24.237.180:8080/PregnantHealth";
    
    //TemperatureApp/sendCaptchaByCellphone.jsp
    // Client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    twoview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    twoview.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:twoview];
    
    UINavigationBar *nav = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 65)];
    //nav.backgroundColor = NAVIGATIONBAR_BACKCOLOR;
    [nav setBarTintColor:NAVIGATIONBAR_BACKCOLOR];
    [self.view addSubview:nav];
    
    UILabel *regist = [[UILabel alloc] initWithFrame:CGRectMake(100, 27, 120, 30)];
    regist.text = NSLocalizedStringFromTable(@"Lable_changepsd_Title",@"MyLoaclization" , @"");
    regist.textAlignment = NSTextAlignmentCenter;
    regist.font = [UIFont systemFontOfSize:14.0];
    regist.textColor = [UIColor whiteColor];
    [self.view addSubview:regist];
    
    
    returnbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    [returnbutton setImage:[UIImage imageNamed:@"btn_arrow_back"] forState:UIControlStateNormal];
    [returnbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [returnbutton addTarget:self action:@selector(returntofirst) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnbutton];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"02text_inputbox.png"]];
    image.frame = CGRectMake(25,187, 270, 40);
    phonenum  = [[UITextField alloc]initWithFrame:CGRectMake(37,192, 158,30)];
    getchecknum = [[UIButton alloc]initWithFrame:CGRectMake(200, 192, 79, 30)];
    phonenum.placeholder = NSLocalizedStringFromTable(@"change_text",@"MyLoaclization" , @"");
    phonenum.textAlignment = NSTextAlignmentCenter;
    phonenum.font = [UIFont systemFontOfSize:14.0];
    phonenum.textColor = [UIColor grayColor];
    // phonenum.keyboardType = UIKeyboardTypeNumberPad;
    [getchecknum setTitle:NSLocalizedStringFromTable(@"Registtwo_Getcheck_Text",@"MyLoaclization" , @"") forState:UIControlStateNormal];
    [getchecknum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [getchecknum setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [getchecknum addTarget:self action:@selector(getchecknum) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *image1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"01text_inputbox.png"]];
    image1.frame = CGRectMake(25,248, 270, 40);
    checknum  = [[UITextField alloc]initWithFrame:CGRectMake(37,253, 240,30)];
    aggetchecknum = [[UIButton alloc]initWithFrame:CGRectMake(200, 253, 79, 30)];
    checknum.placeholder = NSLocalizedStringFromTable(@"Registtwo_PutIncheckNum_Text",@"MyLoaclization" , @"");
    checknum.textAlignment = NSTextAlignmentCenter;
    checknum.font = [UIFont systemFontOfSize:14.0];
    checknum.textColor = [UIColor grayColor];
    [aggetchecknum setTitle:NSLocalizedStringFromTable(@"Registtwo_ReGetcheckNum_Text",@"MyLoaclization" , @"") forState:UIControlStateNormal];
    [aggetchecknum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [aggetchecknum setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    //[aggetchecknum addTarget:self action:@selector(aggetchenum) forControlEvents:UIControlEventTouchUpInside];
    getchecknum.titleLabel.font = [UIFont systemFontOfSize:14.0];
    aggetchecknum.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    getchecknum.backgroundColor = [UIColor whiteColor];
    aggetchecknum.backgroundColor = [UIColor whiteColor];
    phonenum.backgroundColor = [UIColor whiteColor];
    checknum.backgroundColor = [UIColor whiteColor];
    
    
    phonenum.delegate = self;
    checknum.delegate = self;
    phonenum.returnKeyType = UIReturnKeyDone;
    checknum.returnKeyType = UIReturnKeyDone;
    // phonenum.keyboardType = UIKeyboardTypeNamePhonePad;
    
    [twoview addSubview:image];
    [twoview addSubview:image1];
    [twoview addSubview:checknum];
    // [twoview addSubview:aggetchecknum];
    [twoview addSubview:phonenum];
    [twoview addSubview:getchecknum];
    //01text_inputbox
    UIImageView *image2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"01text_inputbox.png"]];
    image2.frame = CGRectMake(25, 309, 270, 40);
    UIImageView *image3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"01text_inputbox.png"]];
    image3.frame = CGRectMake(25, 369, 270, 40);
    
    
    passwd = [[UITextField alloc] initWithFrame:CGRectMake(37, 314, 240, 30)];
    checkpasswd = [[UITextField alloc]initWithFrame:CGRectMake(37, 374, 240, 30)];
    passwd.delegate = self;
    checkpasswd.delegate = self;
    passwd.backgroundColor = [UIColor whiteColor];
    checkpasswd.backgroundColor = [UIColor whiteColor];
    passwd.placeholder = NSLocalizedStringFromTable(@"PutInPasswd_Text",@"MyLoaclization" , @"");
    checkpasswd.placeholder = NSLocalizedStringFromTable(@"CheckPasswd_Text",@"MyLoaclization" , @"");
    checkpasswd.textAlignment = NSTextAlignmentCenter;
    passwd.textAlignment = NSTextAlignmentCenter;
    
    passwd.font = [UIFont systemFontOfSize:14.0];
    passwd.returnKeyType = UIReturnKeyDone;
    checkpasswd.font = [UIFont systemFontOfSize:14.0];
    checkpasswd.returnKeyType = UIReturnKeyDone;
    checkpasswd.secureTextEntry = YES;
    passwd.secureTextEntry = YES;
    // [checkpasswd addTarget:self action:@selector(moveview) forControlEvents:UIControlEventTouchUpInside];
    
    [twoview addSubview:image2];
    [twoview addSubview:image3];
    [twoview addSubview:passwd];
    [twoview addSubview:checkpasswd];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    
    registbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    registbutton.frame = CGRectMake(100, 480, 100, 50);
    [registbutton setTitle:NSLocalizedStringFromTable(@"NextButton_Title",@"MyLoaclization" , @"") forState:UIControlStateNormal];
    [registbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    registbutton.backgroundColor = [UIColor whiteColor];
    
    registbutton.titleLabel.font = [UIFont systemFontOfSize:22.0];
    [registbutton addTarget:self action:@selector(isNetwork) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registbutton];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==checkpasswd) {
        
        
        NSTimeInterval animationDuration=0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        //上移30个单位，按实际情况设置
        CGRect rect=CGRectMake(0.0f,-60,width,height);
        twoview.frame=rect;
        [UIView commitAnimations];
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    if (theTextField == phonenum) {
        num = phonenum.text;
    }
    if (theTextField == checknum) {
        check = checknum.text;
    }
    if (theTextField == passwd) {
        pwd = passwd.text;
    }
    if (theTextField == checkpasswd) {
        pwdcheck = checkpasswd.text;
        [self resumeView];
    }
    return YES;
    
}


-(void)hidenKeyboard
{
    num = phonenum.text;
    check = checknum.text;
    pwd = passwd.text;
    pwdcheck = checkpasswd.text;
    [phonenum resignFirstResponder];
    [checknum resignFirstResponder];
    [passwd resignFirstResponder];
    [checkpasswd resignFirstResponder];
    [self resumeView];
}

-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,0.0f,width,height);
    twoview.frame=rect;
    [UIView commitAnimations];
    
    
}
-(void)isNetwork
{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld", status);
        if (!status) {
            [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Networking_isNot",@"MyLoaclization" , @"")];
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
        }
        else
            [self didregist];
    }];
}


-(void)didregist
{
    
    num = phonenum.text;
    check = checknum.text;
    pwd = passwd.text;
    pwdcheck = checkpasswd.text;
    NSLog(@"num = %@   check = %@     pwd = %@      pwdcheck = %@",num,check,pwd,pwdcheck);
    
    
    if (([phonenum.text isEqual:@""])|([checknum.text isEqual:@""])|([passwd.text isEqual:@""])|([checkpasswd.text isEqual:@""])) {
        XYAlertView *alert = [XYAlertView alertViewWithTitle:NSLocalizedStringFromTable(@"Changepasswd_alret_title",@"MyLoaclization" , @"") message:NSLocalizedStringFromTable(@"Changepasswd_alret_message",@"MyLoaclization" , @"") buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"Changepasswd_Alret_Button",@"MyLoaclization" , @""),  nil] afterDismiss:^(long buttonIndex) {
            
        }];
        [alert show];
    }
    else
    {
        if ([pwd isEqual:pwdcheck]) {
            //  [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
            loading = [XYLoadingView loadingViewWithMessage:NSLocalizedStringFromTable(@"RLoadingview_Message",@"MyLoaclization" , @"")];
            [loading show];
            // [parameters setValue:@"15815549151" forKey:@"phoneNo"];
            [parameters setValue:check forKey:@"captcha"];
            [parameters setValue:pwdcheck forKey:@"passwd"];
            NSString *order = @"changePasswd.jsp";
            [self postHttpUrl:order postInfo:parameters state:1];
            NSLog(@"parameters = %@",parameters);
            
            
            
        }
        else{
            [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Registtwo_Passwdnotsuit",@"MyLoaclization" , @"")];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
        }
    }
    
    
    
}
-(BOOL)isEmail:(NSString *)string
{
    BOOL isemail = NO;
   const char *p = [string UTF8String];
    for (int j = 0; j<[string length]; j++) {
        if (p[j] =='@') {
            isemail = YES;
        }
        
    }
    return isemail;
}
-(void)getchecknum
{
    getchecknum.enabled =NO;
    
    num = phonenum.text;
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
     NSString *order;
    if ([self isEmail:num]) {
        [parameters setValue:num forKey:@"email"];
         order = @"sendCaptchaByEmail.jsp";
        NSLog(@"邮箱");
    }
    else
    {
        [parameters setValue:num forKey:@"phoneNo"];
        order = @"sendCaptchaByCellphone.jsp";
        NSLog(@"手机号码");
    }
    // [parameters setValue:@"15815549151" forKey:@"phoneNo"];
    [parameters setValue:@"2" forKey:@"type"];
   
    [self postHttpUrl:order postInfo:parameters state:0];
    NSLog(@"parameters = %@",parameters);
    
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(changetime) userInfo:nil repeats:NO];
    
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
        NSLog(@"ok result = %@",resultDic);
        
        if (state==0) {
            if ([[resultDic objectForKey:@"result"]isEqual:@"false"]) {
                getchecknum.enabled = YES;
                [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Registtwo_Getcheckfaile",@"MyLoaclization" , @"")];
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
            }
   
        }
        else
        {
            if ([[resultDic objectForKey:@"result"]isEqual:@"false"]) {
                [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Change_passwordfalse",@"MyLoaclization" , @"")];
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
            }
            else if ([[resultDic objectForKey:@"result"]isEqual:@"captchfalse "]) {
                [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Registtwo_Checknim_faile",@"MyLoaclization" , @"")];
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
            }
            else
            {
                [loading dismiss];
                [(AppDelegate *)[UIApplication sharedApplication].delegate setlogin];
            }
 
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"由于网络原因失败error = %@",error.localizedDescription);
        
        if (state == 0) {
            getchecknum.enabled = YES;
            [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Registtwo_Getcheckfaile",@"MyLoaclization" , @"")];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
        }
       else
       {
       
       
       }
        
    }];
    
}

-(void)returntofirst
{
    [(AppDelegate *)[UIApplication sharedApplication].delegate setlogin];

}

-(void)changetime
{
    getchecknum.enabled = YES;
}

-(void)rmalert
{
    [FVCustomAlertView hideAlertFromView:self.view fading:YES];
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

@end
