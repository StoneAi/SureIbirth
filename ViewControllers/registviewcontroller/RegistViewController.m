//
//  RegistViewController.m
//  iSeed
//
//  Created by Chan Bill on 15/1/8.
//  Copyright (c) 2015年 elias kang. All rights reserved.
//

#import "RegistViewController.h"
#import "AppDelegate.h"

@interface RegistViewController ()
@property(nonatomic,strong)NSIndexPath *indexPath;
@property (strong,nonatomic) ZHPickView *pickview;

@end

@implementation RegistViewController
{
    UIButton *nextbutton;
    UIButton *returnbutton;
    UITableView *table;
    UITextField *namefield;
    NSUserDefaults *userDefaults;
    NSIndexPath *indexpath;
    NSArray *agearray;
    NSArray *hightarray;
    NSArray *weightarray;
    NSString *IFname;
    NSString *IFage;
    NSString *IFbirth;
    NSString *IFweight;
    NSString *IFhigh;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self initwithage];
    [self initwithhight];
    [self initwithweight];
    
    UINavigationBar *nav = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 65)];
    //nav.backgroundColor = NAVIGATIONBAR_BACKCOLOR;
    [nav setBarTintColor:NAVIGATIONBAR_BACKCOLOR];
    [self.view addSubview:nav];
    
    UILabel *regist = [[UILabel alloc] initWithFrame:CGRectMake(100, 27, 120, 30)];
    regist.text = NSLocalizedStringFromTable(@"Lable_regist_Title",@"MyLoaclization" , @"");
    regist.textAlignment = NSTextAlignmentCenter;
    regist.font = [UIFont systemFontOfSize:20.0];
    regist.textColor = [UIColor whiteColor];
    [self.view addSubview:regist];
    
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    returnbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    [returnbutton setImage:[UIImage imageNamed:RegistOneReImage] forState:UIControlStateNormal];
    [returnbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [returnbutton addTarget:self action:@selector(returntologin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnbutton];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, 320, 54*5) style:UITableViewStylePlain
             ];
    table.backgroundColor = [UIColor clearColor];
    table.dataSource = self;
    table.delegate = self;
    table.scrollEnabled = NO;
    [self.view addSubview:table];
    namefield = [[UITextField alloc]initWithFrame:CGRectMake(150, 147, 135, 40)];
    //namefield.backgroundColor = [UIColor blackColor];
    namefield.textAlignment = NSTextAlignmentRight;
    namefield.delegate = self;
    namefield.returnKeyType = UIReturnKeyDone;
    namefield.placeholder = NSLocalizedStringFromTable(@"NameTextField_Text",@"MyLoaclization" , @"");
    namefield.textColor = [UIColor grayColor];
    [self.view addSubview:namefield];
    
    
    nextbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextbutton.frame = CGRectMake(120, 480, 80, 50);
    [nextbutton setTitle:NSLocalizedStringFromTable(@"NextButton_Title",@"MyLoaclization" , @"") forState:UIControlStateNormal];
    [nextbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    nextbutton.titleLabel.font = [UIFont systemFontOfSize:22.0];
    [nextbutton addTarget:self action:@selector(nextregist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextbutton];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [namefield addGestureRecognizer:gesture];
    // Do any additional setup after loading the view from its nib.
}

-(void)hidenKeyboard
{
    [_pickview remove];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}
//返回有几个区
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    //  NSString *story = [stories objectAtIndex:section];
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    return 54;
    
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
 
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = NSLocalizedStringFromTable(@"Information_Name",@"MyLoaclization" , @"");
           
            break;
        case 1:
            cell.textLabel.text = NSLocalizedStringFromTable(@"Information_Age",@"MyLoaclization" , @"");
           
            break;
        case 2:
            cell.textLabel.text = NSLocalizedStringFromTable(@"Information_Birth",@"MyLoaclization" , @"");
            break;
        case 3:
            cell.textLabel.text = NSLocalizedStringFromTable(@"Information_Weight",@"MyLoaclization" , @"");
            
            break;
        case 4:
            cell.textLabel.text = NSLocalizedStringFromTable(@"Information_High",@"MyLoaclization" , @"");
            break;
        default:
            break;
    }
    cell.detailTextLabel.text = @" ";
    cell.textLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.textColor = [UIColor grayColor];
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPath=indexPath;

    [_pickview remove];
 
    if (indexPath.row!=0) {
        IFname = namefield.text;
        [namefield resignFirstResponder];
    }
    
    switch (indexPath.row) {
        case 1:{
            _pickview=[[ZHPickView alloc] initPickviewWithArray:agearray isHaveNavControler:NO];
            _pickview.delegate=self;
            [_pickview show];
                    }
            break;
        case 2 :
        {
            NSDate *date=[NSDate dateWithTimeIntervalSinceNow:9000000];
            _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
            _pickview.delegate=self;
            [_pickview show];
            

                   }
            break;
        case 3 :
        {
            _pickview=[[ZHPickView alloc] initPickviewWithArray:weightarray isHaveNavControler:NO];
            _pickview.delegate=self;
            [_pickview show];
            
            
        }
            break;
        case 4 :
        {
            _pickview=[[ZHPickView alloc] initPickviewWithArray:hightarray isHaveNavControler:NO];
            _pickview.delegate=self;
            [_pickview show];
            
            
        }
            break;
        default:
            break;
    }

   
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


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    if (theTextField == namefield) {
        IFname = namefield.text;
        [theTextField resignFirstResponder];
        
    }
       return YES;
    
}


