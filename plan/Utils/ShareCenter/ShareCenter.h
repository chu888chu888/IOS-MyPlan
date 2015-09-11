//
//  ShareCenter.h
//  plan
//
//  Created by Fengzy on 15/9/10.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "WXApi.h"
#import "WeiboSDK.h"
#import "WeiboUser.h"
#import <ShareSDK/ShareSDK.h>
#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

@interface ShareCenter : NSObject

//注册sharedsdk APIkey
+ (void)registerShareSDK;


//分享一个容器
//+(void) showSharedView:(UIView *)sender url:(NSString *)shareUrl title:(NSString*)title content:(NSString *)content img:(NSString *)sharedImageURL;

//直接分享某一项内容
+ (void)showShare:(NSString *)title content:(NSString*)content shareUrl:(NSString *)shareUrl sharedImageURL:(NSString *)sharedImageURL;

//#if TencenQQ_Shared
////QQ 登录
//+(void) QQLogin:(SSGetUserInfoEventHandler) loginbk;
//#endif
////取消qq授权
//+(void) cancelAuthWithQQ;
//
////qq是否授权
//+ (BOOL)hasAuthorizedWithQQ;
//
//
////新浪微博登录
//+(void) SinzLogin:(SSGetUserInfoEventHandler) loginbk;
//
////取消新浪授权
//+(void) cancelAuthWithSina;
//
////新浪是否授权
//+ (BOOL)hasAuthorizedWithSina;

@end
