//
//  ThreeRegistViewController.m
//  iSeed
//
//  Created by Chan Bill on 15/3/20.
//  Copyright (c) 2015年 elias kang. All rights reserved.
//

#import "ThreeRegistViewController.h"

@interface ThreeRegistViewController ()

@end

@implementation ThreeRegistViewController
{
    XYLoadingView *loading;
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
    
    UILabel *netlable = [[UILabel alloc] initWithFrame:CGRectMake(25, 130, 280, 30)];
    netlable.text = NSLocalizedStringFromTable(@"Rigist_Network",@"MyLoaclization" , @"");
    netlable.textColor = [UIColor grayColor];
    netlable.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:netlable];
    
    
    
    UILabel *regist = [[UILabel alloc] initWithFrame:CGRectMake(100, 27, 120, 30)];
    regist.text = NSLocalizedStringFromTable(@"Lable_regist_Title",@"MyLoaclization" , @"");
    regist.textAlignment = NSTextAlignmentCenter;
    regist.font = [UIFont systemFontOfSize:20.0];
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
    phonenum.placeholder = NSLocalizedStringFromTable(@"Registtwo_EmailnumTextField_Text",@"MyLoaclization" , @"");
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
    [aggetchecknum addTarget:self action:@selector(aggetchenum) forControlEvents:UIControlEventTouchUpInside];
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
    CGFloat hei;
    if (iPhone4) {
        hei = 64;
    }
    else
        hei = 0;
    
    registbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    registbutton.frame = CGRectMake(100, 480-hei, 100, 50);
    [registbutton setTitle:NSLocalizedStringFromTable(@"RegistAlready_Text",@"MyLoaclization" , @"") forState:UIControlStateNormal];
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
        XYAlertView *alert = [XYAlertView alertViewWithTitle:NSLocalizedStringFromTable(@"Registtwo_Alretfaile_Title",@"MyLoaclization" , @"") message:NSLocalizedStringFromTable(@"Registtwo_Alretfaile_Message",@"MyLoaclization" , @"") buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"Registtwo_Alretfaile_Button",@"MyLoaclization" , @""),  nil] afterDismiss:^(long buttonIndex) {
            
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
            [parameters setValue:num forKey:@"username"];
            // [parameters setValue:@"15815549151" forKey:@"phoneNo"];
            [parameters setValue:check forKey:@"captcha"];
            [parameters setValue:pwdcheck forKey:@"userpasswd"];
            NSString *order = @"register.jsp";
            [self postHttpUrl:order postInfo:parameters state:1];
            NSLog(@"parameters = %@",parameters);
            
            
            
        }
        else{
            [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Registtwo_Passwdnotsuit",@"MyLoaclization" , @"")];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
        }
    }
    
    
    
}
-(void)getchecknum
{
    getchecknum.enabled =NO;
    
    num = phonenum.text;
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:num forKey:@"email"];
    // [parameters setValue:@"15815549151" forKey:@"phoneNo"];
    [parameters setValue:@"1" forKey:@"type"];
    NSString *order = @"sendCaptchaByEmail.jsp";
    [self postHttpUrl:order postInfo:parameters state:0];
    NSLog(@"parameters = %@",parameters);
    
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(changetime) userInfo:nil repeats:NO];
    
}
-(void)changetime
{
    getchecknum.enabled = YES;
}


-(void)aggetchenum
{
    [self getchecknum];
    
}
-(void)returntofirst
{
    [(AppDelegate*)[UIApplication sharedApplication].delegate setregist];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)postHttpUrl:(NSString *)urlString postInfo:(NSDictionary *)info state:(int)state
