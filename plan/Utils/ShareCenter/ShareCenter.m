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
                case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                
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

/**
 *  显示分享菜单
 *
 *  @param view 容器视图
 */
+ (void)showShareActionSheet:(UIView *)view title:(NSString *)title content:(NSString *)content shareUrl:(NSString *)shareUrl sharedImageURL:(NSString *)sharedImageURL
{
    if (!shareUrl || [shareUrl isEqualToString:@""]) {
        shareUrl = str_Website_URL;
    }
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:png_Icon_Logo_512]];
    [shareParams SSDKSetupShareParamsByText:content
                                     images:imageArray
                                        url:[NSURL URLWithString:shareUrl]
                                      title:title
                                       type:SSDKContentTypeAuto];
    
    //1.2、自定义分享平台
    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformSubTypeWechatSession), @(SSDKPlatformSubTypeWechatTimeline), @(SSDKPlatformSubTypeQQFriend), @(SSDKPlatformSubTypeQZone), @(SSDKPlatformTypeQQ)]];
    
    //2、分享
    [ShareSDK showShareActionSheet:view
                             items:activePlatforms
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           [AlertCenter alertToastMessage:str_Share_Success];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str_Share_Fail
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:str_OK
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
//                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str_Share_Cancel
//                                                                               message:nil
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:str_OK
//                                                                     otherButtonTitles:nil];
//                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
                   
                   if (state != SSDKResponseStateBegin)
                   {
                   }
                   
               }];
}

@end
