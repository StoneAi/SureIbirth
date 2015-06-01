//
//  leftMenuViewController.h
//  iSeed
//
//  Created by Chan Bill on 14/12/16.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "SettingTableViewController.h"
#import "HistoryViewController.h"
#import "RtHistoryViewController.h"
#import "RESideMenu.h"
#import "InforViewController.h"
#import "SpHistoryViewController.h"
@interface leftMenuViewController : UIViewController< UITableViewDataSource, UITableViewDelegate,InforViewControllerDelegate,HistoryViewControllerDelegate,SettingTableViewControllerDelegate,RtHistoryViewControllerDelegate,SpHistoryViewControllerDelegate>
{
    sqlite3 *db;
}


-(void)givemeViewController:(MainiSeedViewController*) simpleVC;

@property (strong,nonatomic) UILabel *name;
@end