//0 获取验证码    1 注册    2 登录   3上传信息
{
    
    
    NSURL * url = [NSURL URLWithString:BaseURLString];
    
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    
    [httpClient postPath:urlString parameters:info success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        //系统自带JSON解析
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"result = %@",resultDic);
        [loading dismiss];
        
        //    [AFNetworkActivityIndicatorManager sharedManager].enabled = NO;
        //注册成功
        if (state==1) {
            if ([[resultDic objectForKey:@"result"] isEqual:@"true"]) {
                //创建用户个人信息文件夹
                [FVCustomAlertView showDefaultDoneAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Registtwo_Alretsucces_Tiltle",@"MyLoaclization" , @"")];
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
                
                
                imageDir = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(),num];//原来是参数是phonenum.text;
                
                BOOL isDir = NO;
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
                
                if ( !(isDir == YES && existed == YES) )
                    
                {
                    
                    [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
                    
                }
                //创建用户历史辐射计步数据文件夹
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
                
                [self initwithDB];
                registbutton.enabled = NO;
                
                [userDefaults setValue:num forKey:USERDEFAULTS_USERNAME];
                [userDefaults setValue:pwd forKey:USERDEFAULTS_PASSWD];
                [userDefaults setValue:@"1" forKey:USERDEFAULTS_LOGINSTATE];
                
                //注册成功后插入新表中
                NSString *sql = [NSString stringWithFormat:
                                 @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@',state) VALUES ('%@', '%@', '%@', '%@', '%@', '%@')",
                                 TABLENAME, NAME, AGE, BIRTH, WEIGHT, HIGH, [userDefaults objectForKey:USERDEFAULTS_NAME], [userDefaults objectForKey:USERDEFAULTS_AGE], [userDefaults objectForKey:USERDEFAULTS_BIRTH], [userDefaults objectForKey:USERDEFAULTS_WEIGHT], [userDefaults objectForKey:USERDEFAULTS_HIGH],@"0"];
                
                [self execSql:sql];
                
                
                
                //登录操作 以便上传数据
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
                [parameters setValue:num forKey:@"account"];
                [parameters setValue:pwd forKey:@"password"];
                NSString *order = @"login.jsp";
                [self postHttpUrl:order postInfo:parameters state:2];
                NSLog(@"登录  parameters = %@",parameters);
            }
            //注册失败
            else if ([[resultDic objectForKey:@"result"] isEqual:@"captchfalse"])
            {
                [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Registtwo_Checknim_faile",@"MyLoaclization" , @"")];
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
                
            }
            else
            {
                [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Registtwo_Alretfaile_Title",@"MyLoaclization" , @"")];
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
                
            }
            
        }
        
        //登录，
        if (state == 2) {
            
            if ([[resultDic objectForKey:@"result"] isEqual:@"true"]) {
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
                [parameters setValue:[userDefaults objectForKey:USERDEFAULTS_HIGH] forKey:@"height"];
                [parameters setValue:[userDefaults objectForKey:USERDEFAULTS_NAME] forKey:@"nickname"];
                [parameters setValue:[userDefaults objectForKey:USERDEFAULTS_WEIGHT] forKey:@"weight"];
                [parameters setValue:[userDefaults objectForKey:USERDEFAULTS_AGE] forKey:@"age"];
                [parameters setValue:[userDefaults objectForKey:USERDEFAULTS_BIRTH] forKey:@"birthDate"];
                
                NSString *order = @"createGravidaInfo.jsp";
                [self postHttpUrl:order postInfo:parameters state:3];
                NSLog(@"上传数据的parameters = %@",parameters);
            }
            else//返回false
            {
                NSString *sql1 = [NSString stringWithFormat:@"update '%@' set state ='%@' where ID='%d'",TABLENAME,@"1",1];
                [self execSql:sql1];
                sqlite3_close(db);
                [(AppDelegate *)[UIApplication sharedApplication].delegate setlogin];
            }
            
            
        }
        //上传个人信息
        if (state==3) {
            if ([[resultDic objectForKey:@"result"] isEqual:@"true"]) {
                
                [(AppDelegate*)[UIApplication sharedApplication].delegate setsidemenu];
            }
            else{
                //归档
                NSString *sql1 = [NSString stringWithFormat:@"update '%@' set state ='%@' where ID='%d'",TABLENAME,@"1",1];
                [self execSql:sql1];
                [(AppDelegate *)[UIApplication sharedApplication].delegate setlogin];
            }
        }
        
        //获取验证码成功
        if (state==0) {
            if ([[resultDic objectForKey:@"result"] isEqual:@"true"]) {
                
            }
            //验证码失败
            else if ([[resultDic objectForKey:@"result"] isEqual:@"UsernameExisted"])
            {
                getchecknum.enabled = YES;
                [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Registtwo_Userexit",@"MyLoaclization" , @"")];
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
            }
            else
            {
                getchecknum.enabled = YES;
                [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Registtwo_Getcheckfaile",@"MyLoaclization" , @"")];
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
                
            }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [loading dismiss];
        //出错处理多种情况
        if (state==2|state==3) {
            // [userDefaults setValue:@"1" forKey:USERDEFAULTS_SENDTOWEB];
            NSString *sql1 = [NSString stringWithFormat:@"update '%@' set state ='%@' where ID='%d'",TABLENAME,@"1",1];
            //  NSString *sql2 = [NSString stringWithFormat:@"delete from '%@'  where ID = '%d'",TABLENAME,2];
            
            [self execSql:sql1];
            [(AppDelegate *)[UIApplication sharedApplication].delegate setlogin];
        }
        else
        {
            [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Registtwo_Actionfaile",@"MyLoaclization" , @"")];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
        }
    }];
    
    
    
}
-(void)rmalert
{
    [FVCustomAlertView hideAlertFromView:self.view fading:YES];
}

#pragma mark 数据库模块
-(void)initwithDB
{
    NSString*database_path =[imageDir stringByAppendingPathComponent:DBNAME];
    if (sqlite3_open([database_path UTF8String], &db)!=SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    else{
        NSLog(@"创建数据库成功");
        
        // NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age TEXT, address TEXT,weight TEXT)";
        NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS INFORPERSONN (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age TEXT, birth TEXT, weight TEXT, high TEXT, state TEXT)";
        [self execSql:sqlCreateTable];
    }
}


-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err)!=SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库数据操作失败");
    }
    else{
        NSLog(@"数据操作成功");
        sqlite3_close(db);
    }
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
