//
//  InforViewController.m
//  iSeed
//
//  Created by Chan Bill on 14/12/16.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import "InforViewController.h"
#import "Config.h"
#import "RESideMenu.h"


//#define DBNAME @"persioninfo.sqlite"

@interface InforViewController ()

@property (strong,nonatomic) ZHPickView *pickview;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property (strong,nonatomic) NSArray *agesArray;
@property (strong,nonatomic) NSArray *numbersArray;
@property (strong, nonatomic) NSString *selectedString;

@end

@implementation InforViewController

{
    CGRect memberInformationView_OldFrame;
    NSArray *agearray;
    XYLoadingView *loading;
    NSArray *hightarray;
  
    NSArray *weightarray;
  
    NSArray *birtharray;
    
    NSString *IFname;
    NSString *IFage;
    NSString *IFbirth;
    NSString *IFweight;
    NSString *IFhigh;
    UITextField *nameTextFiled;
    NSString *RDstate;
    NSString *RDname;
    NSString *RDage;
    NSString *RDbirth;
    NSString *RDweight;
    NSString *RDhigh;
    UIImage *myimage;
    NSString*database_path;
    NSString *imagephoto;
    NSString * NAMEFORUSER;
    NSUserDefaults *userDefaults;
}
@synthesize delegate;
@synthesize tableview;
@synthesize imagev;
@synthesize serndview;
@synthesize cell;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    userDefaults = [NSUserDefaults standardUserDefaults];
    //[self initwithDB];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self readfromsqlite];
    });
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    //数据库
    //pickerview数据源
    [self initwithage];
    [self initwithweight];
    [self initwithhight];
    NAMEFORUSER = [userDefaults objectForKey:USERDEFAULTS_USERNAME];
    imagev=[[UIButton alloc] initWithFrame:CGRectMake(10, 85, 80, 80)];
    
    [imagev addTarget:self action:@selector(pickphoto) forControlEvents:UIControlEventTouchUpInside];
   // imagev.layer.cornerRadius = 10;
    imagev.layer.cornerRadius = imagev.layer.bounds.size.width*0.5;
    imagev.layer.masksToBounds = YES;
    imagev.layer.borderWidth = 2;
    imagev.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    NSString *imagehead  = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"imagephoto"];
    NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:imagehead];
    NSData *mydata = [fh readDataToEndOfFile];
    if (mydata.length!=0) {
        
        UIImage *hisphoto = [[UIImage alloc]initWithData:mydata];
        [imagev setImage:hisphoto forState:UIControlStateNormal];
    }
    else
    {
        [imagev setImage:[UIImage imageNamed:InforDeHeadImage] forState:UIControlStateNormal];

    }

    myimage = imagev.imageView.image;

    
    imagephoto = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:NAMEFORUSER] stringByAppendingPathComponent:@"imagephoto"];
    self.restorationIdentifier = @"InforViewController";
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = NAVIGATIONBAR_BACKCOLOR;
    self.navigationItem.title = NSLocalizedStringFromTable(@"InformationVC_Title", @"MyLoaclization" , @"");
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    
    serndview = [[UIView alloc]initWithFrame:CGRectMake(0, 60, 320, 180)];
    serndview.backgroundColor = [UIColor clearColor];
    UIImageView *topimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:InforBackImage]];
    topimage.frame = CGRectMake(0, 0, 320, 180);
    [serndview addSubview:topimage];
    [serndview addSubview:imagev];
    [self.view addSubview:serndview];
    
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
    [lbutton addTarget:self action:@selector(removepicker) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:lbutton];
    self.navigationItem.leftBarButtonItem=leftButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIButton *rbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rbutton.frame = CGRectMake(0, 0, 22,22);
    [rbutton setImage:[UIImage imageNamed:InforSaveImage] forState:UIControlStateNormal];
   [rbutton addTarget:self action:@selector(MakeSure) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:rbutton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    
   // UIView *table = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, 200+54*5)];
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 1) / 2.0f,320, 54 * 5) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.backgroundColor = [UIColor clearColor];
   // table = tableview;
    tableview.scrollEnabled = NO;
    [self.view addSubview:tableview];
    
    
    //textfield
    
    
    nameTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(150, (self.view.frame.size.height-30) / 2.0f, 135, 28)];
    nameTextFiled.backgroundColor= [UIColor clearColor];
    nameTextFiled.returnKeyType = UIReturnKeyDone;
    nameTextFiled.textColor = [UIColor grayColor];
    nameTextFiled.textAlignment = NSTextAlignmentRight;
    nameTextFiled.font = [UIFont systemFontOfSize:15.0];
    nameTextFiled.text = RDname;
    nameTextFiled.delegate =self;
    [self.view addSubview:nameTextFiled];
    //IFname = @"Stone";
    
    
    
    [self NeedSendAgin];
    
    
