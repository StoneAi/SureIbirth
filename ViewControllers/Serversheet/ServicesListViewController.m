//
//  ServicesOrderViewController.m
//  iTemperature
//
//  Created by haotian on 14-8-8.
//  Copyright (c) 2014年 Baseus. All rights reserved.
//

#import "ServicesListViewController.h"

@interface ServicesListViewController ()
@property (weak, nonatomic) IBOutlet UIView *topVIew;
- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;

@end

@implementation ServicesListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedStringFromTable(@"tittleLabel_ServicesListVC_Text", @"MyLoaclization" , @"");
    [_topVIew setBackgroundColor:[UIColor colorWithRed:0.18 green:0.78 blue:0.78 alpha:1.0]];
    _tittleLabel.text = NSLocalizedStringFromTable(@"tittleLabel_ServicesListVC_Text", @"MyLoaclization" , @"");
    [self servicesOrderInit];
}

/**
 *  免责声明的初始化：文本格式，行间距，颜色等
 */
-(void)servicesOrderInit
{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineHeightMultiple = 20.f;
    paragraphStyle.maximumLineHeight = 25.f;
    paragraphStyle.minimumLineHeight = 15.f;
    paragraphStyle.firstLineHeadIndent = 20.f;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor colorWithRed:76./255. green:75./255. blue:71./255. alpha:1]
                                  };
    NSString *content = NSLocalizedStringFromTable(@"servicesListTextView_ServicesListVC_Text", @"MyLoaclization" , @"");
    _textView.attributedText = [[NSAttributedString alloc]initWithString:content attributes:attributes];
    
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"servicesList1" ofType:@"txt"];
//    //NSString *myFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/servicesList.txt"];
//    NSString *contends = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"myfilestring === %@",path);
//    NSLog(@"myfileString === %@",contends);
//   // _textView.text = [[NSString alloc]initWithContentsOfFile:path];
//    _textView.attributedText = [[NSAttributedString alloc]initWithString:contends attributes:attributes];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonAction:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)dealloc
{
    _textView.text = nil;
}
@end
