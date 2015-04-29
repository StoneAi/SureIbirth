//
//  LoadingViewController.h
//  iSeed
//
//  Created by Chan Bill on 15/1/8.
//  Copyright (c) 2015年 elias kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "XYAlertViewHeader.h"
#import "FVCustomAlertView.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "ForgetpswViewController.h"
#import "Config.h"
#import <sqlite3.h>
@interface LoadingViewController : UIViewController<UITextFieldDelegate>
{
    sqlite3*db;
}
@end
