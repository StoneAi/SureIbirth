
    
//
//  LoadingViewController.m
//  iSeed
//
//  Created by Chan Bill on 15/1/8.
//  Copyright (c) 2015年 elias kang. All rights reserved.
//

#import "LoadingViewController.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController
{
    UITextField *loginfield;
    UITextField *pwdfield;
    NSUserDefaults *userDefaults;
    NSString *usrname;
    NSString *passwd;
    NSString *BaseURLString;
    XYLoadingView *loading;
    UIView *textview;
    NSString *imageDir;
    NSString *database_path;
    UIView *myview;
}


- (void)viewDidLoad {
    [super viewDidLoad];
  //  self.view.frame = ;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
   // [self.view addSubview:myview];
    BaseURLString = @"http://115.29.205.2:8080/PregnantHealth";
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self initviewcontroller];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initviewcontroller
{
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:LoginLogo]];
    img.frame = CGRectMake(50, 40, 229, 298);
    [self.view addSubview:img];
    userDefaults = [NSUserDefaults standardUserDefaults];
    UIButton *loginbutton = [[UIButton alloc]initWithFrame:CGRectMake(32, 450, 120, 40)];
    UIButton *registbutton = [[UIButton alloc]initWithFrame:CGRectMake(168, 450, 120, 41)];
