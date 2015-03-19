//
//  TeamIntrViewController.m
//  iSeed
//
//  Created by Chan Bill on 14/11/27.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import "TeamIntrViewController.h"

@interface TeamIntrViewController ()
@property (strong, nonatomic) IBOutlet UILabel *kklabel;
@property (strong, nonatomic) IBOutlet UILabel *shdlabel;
@property (strong, nonatomic) IBOutlet UILabel *meililabel;

@end

@implementation TeamIntrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStringFromTable(@"TeamIntrudece", @"MyLoaclization" , @"");
    _kklabel.text = NSLocalizedStringFromTable(@"TeamKKtext", @"MyLoaclization" , @"");
    _shdlabel.text = NSLocalizedStringFromTable(@"TeamShdtext", @"MyLoaclization" , @"");
    _meililabel.text = NSLocalizedStringFromTable(@"TeamMeilitext", @"MyLoaclization" , @"");
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