//    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(removepicker)];
//    //gesture.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:gesture];

    
    
}

-(void)NeedSendAgin
{
   
        NSLog(@"RDstate = %@",RDstate);
        if ([RDstate isEqual:@"1"]) {
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
            [parameters setValue:RDhigh forKey:@"height"];
            [parameters setValue:RDname forKey:@"nickname"];
            [parameters setValue:RDweight forKey:@"weight"];
            [parameters setValue:RDage forKey:@"age"];
            [parameters setValue:RDbirth forKey:@"birthDate"];
            
            NSString *order = @"createGravidaInfo.jsp";
            [self postHttpUrl:order postInfo:parameters state:2];
        }
    
    
}


-(void)removepicker
{
    [_pickview remove];

}
#pragma mark 头像功能
-(void)pickphoto
{
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:NSLocalizedStringFromTable(@"InforVCAction_Cancel", @"MyLoaclization" , @"")
                                    destructiveButtonTitle:nil
                                    otherButtonTitles: NSLocalizedStringFromTable(@"InforVCAction_Choice", @"MyLoaclization" , @""), NSLocalizedStringFromTable(@"InforVCAction_TakePhoto", @"MyLoaclization" , @""),nil];
    myActionSheet.actionSheetStyle = UIActionSheetStyleDefault;

    [myActionSheet showInView:self.view];
    

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //从相册选择
            [self LocalPhoto];
            break;
        case 1:
            //拍照
            [self takePhoto];
            break;
        default:
            break;
    }
}

-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentModalViewController:picker animated:YES];
}
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
       // [picker release];
    }else {
        NSLog(@"该设备无摄像头");
    }
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    //当图片不为空时显示图片并保存图片
    if (image != nil) {
        //图片显示在界面上
        [imagev setImage:image forState:UIControlStateNormal];
        
      
        myimage=image;
 }
    //[delegate givemeimage:myimage];
    [picker dismissModalViewControllerAnimated:YES];
}
#pragma mark 数据库模块

-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_open([database_path UTF8String], &db)!=SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }else{
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
    
    database_path = [NSString stringWithFormat:@"%@/Documents/%@/%@", NSHomeDirectory(),[userDefaults objectForKey:USERDEFAULTS_USERNAME],DBNAME];
    
    NSLog(@"%@",database_path);
    if (sqlite3_open([database_path UTF8String], &db)!=SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    
    else{
        NSString *sqlQuery = @"SELECT * FROM INFORPERSONN";
        sqlite3_stmt * statement;
        
        if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *name = (char*)sqlite3_column_text(statement, 1);
                RDname = [[NSString alloc]initWithUTF8String:name];
                
                char *age = (char *)sqlite3_column_text(statement, 2);
                RDage = [[NSString alloc]initWithUTF8String:age];
                
                char *birth = (char*)sqlite3_column_text(statement, 3);
                RDbirth = [[NSString alloc]initWithUTF8String:birth];
                
                char *weight = (char*)sqlite3_column_text(statement, 4);
                RDweight = [[NSString alloc]initWithUTF8String:weight];
                
                char *high = (char*)sqlite3_column_text(statement, 5);
                RDhigh = [[NSString alloc]initWithUTF8String:high];
                
                char *state = (char*)sqlite3_column_text(statement, 6);
                RDstate = [[NSString alloc]initWithUTF8String:state];
                
                IFname = RDname;
                IFage = RDage;
                IFbirth = RDbirth;
                IFweight = RDweight;
                IFhigh = RDhigh;
                
                
            }
            NSLog(@"name:%@  age:%@  birth:%@ weight:%@ high:%@",RDname,RDage, RDbirth,RDweight,RDhigh);
           sqlite3_close(db);
        }
        else
        {
            
            NSLog(@"数据库没数据");
        sqlite3_close(db);
        }
    }
}


