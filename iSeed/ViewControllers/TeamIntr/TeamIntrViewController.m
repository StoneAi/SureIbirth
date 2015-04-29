//
//  TeamIntrViewController.m
//  iSeed
//
//  Created by Chan Bill on 14/11/27.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import "TeamIntrViewController.h"
#import "Config.h"
@interface TeamIntrViewController ()
@property (strong, nonatomic) IBOutlet UILabel *kklabel;
@property (strong, nonatomic) IBOutlet UILabel *shdlabel;
@property (strong, nonatomic) IBOutlet UILabel *meililabel;
@property (strong, nonatomic) IBOutlet UILabel *HaiJ;

@end

@implementation TeamIntrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    //imageView.image = [UIImage imageNamed:@"homepagebackground1231.png"];
//    [imageView setImage:[UIImage imageNamed:MainViewImage]];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    [self.view addSubview:imageView];
    
    self.navigationItem.title = NSLocalizedStringFromTable(@"TeamIntrudece", @"MyLoaclization" , @"");
    _kklabel.text = NSLocalizedStringFromTable(@"TeamKKtext", @"MyLoaclization" , @"");
    _shdlabel.text = NSLocalizedStringFromTable(@"TeamShdtext", @"MyLoaclization" , @"");
    _meililabel.text = NSLocalizedStringFromTable(@"TeamMeilitext", @"MyLoaclization" , @"");
    _HaiJ.text = NSLocalizedStringFromTable(@"TeamHJtext", @"MyLoaclization" , @"");
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
