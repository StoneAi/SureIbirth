//
//  ThreeRegistViewController.h
//  iSeed
//
//  Created by Chan Bill on 15/3/20.
//  Copyright (c) 2015年 elias kang. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "FVCustomAlertView.h"
#import "XYAlertViewHeader.h"
#import "Config.h"
#import "AFNetworkReachabilityManager.h"
@interface ThreeRegistViewController : UIViewController<UITextFieldDelegate>
{

sqlite3 *db;
}

@end
