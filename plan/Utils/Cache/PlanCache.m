//
//  PlanCache.m
//  plan
//
//  Created by Fengzy on 15/8/29.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "PlanCache.h"
#import "FMDatabase.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"



#define FMDBQuickCheck(SomeBool, Title, Db) {\
if (!(SomeBool)) { \
NSLog(@"Failure on line %d, %@ error(%d): %@", __LINE__, Title, [Db lastErrorCode], [Db lastErrorMessage]);\
}}

NSString * dbFilePath(NSString * filename) {
    NSArray * documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString * documentDirectory = [documentPaths objectAtIndex:0];
    NSString * pathName = [documentDirectory stringByAppendingPathComponent:@"cache"];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:pathName])
        [fileManager createDirectoryAtPath:pathName withIntermediateDirectories:YES attributes:nil error:nil];
    
    pathName = [pathName stringByAppendingPathComponent:filename];
    
    return pathName;
};

NSData * encodePwd(NSString * pwd) {
    
    NSData * data = [pwd dataUsingEncoding:NSUTF8StringEncoding];
    
    return data;
};

NSString * decodePwd(NSData * data) {
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
};


@implementation PlanCache


static FMDatabase * __db;
static NSString *__currentPath;
static NSString *__currentPlistPath;
static NSString *__offlineMsgPlistPath;
static NSMutableDictionary * __contactsOnlineState;

+ (void)initialize {
    
    NSLog(@"Is SQLite compiled with it's thread safe options turned on? %@!", [FMDatabase isSQLiteThreadSafe] ? @"Yes" : @"No");
    
}

#pragma mark -重置当前用户本地数据库链接
+ (void)resetCurrentLogin
{
    
    [__db close];
    __db = nil;
    
    if (__currentPath) {
        __currentPath = nil;
    }
    
    if (__currentPlistPath) {
        __currentPlistPath = nil;
    }
    
    if (__offlineMsgPlistPath) {
        __offlineMsgPlistPath = nil;
    }
}

#pragma mark -打开当前用户本地数据库链接
+ (void)openDBWithAccount:(NSString *)account
{
    
    [PlanCache resetCurrentLogin];
    
    if (!account)
        return;
    
    NSString * fileName = dbFilePath([NSString stringWithFormat:@"data_%@.db", account]);
    
    __currentPath = [fileName copy];
    __db = [FMDatabase databaseWithPath:fileName];
    
    if (![__db open]) {
        NSLog(@"Could not open db:%@", fileName);
        
        return;
    }
    
    // kind of experimentalish.
    [__db setShouldCacheStatements:YES];
    
    // 个人设置
    if (![__db tableExists:@"t_settings"]) {
        BOOL b = [__db executeUpdate:@"CREATE TABLE t_settings (nickname TEXT, birthday TEXT, email TEXT, gender TEXT, lifespan TEXT)"];
        FMDBQuickCheck(b, @"create table t_settings", __db);
    }
    
    // 计划
    if (![__db tableExists:@"t_plan"]) {
        BOOL b = [__db executeUpdate:@"CREATE TABLE t_plan (planid TEXT, content TEXT, createtime TEXT, completetime TEXT, updatetime TEXT, iscompleted TEXT, plantype TEXT)"];
        FMDBQuickCheck(b, @"create table t_plan", __db);
    }

}

#pragma mark -存储个人设置
+ (void)storePersonalSettings:(Settings *)settings
{
    
    @synchronized(__db) {
        
        if (!__db.open)
        {
            if (![__db open]) {
                return ;
            }
        }
        
        if (!settings.nickname) {
            settings.nickname = @"";
        }
        if (!settings.birthday) {
            settings.birthday = @"";
        }
        if (!settings.email) {
            settings.email = @"";
        }
        if (!settings.gender) {
            settings.gender = @"";
        }
        if (!settings.lifespan) {
            settings.lifespan = @"";
        }
        if (!settings.password) {
            settings.password = @"";
        }
        
        BOOL hasRec = NO;
        FMResultSet * rs = [__db executeQuery:@"SELECT * FROM t_settings"];
        hasRec = [rs next];
        [rs close];
        if (hasRec) {
            BOOL b = [__db executeUpdate:@"UPDATE t_settings SET nickname=?, birthday=?, email=?, gender=?, lifespan=?" withArgumentsInArray:@[settings.nickname, settings.birthday, settings.email, settings.gender, settings.lifespan]];
            
            NSString * log = @"store(update) t_settings";
            FMDBQuickCheck(b, log, __db);
        }
        else
        {
            BOOL b = [__db executeUpdate:@"INSERT INTO t_settings(nickname, birthday, email, gender, lifespan) values(?, ?, ?, ?, ?)" withArgumentsInArray:@[settings.nickname, settings.birthday, settings.email, settings.gender, settings.lifespan]];
            
            NSString * log = @"store(insert) t_settings";
            FMDBQuickCheck(b, log, __db);
        }
        
        [NotificationCenter postNotificationName:Notify_Settings_Changed object:nil];
    }
}

