//
//  Config.h
//  Simple_demo
//
//  Created by Chan Bill on 14/11/25.
//  Copyright (c) 2014年 Viposes. All rights reserved.
//

#ifdef __OPTIMIZE__
# define NSLog(...) {}
#else
# define NSLog(...) NSLog(__VA_ARGS__)
#endif
#ifndef Simple_demo_Config_h
#define Simple_demo_Config_h

#define USERDEFAULTS_USERNAME   @"usrname"
#define USERDEFAULTS_PASSWD     @"passwd"
#define USERDEFAULTS_LOGINSTATE    @"alreadylogin"
#define USERDEFAULTS_NAME   @"name"
#define USERDEFAULTS_AGE    @"age"
#define USERDEFAULTS_BIRTH  @"birth"
#define USERDEFAULTS_WEIGHT @"weight"
#define USERDEFAULTS_HIGH   @"high"
#define USERDEFAULTS_LASTTIMEREFRESH @"lastrefresh"
#define USERDEFAULTS_BLENAME @"blename"
#define USERDEFAULTS_SHANKE  @"shankeopen"
#define USERDEFAULTS_BLESTATE   @"blestate"
#define USERDEFAULTS_SENDTOWEB    @"sendToWeb"
#define USERDEFAULTS_BATTRY    @"battry"


#define DBNAME    @"personinfo.sqlite"
#define NAME @"name"
#define AGE @"age"
#define BIRTH     @"birth"
#define WEIGHT  @"weight"
#define HIGH    @"high"
#define TABLENAME   @"INFORPERSONN"

#pragma mark 颜色区

//#define VIEWBACKCOLOR     [UIColor colorWithRed: 86.0/255 green: 189.0/255 blue: 240.0/255 alpha: 1.0]
//#define VIEWBACKCOLOR     [UIColor colorWithRed: 255.0/255 green: 111.0/255 blue: 132.0/255 alpha: 0.5]             //视图全局颜色
//modify 1204
#define VIEWBACKCOLOR     [UIColor colorWithRed: 122.0/255 green: 122.0/255 blue: 122.0/255 alpha: 1.0]             //视图全局颜色
#define NAVIGATIONBAR_BACKCOLOR   [UIColor colorWithRed: 72.0/255 green: 193.0/255 blue: 201.0/255 alpha: 1.0f]     //导航栏视图颜色 [UIColor colorWithRed: 240.0/255 green: 146.0/255 blue: 174.0/255 alpha: 1.0f]
#define TABLEVIEWCOLOR   [UIColor colorWithRed: 255.0/255 green: 111.0/255 blue: 132.0/255 alpha: 0]                //表图视图颜色
//TODO elias
#define CELLTEXTLABELHIGHTCOLOR    [UIColor whiteColor]       //单元字体颜色 [UIColor colorWithRed: 117.0/255 green: 193.0/255 blue: 199.0/255 alpha: 1]
#define SETCELLTEXTLABELCOLOR     [UIColor blackColor]
//modify 1204
//TODO elias
#define CELLSELECTCOLOR    [UIColor colorWithRed: 20.0/255 green: 153.0/255 blue: 155.0/255 alpha: 1.0f]            //选中单元整个背景颜色 [UIColor colorWithRed: 240.0/255 green: 146.0/255 blue: 174.0/255 alpha: 1.0f]
#define CELLNOMARLCOLOR [UIColor whiteColor]   //单元字体高亮颜色

#define CircleTextColor [UIColor colorWithRed:165.0/255 green:175.0/255 blue:176.0/255 alpha:1]  //环中字体颜色

//#define CELLBACKCOLOR_SETTING       [UIColor colorWithRed: 255.0/255 green: 111.0/255 blue: 132.0/255 alpha: 1.0f]   //设置中单元颜色

//#define CELLBACKCOLOR      [UIColor colorWithRed: 255.0/255 green: 111.0/255 blue: 132.0/255 alpha: 0]              //表图单元颜色

#pragma mark  大小区

#define UIVIEW_SIZE    (0, 0, 320, 700)                     //用户界面大小
#define NAVIGATIONBAR_SIZE    (0, 20, 320, 40)              //导航栏大小位置
#define MAINVIEWTABLEVIEW_SIZE    (0, 0, 320, 240)         //主界面表图大小位置
#define HIGHFORCELL_MAINVIEW     40                         //主界面单元高度
#define SETTINGTABLEVIEW_SIZE    (0, 0, 320, 550)          //设置界面表图大小位置
#define HIGHFORCELL_SETTINGVIEW     40                      //设置界面单元高度
#define FIRSTVIEWTABLEVIEW_SIZE   (0, 0, 320, 170)          //首页单元高度

#pragma mark    表图成员

#define MAINVIEWTABLECELL     [NSArray arrayWithObjects:@"首页",@"历史",@"推荐",@"设置", nil]                   //主界面表图成员

#define SETTINGVIEWTABLECELL     [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"手环电量",@"振动开关",nil],@" " ,[NSArray arrayWithObjects:@"帮助",@"联系我们",@"版本更新",@"免责申明",@"团队介绍", nil],@"  ",nil]                                                    //设置表图成员
#pragma mark 主视图
#define rightbutton @"断开连接"
#define circle_size (40, 90, 240, 240)
#define circle_label @"请点击连接设备"
#define centrlbutton_size (40, 163, 240, 220)
#define refreshbutton_size (260 , 100, 50, 50)
#define refreshbutton_title @"刷新"
#define alertview_title @"请确认是否更新"
#define alertview_message @"获取手镯历史数据时间较长"
#define loadingview_title @"历史数据更新中"

