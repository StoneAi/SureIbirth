//
//  InforViewController.h
//  iSeed
//
//  Created by Chan Bill on 14/12/16.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"
#import "ZHPickView.h"
#import "XYAlertViewHeader.h"
#import <sqlite3.h>
#import "Config.h"
#import "AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
@protocol InforViewControllerDelegate
-(void)givemename:(NSString *)name;
-(void)givemeimage:(UIImage *)image;

@end
@interface InforViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ZHPickViewDelegate>
{
     NSObject<InforViewControllerDelegate> * delegate;
    sqlite3 *db;
}

@property(nonatomic, retain) NSObject<InforViewControllerDelegate> * delegate;
@property (strong, nonatomic) UIButton *imagev;
@property (strong, nonatomic)  UIView *serndview;
@property (strong, nonatomic) UITableView *tableview;
@property (strong,nonatomic) TableViewCell *cell;

@end
