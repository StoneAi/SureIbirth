//
//  ServiceNet.h
//  iSeed
//
//  Created by Chan Bill on 15/3/30.
//  Copyright (c) 2015年 elias kang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol ServiceDelegate
-(void)PostResult:(NSMutableDictionary *)result;
-(void)GetResult:(NSMutableDictionary *)result;

@end

@interface ServiceNet : NSObject
@property id<ServiceDelegate> delegate;
typedef enum
{
    PhoneRegistCheck = 0,
    PhoneForgetCheck = 1,
    EmailRegistCheck = 2,
    EmailForgetCheck = 3,
    Didregist = 4,
    DidLogin = 5,
    CreatePregantInfo = 6,
    UpdatePregantInfo = 7,
    ChangePasswd = 8
    
}Posttype;


typedef enum
{
    PregantInfoGet = 0,
    HeadPhotoGet = 1,
    IosAppversion = 2,
    FirmwareGet = 3
    
}Gettype;



-(void)getCom:(Gettype)type;
-(void)PostCom:(Posttype)type postInfo:(NSMutableDictionary *)info;
-(void)HeadPhotoSendService:(NSData *)data; 
-(void)RTsendtoService:(NSData *)data name:(NSString *)name;
-(void)SPsendtoService:(NSData *)data name:(NSString *)name;
@end
