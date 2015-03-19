//
//  AppDelegate.m
//  iSeed
//
//  Created by elias kang on 14-11-25.
//  Copyright (c) 2014年 elias kang. All rights reserved.
//

#import "AppDelegate.h"
#import "XYAlertView.h"
#import "ViewController.h"
#import "HistoryViewController.h"
#import "RESideMenu.h"
#import "leftMenuViewController.h"
#import "Config.h"

#ifdef __OPTIMIZE__
# define NSLog(...) {}
#else
# define NSLog(...) NSLog(__VA_ARGS__)
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    //0127 ? *hisVC remove?
   
    RESideMenu *sideMenuViewController;
    NSUserDefaults * userDefaults;
    MainiSeedViewController *mainVC;
    NSString *appVersion;
}

@synthesize changeSinaWeiboNaviBGImageDelegate;
@synthesize isAppNeedUpdate;
@synthesize appUpdateURL;
-(void)initializeSharePlat
{
 //   添加新浪微博应用 注册网址 http://open.weibo.com
        [ShareSDK connectSinaWeiboWithAppKey:@"4171717212"
                                   appSecret:@"d66a52babfcd2b67a8a1ffad591c2a1a"
                                 redirectUri:@"http://www.vipose.com"];
//    http://www.sharesdk.cn
//    [ShareSDK connectSinaWeiboWithAppKey:@"4171717212"
//                               appSecret:@"d66a52babfcd2b67a8a1ffad591c2a1a"
//                             redirectUri:@""];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"4171717212"
                                appSecret:@"d66a52babfcd2b67a8a1ffad591c2a1a"
                              redirectUri:@"www.vipose.com"
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"1103869120"
                           appSecret:@"WZ7schnuk63iFUQY"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    [ShareSDK connectQQWithAppId:@"1103869120" qqApiCls:[QQApiInterface class]];
    
    
    
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wxed5ddff04beaf676"
                           appSecret:@"624aeb079654575b4f2d99f6d828857f"  //微信APPSecret
                           wechatCls:[WXApi class]];
}

-(void)shareSDKInit  //shareSDK的相关初始化
{
        [self initializeSharePlat];//分享平台初始化
        
       changeSinaWeiboNaviBGImageDelegate = [[AGViewDelegate alloc]init];
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

-(void)GetAppIdFromItunes
{
    //TODO 从网络获取版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSLog(@"当前APP版本为%@",appVersion);
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=956095195"]];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client postPath:nil parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        //系统自带JSON解析
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
       // NSLog(@"resultDic = %@",resultDic);
        //  NSString *NewVerson = [[resultDic objectForKey:@"results"] valueForKey:@"version"];
        //  NSLog(@"NewVersion = %@",NewVerson);
      //  NSLog(@"%@",resultDic);
        NSArray *infoArray = [resultDic objectForKey:@"results"];
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *latestVersion = [releaseInfo objectForKey:@"version"];
        appUpdateURL = [releaseInfo objectForKey:@"trackViewUrl"];
        
        NSLog(@"store = %@,local = %@",latestVersion,appVersion);
        
        if (![latestVersion isEqualToString:appVersion]) {
            NSLog(@"需要更新呢");
            XYAlertView *alert = [XYAlertView alertViewWithTitle:NSLocalizedStringFromTable(@"APPalret", @"MyLoaclization" , @"") message:NSLocalizedStringFromTable(@"APPNeedUpdate", @"MyLoaclization" , @"") buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"APPSure", @"MyLoaclization" , @""),  nil] afterDismiss:^(long buttonIndex) {
                
            }];
            [alert show];
            isAppNeedUpdate = YES;
        }
        else
        {
            isAppNeedUpdate = NO;
            NSLog(@"不需要更新");
            
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error.localizedDescription);
    }];
    
    
    
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    userDefaults = [NSUserDefaults standardUserDefaults];
    //注册shareSDK  appkey
    [ShareSDK registerApp:@"4f2fb2128acc"];
    [self shareSDKInit];
    isAppNeedUpdate = NO;
    [self GetAppIdFromItunes];
 //   [self Suitable];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
   // self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // Override point for customization after application launch.
      // sideMenuViewController.view.backgroundColor = [UIColor colorWithRed: 160.0/255 green: 160.0/255 blue: 160.0/255 alpha: 1.0f];
    
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil]];
    }
    
    //判断是否已经登录过
    NSLog(@"login = %@",[userDefaults objectForKey:USERDEFAULTS_LOGINSTATE]);
    if ([[userDefaults objectForKey:USERDEFAULTS_LOGINSTATE] isEqual:@"1"] ) {
        mainVC = [[MainiSeedViewController alloc]initWithNibName:@"MainiSeedViewController" bundle:nil];
        self.navController = [[UINavigationController alloc]initWithRootViewController:mainVC];
        leftMenuViewController *leftMenuVC = [[leftMenuViewController alloc]init ];
        [[UINavigationBar appearance] setBarTintColor:NAVIGATIONBAR_BACKCOLOR];
        [leftMenuVC givemeViewController:mainVC];
        sideMenuViewController = [[RESideMenu alloc]initWithContentViewController:self.navController leftMenuViewController:leftMenuVC rightMenuViewController:nil];
        sideMenuViewController.backgroundImage = [UIImage imageNamed:RidemenuImage];

        self.window.rootViewController = sideMenuViewController;
    }
    
    else {
        LoadingViewController *loadingview = [[LoadingViewController alloc] init];
        self.window.rootViewController = loadingview;
    }
    //self.window.backgroundColor = [UIColor whiteColor];
   // [self.window addSubview:self.navController.view];
    [self.window makeKeyAndVisible];
    return YES;
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    
    XYAlertView *alert = [XYAlertView alertViewWithTitle:nil message:notification.alertBody buttons:[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"APPKnow", @"MyLoaclization" , @""), nil] afterDismiss:^(long buttonIndex) {
        
    }];
    [alert show];

}


-(void)setsidemenu
{
    mainVC = [[MainiSeedViewController alloc]initWithNibName:@"MainiSeedViewController" bundle:nil];
    self.navController = [[UINavigationController alloc]initWithRootViewController:mainVC];
    leftMenuViewController *leftMenuVC = [[leftMenuViewController alloc]init ];
    [[UINavigationBar appearance] setBarTintColor:NAVIGATIONBAR_BACKCOLOR];
    [leftMenuVC givemeViewController:mainVC];
    sideMenuViewController = [[RESideMenu alloc]initWithContentViewController:self.navController leftMenuViewController:leftMenuVC rightMenuViewController:nil];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:RidemenuImage];
    self.window.rootViewController = sideMenuViewController;
}
-(void)setregist
{
    RegistViewController *registviewcontroller = [[RegistViewController alloc]init];
    self.window.rootViewController = registviewcontroller;
}

-(void)setlogin
{
    LoadingViewController *loadingview = [[LoadingViewController alloc]init];
    self.window.rootViewController = loadingview;

}
-(void)settworegist
{
    TwoRegistViewController *tworegist = [[TwoRegistViewController alloc]init];
    self.window.rootViewController = tworegist;

}


-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}
-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}
-(void)application:(UIApplication *)application didDecodeRestorableStateWithCoder:(NSCoder *)coder
{
//    float lastVer = [coder decodeFloatForKey:@"Version"];
//    NSLog(@"lastVer = %f",lastVer);
}
-(void)application:(UIApplication *)application willEncodeRestorableStateWithCoder:(NSCoder *)coder
{
//    [coder encodeFloat:2.0 forKey:@"Version"];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.vipose.ISeed.iSeed" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iSeed" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iSeed.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
