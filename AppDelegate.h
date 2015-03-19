//
//  AppDelegate.h
//  iSeed
//
//  Created by elias kang on 14-11-25.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Config.h"
#import "MainiSeedViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "AGViewDelegate.h"
#import "WeiboSDK.h"
#import "leftMenuViewController.h"
#import "LoadingViewController.h"
#import "RegistViewController.h"
#import "TwoRegistViewController.h"

#define AppDelegateAccessor ((AppDelegate *)[[UIApplication sharedApplication] delegate])
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic)BOOL  isAppNeedUpdate;//是否有软件需要更新
@property (nonatomic) NSString *appUpdateURL; //需要更新的地址
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UINavigationController *navController;

//改变新浪微博分享导航栏背景的代理
@property (strong, nonatomic) AGViewDelegate *changeSinaWeiboNaviBGImageDelegate;
-(void)setsidemenu;
-(void)setregist;
-(void)setlogin;
-(void)settworegist;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

