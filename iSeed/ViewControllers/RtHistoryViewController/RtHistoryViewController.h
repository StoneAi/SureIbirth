//
//  RtHistoryViewController.h
//  iSeed
//
//  Created by Nico on 15/5/6.
//  Copyright (c) 2015年 elias kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhuView.h"
#import "Config.h"
#import "XYAlertViewHeader.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "FVCustomAlertView.h"
#import "PMCalendar.h"
@protocol RtHistoryViewControllerDelegate
-(NSInteger )getblestate;
-(void)blehistory;

@end

@interface RtHistoryViewController : UIViewController<PMCalendarControllerDelegate>
{
NSObject<RtHistoryViewControllerDelegate> * delegate;
}
@property(nonatomic, retain) NSObject<RtHistoryViewControllerDelegate> * delegate;
@property (weak, nonatomic) IBOutlet ZhuView *Myzhuview;

@property (weak, nonatomic) IBOutlet UILabel *Statelabel;
//@property (weak, nonatomic) IBOutlet UILabel *Zhishulabel;
@property (weak, nonatomic) IBOutlet UILabel *Dbmlabel;
@property (weak, nonatomic) IBOutlet UILabel *Nodatalabel;
@property (weak, nonatomic) IBOutlet UIButton *Sync1Button;
@property (weak, nonatomic) IBOutlet UILabel *Danweilabel;
- (IBAction)SyncButton:(id)sender;
@property (nonatomic, strong) PMCalendarController *pmCC;
@end
