//
//  PlanCache.h
//  plan
//
//  Created by Fengzy on 15/8/29.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "Plan.h"
#import "Settings.h"

@interface PlanCache : NSObject

+ (void)openDBWithAccount:(NSString *)account;

+ (void)storePersonalSettings:(Settings *)settings;

+ (void)storePlan:(Plan *)plan;

+ (void)deletePlan:(Plan *)plan;

+ (Settings *)getPersonalSettings;

+ (NSArray *)getPlanByPlantype:(NSString *)plantype;

+ (NSString *)getPlanTotalCountByPlantype:(NSString *)plantype;

+ (NSString *)getPlanCompletedCountByPlantype:(NSString *)plantype;
@end
