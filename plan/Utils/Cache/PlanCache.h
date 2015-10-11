//
//  PlanCache.h
//  plan
//
//  Created by Fengzy on 15/8/29.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "Plan.h"
#import "Photo.h"
#import "Settings.h"

@interface PlanCache : NSObject

+ (void)openDBWithAccount:(NSString *)account;

+ (void)storePersonalSettings:(Settings *)settings;

+ (BOOL)storePlan:(Plan *)plan;

+ (BOOL)storePhoto:(Photo *)photo;

+ (BOOL)deletePlan:(Plan *)plan;

+ (void)deletePhoto:(Photo *)photo;

+ (Settings *)getPersonalSettings;

+ (NSArray *)getPlanByPlantype:(NSString *)plantype;

+ (NSString *)getPlanTotalCountByPlantype:(NSString *)plantype;

+ (NSString *)getPlanCompletedCountByPlantype:(NSString *)plantype;

+ (NSArray *)getPhoto;

+ (void)updateLocalNotification:(Plan *)plan;

+ (void)linkedLocalDataToAccount;

+ (NSArray *)getPlanForSync:(NSString *)syntime;

+ (Plan *)findPlan:(NSString *)account planid:(NSString *)planid;

@end
