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
{
    CGFloat allheight;
    UISwipeGestureRecognizer *swipe;
    NSUInteger num;
    UIScrollView *tmpscrollview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    num = 1;
    self.navigationItem.title = NSLocalizedStringFromTable(@"SettingVC_NoteBook", @"MyLoaclization" , @"");
    allheight = 0;
    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 580)];
    
    for (int i=0;i<22;i++) {
        NSString *name = [NSString stringWithFormat:@"返過-%d.png",i+1];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:name]];
        UIImage *image = [UIImage imageNamed:name];
        imageView.frame = CGRectMake(0, allheight+20, image.size.width/2, image.size.height/2);
        allheight += image.size.height/2+20;
        
        
        [scrollview addSubview:imageView];
    }
    scrollview.contentSize = CGSizeMake(320,allheight+20);
    scrollview.scrollEnabled = YES;
    [self.view addSubview:scrollview];
    
    
    if (/* DISABLES CODE */ (0)) {
        int i=1;
        tmpscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 580)];
        NSString *tmpname = [NSString stringWithFormat:@"返過-%d.png",i];
        UIImageView *tmpimageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:tmpname]];
        UIImage *tmpimage = [UIImage imageNamed:tmpname];
        tmpimageView.frame = CGRectMake(0, 80, tmpimage.size.width/2, tmpimage.size.height);
        [tmpscrollview addSubview:tmpimageView];
        
        tmpscrollview.contentSize = CGSizeMake(320,580);
        tmpscrollview.scrollEnabled = YES;
        [self.view addSubview:tmpscrollview];

        tmpscrollview.userInteractionEnabled = YES;
        tmpscrollview.multipleTouchEnabled = NO;
        
        swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeview)];
        swipe.direction = 1<<2|1<<3;
        [tmpscrollview addGestureRecognizer:swipe];
            
            }
    // Do any additional setup after loading the view from its nib.
}

-(void)swipeview
{

    NSUInteger direction = swipe.direction;
    if (direction==UISwipeGestureRecognizerDirectionUp) {
        num--;
        
    }
    if (direction==UISwipeGestureRecognizerDirectionDown) {
        
    }

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
