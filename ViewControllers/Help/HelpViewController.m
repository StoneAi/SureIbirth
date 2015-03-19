//
//  HelpViewController.m
//  iSeed
//
//  Created by Chan Bill on 14/11/27.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import "HelpViewController.h"
#import "Config.h"
@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStringFromTable(@"HelpVC_Title", @"MyLoaclization" , @"");
    
    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 580)];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:HelpImage]];
    UIImage *image = [UIImage imageNamed:HelpImage];
    scrollview.contentSize = CGSizeMake(image.size.width/2, image.size.height/2);
    imageView.frame = CGRectMake(0, 0, image.size.width/2, image.size.height/2);
    [scrollview addSubview:imageView];
    [self.view addSubview:scrollview];
    
    // Do any additional setup after loading the view from its nib.
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
