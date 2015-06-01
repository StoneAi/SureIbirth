//
//  DeclearViewController.m
//  iSeed
//
//  Created by Chan Bill on 14/11/27.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import "DeclearViewController.h"
#import "Config.h"
@interface DeclearViewController ()

@end

@implementation DeclearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStringFromTable(@"tittleLabel_ServicesOrderVC_Text", @"MyLoaclization" , @"");
    UITextView *mytextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 60, 300, 508)];
    
    //TODO elias
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    //imageView.image = [UIImage imageNamed:@"homepagebackground1231.png"];
//    [imageView setImage:[UIImage imageNamed:MainViewImage]];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    [self.view addSubview:imageView];
    
    mytextView.editable=NO;
    // Do any additional setup after loading the view from its nib.
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineHeightMultiple = 20.f;
    paragraphStyle.maximumLineHeight = 25.f;
    paragraphStyle.minimumLineHeight = 15.f;
    paragraphStyle.firstLineHeadIndent = 20.f;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor colorWithRed:76./255. green:75./255. blue:71./255. alpha:1]
                                  };
    NSString *content = NSLocalizedStringFromTable(@"serviceOrderTextView_ServicesOrderVC_Text", @"MyLoaclization" , @"");
    mytextView.attributedText = [[NSAttributedString alloc]initWithString:content attributes:attributes];
    [self.view addSubview:mytextView];
    mytextView.backgroundColor = [UIColor clearColor];
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
