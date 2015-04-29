//
//  HistoryViewController.h
//  iSeed
//
//  Created by Chan Bill on 14/11/27.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "FLDemoView.h"
#import "SnapView.h"
#import "BLEdebug.h"
#import "SerndView.h"
#import "Sntmp.h"
#import "RESideMenu.h"
#import "FVCustomAlertView.h"
#import "PMCalendar.h"
@protocol HistoryViewControllerDelegate
-(NSInteger )getblestate;
-(void)readhistory;
@end
@interface HistoryViewController : UIViewController<UIScrollViewDelegate,PMCalendarControllerDelegate>
{
NSObject<HistoryViewControllerDelegate> * delegate;
}
typedef enum
{
    Default = 0,
    Face = 1
    
}Type;
-(id)init:(Type)type;
@property(nonatomic, retain) NSObject<HistoryViewControllerDelegate> * delegate;
@property (nonatomic, strong) PMCalendarController *pmCC;
@property (strong, nonatomic) UIScrollView *pageview;
@property (strong, nonatomic) NSArray *pageContent;
@property (nonatomic,strong) PMPeriod *mynewPeriod;
@property (assign,nonatomic) int lv1;
@property (assign,nonatomic) int lv2;
@property (assign,nonatomic) int lv3;
@property (assign,nonatomic) int lv4;
@property (assign,nonatomic) int lv5;
@property (assign,nonatomic) float lv1steps;
@property (assign,nonatomic) float lv2steps;
@property (assign,nonatomic) float lv3steps;
@property (assign,nonatomic) int lv4steps;
@property (assign,nonatomic) int lv5steps;
@property (assign,nonatomic)  long rtlength;
@property (assign,nonatomic)   long steplength;
@property (assign,nonatomic) int state;
@end
