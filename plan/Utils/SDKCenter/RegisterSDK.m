//
//  RegisterSDK.m
//  plan
//
//  Created by Fengzy on 15/9/26.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "WeiboSDK.h"
#import "RegisterSDK.h"

@implementation RegisterSDK

+ (void)registerSDK
{
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:str_SinaWeibo_AppKey];
    
}

@end
