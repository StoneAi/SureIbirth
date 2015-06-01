//
//  SpHistoryViewController.h
//  iSeed
//
//  Created by Nico on 15/5/8.
//  Copyright (c) 2015年 elias kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "XYAlertViewHeader.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "FVCustomAlertView.h"
#import "PMCalendar.h"
@protocol SpHistoryViewControllerDelegate
-(NSInteger )getblestate;
-(void)blehistory;

@end



@interface SpHistoryViewController : UIViewController<PMCalendarControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *stepslabel;
@property (weak, nonatomic) IBOutlet UILabel *miterlabel;
@property (nonatomic, strong) PMCalendarController *pmCC;
@property(nonatomic, retain) NSObject<SpHistoryViewControllerDelegate> * delegate;
@property (weak, nonatomic) IBOutlet UILabel *Nodatalabel;
@property (weak, nonatomic) IBOutlet UIButton *SyncButton;
@property (assign,nonatomic) float lv1steps;
- (IBAction)Sync:(id)sender;
@property (assign,nonatomic) float lv2steps;
@property (weak, nonatomic) IBOutlet UIView *AllprogressView;
@property (assign,nonatomic) float lv3steps;
@property (weak, nonatomic) IBOutlet UIView *precessView;
@property (weak, nonatomic) IBOutlet UILabel *CalorieLabel;

@end
