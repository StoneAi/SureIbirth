//
//  leftMenuViewController.m
//  iSeed
//
//  Created by Chan Bill on 14/12/16.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import "leftMenuViewController.h"
#import "AppDelegate.h"
#import "FVCustomAlertView.h"
@interface leftMenuViewController ()
@property (strong, readwrite, nonatomic) UITableView *tableView;
@end

@implementation leftMenuViewController
{
    InforViewController *information;
    NSString *RDname;
    NSString *RDage;
    NSString *RDbirth;
    NSString *RDweight;
    NSString *RDhigh;
    MainiSeedViewController *mainVC;
    SettingTableViewController *settingVC;
    AppDelegate *appdele;
    UIImageView *myimageview;
    UIAlertView *alertvc;
    NSUserDefaults *userDefaults;
    NSString *NAMEFORUSER;
    NSString*database_path;
}
-(void)givemename:(NSString *)name
{
    _name.text = name;
}
-(void)givemeimage:(UIImage *)image
{
    [myimageview setImage:image];

}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    database_path = [NSString stringWithFormat:@"%@/Documents/%@/%@", NSHomeDirectory(),[userDefaults objectForKey:USERDEFAULTS_USERNAME],DBNAME];
    NSLog(@"%@",database_path);
    // [self initwithDB];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       [self readfromsqlite];
    });
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];   
    [self isNetwork];
    
    NAMEFORUSER = [userDefaults objectForKey:USERDEFAULTS_USERNAME];
    NSLog(@"name = %@",NAMEFORUSER);
    UIButton *informationbutton = [[UIButton alloc]initWithFrame:CGRectMake(16, 80, 216, 249)];
    [informationbutton addTarget:self action:@selector(information) forControlEvents:UIControlEventTouchUpInside];
    informationbutton.enabled = YES;
    //[self initwithDB];
    
    myimageview = [[UIImageView alloc]init];
    
    CGFloat hei;
    if (iPhone4) {
        hei = 64;
    }
    else
        hei = 0;
    myimageview.frame = CGRectMake(70, 110-hei, 100,100);
    //myimageview.layer.cornerRadius = 10;
    myimageview.layer.cornerRadius = myimageview.bounds.size.width*0.5;
    myimageview.layer.masksToBounds = YES;
    myimageview.layer.borderWidth = 2;
    myimageview.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    
    
    NSString *imagehead  = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"imagephoto"];
    NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:imagehead];
    NSData *mydata = [fh readDataToEndOfFile];
    if (mydata.length!=0) {
        
        UIImage *hisphoto = [[UIImage alloc]initWithData:mydata];
        myimageview.image = hisphoto;
    }
    else
    {
        myimageview.image = [UIImage imageNamed:InforDeHeadImage];
    }
    
    
    
    _name = [[UILabel alloc]initWithFrame:CGRectMake(100, 190-hei, 140, 30)];
    _name.text = RDname;
    _name.textColor = CELLTEXTLABELHIGHTCOLOR;
    _name.font = [UIFont systemFontOfSize:18.0];
    //TODO elias
    _name.backgroundColor = [UIColor clearColor];
    _name.textAlignment = NSTextAlignmentCenter;
    _name.center = CGPointMake(myimageview.center.x, myimageview.center.y+75);
    
    [self.view addSubview:informationbutton];
   [self.view addSubview:myimageview];
    [self.view addSubview:_name];

       
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 1) / 2.0f, self.view.frame.size.width-80, 54 * 5) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        //TODO elias
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
       
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    self.tableView.scrollEnabled = NO;
    
    
    
}
#pragma mark 网络
-(void)isNetwork
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"主视图中网络状态%ld", status);
        if (!status) {
            [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Networking_Isnot",@"MyLoaclization" , @"")];
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
        }
        else//下载数据
        {
           
            
            NSString *order = @"getGravidaInfo.jsp";
            [self getHttpUrl:order state:0];
            //[self GetFirmware];
//            NSString *order1 = @"getHeadPhoto.jsp";
//            [self getHttpUrl:order1 state:1];
           
        }
    }];
    [[AFNetworkReachabilityManager sharedManager]stopMonitoring];
}
-(void)getHttpUrl:(NSString *)urlString state:(int)sta
{
   
    NSURL * url = [NSURL URLWithString:@"http://120.24.237.180:8080/PregnantHealth"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [httpClient getPath:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        //系统自带JSON解析
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"result = %@",resultDic);
        
        
       // if (sta==0) {

        // 成功
        [userDefaults setObject:[resultDic objectForKey:@"nickname"] forKey:USERDEFAULTS_NAME];
        [userDefaults setObject:[resultDic objectForKey:@"childbirthDate"] forKey:USERDEFAULTS_BIRTH];
        [userDefaults setObject:[resultDic objectForKey:@"height"] forKey:USERDEFAULTS_HIGH];
        [userDefaults setObject:[resultDic objectForKey:@"weight"] forKey:USERDEFAULTS_WEIGHT];
        [userDefaults setObject:[resultDic objectForKey:@"age"] forKey:USERDEFAULTS_AGE];
        
        [userDefaults synchronize];
        
      //  NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:database_path];
       
        if (RDname==nil) {
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', state) VALUES ('%@', '%@', '%@', '%@', '%@', '%@')",TABLENAME, NAME, AGE, BIRTH, WEIGHT, HIGH, [resultDic objectForKey:@"nickname"], [resultDic objectForKey:@"age"], [resultDic objectForKey:@"childbirthDate"], [resultDic objectForKey:@"weight"], [resultDic objectForKey:@"height"], @"0"];
            
            [self execSql:sql];
            NSLog(@"插入数据库");
        }
        else{
            NSString *sql1 = [NSString stringWithFormat:@"update '%@' set '%@'='%@', '%@'='%@', '%@'='%@','%@'='%@','%@'='%@' where ID='%d'",TABLENAME,NAME,[resultDic objectForKey:@"nickname"],AGE,[resultDic objectForKey:@"age"],BIRTH,[resultDic objectForKey:@"childbirthDate"],WEIGHT,[resultDic objectForKey:@"weight"],HIGH,[resultDic objectForKey:@"height"],1];
            //  NSString *sql2 = [NSString stringWithFormat:@"delete from '%@'  where ID = '%d'",TABLENAME,2];
           
            [self execSql:sql1];
            
            NSLog(@"修改数据库");
   
        }
        
        RDname =[resultDic objectForKey:@"nickname"];
        _name.text = RDname;
    //   }
        
        
        //获取头像地址
        
            [httpClient postPath:@"getHeadPhoto.jsp" parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
                
                NSString *requestTmp = [NSString stringWithString:operation.responseString];
                NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                //系统自带JSON解析
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"获取头像的 result = %@",resultDic);
                  // dispatch_queue_t urls_queue = dispatch_queue_create("Photo", NULL);
                  // dispatch_async(urls_queue, ^{
                dispatch_async(dispatch_get_global_queue(0, 0), ^{

                       //下载头像，并保存到文件中
               NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://120.24.237.180:8080/%@",[resultDic objectForKey:@"filePath"]]]];
              // [myimageview setImage:[UIImage imageWithData:data]];
               NSString *imagehead  = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"imagephoto"];
              //       NSLog(@"data = %@,dizhi = %@",data,imagehead);
//                    NSFileManager *fileManager = [NSFileManager defaultManager];
//                    NSLog(@"data = %@",data);
//                if(![fileManager fileExistsAtPath:imagehead]) //如果不存在
//                {
//                    [fileManager createFileAtPath:imagehead contents:nil attributes:nil];
//                    NSFileHandle *handl = [NSFileHandle fileHandleForWritingAtPath:imagehead];
//                    [handl writeData:data];
//                }
//                else
                    [data writeToFile:imagehead atomically:NO];
               
                    
                NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:imagehead];
                NSData *mydata = [fh readDataToEndOfFile];
                    
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (mydata.length!=0) {
                        myimageview.image = [UIImage imageWithData:mydata];
                    }

                    });
                });
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"由于网络原因失败error111 = %@",error.localizedDescription);
            }];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"由于网络原因失败error = %@",error.localizedDescription);
        
    }];
    
}




