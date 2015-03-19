//
//  SettingTableViewController.m
//  iSeed
//
//  Created by Chan Bill on 14/11/27.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import "SettingTableViewController.h"
#import "RESideMenu.h"
#import "Config.h"
#import "BLEdebug.h"

@interface SettingTableViewController ()
{
    BLEdebug *ble;
    NSString *BTstring;
    NSString *rthistoryPath;
    NSMutableData *bufferDataFor;
    NSString *makeConfig ;
    NSUserDefaults *userDefaults;
    NSString *NAMEFORUSER;
}
@end

@implementation SettingTableViewController

@synthesize delegate;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}
-(void)loadView
{
  
    userDefaults = [NSUserDefaults standardUserDefaults];
    NAMEFORUSER = [userDefaults objectForKey:USERDEFAULTS_USERNAME];
    makeConfig = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:NAMEFORUSER] stringByAppendingPathComponent:@"makeConfig"];
    //初始化
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake UIVIEW_SIZE];
    self.view=view;
//    UIImageView *screen = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 320, 568)];
//    [screen setImage:[UIImage imageNamed:RidemenuImage]];
    //[self.view addSubview:screen];
   // self.view.backgroundColor = VIEWBACKCOLOR;
    self.view.backgroundColor = [UIColor colorWithRed: 165.0/255 green: 175.0/255 blue: 176.0/255 alpha: 0];
    //self.view.backgroundColor = VIEWBACKCOLOR;
    //    UINavigationBar *navigationbar = [[UINavigationBar alloc]initWithFrame:CGRectMake NAVIGATIONBAR_SIZE];
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake SETTINGTABLEVIEW_SIZE style:UITableViewStylePlain];
    self.navigationItem.title =NSLocalizedStringFromTable(@"SettingVC_Title", @"MyLoaclization" , @"");
    //tableview
    table.backgroundColor = TABLEVIEWCOLOR;
    
    table.dataSource = self;
    table.delegate = self;

    table.scrollEnabled = NO;
    
    
    UIButton *lbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    lbutton.frame = CGRectMake(0, 0, 20,15 ); //(0, 0, 12, 16)
    UIImage *icon3 = [UIImage imageNamed:RidemenuButtonImage];
    CGSize itemSize3 = CGSizeMake(15, 15);
    UIGraphicsBeginImageContextWithOptions(itemSize3, NO ,0.0);
    CGRect imageRect3 = CGRectMake(0.0, 0.0, itemSize3.width, itemSize3.height);
    [icon3 drawInRect:imageRect3];
    icon3 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [lbutton setBackgroundImage:icon3 forState:UIControlStateNormal]; //modify 1204
    [lbutton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:lbutton];
    self.navigationItem.leftBarButtonItem=leftButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  
    [self.view addSubview:table];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    UIButton *cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 500, 310, 50)];
    cancleButton.backgroundColor = [UIColor clearColor];
    [cancleButton addTarget:self action:@selector(cancalpress) forControlEvents:UIControlEventTouchUpInside];
    [cancleButton setTitle:NSLocalizedStringFromTable(@"SettingVC_Cancle", @"MyLoaclization" , @"") forState:UIControlStateNormal];
    [cancleButton setBackgroundColor:NAVIGATIONBAR_BACKCOLOR];
    [cancleButton setTitleColor:CELLTEXTLABELHIGHTCOLOR forState:UIControlStateNormal];
    [cancleButton setBackgroundImage:[UIImage imageNamed:SettingCancaleImage] forState:UIControlStateNormal];
    [self.view addSubview:cancleButton];
}

-(void)cancalpress
{
    XYAlertView *alert1 = [XYAlertView alertViewWithTitle:NSLocalizedStringFromTable(@"SettingVC_Alret_Title", @"MyLoaclization" , @"") message:NSLocalizedStringFromTable(@"SettingVC_Alret_Message", @"MyLoaclization" , @"") buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"SettingVC_Alret_SureButton", @"MyLoaclization" , @""),NSLocalizedStringFromTable(@"SettingVC_Alret_CancleButton", @"MyLoaclization" , @""),nil] afterDismiss:^(long buttonIndex) {
        if (buttonIndex==0) {
            //fixmeup 退出时保存用户资料到服务器
            [userDefaults setValue:@"0" forKey:USERDEFAULTS_LOGINSTATE];
            [userDefaults synchronize];
            // [userDefaults removeObjectForKey]
            if ([self.delegate getblestate]==1) {
                [self.delegate disconnectble];
            }
            
            [self.delegate cancleview];
        }
        if (buttonIndex==1) {
            
        }
        
    }];
    [alert1 show];
}


