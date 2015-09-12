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
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>


@interface ShareCenter : NSObject

//注册sharedsdk APIkey
+ (void)registerShareSDK;


+ (void)showShareActionSheet:(UIView *)view title:(NSString *)title content:(NSString*)content shareUrl:(NSString *)shareUrl sharedImageURL:(NSString *)sharedImageURL;;

@end
