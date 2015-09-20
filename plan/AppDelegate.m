//
//  AppDelegate.m
//  plan
//
//  Created by Fengzy on 15/8/28.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "Plan.h"
#import "PlanCache.h"
#import "AppDelegate.h"
#import "LocalNotificationManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //本地通知注册
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    UILocalNotification *localNotify = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotify)
    {
        //程序在后台或者已关闭
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [NotificationCenter postNotificationName:Notify_Push_LocalNotify object:nil userInfo:localNotify.userInfo];
        });
    }

    return YES;
}

//禁止横向旋转屏幕
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // 清除推送图标标记
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    // 清除推送图标标记
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

/**
 *  接收本地推送
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification{
    
    lastNotification = notification;
    
    //重置5天未新建计划提醒时间
    [self checkFiveDayNotification];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }
    else if(buttonIndex == 1) {
        //显示
        [NotificationCenter postNotificationName:Notify_Push_LocalNotify object:nil userInfo:lastNotification.userInfo];
    }
    else if(buttonIndex == 2) {
        //5分钟后提醒
        NSDate *date = [[NSDate date] dateByAddingTimeInterval:5 * 60];
        [LocalNotificationManager updateNotificationWithTag:lastNotification fireDate:date userInfo:lastNotification.userInfo alertBody:lastNotification.alertBody];
    }
}

- (void)checkFiveDayNotification {
    
    NSDictionary *dict = lastNotification.userInfo;
    Plan *plan = [[Plan alloc] init];
    plan.planid = [dict objectForKey:@"tag"];
    plan.createtime = [dict objectForKey:@"createtime"];
    plan.content = [dict objectForKey:@"content"];
    plan.plantype = [dict objectForKey:@"plantype"];
    plan.iscompleted = [dict objectForKey:@"iscompleted"];
    plan.completetime = [dict objectForKey:@"completetime"];
    plan.isnotify = @"1";
    plan.notifytime = [dict objectForKey:@"notifytime"];
    
    if ([plan.planid isEqualToString:Notify_FiveDay_Tag]) {
        
        //如果还是没有新建计划，每天提醒一次
        NSString *formatterString = @"yyyy-MM-dd HH:mm";
        NSDate *tomorrow = [[NSDate date] dateByAddingTimeInterval:24 * 3600];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: formatterString];
        NSString *fiveDayTomorrow = [dateFormatter stringFromDate:tomorrow];
        plan.notifytime = fiveDayTomorrow;
        
        [PlanCache updateLocalNotification:plan];
    } else {
        
        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        if (state == UIApplicationStateInactive) {
            //程序在后台或者已关闭
            [NotificationCenter postNotificationName:Notify_Push_LocalNotify object:nil userInfo:lastNotification.userInfo];
        }
        else {
            //程序正在运行
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:lastNotification.alertTitle message:lastNotification.alertBody delegate:self cancelButtonTitle:str_Cancel otherButtonTitles:str_Show, str_Notify_Later, nil];
            [alert show];
        }
    }
}

@end