-(void)MakeSure
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"个人信息中网络状态%ld", status);
        if (!status) {
            XYAlertView *alert1 = [XYAlertView alertViewWithTitle:NSLocalizedStringFromTable(@"InforVCAlretNet_Title", @"MyLoaclization" , @"") message:NSLocalizedStringFromTable(@"InforVCAlretNet_Message", @"MyLoaclization" , @"") buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"InforVCAlretNet_Button", @"MyLoaclization" , @""),nil] afterDismiss:^(long buttonIndex) {
                
            }];
            [alert1 show];
        }
        else//上传数据
        {
            XYAlertView *alert1 = [XYAlertView alertViewWithTitle:NSLocalizedStringFromTable(@"InforVCAlretNotAll_Title", @"MyLoaclization" , @"") message:NSLocalizedStringFromTable(@"InforVCAlretNotAll_Message", @"MyLoaclization" , @"") buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"InforVCAlretNet_Button", @"MyLoaclization" , @""),nil] afterDismiss:^(long buttonIndex) {
                
            }];
            XYAlertView *alertView2 = [XYAlertView alertViewWithTitle:NSLocalizedStringFromTable(@"InforVCAlretSave_Title", @"MyLoaclization" , @"")
                                                              message:NSLocalizedStringFromTable(@"InforVCAlretSave_Message", @"MyLoaclization" , @"")
                                                              buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"InforVCAlretNet_Button", @"MyLoaclization" , @""), NSLocalizedStringFromTable(@"InforVCAction_Cancel", @"MyLoaclization" , @""), nil]
                                                         afterDismiss:^(long buttonIndex) {
                                                             if (buttonIndex == 0){
                                                                 if (IFname==nil|IFage==nil|IFbirth==nil|IFweight==nil|IFhigh==nil) {
                                                                     [alert1 show];
                                                                 }
                                                                 else{
                                                                     [self Correct];
                                                                     loading = [XYLoadingView loadingViewWithMessage:NSLocalizedStringFromTable(@"InforVCLoadview_Title", @"MyLoaclization" , @"")];
                                                                     [loading show];
                                                                     }
                                                             }
                                                             if(buttonIndex == 1)
                                                                 
                                                                 NSLog(@"button index: %ld pressed!", buttonIndex);
                                                         }];
            
            
            [alertView2 show];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager]stopMonitoring];

    
  
}
-(void)Correct
{

//向服务器添加用户个人信息
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:IFhigh forKey:@"height"];
    [parameters setValue:IFname forKey:@"nickname"];
    [parameters setValue:IFweight forKey:@"weight"];
    [parameters setValue:IFage forKey:@"age"];
    [parameters setValue:IFbirth forKey:@"birthDate"];
    
    NSString *order = @"updateGravidaInfo.jsp";
    
    [userDefaults setObject:IFname forKey:USERDEFAULTS_NAME];           //保存到本地
    [userDefaults setObject:IFage forKey:USERDEFAULTS_AGE];
    [userDefaults setObject:IFbirth forKey:USERDEFAULTS_BIRTH];
    [userDefaults setObject:IFweight forKey:USERDEFAULTS_WEIGHT];
    [userDefaults setObject:IFhigh forKey:USERDEFAULTS_HIGH];
   
        // something
    
    [self postHttpUrl:order postInfo:parameters state:1];
    NSLog(@"第一次上传parameters = %@",parameters);
   
    
    NSLog(@"IFbirth = %@,IFage = %@,IFweight = %@,IFhigh = %@",IFbirth,IFage,IFweight,IFhigh);

}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
          
            if (cell == nil) {
           
            cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.textLabel.text = NSLocalizedStringFromTable(@"Information_Name", @"MyLoaclization" , @"");
            cell.detailtextview.text = @"Stone";
                cell.once.hidden = YES;
               
                cell.detailtextview.editable = YES;
                cell.detailtextview.hidden =  YES;
            }
        }
        
        else if (indexPath.row == 1) {
                      if (cell == nil) {
                
                cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
                 cell.detailtextview.keyboardType = UIKeyboardTypeNumberPad;
                cell.detailtextview.text = RDage;
                 cell.once.hidden = YES;
                cell.detailtextview.textAlignment = NSTextAlignmentRight;
            }

            cell.textLabel.text = NSLocalizedStringFromTable(@"Information_Age", @"MyLoaclization" , @"");
        }
        
        else if (indexPath.row == 2) {
            

            if (cell == nil) {
                
                cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
                cell.detailtextview.hidden = YES;
                //cell.detailtextview.textAlignment = NSTextAlignmentLeft;
                cell.once.text = RDbirth;
                cell.once.hidden = NO;
                //cell.once.frame = CGRectMake(238, 10, 100, 30);
                cell.once.frame = CGRectMake(185, 10, 100, 30);
                cell.once.textAlignment = NSTextAlignmentRight;
                cell.once.font = [UIFont systemFontOfSize:15.0];
            }
            //            cell.datapicker.hidden = NO;
            cell.textLabel.text = NSLocalizedStringFromTable(@"Information_Birth", @"MyLoaclization" , @"");
         
        }
        
        else if (indexPath.row == 3) {
            
            if (cell == nil) {
                
                cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
                 cell.detailtextview.keyboardType = UIKeyboardTypeNumberPad;
                //cell.backgroundColor = [UIColor clearColor];
                 cell.detailtextview.text = RDweight;
            }
            cell.detailtextview.frame = CGRectMake(200, 10, 65, 28);
            cell.once.frame = CGRectMake(265, 13, 20, 30);

           
            cell.textLabel.text = NSLocalizedStringFromTable(@"Information_Weight", @"MyLoaclization" , @"");
            cell.once.text = @"kg";

        }
        else if (indexPath.row ==4)
        {
            
            if (cell == nil) {
                
                cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
                 cell.detailtextview.text = RDhigh;
               
                
            }
            cell.detailtextview.keyboardType = UIKeyboardTypeNumberPad;
            cell.textLabel.text = NSLocalizedStringFromTable(@"Information_High", @"MyLoaclization" , @"");
            cell.detailtextview.frame = CGRectMake(200, 10, 65, 28);
            cell.once.frame = CGRectMake(265, 13, 20, 30);
                       cell.once.text = @"cm";
            
            }
        
     
    }
   // cell.textLabel.highlightedTextColor = CELLTEXTLABELHIGHTCOLOR;
    
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    
    cell.selectedBackgroundView.backgroundColor = NAVIGATIONBAR_BACKCOLOR;
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.textColor = [UIColor whiteColor];
     //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor grayColor];
  
    return cell;
}