-(void)returntologin
{
    [_pickview remove];
   
    [(AppDelegate*)[UIApplication sharedApplication].delegate setlogin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    UITableViewCell * icell=[table cellForRowAtIndexPath:_indexPath];
    
    icell.detailTextLabel.text = resultString;
    if (_indexPath.row==1) {
       
        IFage = icell.detailTextLabel.text;
        
        NSLog(@"IFage = %@",IFage);
    }
    if (_indexPath.row==2) {
       
        IFbirth = icell.detailTextLabel.text;
        NSLog(@"IFbirth = %@",IFbirth);
    }
    if (_indexPath.row==3) {
        icell.detailTextLabel.text = [NSString stringWithFormat:@"%@ kg",resultString];
        IFweight = resultString;
        NSLog(@"IFweight = %@",IFweight);
    }
    if (_indexPath.row==4) {
        icell.detailTextLabel.text = [NSString stringWithFormat:@"%@ cm",resultString];
        IFhigh = resultString;
        NSLog(@"IFhigh = %@",IFhigh);
    }
    
    
}
-(void)nextregist
{
    NSData *data1 = [IFname dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data2 = [IFage dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data3 = [IFbirth dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data4 = [IFweight dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data5 = [IFhigh dataUsingEncoding:NSUTF8StringEncoding];
    //测试修改
    if ((data1.length)&&(data2.length)&&(data3.length)&&(data4.length)&&(data5.length)) {
        [userDefaults setObject:IFname forKey:USERDEFAULTS_NAME];           //保存到本地
        [userDefaults setObject:IFage forKey:USERDEFAULTS_AGE];
        [userDefaults setObject:IFbirth forKey:USERDEFAULTS_BIRTH];
        [userDefaults setObject:IFweight forKey:USERDEFAULTS_WEIGHT];
        [userDefaults setObject:IFhigh forKey:USERDEFAULTS_HIGH];
        
        [userDefaults synchronize];
    
       

    
        [self gotonext];
         NSLog(@"下一步");
     //测试修改
    }
    else
    {
        XYAlertView *alert = [XYAlertView alertViewWithTitle:NSLocalizedStringFromTable(@"Registfaile_Alret_Title",@"MyLoaclization" , @"") message:NSLocalizedStringFromTable(@"Registfaile_Alret_Message",@"MyLoaclization" , @"") buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"Registfaile_Alret_Button",@"MyLoaclization" , @""), nil]  afterDismiss:^(long buttonIndex) {
            
        }];
        [alert show];
    
    }

}
-(void)gotonext
{
    [(AppDelegate *)[UIApplication sharedApplication].delegate settworegist];
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
    for (int i = 40; i <= 75; i++) {
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
    for (int i = 130; i <= 200; i++) {
        
        
        str = [NSString stringWithFormat:@"%i",i];
        [strArray addObject:str];
        
    }
    hightarray = [strArray copy];   
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
