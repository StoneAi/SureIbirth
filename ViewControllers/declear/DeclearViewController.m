//
//  DeclearViewController.m
//  iSeed
//
//  Created by Chan Bill on 14/11/27.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import "DeclearViewController.h"

@interface DeclearViewController ()

@end

@implementation DeclearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStringFromTable(@"tittleLabel_ServicesOrderVC_Text", @"MyLoaclization" , @"");
    UITextView *mytextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 60, 320, 508)];
    
    
    mytextView.editable=NO;
    // Do any additional setup after loading the view from its nib.
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineHeightMultiple = 20.f;
    paragraphStyle.maximumLineHeight = 25.f;
    paragraphStyle.minimumLineHeight = 15.f;
    paragraphStyle.firstLineHeadIndent = 20.f;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor colorWithRed:76./255. green:75./255. blue:71./255. alpha:1]
                                  };
    NSString *content = NSLocalizedStringFromTable(@"serviceOrderTextView_ServicesOrderVC_Text", @"MyLoaclization" , @"");
    mytextView.attributedText = [[NSAttributedString alloc]initWithString:content attributes:attributes];
    [self.view addSubview:mytextView];
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