-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{


    return YES;
}
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    //根据 NSIndexPath判定行是否可选。
  
 
    return path;
}
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPath=indexPath;
    [_pickview remove];
    
    TableViewCell * icell=[self.tableview cellForRowAtIndexPath:indexPath];
    if ([icell.textLabel.text isEqualToString:NSLocalizedStringFromTable(@"Information_Birth", @"MyLoaclization" , @"")]) {
        NSDate *date=[NSDate dateWithTimeIntervalSinceNow:9000000];
        _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
        _pickview.delegate=self;
        
        [_pickview show];
               //self.navigationItem.leftBarButtonItem.enabled= NO;
    }
  
    if ([icell.textLabel.text isEqualToString:NSLocalizedStringFromTable(@"Information_Age", @"MyLoaclization" , @"")]) {
        _pickview=[[ZHPickView alloc] initPickviewWithArray:agearray isHaveNavControler:NO];
        _pickview.delegate=self;
        [_pickview show];
    }
    if ([icell.textLabel.text isEqualToString:NSLocalizedStringFromTable(@"Information_Weight", @"MyLoaclization" , @"")]) {
         _pickview=[[ZHPickView alloc] initPickviewWithArray:weightarray isHaveNavControler:NO];
        _pickview.delegate=self;
        [_pickview show];
    }
    if ([icell.textLabel.text isEqualToString:NSLocalizedStringFromTable(@"Information_High", @"MyLoaclization" , @"")]) {
         _pickview=[[ZHPickView alloc] initPickviewWithArray:hightarray isHaveNavControler:NO];
        _pickview.delegate=self;
        [_pickview show];
    }
}
#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
     self.navigationItem.leftBarButtonItem.enabled= YES;
    TableViewCell * icell=[self.tableview cellForRowAtIndexPath:_indexPath];
    if(resultString.length>8)
    {
    icell.once.text=resultString;
    NSLog(@"once = %@",icell.once.text);
    }
    else
    {
        icell.detailtextview.text = resultString;
        NSLog(@"detailtext = %@",icell.detailtextview.text);
    }
    if (_indexPath.row==1) {
        IFage = icell.detailtextview.text;
        NSLog(@"IFage = %@",IFage);
    }
    if (_indexPath.row==2) {
        IFbirth = icell.once.text;
        NSLog(@"IFbirth = %@",IFbirth);
    }
    if (_indexPath.row==3) {
        IFweight = icell.detailtextview.text;
        NSLog(@"IFweight = %@",IFweight);
    }
    if (_indexPath.row==4) {
        IFhigh = icell.detailtextview.text;
        NSLog(@"IFhigh = %@",IFhigh);
    }
}

