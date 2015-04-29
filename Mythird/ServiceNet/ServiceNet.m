//
//  ServiceNet.m
//  iSeed
//
//  Created by Chan Bill on 15/3/30.
//  Copyright (c) 2015年 elias kang. All rights reserved.
//

#import "ServiceNet.h"


#define BaseURL @"http://120.24.237.180:8080/PregnantHealth"
#define PhoneCheck @"sendCaptchaByCellphone.jsp"
#define EmailCheck @"sendCaptchaByEmail.jsp"
#define Regist @"register.jsp"
#define Login @"login.jsp"
#define APPversion @"getIOSVersion.jsp"
#define FirmwareVersion @"getFirmware.jsp"
#define ChangePwd @"changePasswd.jsp"


#define CreatePregant @"createGravidaInfo.jsp"
#define UpdatePregant @"updateGravidaInfo.jsp"
#define GetPregant @"getGravidaInfo.jsp"
#define SendHeadPhoto @"uploadHeadPhoto.jsp"
#define GetHeadPhoto @"getHeadPhoto.jsp"



#define RTSendHistory @"uploadRadiationFile.jsp"
#define SPSendHistory @"uploadCalorieFile.jsp"






@implementation ServiceNet
{
    AFHTTPClient *httpClient;
    NSURL * url;
    NSMutableDictionary *resultDic;
    NSUserDefaults *user;
}




-(id)init
{
    url = [NSURL URLWithString:BaseURL];
    httpClient  = [[AFHTTPClient alloc] initWithBaseURL:url];
    resultDic = [[NSMutableDictionary alloc]init];
    user = [NSUserDefaults standardUserDefaults];
    return self;
}


-(void)PostCom:(Posttype)type postInfo:(NSMutableDictionary *)info
{
    [resultDic setObject:[NSString stringWithFormat:@"%u",type] forKey:@"type"];
    switch (type) {
        case 0:
            [info setObject:@"1" forKey:@"type"];
            [self postHttpUrl:PhoneCheck postInfo:info state:0];
            break;
        case 1:
            [info setObject:@"2" forKey:@"type"];
            [self postHttpUrl:PhoneCheck postInfo:info state:0];
            break;
        case 2:
            [info setObject:@"1" forKey:@"type"];
            [self postHttpUrl:EmailCheck postInfo:info state:0];
            break;
        case 3:
            [info setObject:@"2" forKey:@"type"];
            [self postHttpUrl:EmailCheck postInfo:info state:0];
            break;
        case 4:
            [self postHttpUrl:Regist postInfo:info state:0];
            break;
        case 5:
            [self postHttpUrl:Login postInfo:info state:0];
            break;
        case 6:
            [self postHttpUrl:CreatePregant postInfo:info state:1];
            break;
        case 7:
            [self postHttpUrl:UpdatePregant postInfo:info state:1];
            break;
        case 8:
            [self postHttpUrl:ChangePwd postInfo:info state:0];
            break;
            
        default:
            break;
    }



}


- (void)postHttpUrl:(NSString *)urlString postInfo:(NSDictionary *)info state:(NSInteger)state

{
    if (state==1) {
        
        NSDictionary *logininfo = [[NSDictionary alloc] init];
        [logininfo setValue:[user objectForKey:@"usrname"] forKey:@"account"];
        [logininfo setValue:[user objectForKey:@"passwd"] forKey:@"password"];
    
        [httpClient postPath:Login parameters:logininfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *requestTmp = [NSString stringWithString:operation.responseString];
            NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
            //系统自带JSON解析
            resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
            if ([[resultDic objectForKey:@"result"]isEqual:@"true"]) {
                
                [httpClient postPath:urlString parameters:info success:^(AFHTTPRequestOperation *operation,id responseObject) {
                    
                    NSString *requestTmp = [NSString stringWithString:operation.responseString];
                    NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                    //系统自带JSON解析
                    resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                    NSLog(@"ok result = %@",[resultDic objectForKey:@"result"]);
                    
                    [self.delegate PostResult:resultDic];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"由于网络原因失败error = %@",error.localizedDescription);
                    
                }];
  
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    else
    {
        [httpClient postPath:urlString parameters:info success:^(AFHTTPRequestOperation *operation,id responseObject) {
            
            NSString *requestTmp = [NSString stringWithString:operation.responseString];
            NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
            //系统自带JSON解析
            resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"ok result = %@",[resultDic objectForKey:@"result"]);
            
            [self.delegate PostResult:resultDic];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"由于网络原因失败error = %@",error.localizedDescription);
            
        }];
    }
    [resultDic removeAllObjects];
}


-(void)getCom:(Gettype)type
{
    [resultDic setObject:[NSString stringWithFormat:@"%u",type] forKey:@"type"];
    switch (type) {
        case 0:
            [self getHttpUrl:GetPregant state:1];
            break;
        case 1:
            [self getHttpUrl:GetHeadPhoto state:1];
            break;
        case 2:
            [self getHttpUrl:APPversion state:0];
            break;
        case 3:
            [self getHttpUrl:FirmwareVersion state:0];
            break;
            
        default:
            break;
    }

}

