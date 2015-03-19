//
//  Config.h
//  Simple_demo
//
//  Created by Chan Bill on 14/11/25.
//  Copyright (c) 2014年 Viposes. All rights reserved.
//

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
#define NAVIGATIONBAR_BACKCOLOR   [UIColor colorWithRed: 240.0/255 green: 146.0/255 blue: 174.0/255 alpha: 1.0f]     //导航栏视图颜色
#define TABLEVIEWCOLOR   [UIColor colorWithRed: 255.0/255 green: 111.0/255 blue: 132.0/255 alpha: 0]                //表图视图颜色
#define CELLBACKCOLOR      [UIColor colorWithRed: 255.0/255 green: 111.0/255 blue: 132.0/255 alpha: 0]              //表图单元颜色
#define CELLTEXTLABELHIGHTCOLOR    [UIColor colorWithRed: 131.0/255 green: 204.0/255 blue: 210.0/255 alpha: 1]       //单元高亮颜色
//modify 1204
#define CELLSELECTCOLOR    [UIColor colorWithRed: 240.0/255 green: 146.0/255 blue: 174.0/255 alpha: 1.0f]            //选中单元背景颜色
#define CELLBACKCOLOR_SETTING       [UIColor colorWithRed: 255.0/255 green: 111.0/255 blue: 132.0/255 alpha: 1.0f]   //设置单元颜色


#pragma mark  大小区

#define UIVIEW_SIZE    (0, 0, 320, 700)                     //用户界面大小
#define NAVIGATIONBAR_SIZE    (0, 20, 320, 40)              //导航栏大小位置
#define MAINVIEWTABLEVIEW_SIZE    (0, 0, 320, 240)         //主界面表图大小位置
#define HIGHFORCELL_MAINVIEW     40                         //主界面单元高度
#define SETTINGTABLEVIEW_SIZE    (0, 0, 320, 450)          //设置界面表图大小位置
#define HIGHFORCELL_SETTINGVIEW     40                      //设置界面单元高度
#define FIRSTVIEWTABLEVIEW_SIZE   (0, 0, 320, 170)          //首页单元高度

#pragma mark    表图成员

#define MAINVIEWTABLECELL     [NSArray arrayWithObjects:@"首页",@"历史",@"推荐",@"设置", nil]                   //主界面表图成员

#define SETTINGVIEWTABLECELL     [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"手环电量",@"振动开关",nil],@" " ,[NSArray arrayWithObjects:@"帮助",@"联系我们",@"版本更新",@"免责申明",@"团队介绍", nil],@"  ",nil]                                                    //设置表图成员
#pragma mark 主视图
#define rightbutton @"断开连接"
#define circle_size (40, 90, 240, 240)
#define circle_label @"请点击连接设备"
#define centrlbutton_size (40, 163, 240, 240)
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

#define RidemenuImage @"background0309.png"

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

#define InforDeHeadImage @"head portrait120.png"
#define InforBackImage @"backgroundtwo1230.png"
#define InforSaveImage @"save1227.png"


#define LeftHomeImage @ "homepageblue0309.png"   //homepageblue0309
#define LeftHomeHighImage @"homepage1227.png"
#define LeftHistoryImage @ "historyblue0309.png"   //historyblue0309
#define LeftHistoryHighImage @"history1227.png"
#define LeftRecomImage @ "recommendblue0309.png"   //recommendblue0309
#define LeftRecomHigeImage @ "recommend1227.png"
#define LeftSettingImage @ "setblue0309.png"   //setblue0309
#define LeftSettingHighImage @ "set1227.png"

#define HelpImage @"help0104.png"

#define MainViewImage @"首页背景0309.png"
#define MainViewShareImage @"share0309"

#define RegistOneReImage @"btn_arrow_back.png"

#define SettingCancaleImage @"矩形2.png"
#define SettingBatteryImage @ "batteryblue0309.png"
#define SettingShakeImage @ "shakeblue0309.png"
#define SettingHelpImage @ "helpblue0309.png" //helpblue0309
#define SettingHelpHighImage @ "help1205.png"
#define SettingRelationImage @ "relationblue0309.png"   //relationblue0309
#define SettingRelationHighImage @"relation1205.png"
#define SettingStatementImage @ "statementblue0309.png"   //statementblue0309
#define SettingStatementHighImage @"statement1205.png"
#define SettingIntroImage @"introductionblue0309.png"    //introductionblue0309
#define SettingIntroHighImage @"introduction1227.png"
#define SettingUpdateImage @ "refresh1226.png"
#define SettingUpdateHighImage @ "refreshgreen1231.png"

#define ConnectLogeImage @"pic_logo_bg.png"
#define ConnectCallImage @"btn_call_default.png"
#define ConnectCallHighImage @"btn_call_selcet.png"
#define ConnectEmailImage @"btn_email.png"
#define ConnectEmailHighImage @"btn_email_select.png"

#define LoginLogo @"登录注册(1)"
#define LoginzhuceImage @"注册0309.png"
#define LoginlogImage @"登录0309.png"
#define LoginEditerImage @"账号0309.png"

#endif