#pragma mark 设置数据源
-(void)initwithage
{
    NSString *str;
    NSMutableArray *strArray = [NSMutableArray array];
    for (int i = 18; i <= 65; i++) {
        
        str = [NSString stringWithFormat:@"%i",i];
        [strArray addObject:str];
        
    }
    agearray = [strArray copy];
    

}
-(void)initwithweight
{
    NSString *str;
    NSMutableArray *strArray = [NSMutableArray array];
    for (int i = 30; i <= 100; i++) {
        for (int j=0; j<10; j++) {
            
            
            str = [NSString stringWithFormat:@"%i.%i",i,j];
            [strArray addObject:str];
        }
    }
    weightarray = [strArray copy];
    
  
}
-(void)initwithhight
{
    NSString *str;
    NSMutableArray *strArray = [NSMutableArray array];
    for (int i = 130; i <= 220; i++) {
        
        
        str = [NSString stringWithFormat:@"%i",i];
        [strArray addObject:str];
        
    }
    hightarray = [strArray copy];

}



-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    IFname = textField.text;
    NSLog(@"IFname = %@",IFname);
    [textField resignFirstResponder];
    //[delegate givemename:IFname];
    return  YES;
    
}
-(void)viewanimation:(UIView *)view willhidden:(BOOL)hidden
{
    [UIView animateWithDuration:0.3 animations:^{
        if (hidden) {
            view.frame = CGRectMake(0, 600, 320, 260);
        }
        else
        {
            view.frame =CGRectMake(0, 340, 320, 260);
        }
    } completion:^(BOOL finished)
     {
         [view setHidden:hidden];
     }];
    
}


- (void)resignKeyboard {
    [nameTextFiled resignFirstResponder];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)postHttpUrl:(NSString *)urlString postInfo:(NSDictionary *)info state:(int)state