#pragma mark 数据库模块
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
-(void)readfromsqlite
{
    
    //    database_path = [NSString stringWithFormat:@"%@/Documents/%@/%@", NSHomeDirectory(),[userDefaults objectForKey:USERDEFAULTS_USERNAME],DBNAME];
    if (sqlite3_open([database_path UTF8String], &db)!=SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"读取： 数据库打开失败");
    }
    else    {
        NSString *sqlQuery = @"SELECT * FROM INFORPERSONN";
        sqlite3_stmt * statement;
        
        if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *name = (char*)sqlite3_column_text(statement, 1);
                RDname = [[NSString alloc]initWithUTF8String:name];
                _name.text = RDname;
                char *age = (char *)sqlite3_column_text(statement, 2);
                RDage = [[NSString alloc]initWithUTF8String:age];
                
                char *birth = (char*)sqlite3_column_text(statement, 3);
                RDbirth = [[NSString alloc]initWithUTF8String:birth];
                
                char *weight = (char*)sqlite3_column_text(statement, 4);
                RDweight = [[NSString alloc]initWithUTF8String:weight];
                
                char *high = (char*)sqlite3_column_text(statement, 5);
                RDhigh = [[NSString alloc]initWithUTF8String:high];
                
                [userDefaults setObject:RDname forKey:USERDEFAULTS_NAME];           //保存到本地
                [userDefaults setObject:RDage forKey:USERDEFAULTS_AGE];
                [userDefaults setObject:RDbirth forKey:USERDEFAULTS_BIRTH];
                [userDefaults setObject:RDweight forKey:USERDEFAULTS_WEIGHT];
                [userDefaults setObject:RDhigh forKey:USERDEFAULTS_HIGH];
                NSLog(@"name1:%@ ",RDname);
            }
        }
        sqlite3_close(db);
    }
    
}