-(void)readbattry
{
    
    NSString *makeConfig1 = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:NAMEFORUSER]stringByAppendingPathComponent:@"makeConfig"];
    NSData *data = [NSData dataWithContentsOfFile:makeConfig1];
    NSKeyedUnarchiver * uarch = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
   // BTstring = [uarch decodeObjectForKey:@"batty"];
    
   // NSLog(@"电池电量为 %@%%",BTstring);
    NSString *version = [uarch decodeObjectForKey:@"version"];
    NSLog(@"版本号为%@",version);
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc]init];
    myButton.title = NSLocalizedStringFromTable(@"SettingVC_ReturnButton", @"MyLoaclization" , @"");
    self.navigationItem.backBarButtonItem = myButton;
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"root" ofType:@"plist"];
    //    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    [self readbattry];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 2;
}
//返回有几个区
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
  //  NSString *story = [stories objectAtIndex:section];
    if (section==0) {
        return 2;
    }
    else
       return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section==0) {
        return 50;
    }
    else
        return 50;
    
}
//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
//    NSUInteger sectionNo = indexPath.section;
//    NSUInteger rowNo = indexPath.row;
//    NSString * story = [stories objectAtIndex:sectionNo];
    static NSString* cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.textLabel.highlightedTextColor = CELLTEXTLABELHIGHTCOLOR;
    //根据不同区的不同行创建不同风格的cell
    if (indexPath.section==0) {
        
    
        if (indexPath.row == 0) {
            if (cell==nil) {
         
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
                cell.detailTextLabel.textColor = CELLTEXTLABELHIGHTCOLOR;
            if ([userDefaults objectForKey:USERDEFAULTS_BATTRY]==nil) {
              cell.detailTextLabel.text = @"- -";
            }
            else
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%%",[userDefaults objectForKey:USERDEFAULTS_BATTRY]];
                
            //cell.detailTextLabel.textColor = [UIColor whiteColor];
                //头像的缩放
            UIImage *icon = [UIImage imageNamed:SettingBatteryImage ];
            CGSize itemSize = CGSizeMake(12, 20);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [icon drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            //  cell.imageView.image = [UIImage imageNamed:@"homepage1128.png"];
            //cell.imageView.highlightedImage = [UIImage imageNamed:@"cellgreen1202.png"];
            cell.textLabel.text = NSLocalizedStringFromTable(@"SettingVC_Battary", @"MyLoaclization" , @"");
            
            
        }
    }
    if (indexPath.row==1)
    {
        if (cell==nil) {
           
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            switchview.onTintColor = [UIColor whiteColor];//[UIColor whiteColor]
            switchview.thumbTintColor = CELLSELECTCOLOR;//CELLSELECTCOLOR
            [switchview addTarget:self action:@selector(switchchange:) forControlEvents:UIControlEventValueChanged];
            
  //           震动开关的打开关闭
            
            NSLog(@"振动开关为%@",[userDefaults objectForKey:USERDEFAULTS_SHANKE]);
            if ([[userDefaults objectForKey:USERDEFAULTS_SHANKE] isEqual:@"0"]) {
                [switchview setOn:NO];
                }
            if ([[userDefaults objectForKey:USERDEFAULTS_SHANKE] isEqual:@"1"]) {
                [switchview setOn:YES];
                
            }
            
            
            cell.accessoryView = switchview;
            UIImage *icon = [UIImage imageNamed:SettingShakeImage ];
            CGSize itemSize = CGSizeMake(16,16 );
            UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [icon drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            //  cell.imageView.image = [UIImage imageNamed:@"homepage1128.png"];
            //cell.imageView.highlightedImage = [UIImage imageNamed:@"shakegreen1202.png"];
             cell.textLabel.text = NSLocalizedStringFromTable(@"SettingVC_Sharke", @"MyLoaclization" , @"");
            }
        }
    }
    else if(indexPath.section==1){
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

        if (indexPath.row==0) {
            cell.textLabel.text = NSLocalizedStringFromTable(@"SettingVC_Help", @"MyLoaclization" , @"");
            UIImage *icon = [UIImage imageNamed:SettingHelpImage];
            
            CGSize itemSize = CGSizeMake(20, 20);
            
            UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
            
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            
            [icon drawInRect:imageRect];
            
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            
            
            UIImage *icon1 = [UIImage imageNamed:SettingHelpHighImage];
            CGSize itemSize1 = CGSizeMake(20, 20);
            UIGraphicsBeginImageContextWithOptions(itemSize1, NO ,0.0);
            CGRect imageRect1 = CGRectMake(0.0, 0.0, itemSize1.width, itemSize1.height);
            [icon1 drawInRect:imageRect1];
            cell.imageView.highlightedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
           // cell.imageView.highlightedImage = [UIImage imageNamed:SettingHelpHighImage];
            cell.imageView.contentMode = UIViewContentModeCenter;
        }
        if (indexPath.row==1) {
            cell.textLabel.text = NSLocalizedStringFromTable(@"SettingVC_Connect", @"MyLoaclization" , @"");
            UIImage *icon = [UIImage imageNamed:SettingRelationImage];
            
            CGSize itemSize = CGSizeMake(21, 15);
            
            UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
            
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            
            [icon drawInRect:imageRect];
            
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            
          //  cell.imageView.highlightedImage = [UIImage imageNamed:SettingRelationHighImage];
            UIImage *icon1 = [UIImage imageNamed:SettingRelationHighImage];
            CGSize itemSize1 = CGSizeMake(21, 15);
            UIGraphicsBeginImageContextWithOptions(itemSize1, NO ,0.0);
            CGRect imageRect1 = CGRectMake(0.0, 0.0, itemSize1.width, itemSize1.height);
            [icon1 drawInRect:imageRect1];
            cell.imageView.highlightedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // cell.imageView.highlightedImage = [UIImage imageNamed:SettingHelpHighImage];
            cell.imageView.contentMode = UIViewContentModeCenter;
        }

        if (indexPath.row==2) {
            cell.textLabel.text = NSLocalizedStringFromTable(@"SettingVC_Update", @"MyLoaclization" , @"");
            UIImage *icon = [UIImage imageNamed:SettingUpdateHighImage ];
            
            CGSize itemSize = CGSizeMake(20, 20);
            
            UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
            
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            
            [icon drawInRect:imageRect];
            
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            //cell.imageView.highlightedImage = [UIImage imageNamed:SettingUpdateHighImage];
            
            
            UIImage *icon1 = [UIImage imageNamed:SettingUpdateImage];//SettingUpdateImage
            CGSize itemSize1 = CGSizeMake(20, 20);
            UIGraphicsBeginImageContextWithOptions(itemSize1, NO ,0.0);
            CGRect imageRect1 = CGRectMake(0.0, 0.0, itemSize1.width, itemSize1.height);
            [icon1 drawInRect:imageRect1];
            cell.imageView.highlightedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        
            cell.imageView.contentMode = UIViewContentModeRight;
            
        }

        if (indexPath.row==3) {
            cell.textLabel.text = NSLocalizedStringFromTable(@"SettingVC_Declear", @"MyLoaclization" , @"");
            UIImage *icon = [UIImage imageNamed:SettingStatementImage];
            
            CGSize itemSize = CGSizeMake(20, 22);
            
            UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
            
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            
            [icon drawInRect:imageRect];
            
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            
            
            UIImage *icon1 = [UIImage imageNamed:SettingStatementHighImage];
            CGSize itemSize1 = CGSizeMake(20, 22);
            UIGraphicsBeginImageContextWithOptions(itemSize1, NO ,0.0);
            CGRect imageRect1 = CGRectMake(0.0, 0.0, itemSize1.width, itemSize1.height);
            [icon1 drawInRect:imageRect1];
            cell.imageView.highlightedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
           // cell.imageView.highlightedImage = [UIImage imageNamed:SettingStatementHighImage];
            cell.imageView.contentMode = UIViewContentModeRight;
        }

        if (indexPath.row==4) {
            cell.textLabel.text = NSLocalizedStringFromTable(@"SettingVC_TeamIntreduc", @"MyLoaclization" , @"");
            UIImage *icon = [UIImage imageNamed:SettingIntroImage ];
            
            CGSize itemSize = CGSizeMake(20, 20);
            
            UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
            
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            
            [icon drawInRect:imageRect];
            
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            
            
            UIImage *icon1 = [UIImage imageNamed:SettingIntroHighImage];
            CGSize itemSize1 = CGSizeMake(20, 20);
            UIGraphicsBeginImageContextWithOptions(itemSize1, NO ,0.0);
            CGRect imageRect1 = CGRectMake(0.0, 0.0, itemSize1.width, itemSize1.height);
            [icon1 drawInRect:imageRect1];
            cell.imageView.highlightedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
           // cell.imageView.highlightedImage = [UIImage imageNamed:SettingIntroHighImage];
            cell.imageView.contentMode = UIViewContentModeCenter;
        }

            }
    //设置cell的各种属性
    //cell.textLabel.highlightedTextColor = CELLTEXTLABELHIGHTCOLOR;
    cell.textLabel.font =[UIFont systemFontOfSize:15];
   // cell.textLabel.textColor =
    cell.backgroundColor =TABLEVIEWCOLOR;
    // Configure the cell...
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = CELLSELECTCOLOR;
    cell.textLabel.textColor = CELLTEXTLABELHIGHTCOLOR;
    
    //   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


-(void)switchchange:(id)sender
{
    
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
        //归档
    NSLog(@"目前蓝牙的状态为%@",[userDefaults objectForKey:USERDEFAULTS_BLESTATE]);
    if (![userDefaults objectForKey:USERDEFAULTS_BLESTATE]|[[userDefaults objectForKey:USERDEFAULTS_BLESTATE] isEqualToString:@"0"]) {
        XYAlertView *alert = [XYAlertView alertViewWithTitle:NSLocalizedStringFromTable(@"SettingVC_ConnectBleAlret_Title", @"MyLoaclization" , @"") message:NSLocalizedStringFromTable(@"SettingVC_ConnectBleAlret_Message", @"MyLoaclization" , @"") buttons:[NSArray arrayWithObjects:@"OK", nil] afterDismiss:^(long buttonIndex) {
            
        }];
        [alert show];
        
    }

    else{
        if (isButtonOn) {
            [userDefaults setObject:@"1" forKey:USERDEFAULTS_SHANKE];
            [self.delegate Wariming:1];
           
        }else {
            [userDefaults setObject:@"0" forKey:USERDEFAULTS_SHANKE];
            [self.delegate Wariming:0];
        
    }
        [userDefaults synchronize];
    }
}



//设置页眉
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    if (section == 0){
        [headerView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
        title.text = NSLocalizedStringFromTable(@"SettingVC_SectionOne_Title", @"MyLoaclization" , @"");
        title.center =CGPointMake(headerView.center.x-100, headerView.center.y+10);
        title.textColor = [UIColor colorWithRed:165.0/255 green:175.0/255 blue:176.0/255 alpha:1]; //165 175 176
        [headerView addSubview:title];
    }
    else{
        [headerView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
        [headerView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        title.text = NSLocalizedStringFromTable(@"SettingVC_SectionTwo_Title", @"MyLoaclization" , @"");
        title.center =CGPointMake(headerView.center.x-120, headerView.center.y+10);
        title.textColor = [UIColor colorWithRed:165.0/255 green:175.0/255 blue:176.0/255 alpha:1];
        [headerView addSubview:title];
    }
    return headerView;


}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        NSString *title = [NSString stringWithFormat:NSLocalizedStringFromTable(@"SettingVC_SectionOne_Title", @"MyLoaclization" , @"")];
        //title.backgroundColor =[UIColor colorWithRed: 255.0/255 green: 111.0/255 blue: 132.0/255 alpha: 0.6];
        
        return title;
    }else{
        NSString *title = [NSString stringWithFormat:NSLocalizedStringFromTable(@"SettingVC_SectionTwo_Title", @"MyLoaclization" , @"")];
        return title;
    }
}
//设置页尾
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}
//设置高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return HIGHFORCELL_SETTINGVIEW;
}

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    //根据 NSIndexPath判定行是否可选。
    
    if ((path.row==1)&(path.section==0))
    {
        return nil;
    }
    
    return path;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Table view delegate
