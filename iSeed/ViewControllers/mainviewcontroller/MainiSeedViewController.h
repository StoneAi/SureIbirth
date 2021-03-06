//
//  MainiSeedViewController.h
//  iSeed
//
//  Created by elias kang on 14-11-26.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import <sqlite3.h>
#import "EKCustomProgressView.h"
#import "EKCustomProgressTheme.h"
#import "EKCustomProgressLabel.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEdebug.h"
#import "FLDemoView.h"
#import "SnapView.h"
#import "SerndView.h"
#import "HistoryViewController.h"
#import "FVCustomAlertView.h"
#import "AFNetworking.h"


@interface MainiSeedViewController : UIViewController<CBCentralManagerDelegate,BLEdebugDelegate,UIAlertViewDelegate>
{
  sqlite3 *db;
}

-(void)blehistory;
-(void)WarmingON;
-(void)WarmingOFF;
-(void)disconnectBle;
-(int)readbat;
- (IBAction)RadiationButton:(id)sender;
- (IBAction)WalkButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *DateLabel;
@property (strong,nonatomic) CBCentralManager *my;
@property (assign,nonatomic)  int state;
@property (strong,nonatomic) EKCustomProgressView *customview;
@property (strong,nonatomic) UILabel *connectlabel;
@property (strong,nonatomic) UIButton *animatbutton;
@property (strong,nonatomic) UIButton *refreshbutton;
@property (assign,nonatomic) NSInteger blesta;
@property (strong,nonatomic) UILabel *DbmLable;
@property (strong, nonatomic) IBOutlet UILabel *belowrauplabel;
@property (strong, nonatomic) IBOutlet UILabel *belowrabelowlable;
@property (strong, nonatomic) IBOutlet UILabel *belowstepuplab;
@property (strong, nonatomic) IBOutlet UILabel *belowstepbelowlab;

//@property (strong,nonatomic) EKCustomProgressLabel *lable;

@end


