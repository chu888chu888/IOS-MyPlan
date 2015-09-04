//
//  Config.m
//  plan
//
//  Created by Fengzy on 15/8/28.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "Config.h"

static Config * instance = nil;

@implementation Config

+(id)shareInstance
{
    if(instance == nil)
    {
        instance = [[super allocWithZone:nil] init];
    }
    return instance;
}

#pragma mark -保存用户头像到本地缓存
- (void)saveAvatar:(UIImage *)image
{
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:str_Avatar];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [NotificationCenter postNotificationName:Notify_Settings_Changed object:nil];
}

#pragma mark -从本地缓存获取用户头像
- (UIImage *)getAvatar
{
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:str_Avatar];
    UIImage* image = [UIImage imageWithData:imageData];
    if (!image) {
        image = [UIImage imageNamed:png_AvatarDefault];
    }
    
    return image;
}

#pragma mark -App版本号
- (NSString *)appVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