//选中的操作
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"选中了:%@",[self.stories objectAtIndex:[indexPath row]]);
    //选中动作
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    NSLog(@"选择电池电量");
                    break;
                case 1:
                     NSLog(@"选择震动开关");
                    break;
                
                    
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:{
                    NSLog(@"选择帮助");
                    HelpViewController *helpVC  = [[HelpViewController alloc]initWithNibName:@"HelpViewController" bundle:nil];
                    [self.navigationController pushViewController:helpVC animated:YES];
                }
                    break;
                case 1:{
                    ConnectViewController *connectVC = [[ConnectViewController alloc]initWithNibName:@"ConnectViewController" bundle:nil];
                    [self.navigationController pushViewController:connectVC animated:YES];
                    NSLog(@"选择联系我们");
                }
                    break;
                case 2:{
                    UpdataViewController *updataVC = [[UpdataViewController alloc]initWithNibName:@"ConnectViewController" bundle:nil];
                    [self.navigationController pushViewController:updataVC animated:YES];
                    NSLog(@"选择版本更新");
                }
                    break;
                case 3:{
                    DeclearViewController *declearVC = [[DeclearViewController alloc]initWithNibName:@"DeclearViewController" bundle:nil];
                    [self.navigationController pushViewController:declearVC animated:YES];
                    NSLog(@"选择免责申明");
                   
                }
                    break;
                case 4:{
                    TeamIntrViewController *teamintrVC = [[TeamIntrViewController alloc]initWithNibName:@"TeamIntrViewController" bundle:nil];
                    [self.navigationController pushViewController:teamintrVC animated:YES];
                    NSLog(@"选择团队介绍");
                    
                }
                    break;
                default:
                    break;
            }
        default:
            break;
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
