//
//  ShareCenter.m
//  plan
//
//  Created by Fengzy on 15/9/10.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "ShareCenter.h"
#import "AlertCenter.h"

@implementation ShareCenter

+ (void)registerShareSDK
{
    [ShareSDK registerApp:@"a47e7a940fac" activePlatforms:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeWechat), @(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType) {
        
        switch (platformType) {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
                
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        
        switch (platformType) {
            case SSDKPlatformTypeSinaWeibo:
                [appInfo SSDKSetupSinaWeiboByAppKey:@"2763375435" appSecret:@"c0f52655316236b558b22f6b90e2ba44" redirectUri:str_Website_URL authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wx6bae95e549a33fb8" appSecret:@"24dd0aaa317888920cd690ed55a98520"];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:@"1104853884" appKey:@"WtXharg81OeHEhb2" authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformSubTypeQZone:
                break;
            default:
                break;
        }
    }];

}

+ (void)showShare:(NSString *)title content:(NSString *)content shareUrl:(NSString *)shareUrl sharedImageURL:(NSString *)sharedImageURL
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];

    if (!shareUrl || [shareUrl isEqualToString:@""]) {
        shareUrl = str_Website_URL;
    }
    
    UIImage *image = [UIImage imageNamed:png_Icon_Logo_512];
    
    [shareParams SSDKSetupShareParamsByText:content images:image url:[NSURL URLWithString:shareUrl] title:title type:SSDKContentTypeImage];
    
    [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state) {
            case SSDKResponseStateSuccess:
                [AlertCenter alertToastMessage:str_Share_Success];
                break;
            case SSDKResponseStateFail:
                [AlertCenter alertToastMessage:str_Share_Fail];
                break;
            case SSDKResponseStateCancel:
                [AlertCenter alertToastMessage:str_Share_Cancel];
                break;

            default:
                break;
        }
        
    }];
}

+ (void)shareWithShareType:(SSDKPlatformType)shareType title:(NSString *)title
{
}

@end
