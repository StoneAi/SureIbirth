//
//  TwoRegistViewController.h
//  iSeed
//
//  Created by Chan Bill on 15/1/9.
//  Copyright (c) 2015年 elias kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "FVCustomAlertView.h"
#import "XYAlertViewHeader.h"
#import "Config.h"
#import "AFNetworkReachabilityManager.h"
@interface TwoRegistViewController : UIViewController<UITextFieldDelegate>
{
sqlite3 *db;
}
@end