//state 0 登录   1 上传   2  监测到注册时上传失败   3上传失败重新登录上传
{
    
        NSURL * url = [NSURL URLWithString:@"http://120.24.237.180:8080/PregnantHealth"];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        
        
        [httpClient postPath:urlString parameters:info success:^(AFHTTPRequestOperation *operation,id responseObject) {
            NSString *requestTmp = [NSString stringWithString:operation.responseString];
            NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
            //系统自带JSON解析
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"STATE%d ok result = %@",state,resultDic);
            if ([[resultDic objectForKey:@"result"] isEqual:@"true"]) {
                if (state == 1|state == 3) {
                 
                    
                    NSData *data;
                    //判断图片是不是png格式的文件
                    if (UIImagePNGRepresentation(myimage)) {
                        //返回为png图像。
                        data = UIImagePNGRepresentation([self imageWithImage:myimage scaledToSize:CGSizeMake(300, 300)]);
                    }else {
                        //返回为JPEG图像。
                        data = UIImageJPEGRepresentation([self imageWithImage:myimage scaledToSize:CGSizeMake(300, 300)], 1.0);
                    }
                    [data writeToFile:imagephoto atomically:NO];
                    
                    //上传头像
                    if (data!=nil) {
                        // something
                        NSString *RTorder =@"uploadHeadPhoto.jsp";
                        NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:RTorder parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                            //                        NSData *photodata;
                            //                        photodata = [self imageWithImage:myimage scaledToSize:CGSizeMake(20, 20)];
                            
                            [formData appendPartWithFileData:data name:@"header.jpg" fileName:@"header.jpg" mimeType:@"multipart/form-data; boundary=Boundary+0xAbCdEfGbOuNdArY"];
                            // [formData appendPartWithFormData:RTdata name:str];
                            NSLog(@"上传头像");
                            
                        }];
                        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                        [httpClient.operationQueue addOperation:op];
                        
                        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSString *requestTmp = [NSString stringWithString:operation.responseString];
                            NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                            //系统自带JSON解析
                            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                            NSLog(@" 头像resultDic = %@",resultDic);
                            NSLog(@"上传头像result = %@",[resultDic objectForKey:@"result"]);
                            
                            if ([[resultDic objectForKey:@"result"] isEqual:@"true"]) {
                                NSLog(@"头像上传完成");
                                
                            }
                            if ([[resultDic objectForKey:@"result"] isEqual:@"false"]) {
                                NSLog(@"头像上传失败");
                                
                                
                            }
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [loading dismiss];
                            NSLog(@"上传失败->%@", error);
                            
                        }];
                    }
                    
                    
                    [loading dismiss];
                    XYAlertView *alertView3 = [XYAlertView alertViewWithTitle:nil
                                                                      message:NSLocalizedStringFromTable(@"InforVCSaveSucces_Title", @"MyLoaclization" , @"")
                                                                      buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"InforVCSaveSucces_Button", @"MyLoaclization" , @""), nil]
                                                                 afterDismiss:^(long buttonIndex) {
                                                                     
                                                                 }];
                    [alertView3 show];
                    
                    
                    

                        NSString *sql1 = [NSString stringWithFormat:@"update '%@' set '%@'='%@', '%@'='%@', '%@'='%@','%@'='%@','%@'='%@',state='%@' where ID='%d'",TABLENAME,NAME,IFname,AGE,IFage,BIRTH,IFbirth,WEIGHT,IFweight,HIGH,IFhigh,@"0",1];
                        //  NSString *sql2 = [NSString stringWithFormat:@"delete from '%@'  where ID = '%d'",TABLENAME,2];
                        
                        [self execSql:sql1];
                        
                        NSLog(@"修改数据库");
                //    }
                     sqlite3_close(db);
                    //将上传失败的标志位置0
                    
                    
                    
                    [delegate givemename:IFname];
                    [delegate givemeimage:myimage];
                }
                
                if (state==0) {
                    
                    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
                    [parameters setValue:IFhigh forKey:@"height"];
                    [parameters setValue:IFname forKey:@"nickname"];
                    [parameters setValue:IFweight forKey:@"weight"];
                    [parameters setValue:IFage forKey:@"age"];
                    [parameters setValue:IFbirth forKey:@"birthDate"];
                    
                    NSString *order = @"updateGravidaInfo.jsp";
                    [self postHttpUrl:order postInfo:parameters state:3];
                    NSLog(@"第二次保存parameters = %@",parameters);
                }
                if (state==2) {
                    //将上传失败的标志位置0
                    NSString *sql1 = [NSString stringWithFormat:@"update '%@' set state = '%@' where ID='%d'", TABLENAME, @"0",1];
                    
                    [self execSql:sql1];
                    
                    
                }
                
            }
            if ([[resultDic objectForKey:@"result"] isEqual:@"false"]) {
                if (state!=2) {
                    [loading dismiss];
                    XYAlertView *alertView3 = [XYAlertView alertViewWithTitle:NSLocalizedStringFromTable(@"InforVCSaveFaile_Title", @"MyLoaclization" , @"")
                                                                      message:NSLocalizedStringFromTable(@"InforVCSaveFaile_Message", @"MyLoaclization" , @"")
                                                                      buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"InforVCAlretNet_Button", @"MyLoaclization" , @""), nil]
                                                                 afterDismiss:^(long buttonIndex) {
                                                                 }];
                    [alertView3 show];
                    
                }else if (state==2)
                {
                    XYAlertView *alertView3 = [XYAlertView alertViewWithTitle:nil
                                                                      message:NSLocalizedStringFromTable(@"InforVCSendFaile_Message", @"MyLoaclization" , @"")
                                                                      buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"InforVCAlretNet_Button", @"MyLoaclization" , @""), nil]
                                                                 afterDismiss:^(long buttonIndex) {
                                                                 }];
                    [alertView3 show];
                    
                }
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (state ==1) {//第一次上传失败
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
                [parameters setValue:[userDefaults objectForKey:USERDEFAULTS_USERNAME] forKey:@"account"];
                [parameters setValue:[userDefaults objectForKey:USERDEFAULTS_PASSWD] forKey:@"password"];
                NSString *order = @"login.jsp";
                [self postHttpUrl:order postInfo:parameters state:0];
            }
            if (state == 3| state ==0) {//第二次上传失败
                [loading dismiss];
                XYAlertView *alertView3 = [XYAlertView alertViewWithTitle:NSLocalizedStringFromTable(@"InforVCSaveFaile_Title", @"MyLoaclization" , @"")
                                                                  message:NSLocalizedStringFromTable(@"InforVCSaveFaile_Message", @"MyLoaclization" , @"")
                                                                  buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"InforVCAlretNet_Button", @"MyLoaclization" , @""), nil]
                                                             afterDismiss:^(long buttonIndex) {
                                                                 
                                                             }];
                [alertView3 show];
            }
            if (state==2) {
                [loading dismiss];
                XYAlertView *alertView3 = [XYAlertView alertViewWithTitle:nil
                                                                  message:NSLocalizedStringFromTable(@"InforVCSendFaile_Message", @"MyLoaclization" , @"")
                                                                  buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"InforVCAlretNet_Button", @"MyLoaclization" , @""), nil]
                                                             afterDismiss:^(long buttonIndex) {
                                                             }];
                [alertView3 show];
                
            }
            NSLog(@"由于网络原因失败error = %@",error.localizedDescription);
            
        }];
    
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize

{
    
    // Create a graphics image context
    
    UIGraphicsBeginImageContext(newSize);
    
    
    
    // Tell the old image to draw in this new context, with the desired
    
    // new size
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    
    
    // Get the new image from the context
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    // End the context
    
    UIGraphicsEndImageContext();
    
    
    
    // Return the new image.
    
    return newImage;
    
}

-(NSData *)returnforimg:(UIImage *)image
{
    NSData *data;

    return data;
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