//    loginbutton.center = CGPointMake(self.view.center.x, 400);
//    registbutton.center = CGPointMake(self.view.center.x, 480);
    loginbutton.backgroundColor = [UIColor clearColor];
    registbutton.backgroundColor = [UIColor clearColor];
    
    registbutton.titleLabel.textColor = [UIColor blackColor];
    loginbutton.titleLabel.textAlignment = NSTextAlignmentCenter;
    registbutton.titleLabel.textAlignment = NSTextAlignmentCenter;
    loginbutton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    registbutton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [loginbutton addTarget:self action:@selector(loginpress) forControlEvents:UIControlEventTouchUpInside];
    [registbutton addTarget:self action:@selector(registpress) forControlEvents:UIControlEventTouchUpInside];
    [loginbutton setBackgroundImage:[UIImage imageNamed:LoginlogImage] forState:UIControlStateNormal];
     [loginbutton setTitle:NSLocalizedStringFromTable(@"LoginL", @"MyLoaclization", nil) forState:UIControlStateNormal];
    [loginbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    [loginbutton setImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"Loginpic", @"MyLoaclization", nil)] forState:UIControlStateHighlighted];
    [registbutton setBackgroundImage:[UIImage imageNamed:LoginzhuceImage] forState:UIControlStateNormal];
    [registbutton setTitle:NSLocalizedStringFromTable(@"LoginRegist", @"MyLoaclization", nil) forState:UIControlStateNormal];
    [registbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    //[registbutton setTitle:@"注册" forState:UIControlStateNormal];
    
    UIButton *gotovipose = [[UIButton alloc]initWithFrame:CGRectMake(81, 530, 158, 30)];
    [gotovipose setTitle:@"www.vipose.com" forState:UIControlStateNormal];
    [gotovipose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    gotovipose.titleLabel.font =[UIFont systemFontOfSize:19.0];
    [gotovipose addTarget:self action:@selector(gotopress) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:gotovipose];
    [self.view addSubview:loginbutton];
    [self.view addSubview:registbutton];
//    textview = [[UIView alloc]initWithFrame:CGRectMake(0, 330, 320, 90)];
//    textview.backgroundColor = [UIColor clearColor];
//    UIImageView *account = [[UIImageView alloc] initWithFrame:CGRectMake(32, 330, 256, 40)];
//    UIImageView *passwdd = [[UIImageView alloc] initWithFrame:CGRectMake(32, 380, 256, 40)];
//    [account setImage:[UIImage imageNamed:LoginEditerImage]];
//    [passwdd setImage:[UIImage imageNamed:LoginEditerImage]];
//    [self.view addSubview:account];
//    [self.view addSubview:passwdd];
    
    
    loginfield = [[UITextField alloc] initWithFrame:CGRectMake(32, 350, 256, 40)];
    pwdfield = [[UITextField alloc]initWithFrame:CGRectMake(32, 400, 256, 40)];
    loginfield.delegate = self;
    pwdfield.delegate = self;
    loginfield.backgroundColor = [UIColor whiteColor];
    pwdfield.backgroundColor = [UIColor whiteColor];
    loginfield.placeholder = NSLocalizedStringFromTable(@"LoginInputname", @"MyLoaclization", nil);
    pwdfield.placeholder = NSLocalizedStringFromTable(@"LoginInputPasswd", @"MyLoaclization", nil);
    
    loginfield.text = [userDefaults objectForKey:USERDEFAULTS_USERNAME];
    
    loginfield.keyboardType = UIKeyboardTypeNumberPad;
    loginfield.borderStyle = UITextBorderStyleRoundedRect;
    pwdfield.borderStyle = UITextBorderStyleRoundedRect;
    loginfield.font = [UIFont systemFontOfSize:18.0];
    loginfield.returnKeyType = UIReturnKeyDone;
    pwdfield.font = [UIFont systemFontOfSize:18.0];
    pwdfield.returnKeyType = UIReturnKeyDone;
    pwdfield.secureTextEntry = YES;
    
    [self.view addSubview:loginfield];
    [self.view addSubview:pwdfield];
    //[self.view addSubview:textview];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
   // [self isNetwork];
}


#pragma mark 按键处理
-(void)loginpress
{
    
    NSData *data = [loginfield.text dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data2 = [pwdfield.text dataUsingEncoding:NSUTF8StringEncoding];
    if (data.length<4|data2.length<4) {
        
        XYAlertView *alert = [XYAlertView alertViewWithTitle:nil message:NSLocalizedStringFromTable(@"LoginInputCorrectNum", @"MyLoaclization", nil) buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"LoginSure", @"MyLoaclization", nil),  nil] afterDismiss:^(long buttonIndex) {
            
        }];
        [alert show];

    }
    else
    {
        //if (1) {
            usrname = loginfield.text;
            passwd = pwdfield.text;
            loading = [XYLoadingView loadingViewWithMessage:NSLocalizedStringFromTable(@"LoginWait", @"MyLoaclization", nil)];
            [loading show];
          //  [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
            [parameters setValue:usrname forKey:@"account"];
            [parameters setValue:passwd forKey:@"password"];
                       NSString *order = @"login.jsp";
            [self postHttpUrl:order postInfo:parameters state:1];
            NSLog(@"parameters = %@",parameters);

//        }
//        else
//        {
//            XYAlertView *alert = [XYAlertView alertViewWithTitle:@"账号或者密码错误" message:@"请重新输入" buttons:[NSArray arrayWithObjects:@"确定", @"取消", nil] afterDismiss:^(long buttonIndex) {
//                
//            }];
//            [alert show];
//        }

    
    }
    
}
-(void)registpress
{
    [(AppDelegate*)[UIApplication sharedApplication].delegate setregist];
    
}
-(void)gotopress
{
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.vipose.com"]];
}


//键盘确定以后
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    if (theTextField == loginfield) {
       
        [theTextField resignFirstResponder];
        
    }
    
    if (theTextField == pwdfield) {
              [theTextField resignFirstResponder];
    }
    [self resumeView];
    return YES;
    
}

#pragma mark 网络部分