#pragma mark 蓝牙
#define rthistory_path @"rthistoryfile"
#define stephistory_path @"stepshistoryfile"
#define currentRTget {0xAA,0x01,0x23,0x00}   //实时辐射数据指令
#define RTHISTORYGET {0xAA,0x01,0x40,0x00}   //历史数据获得总长度指令
#define STEPHISTORYGET {0xAA,0x01,0x44,0x00} //运动数据获得总长指令

#pragma mark 历史
#define history_title @"历史"
#define navigtion_leftbimage @"menu1202.png"
#define HISalertview_title @"请同步数据"
#define HISalertview_message @"请先进行数据同步"
#define HISalertview_button @"知道了"


#define HISFIRSTCIRCLE_POSITION 100, 270
#define HISSERCNRCIRCLE_POSTION 220, 160
#define HISTHIRDCIRCLE_POSTION 30, 400
#define HISFOURTHCIRCLE_POSTION 100, 160
#define HISFIFTHCIRCLE_POSTION 170, 400

#define HISRTsafe @"安全"
#define HISRTsafer @"较安全"
#define HISRTcentra @"中等"
#define HISRTdangerer @"较危险"
#define HISRTdanger @"危险"
#define HISRTNONUM @"暂时没有数据"


#define SPHISFIRSTCIRCLE_POSITION 100, 270
#define SPHISSERCNRCIRCLE_POSTION 220, 160
#define SPHISTHIRDCIRCLE_POSTION 30, 400
#define SPHISFOURTHCIRCLE_POSTION 100, 160
#define SPHISFIFTHCIRCLE_POSTION 170, 400

#define HISSPsafe @"安全"
#define HISSPsafer @"较安全"
#define HISSPcentra @"中等"
#define HISSPdangerer @"较危险"
#define HISSPdanger @"危险"
#define HISSPNONUM @"暂时没有数据"


#pragma mark  png资源
#define RidemenuButtonImage @"menubar1227.png"
#define ShareSDKImage @"icon.png"

//TODO elias
#define RidemenuImage @"mainview0505.png" //#define RidemenuImage @"首页背景0309.png"

#define HisNodataImage  @"histroycircle1231.png"
#define HisBackImage  @"首页背景0309.png"
#define HisRTImage @"辐射button0309.png"
#define HisStepImage @"计步button0309.png"
#define HisButtonBackImage @"circle0309gai.png"
#define HisSafe @"大笑0309.png"
#define HisSafer @"微笑0309.png"
#define HisCenter @"担心0309.png"
#define HisDanger @"害怕0309.png"
#define HisDangerest @"大哭0309.png"

//TODO elias
#define InforDeHeadImage @"B0505.png" // 头像2-0327.png
#define InforBackImage @"mainview0505.png"
#define InforSaveImage @"save0320.png"

//TODO elias
#define LeftHomeImage @ "Wind_Cone0505.png"   //homepageblue0309 homepageblue0327.png
#define LeftHomeHighImage @"homepage1227.png"
#define LeftHistoryImage @ "historyblue0327改.png"   //historyblue0309
#define LeftHistoryHighImage @"history1227.png"

#define LeftRecomImage @ "Out0505.png"   //recommendblue0309 Out0505.png recommendblue0327.png
#define LeftRecomHigeImage @ "recommend1227.png"
#define LeftSettingImage @ "Settings_Alt0505.png"   //setblue0309 setblue0327.png
#define LeftSettingHighImage @ "set1227.png"

#define HelpImage @"help0104.png"

#define MainViewImage @"首页背景0309.png"
#define MainViewShareImage @"share0309"

#define RegistOneReImage @"btn_arrow_back.png"

#define SettingCancaleImage @"矩形2.png"
//TODO elias
#define SettingBatteryImage @ "battery0505.png"  //battery0327改.png
#define SettingShakeImage @ "viberation0505.png"  //shake0327.png
#define SettingHelpImage @ "helpblue0327.png" //helpblue0309
#define SettingHelpHighImage @ "help1205.png"
#define SettingRelationImage @ "Phone0505.png"   //relationblue0309  relationblue0327.png
#define SettingRelationHighImage @"relation1205.png"
#define SettingStatementImage @ "Ribbon0505.png"   //statementblue0309  statementblue0327.png
#define SettingStatementHighImage @"statement1205.png"
#define SettingIntroImage @"introductionblue0327.png"    //introductionblue0309
#define SettingIntroHighImage @"introduction1227.png"
#define SettingUpdateImage @ "refresh1226.png"
#define SettingUpdateHighImage @ "refreshblue0327.png"
#define SettingUserBookimage @"Book0505.png"   // notebook0327.png
#define SettingUserBookHighimage @"notebook0320.png"
#define SettingBackground @"设置背景.png"



#define ConnectLogeImage @"viposelogo.png"
#define ConnectCallImage @"btn_call.png"
#define ConnectCallHighImage @"btn_call.png"
#define ConnectEmailImage @"btn_email.png"
#define ConnectEmailHighImage @"btn_email.png"
#define ConnectUrlImage @"btn_URL.png"


#define LoginNickname @"输入账号0320.png"
#define LoginPasswd @"密码0320.png"
#define LoginLogo @"loginibs.png"
#define LoginzhuceImage @"注册0309.png"
#define LoginlogImage @"btn_sync0507.png"
#define LoginEditerImage @"账号0309.png"


#define CurrentDeviceRealSize [[[UIScreen mainScreen] currentMode] size]
#define iPhone4RealSize CGSizeMake(640, 960)
#define iPhone4 CGSizeEqualToSize(iPhone4RealSize, CurrentDeviceRealSize)
#define Height iPhone4 ? 64 : 0


#endif