-(void)viewDidAppear:(BOOL)animated
{
    //[self readfromsqlite];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)information
{
    InforViewController *infoVC = [[InforViewController alloc] init];
    infoVC.delegate = self;
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:infoVC]
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];

    NSLog(@"跳转入个人信息界面");

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    return 5;
    
    
    
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return nil;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
    
    return 0;
    
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        UIView *clearView = [[UIView alloc] initWithFrame:CGRectZero];
        
        clearView.backgroundColor = VIEWBACKCOLOR;
        
        return clearView;
        
    }
    
    
    
    return nil;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    return 54;
    
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        //cell.backgroundColor = [UIColor clearColor];
        
    }
    
    
    
    
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = NSLocalizedStringFromTable(@"LeftVC_table_FirstVC_Title",@"MyLoaclization" , @"");
            
            UIImage *icon = [UIImage imageNamed:LeftHomeImage];
            
            CGSize itemSize = CGSizeMake(20, 20);
            
            UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
            
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            
            [icon drawInRect:imageRect];
            
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            //  cell.imageView.image = [UIImage imageNamed:@"homepage1128.png"];
            
            
            
            UIImage *icon1 = [UIImage imageNamed:LeftHomeHighImage];
            CGSize itemSize1 = CGSizeMake(20, 20);
            UIGraphicsBeginImageContextWithOptions(itemSize1, NO ,0.0);
            CGRect imageRect1 = CGRectMake(0.0, 0.0, itemSize1.width, itemSize1.height);
            [icon1 drawInRect:imageRect1];
            //cell.imageView.highlightedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
           // cell.imageView.highlightedImage = [UIImage imageNamed:LeftHomeHighImage];

        }
        
        else if (indexPath.row == 1) {
            
            cell.textLabel.text = NSLocalizedStringFromTable(@"LeftVC_table_HistoryVC_Title",@"MyLoaclization" , @"");
            
            /*******************缩小图片为22.22***************************/
            
            UIImage *icon = [UIImage imageNamed:@"Ellipse0505.png"];
            
            CGSize itemSize = CGSizeMake(20, 20);
            
            UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
            
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            
            [icon drawInRect:imageRect];
            
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            /***********************************************************/
            
            
            UIImage *icon1 = [UIImage imageNamed:LeftHistoryHighImage];
            CGSize itemSize1 = CGSizeMake(20, 20);
            UIGraphicsBeginImageContextWithOptions(itemSize1, NO ,0.0);
            CGRect imageRect1 = CGRectMake(0.0, 0.0, itemSize1.width, itemSize1.height);
            [icon1 drawInRect:imageRect1];
         //   cell.imageView.highlightedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
         //   cell.imageView.highlightedImage = [UIImage imageNamed:LeftHistoryHighImage]; //设置选择此行时的照片
            
            //cell.imageView.image = [UIImage imageNamed:@"history1128.png"];
            
            //LeftVC_table_SPHistoryVC_Title
            
        }
        else if (indexPath.row == 2) {
            
            cell.textLabel.text = NSLocalizedStringFromTable(@"LeftVC_table_SPHistoryVC_Title",@"MyLoaclization" , @"");
            
            /*******************缩小图片为22.22***************************/
            
            UIImage *icon = [UIImage imageNamed:@"walk status0505.png"];
            
            CGSize itemSize = CGSizeMake(20, 20);
            
            UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
            
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            
            [icon drawInRect:imageRect];
            
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            /***********************************************************/
            
            
            UIImage *icon1 = [UIImage imageNamed:LeftHistoryHighImage];
            CGSize itemSize1 = CGSizeMake(20, 20);
            UIGraphicsBeginImageContextWithOptions(itemSize1, NO ,0.0);
            CGRect imageRect1 = CGRectMake(0.0, 0.0, itemSize1.width, itemSize1.height);
            [icon1 drawInRect:imageRect1];
            //   cell.imageView.highlightedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            //   cell.imageView.highlightedImage = [UIImage imageNamed:LeftHistoryHighImage]; //设置选择此行时的照片
            
            //cell.imageView.image = [UIImage imageNamed:@"history1128.png"];
            
            //LeftVC_table_SPHistoryVC_Title
            
        }

        
        else if (indexPath.row == 3) {
            
            cell.textLabel.text = NSLocalizedStringFromTable(@"LeftVC_table_Recommond_Title",@"MyLoaclization" , @"");
            
            UIImage *icon = [UIImage imageNamed:LeftRecomImage ];
            
            CGSize itemSize = CGSizeMake(20, 20);
            
            UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
            
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            
            [icon drawInRect:imageRect];
            
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            
            UIImage *icon1 = [UIImage imageNamed:LeftRecomHigeImage];
            CGSize itemSize1 = CGSizeMake(20, 20);
            UIGraphicsBeginImageContextWithOptions(itemSize1, NO ,0.0);
            CGRect imageRect1 = CGRectMake(0.0, 0.0, itemSize1.width, itemSize1.height);
            [icon1 drawInRect:imageRect1];
          //  cell.imageView.highlightedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
           // cell.imageView.highlightedImage = [UIImage imageNamed:LeftRecomHigeImage];
            
        }
        
        else if (indexPath.row == 4) {
            
            cell.textLabel.text = NSLocalizedStringFromTable(@"LeftVC_table_Setting_Title",@"MyLoaclization" , @"");
            
            UIImage *icon = [UIImage imageNamed:LeftSettingImage ];
            
            CGSize itemSize = CGSizeMake(20, 20);
            
            UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
            
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            
            [icon drawInRect:imageRect];
            
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            
            UIImage *icon1 = [UIImage imageNamed:LeftSettingHighImage];
            CGSize itemSize1 = CGSizeMake(20, 20);
            UIGraphicsBeginImageContextWithOptions(itemSize1, NO ,0.0);
            CGRect imageRect1 = CGRectMake(0.0, 0.0, itemSize1.width, itemSize1.height);
            [icon1 drawInRect:imageRect1];
           // cell.imageView.highlightedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            //cell.imageView.highlightedImage = [UIImage imageNamed:LeftSettingHighImage];
            
        }
        if (indexPath.row == 5) {
            cell.textLabel.text = @"退出";
            UIImage *icon = [UIImage imageNamed:@ "back" ];
            CGSize itemSize = CGSizeMake(15, 15);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [icon drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            
            
            UIImage *icon1 = [UIImage imageNamed:@ "backgreen0115.png" ];
            CGSize itemSize1 = CGSizeMake(15, 15);
            UIGraphicsBeginImageContextWithOptions(itemSize1, NO ,0.0);
            CGRect imageRect1 = CGRectMake(0.0, 0.0, itemSize1.width, itemSize1.height);
            [icon1 drawInRect:imageRect1];
            cell.imageView.highlightedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
          //  cell.imageView.highlightedImage = [UIImage imageNamed:@"backgreen0115.png"];

        }
        
        
    }
   // cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
    cell.imageView.contentMode = UIViewContentModeCenter;
    
    cell.textLabel.highlightedTextColor = CELLNOMARLCOLOR;
    
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    
    cell.selectedBackgroundView.backgroundColor = CELLSELECTCOLOR;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.textColor =  CELLTEXTLABELHIGHTCOLOR;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //TODO elias
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    
//    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
}



- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    
//    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:{
//                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[MainiSeedViewController alloc]init]]
//                                                                 animated:YES];
//                    [self.sideMenuViewController setContentViewController: [[UINavigationController alloc] initWithRootViewController:mainVC]
//                                                                 animated:YES];
                    [self.sideMenuViewController setContentViewController: [[UINavigationController alloc] initWithRootViewController:mainVC]
                                                                                      animated:NO];
                 //   [mainVC GetDelegate:self];
                    [self.sideMenuViewController hideMenuViewController];

                }
                    
                    break;
                    
                case 1:{
                    RtHistoryViewController *history =[[RtHistoryViewController alloc]init];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:history]
                                                                 animated:NO];
                    history.delegate = mainVC;
                    [self.sideMenuViewController hideMenuViewController];
                    NSLog(@"辐射");
                    
                }
                    
                    break;
                case 2:{
                    SpHistoryViewController *history =[[SpHistoryViewController alloc] init];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:history]
                                                                 animated:NO];
                    history.delegate = mainVC;
                    [self.sideMenuViewController hideMenuViewController];
                    NSLog(@"计步");
                    
                }
                    
                    break;
                    
                case 3:{

                    NSString *title = [[NSString alloc]initWithFormat:NSLocalizedStringFromTable(@"share_Tittle_LeftVC_Text",@"MyLoaclization" , @"")];
                    
                    
                    UIImage *image = [UIImage imageNamed:ShareSDKImage];
                    //构造分享内容
                    id<ISSContent> publishContent = [ShareSDK content:title
                                                       defaultContent:title
                                                                image:[ShareSDK jpegImageWithImage:image quality:1.0]
                                                                title:@"Vipsoe"
                                                                  url:@"http://www.vipose.com"
                                                          description:title
                                                            mediaType:SSPublishContentMediaTypeNews];
                    
                    
                    //定制QQ空间信息
                    [publishContent addQQSpaceUnitWithTitle:title
                                                        url:@"http://www.vipose.com/#link_down"//INHERIT_VALUE
                                                       site:nil
                                                    fromUrl:nil
                                                    comment:title
                                                    summary:INHERIT_VALUE
                                                      image:INHERIT_VALUE
                                                       type:INHERIT_VALUE
                                                    playUrl:nil
                                                       nswb:nil];
                    //定制qq分享信息
                    [publishContent addQQUnitWithType:INHERIT_VALUE
                                              content:title
                                                title:title //nil //@"Vipose"
                                                  url:@"http://www.vipose.com/#link_down"
                                                image:[ShareSDK jpegImageWithImage:image quality:1.0]];
                    
                    //定制微信好友信息
                    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                                         content:title
                                                           title:title //@"Vipose"
                                                             url:@"http://www.vipose.com/#link_down"
                                                           image:[ShareSDK jpegImageWithImage:image quality:1.0]musicFileUrl:nil extInfo:nil fileData:nil emoticonData:nil];
                    
                                   //定制微信朋友圈信息
                    [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
                                                          content:INHERIT_VALUE
                                                            title:title
                                                              url:@"http://www.vipose.com/#link_down"
                                                            image:INHERIT_VALUE
                                                     musicFileUrl:INHERIT_VALUE
                                                          extInfo:INHERIT_VALUE
                                                         fileData:INHERIT_VALUE
                                                     emoticonData:INHERIT_VALUE];
                    
                        //定制新浪微博信息
                   

                    
                    
                    
                    
                    
                    
                    id<ISSContainer> container = [ShareSDK container];
                     NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ,ShareTypeQQSpace,ShareTypeSinaWeibo, nil];
                 //   [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
                    
                    //弹出分享菜单
                    [ShareSDK showShareActionSheet:container
                                         shareList:shareList
                                           content:publishContent
                                     statusBarTips:YES
                                       authOptions:nil
                                      shareOptions:nil
                                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                
                                                if (state == SSResponseStateSuccess)
                                                {
                                                    [FVCustomAlertView showDefaultDoneAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Mainview_SharesuccesText",@"MyLoaclization" , @"")];
                                                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
                                                }
                                                else if (state == SSResponseStateFail)
                                                {
                                                    [FVCustomAlertView showDefaultDoneAlertOnView:self.view withTitle:NSLocalizedStringFromTable(@"Mainview_SharefaileText",@"MyLoaclization" , @"")];
                                                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rmalert) userInfo:nil repeats:NO];
                                                }
                                            }];
                    

                    NSLog(@"推荐");
                    
                }
                    
                    break;
                    
                case 4:{
                    if (mainVC.blesta==1) {
                        [mainVC readbat];
                    }
                
                    
                    SettingTableViewController *settingVC1 =[[SettingTableViewController alloc] init];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:settingVC1]
                                                                 animated:NO];
                    settingVC1.delegate = self;
//                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:settingVC]
//                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    
                    NSLog(@"设置");
                    
                }
                    
                    break;
                                    
                default:
                    
                    break;
                    
                    
                    
            }
            
            //[self.sideBar dismiss];
            
    }
    
}
-(void)rmalert
{
 [FVCustomAlertView hideAlertFromView:self.view fading:YES];

}

-(void)givemeViewController:(MainiSeedViewController*) simpleVC
{
    mainVC = simpleVC;
    
}
-(void)readhistory
{
    [mainVC blehistory];
    NSLog(@"历史代理");
}
-(void)Wariming:(int)warning
{
    if (warning==1) {
        [mainVC WarmingON];
    }
    else if (warning==0)
    {
        [mainVC WarmingOFF];
        
    }
}

-(NSInteger )getblestate
{
    //NSLog(@"%ld",mainVC.blesta);
    return mainVC.blesta;
}
-(void)disconnectble
{
    [mainVC disconnectBle];

}
-(void)cancleview
{

    [(AppDelegate *)[UIApplication sharedApplication].delegate setlogin];
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