-(void)isNetwork
{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld", status);
        if (!status) {
            [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Networking_isNot", @"MyLoaclization", nil)];
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];

}


- (void)postHttpUrl:(NSString *)urlString postInfo:(NSDictionary *)info state:(int)state
                                                                        //
{
    NSURL * url = [NSURL URLWithString:BaseURLString];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient postPath:urlString parameters:info success:^(AFHTTPRequestOperation *operation,id responseObject) {
        [loading dismiss];
        
     //   [AFNetworkActivityIndicatorManager sharedManager].enabled = NO;
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        //系统自带JSON解析
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"ok result = %@",[resultDic objectForKey:@"result"]);
       // 成功
        if ([[resultDic objectForKey:@"result"]isEqual:@"true"]) {
            [userDefaults setValue:@"1" forKey:USERDEFAULTS_LOGINSTATE];
            //登录成功后保存信息
            
            [userDefaults setObject:loginfield.text forKey:USERDEFAULTS_USERNAME];
            [userDefaults setObject:pwdfield.text forKey:USERDEFAULTS_PASSWD];
            [userDefaults synchronize];
            [FVCustomAlertView showDefaultDoneAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Loginsucces", @"MyLoaclization", nil)];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
            
            
            //创建用户目录，历史文件夹******************************
            imageDir = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), loginfield.text];
            database_path = [NSString stringWithFormat:@"%@/%@",imageDir,DBNAME];
            BOOL isDir = NO;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
            if ( !(isDir == YES && existed == YES) )
            {
                [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString *rtdir = [imageDir stringByAppendingPathComponent:@"RTDIR"];
            NSString *spdir = [imageDir stringByAppendingPathComponent:@"SPDIR"];
            existed = [fileManager fileExistsAtPath:rtdir isDirectory:&isDir];
            if ( !(isDir == YES && existed == YES) )
            {
                [fileManager createDirectoryAtPath:rtdir withIntermediateDirectories:YES attributes:nil error:nil];
            }
            existed = [fileManager fileExistsAtPath:spdir isDirectory:&isDir];
            
            if ( !(isDir == YES && existed == YES) )
            {
                [fileManager createDirectoryAtPath:spdir withIntermediateDirectories:YES attributes:nil error:nil];
            }
            //***************************************************
            [self initwithDB];

            [(AppDelegate*)[UIApplication sharedApplication].delegate setsidemenu];
    
        }
        else if ([[resultDic objectForKey:@"result"]isEqual:@"false"])
        {
            [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"NameOrPasswdIsNot", @"MyLoaclization", nil)];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
      
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [loading dismiss];
        [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"LoginIsfaile", @"MyLoaclization", nil)];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];

    }];
    
    
    
}
-(void)rmalert
{
    [FVCustomAlertView hideAlertFromView:self.view fading:YES];
}
-(void)hidenKeyboard
{
   
    [loginfield resignFirstResponder];
    [pwdfield resignFirstResponder];
    [self resumeView];
}
-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
//    float width = self.view.frame.size.width;
//    float height = 90;
    //上移30个单位，按实际情况设置
    CGRect rect=CGRectMake(32, 350, 256, 40);
    CGRect rect1=CGRectMake(32, 400, 256, 40);
    loginfield.frame=rect;
    pwdfield.frame = rect1;
    [UIView commitAnimations];
    
    
}

#pragma mark textfield上移
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
            NSTimeInterval animationDuration=0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
//        float width = self.view.frame.size.width;
//        float height = self.view.frame.size.height;
        //上移30个单位，按实际情况设置
        CGRect rect=CGRectMake(32, 260, 256, 40);
        CGRect rect1=CGRectMake(32, 310, 256, 40);
        loginfield.frame=rect;
        pwdfield.frame = rect1;
        [UIView commitAnimations];
    
    return YES;
}
-(void)initwithDB
{
    if (sqlite3_open([database_path UTF8String], &db)!=SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }else{
        NSLog(@"创建数据库成功");
        
        // NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age TEXT, address TEXT,weight TEXT)";
        NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS INFORPERSONN (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age TEXT, birth TEXT, weight TEXT, high TEXT, state TEXT)";
        [self execSql:sqlCreateTable];
    }
}
-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_open([database_path UTF8String], &db)!=SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    else{
        if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err)!=SQLITE_OK) {
            sqlite3_close(db);
            NSLog(@"数据库数据操作失败");
        }
        else
            NSLog(@"数据操作成功");
        sqlite3_close(db);
    }
}
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    
//    // Configure the view for the selected state
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
