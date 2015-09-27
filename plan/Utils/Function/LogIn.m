//
//  LogIn.m
//  plan
//
//  Created by Fengzy on 15/9/26.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "LogIn.h"
#import "WeiboSDK.h"
#import "AlertCenter.h"
#import <BmobSDK/BmobUser.h>


@implementation LogIn

+ (BOOL)isLogin {
    
    BmobUser *bUser = [BmobUser getCurrentUser];
    if (bUser) {
        return YES;
    }else{
        return NO;
    }
}


+ (void)weiboLogIn {
    if([WeiboSDK isWeiboAppInstalled]){
        //向新浪发送请求
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = str_SinaWeibo_RedirectURI;
        request.scope = @"all";
        [WeiboSDK sendRequest:request];
    } else {
        [AlertCenter alertButtonMessage:@"没有安装微博客户端"];
    }
}

//- (void)qqLogIn {
//    if ([TencentOAuth iphoneQQInstalled]) {
//        //注册
//        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104873268" andDelegate:self];
//        //授权
//        NSArray *permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO,nil];
//        [_tencentOAuth authorize:permissions inSafari:NO];
//        //获取用户信息
//        [_tencentOAuth getUserInfo];
//    } else {
//        [AlertCenter alertButtonMessage:@"没有安装qq客户端"];
//    }
//    
//}

//- (void)weixinLogIn {
//    if ([WXApi isWXAppInstalled]){
//        SendAuthReq* req =[[SendAuthReq alloc ] init];
//        req.scope = @"snsapi_userinfo,snsapi_base";
//        req.state = @"0744" ;
//        [WXApi sendReq:req];
//    } else {
//        [AlertCenter alertButtonMessage:@"没有安装微信客户端"];
//    }
//}

@end