#pragma mark -存储计划
+ (void)storePlan:(Plan *)plan
{
    
    @synchronized(__db) {
        
        if (!__db.open)
        {
            if (![__db open]) {
                return ;
            }
        }
        
        if (!plan.planid || !plan.content || !plan.createtime) return;
        if (!plan.completetime) {
            plan.completetime = @"";
        }
        if (!plan.updatetime) {
            plan.updatetime = @"";
        }
        if (!plan.iscompleted) {
            plan.iscompleted = @"";
        }
        if (!plan.plantype) {
            plan.plantype = @"";
        }
        
        BOOL hasRec = NO;
        FMResultSet * rs = [__db executeQuery:@"SELECT * FROM t_plan WHERE planid=?" withArgumentsInArray:@[plan.planid]];
        hasRec = [rs next];
        [rs close];
        if (hasRec) {
            BOOL b = [__db executeUpdate:@"UPDATE t_plan SET content=?, createtime=?, completetime=?, updatetime=?, iscompleted=?, plantype=? WHERE planid=?" withArgumentsInArray:@[plan.content, plan.createtime, plan.completetime, plan.updatetime, plan.iscompleted, plan.plantype, plan.planid]];
            
            NSString * log = @"store(update) t_plan";
            FMDBQuickCheck(b, log, __db);
        }
        else
        {
            BOOL b = [__db executeUpdate:@"INSERT INTO t_plan(planid, content, createtime, completetime, updatetime, iscompleted, plantype) values(?, ?, ?, ?, ?, ?, ?)" withArgumentsInArray:@[plan.planid, plan.content, plan.createtime, plan.completetime, plan.updatetime, plan.iscompleted, plan.plantype]];
            
            NSString * log = @"store(insert) t_plan";
            FMDBQuickCheck(b, log, __db);
        }
        
        [NotificationCenter postNotificationName:Notify_Plan_Save object:nil];
    }
}

#pragma mark -删除计划
+ (void)deletePlan:(Plan *)plan
{
    @synchronized(__db) {
        
        if (!__db.open)
        {
            if (![__db open]) {
                return ;
            }
        }
        
        BOOL hasRec = NO;
        FMResultSet * rs = [__db executeQuery:@"SELECT * FROM t_plan WHERE planid=?" withArgumentsInArray:@[plan.planid]];
        hasRec = [rs next];
        [rs close];
        if (hasRec) {
            BOOL b = [__db executeUpdate:@"DELETE FROM t_plan WHERE planid=?" withArgumentsInArray:@[plan.planid]];
            
            NSString * log = @"delete plan from t_plan";
            FMDBQuickCheck(b, log, __db);
        }
        
        [NotificationCenter postNotificationName:Notify_Plan_Save object:nil];
    }
}

#pragma mark -获取个人设置
+ (Settings *)getPersonalSettings
{
    @synchronized(__db) {
        
        if (!__db.open)
        {
            if (![__db open]) {
                return nil;
            }
        }
        
        Settings *settings = [[Settings alloc] init];
        
        NSString *sqlString = @"select nickname, birthday, email, gender, lifespan from t_settings";
        
        FMResultSet * rs = [__db executeQuery:sqlString];
        while ([rs next]) {
            
            settings.nickname = [rs stringForColumn:@"nickname"];
            settings.birthday = [rs stringForColumn:@"birthday"];
            settings.email = [rs stringForColumn:@"email"];
            settings.gender = [rs stringForColumn:@"gender"];
            settings.lifespan = [rs stringForColumn:@"lifespan"];
        }
        [rs close];
        
        return settings;
        
    }
}

#pragma mark -获取计划
+ (NSArray *)getPlanByPlantype:(NSString *)plantype
{
    
    @synchronized(__db) {
        
        if (!__db.open)
        {
            if (![__db open]) {
                return nil ;
            }
        }
        
        NSMutableArray *array = [NSMutableArray array];
        
        FMResultSet * rs = [__db executeQuery:@"SELECT planid, content, createtime, completetime, updatetime, iscompleted, plantype FROM t_plan WHERE plantype=? ORDER BY createtime DESC" withArgumentsInArray:@[plantype]];
        
        while ([rs next]) {
            
            Plan *plan = [[Plan alloc] init];
            plan.planid = [rs stringForColumn:@"planid"];
            plan.content = [rs stringForColumn:@"content"];
            plan.createtime = [rs stringForColumn:@"createtime"];
            plan.completetime = [rs stringForColumn:@"completetime"];
            plan.updatetime = [rs stringForColumn:@"updatetime"];
            plan.iscompleted = [rs stringForColumn:@"iscompleted"];
            plan.plantype = [rs stringForColumn:@"plantype"];
            
            [array addObject:plan];
        }
        [rs close];
        
        return array;
    }
}


+ (NSString *)getPlanTotalCountByPlantype:(NSString *)plantype
{
    
    @synchronized(__db) {
        
        if (!__db.open)
        {
            if (![__db open]) {
                return nil ;
            }
        }
        
        NSString *total = @"0";
        
        FMResultSet * rs = [__db executeQuery:@"SELECT COUNT(*) as total FROM t_plan WHERE plantype=?" withArgumentsInArray:@[plantype]];
        
        if([rs next]) {
            
            total = [rs stringForColumn:@"total"];
        }
        [rs close];
        
        return total;
    }
}

+ (NSString *)getPlanCompletedCountByPlantype:(NSString *)plantype
{
    
    @synchronized(__db) {
        
        if (!__db.open)
        {
            if (![__db open]) {
                return nil ;
            }
        }
        
        NSString *completed = @"0";
        
        FMResultSet * rs = [__db executeQuery:@"SELECT COUNT(*) as completed FROM t_plan WHERE plantype=? and iscompleted=1" withArgumentsInArray:@[plantype]];
        
        if([rs next]) {
            
            completed = [rs stringForColumn:@"completed"];
        }
        [rs close];
        
        return completed;
    }
}

@end
