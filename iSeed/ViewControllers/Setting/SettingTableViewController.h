//
//  SettingTableViewController.h
//  iSeed
//
//  Created by Chan Bill on 14/11/27.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainiSeedViewController.h"
#import "HelpViewController.h"
#import "DeclearViewController.h"
#import "TeamIntrViewController.h"
#import "UpdataViewController.h"
#import "ConnectViewController.h"
#import "XYAlertView.h"

//#import "AppDelegate.h"
@protocol SettingTableViewControllerDelegate
-(NSInteger )getblestate;
-(void)Wariming:(int)warning;
-(void)disconnectble;
-(void)cancleview;
@end


@interface SettingTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationBarDelegate>
{
    NSObject<SettingTableViewControllerDelegate> * delegate;
}


@property(nonatomic, retain) NSObject<SettingTableViewControllerDelegate> * delegate;

@end
