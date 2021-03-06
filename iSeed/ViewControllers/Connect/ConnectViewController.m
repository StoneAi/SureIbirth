//
//  ConnectViewController.m
//  iSeed
//
//  Created by Chan Bill on 14/11/27.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import "ConnectViewController.h"
#import "AppDelegate.h"
@interface ConnectViewController ()

@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedStringFromTable(@"ConnectVC_Title", @"MyLoaclization" , @"");
    //self.view.backgroundColor = [UIColor colorWithRed:215./255 green:215./255 blue:215./255 alpha:1.0f];
    //TODO elias
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    //imageView.image = [UIImage imageNamed:@"homepagebackground1231.png"];
//    [imageView setImage:[UIImage imageNamed:MainViewImage]];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    [self.view addSubview:imageView];
    
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc]init];
    myButton.title = NSLocalizedStringFromTable(@"ConnectVC_Return", @"MyLoaclization" , @"");
    self.navigationItem.backBarButtonItem = myButton;
   //logo图标
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(107, 108,107, 107)];
    imageview.image = [UIImage imageNamed:ConnectLogeImage];
    [self.view addSubview:imageview];
   
    //call  email按键  和信息
    UIButton *callbutton = [[UIButton alloc]initWithFrame:CGRectMake(64, 257, 193, 40)];
    UIButton *emailbutton = [[UIButton alloc]initWithFrame:CGRectMake(64, 316, 193, 40)];
    
    [callbutton setBackgroundImage:[UIImage imageNamed:ConnectCallImage] forState:UIControlStateNormal];
    //[callbutton setBackgroundImage:[UIImage imageNamed:ConnectCallHighImage] forState:UIControlStateHighlighted];
    [emailbutton setBackgroundImage:[UIImage imageNamed:ConnectEmailImage] forState:UIControlStateNormal];
  //  [emailbutton setBackgroundImage:[UIImage imageNamed:ConnectEmailHighImage] forState:UIControlStateHighlighted];
    [callbutton addTarget:self action:@selector(callbuttonselect) forControlEvents:UIControlEventTouchUpInside];
    [emailbutton addTarget:self action:@selector(emailbuttonselect) forControlEvents:UIControlEventTouchUpInside];
    emailbutton.enabled =YES;
    callbutton.enabled = YES;
    [self.view addSubview:callbutton];
    [self.view addSubview:emailbutton];
    
    UILabel *calllabel = [[UILabel alloc]initWithFrame:CGRectMake(114, 267, 143, 21)];
   
    UILabel *emaillabel = [[UILabel alloc]initWithFrame:CGRectMake(114, 325, 135, 21)];
    calllabel.text = @"0755-86562669";
    emaillabel.text = @"info@vipose.com";
    [self.view addSubview:calllabel];
    [self.view addSubview:emaillabel];
    //下面部分button及label
//    UIButton *sevbutton = [[UIButton alloc]initWithFrame:CGRectMake(175, 490, 68, 30)];
//    [sevbutton addTarget:self action:@selector(sevbuttonselect) forControlEvents:UIControlEventTouchUpInside];

    
    
    
    
    
    UIButton *netbutton = [[UIButton alloc]initWithFrame:CGRectMake(64, 375, 193, 40)];
    [netbutton addTarget:self action:@selector(netbuttonselect) forControlEvents:UIControlEventTouchUpInside];
    [netbutton setBackgroundImage:[UIImage imageNamed:ConnectUrlImage] forState:UIControlStateNormal];
//    UILabel *sevlabel = [[UILabel alloc] initWithFrame:CGRectMake(174, 495, 140, 21)];
    UILabel *netlabel = [[UILabel alloc]initWithFrame:CGRectMake(114, 384, 193, 21)];
    //netlabel.textAlignment = NSTextAlignmentCenter;
//    sevlabel.text = NSLocalizedStringFromTable(@"tittleLabel_ServicesListVC_Text", @"MyLoaclization" , @"");
    netlabel.text = @"www.vipose.com";//NSLocalizedStringFromTable(@"ConnectVC_ViposeNet", @"MyLoaclization" , @"")
//    [self.view addSubview:sevlabel];
//    [self.view addSubview:sevbutton];
    [self.view addSubview:netlabel];
    [self.view addSubview:netbutton];
    
//    sevbutton.enabled = YES;
    netbutton.enabled = YES;
    
    UILabel *lastlabel = [[UILabel alloc]initWithFrame:CGRectMake(42, 520, 435, 21)];
    lastlabel.text = @"Copyright @2015 Vipose Inc. All Rights Reserved";
    lastlabel.textColor = [UIColor lightGrayColor];
    lastlabel.font = [UIFont boldSystemFontOfSize:9];
    lastlabel.textAlignment = NSTextAlignmentCenter;
    lastlabel.center = CGPointMake(self.view.center.x, 530);
    [self.view addSubview:lastlabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 按键方法
-(void)callbuttonselect
{
//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://075586562669"]];
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSString *tel = @"tel:075586562669";
    NSURL *telURL =[NSURL URLWithString:tel];//@"tel:10010"];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self.view addSubview:callWebview];
    
    
}
-(void)emailbuttonselect
{
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://info@vipose.com"]];
}

-(void)sevbuttonselect
{
    ServicesListViewController *serviceVC = [[ServicesListViewController alloc] initWithNibName:@"ServicesListViewController" bundle:nil];
    [self.navigationController pushViewController:serviceVC animated:YES];
}
-(void)netbuttonselect
{
    NSURL *safariURL = [NSURL URLWithString:@"http://www.vipose.com"];
    [[UIApplication sharedApplication] openURL:safariURL];


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