- (void)getHttpUrl:(NSString *)urlString state:(NSInteger)state
{
    if (state==1) {
        NSDictionary *logininfo = [[NSDictionary alloc] init];
        [logininfo setValue:[user objectForKey:@"usrname"] forKey:@"account"];
        [logininfo setValue:[user objectForKey:@"passwd"] forKey:@"password"];
        
        [httpClient postPath:Login parameters:logininfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *requestTmp = [NSString stringWithString:operation.responseString];
            NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
            //系统自带JSON解析
            resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
            if ([[resultDic objectForKey:@"result"]isEqual:@"true"]) {
                
                [httpClient getPath:urlString parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
                    
                    NSString *requestTmp = [NSString stringWithString:operation.responseString];
                    NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                    //系统自带JSON解析
                    resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                    NSLog(@"ok result = %@",[resultDic objectForKey:@"result"]);
                    
                    [self.delegate GetResult:resultDic];
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"由于网络原因失败error = %@",error.localizedDescription);
                    
                }];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
    else
    {
        [httpClient getPath:urlString parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
            
            NSString *requestTmp = [NSString stringWithString:operation.responseString];
            NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
            //系统自带JSON解析
            resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"ok result = %@",[resultDic objectForKey:@"result"]);
            
            [self.delegate GetResult:resultDic];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"由于网络原因失败error = %@",error.localizedDescription);
            
        }];
    
    
    }
        [resultDic removeAllObjects];
}


-(void)HeadPhotoSendService:(NSData *)data
{
    
    NSDictionary *logininfo = [[NSDictionary alloc] init];
    [logininfo setValue:[user objectForKey:@"usrname"] forKey:@"account"];
    [logininfo setValue:[user objectForKey:@"passwd"] forKey:@"password"];
    
    [httpClient postPath:Login parameters:logininfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        //系统自带JSON解析
        resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        if ([[resultDic objectForKey:@"result"]isEqual:@"true"]) {
            
            NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:SendHeadPhoto parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                //                        NSData *photodata;
                //                        photodata = [self imageWithImage:myimage scaledToSize:CGSizeMake(20, 20)];
                
                [formData appendPartWithFileData:data name:@"header.jpg" fileName:@"header.jpg" mimeType:@"multipart/form-data; boundary=Boundary+0xAbCdEfGbOuNdArY"];
                // [formData appendPartWithFormData:RTdata name:str];
                NSLog(@"上传头像");
                
            }];
            AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [httpClient.operationQueue addOperation:op];
            
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *requestTmp = [NSString stringWithString:operation.responseString];
                NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                //系统自带JSON解析
                resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@" 头像resultDic = %@",resultDic);
                
                [self.delegate PostResult:resultDic];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"上传失败->%@", error);
                
            }];
   
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

    [resultDic removeAllObjects];

}


-(void)RTsendtoService:(NSData *)data name:(NSString *)name
{
    
    NSDictionary *logininfo = [[NSDictionary alloc] init];
    [logininfo setValue:[user objectForKey:@"usrname"] forKey:@"account"];
    [logininfo setValue:[user objectForKey:@"passwd"] forKey:@"password"];
    
    [httpClient postPath:Login parameters:logininfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        //系统自带JSON解析
        resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        if ([[resultDic objectForKey:@"result"]isEqual:@"true"]) {
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSString *str1 = [formatter stringFromDate:[NSDate date]];
            
            NSMutableDictionary *info = [[NSMutableDictionary alloc]init];
            [info setValue:str1 forKey:@"uploadTime"];
            NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:RTSendHistory parameters:info constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:data name:name fileName:name mimeType:@"multipart/form-data; boundary=Boundary+0xAbCdEfGbOuNdArY"];
                // [formData appendPartWithFormData:RTdata name:str];
                NSLog(@"上传辐射文件");
                
                }];
            AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [httpClient.operationQueue addOperation:op];
            
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *requestTmp = [NSString stringWithString:operation.responseString];
                NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                //系统自带JSON解析
                resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                [resultDic setValue:@"9" forKey:@"type"];
                NSLog(@" resultDic = %@",resultDic);
                
                [self.delegate PostResult:resultDic];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"上传失败->%@", error);
                
            }];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
    [resultDic removeAllObjects];

}

-(void)SPsendtoService:(NSData *)data name:(NSString *)name
{
    
    NSDictionary *logininfo = [[NSDictionary alloc] init];
    [logininfo setValue:[user objectForKey:@"usrname"] forKey:@"account"];
    [logininfo setValue:[user objectForKey:@"passwd"] forKey:@"password"];
    
    [httpClient postPath:Login parameters:logininfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        //系统自带JSON解析
        resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        if ([[resultDic objectForKey:@"result"]isEqual:@"true"]) {
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSString *str1 = [formatter stringFromDate:[NSDate date]];
            
            NSMutableDictionary *info = [[NSMutableDictionary alloc]init];
            [info setValue:str1 forKey:@"uploadTime"];
            NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:SPSendHistory parameters:info constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:data name:name fileName:name mimeType:@"multipart/form-data; boundary=Boundary+0xAbCdEfGbOuNdArY"];
                // [formData appendPartWithFormData:RTdata name:str];
                NSLog(@"上传计步文件");
                
            }];
            AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [httpClient.operationQueue addOperation:op];
            
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *requestTmp = [NSString stringWithString:operation.responseString];
                NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                //系统自带JSON解析
                resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                [resultDic setValue:@"10" forKey:@"type"];
                NSLog(@" resultDic = %@",resultDic);
                
                [self.delegate PostResult:resultDic];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"上传失败->%@", error);
                
            }];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
    [resultDic removeAllObjects];
    
}






@end
