//
//  PlanCache.m
//  plan
//
//  Created by Fengzy on 15/8/29.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "LogIn.h"
#import "PlanCache.h"
#import "FMDatabase.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"
#import <BmobSDK/BmobUser.h>
#import "FMDatabaseAdditions.h"
#import "LocalNotificationManager.h"



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
+ (void)resetCurrentLogin {
    
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
+ (void)openDBWithAccount:(NSString *)account {
    
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
    
    [__db setShouldCacheStatements:YES];
    
    // 个人设置
    if (![__db tableExists:str_TableName_Settings]) {
        
        NSString *sqlString = [NSString stringWithFormat:@"CREATE TABLE %@ (account TEXT, nickname TEXT, birthday TEXT, email TEXT, gender TEXT, lifespan TEXT, syntime TEXT)", str_TableName_Settings];
        
        BOOL b = [__db executeUpdate:sqlString];
        
        FMDBQuickCheck(b, sqlString, __db);
        
    } else {//新增字段
        
        //新增账号字段2015-10-03
        NSString *account = @"account";
        if (![__db columnExists:account inTableWithName:str_TableName_Settings]) {
            
            NSString *sqlString = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",str_TableName_Settings, account];
            
            BOOL b = [__db executeUpdate:sqlString];
            
            FMDBQuickCheck(b, sqlString, __db);
            
        }
        //新增同步时间字段2015-10-03
        NSString *syntime = @"syntime";
        if (![__db columnExists:syntime inTableWithName:str_TableName_Settings]) {
            
            NSString *sqlString = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",str_TableName_Settings, syntime];
            
            BOOL b = [__db executeUpdate:sqlString];
            
            FMDBQuickCheck(b, sqlString, __db);
        }
        
        //2015-10-12将account值统一赋值
        NSString *sqlString = [NSString stringWithFormat:@"UPDATE %@ SET account=?",str_TableName_Settings];
        [__db executeUpdate:sqlString withArgumentsInArray:@[@""]];
    }
    
    // 计划
    if (![__db tableExists:str_TableName_Plan]) {
        
        NSString *sqlString = [NSString stringWithFormat:@"CREATE TABLE %@ (account TEXT, planid TEXT, content TEXT, createtime TEXT, completetime TEXT, updatetime TEXT, iscompleted TEXT, isnotify TEXT, notifytime TEXT, plantype TEXT, isdeleted TEXT)", str_TableName_Plan];
        
        BOOL b = [__db executeUpdate:sqlString];
        
        FMDBQuickCheck(b, sqlString, __db);
        
    } else { //新增字段
        
        //新增提醒字段
        NSString *isNotify = @"isnotify";
        if (![__db columnExists:isNotify inTableWithName:str_TableName_Plan]) {
            
            NSString *sqlString = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",str_TableName_Plan, isNotify];
            
            BOOL b = [__db executeUpdate:sqlString];
            
            FMDBQuickCheck(b, sqlString, __db);
            
            sqlString = [NSString stringWithFormat:@"UPDATE %@ SET %@=0",str_TableName_Plan, isNotify];
            
            b = [__db executeUpdate:sqlString];
            
            FMDBQuickCheck(b, sqlString, __db);
            
        }
        //新增提醒时间字段
        NSString *notifyTime = @"notifytime";
        if (![__db columnExists:notifyTime inTableWithName:str_TableName_Plan]) {
            
            NSString *sqlString = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",str_TableName_Plan, notifyTime];
            
            BOOL b = [__db executeUpdate:sqlString];
            
            FMDBQuickCheck(b, sqlString, __db);
        }
        //新增删除状态字段2015-09-18
        NSString *isDeleted = @"isdeleted";
        if (![__db columnExists:isDeleted inTableWithName:str_TableName_Plan]) {
            
            NSString *sqlString = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",str_TableName_Plan, isDeleted];
            
            BOOL b = [__db executeUpdate:sqlString];
            
            FMDBQuickCheck(b, sqlString, __db);
            
            sqlString = [NSString stringWithFormat:@"UPDATE %@ SET %@=0",str_TableName_Plan, isDeleted];
            
            b = [__db executeUpdate:sqlString];
            
            FMDBQuickCheck(b, sqlString, __db);
        }
        //新增账号字段2015-10-03
        NSString *account = @"account";
        if (![__db columnExists:account inTableWithName:str_TableName_Plan]) {
            
            NSString *sqlString = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",str_TableName_Plan, account];
            
            BOOL b = [__db executeUpdate:sqlString];
            
            FMDBQuickCheck(b, sqlString, __db);
            
        }
        
        //2015-10-12将account值统一赋值
        NSString *sqlString = [NSString stringWithFormat:@"UPDATE %@ SET account=?",str_TableName_Plan];
        [__db executeUpdate:sqlString withArgumentsInArray:@[@""]];
    }

    //相册
    if (![__db tableExists:str_TableName_Photo]) {
        
        NSString *sqlString = [NSString stringWithFormat:@"CREATE TABLE %@ (account TEXT, photoid TEXT, content TEXT, createtime TEXT, phototime TEXT, updatetime TEXT, location TEXT, photo1 BLOB, photo2 BLOB, photo3 BLOB, photo4 BLOB, photo5 BLOB, photo6 BLOB, photo7 BLOB, photo8 BLOB, photo9 BLOB, isdeleted TEXT)", str_TableName_Photo];
        
        BOOL b = [__db executeUpdate:sqlString];
        
        FMDBQuickCheck(b, sqlString, __db);
        
    } else {
        
        //2015-10-12将account值统一赋值
        NSString *sqlString = [NSString stringWithFormat:@"UPDATE %@ SET account=?",str_TableName_Photo];
        [__db executeUpdate:sqlString withArgumentsInArray:@[@""]];
    }
}

#pragma mark -存储个人设置
+ (void)storePersonalSettings:(Settings *)settings {
    
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return ;
            }
        }
        
//        if ([LogIn isLogin]) {
//            BmobUser *user = [BmobUser getCurrentUser];
//            settings.account = user.objectId;
//        } else {
//            settings.account = @"";
//        }
        settings.account = @"";
        
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
        if (!settings.syntime) {
            settings.syntime = @"";
        }
        
        BOOL hasRec = NO;
        NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE account=?", str_TableName_Settings];
        FMResultSet * rs = [__db executeQuery:sqlString withArgumentsInArray:@[settings.account]];
        hasRec = [rs next];
        [rs close];
        if (hasRec) {
            
            sqlString = [NSString stringWithFormat:@"UPDATE %@ SET nickname=?, birthday=?, email=?, gender=?, lifespan=?, syntime=? WHERE account=?", str_TableName_Settings];
            
            BOOL b = [__db executeUpdate:sqlString withArgumentsInArray:@[settings.nickname, settings.birthday, settings.email, settings.gender, settings.lifespan, settings.syntime, settings.account]];
            
            FMDBQuickCheck(b, sqlString, __db);
            
        } else {
            
            sqlString = [NSString stringWithFormat:@"INSERT INTO %@(account, nickname, birthday, email, gender, lifespan, syntime) values(?, ?, ?, ?, ?, ?, ?)", str_TableName_Settings];
            
            BOOL b = [__db executeUpdate:sqlString withArgumentsInArray:@[settings.account, settings.nickname, settings.birthday, settings.email, settings.gender, settings.lifespan, settings.syntime]];

            FMDBQuickCheck(b, sqlString, __db);
        }
        
        [NotificationCenter postNotificationName:Notify_Settings_Changed object:nil];
    }
}

#pragma mark -存储计划
+ (BOOL)storePlan:(Plan *)plan {
    
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return NO;
            }
        }
        
        if (!plan.planid || !plan.content || !plan.createtime)
            return NO;
        
//        if ([LogIn isLogin]) {
//            BmobUser *user = [BmobUser getCurrentUser];
//            plan.account = user.objectId;
//        } else {
//            plan.account = @"";
//        }
        plan.account = @"";
        
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
        if (!plan.notifytime) {
            plan.notifytime = @"";
        }
        
        BOOL hasRec = NO;
        NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE planid=? AND account=?", str_TableName_Plan];
        
        FMResultSet * rs = [__db executeQuery:sqlString withArgumentsInArray:@[plan.planid, plan.account]];
        hasRec = [rs next];
        [rs close];
        BOOL b = NO;
        if (hasRec) {
            
            sqlString = [NSString stringWithFormat:@"UPDATE %@ SET content=?, createtime=?, completetime=?, updatetime=?, iscompleted=?, isnotify=?, notifytime=?, plantype=? WHERE planid=? AND account=?", str_TableName_Plan];
            
            b = [__db executeUpdate:sqlString withArgumentsInArray:@[plan.content, plan.createtime, plan.completetime, plan.updatetime, plan.iscompleted, plan.isnotify, plan.notifytime, plan.plantype, plan.planid, plan.account]];
            
            FMDBQuickCheck(b, sqlString, __db);
            
            //更新提醒
            if (b && [plan.isnotify isEqualToString:@"1"]) {
                
                [self updateLocalNotification:plan];
                
            } else {
                
                [self cancelLocalNotification:plan.planid];
            }
            
        } else {
            
            sqlString = [NSString stringWithFormat:@"INSERT INTO %@(account, planid, content, createtime, completetime, updatetime, iscompleted, isnotify, notifytime, plantype, isdeleted) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", str_TableName_Plan];
            
            b = [__db executeUpdate:sqlString withArgumentsInArray:@[plan.account, plan.planid, plan.content, plan.createtime, plan.completetime, plan.updatetime, plan.iscompleted, plan.isnotify, plan.notifytime, plan.plantype, @"0"]];
            
            FMDBQuickCheck(b, sqlString, __db);
            
            //添加提醒
            if (b && [plan.isnotify isEqualToString:@"1"]) {
                
                [self addLocalNotification:plan];
            }
            
            //更新5天没有新建计划的提醒时间
            [self setFiveDayNotification];
        }
        
        [NotificationCenter postNotificationName:Notify_Plan_Save object:nil];
        
        return b;
    }
}

+ (BOOL)storePhoto:(Photo *)photo {
    
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return NO;
            }
        }
        
        if (!photo.photoid || !photo.createtime)
            return NO;
        
//        if ([LogIn isLogin]) {
//            BmobUser *user = [BmobUser getCurrentUser];
//            photo.account = user.objectId;
//        } else {
//            photo.account = @"";
//        }
        photo.account = @"";
        
        if (!photo.content) {
            photo.content = @"";
        }
        if (!photo.phototime) {
            photo.phototime = @"";
        }
        if (!photo.updatetime) {
            photo.updatetime = @"";
        }
        if (!photo.location) {
            photo.location = @"";
        }
        NSMutableArray *photoDataArray = [NSMutableArray array];
        for (NSInteger i = 0; i < 9; i++) {
            
            if (i < photo.photoArray.count) {
                
                UIImage *image = photo.photoArray[i];
                NSData *imageData = UIImageJPEGRepresentation(image, 0.8);//UIImagePNGRepresentation(image);
                [photoDataArray addObject:imageData];
                
            } else {
                
                [photoDataArray addObject:[NSData data]];
                
            }
        }

        BOOL hasRec = NO;
        NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE photoid=? AND account=?", str_TableName_Photo];
        
        FMResultSet * rs = [__db executeQuery:sqlString withArgumentsInArray:@[photo.photoid, photo.account]];
        hasRec = [rs next];
        [rs close];
        BOOL b = NO;
        if (hasRec) {
            
            sqlString = [NSString stringWithFormat:@"UPDATE %@ SET content=?, createtime=?, phototime=?, updatetime=?, location=?, photo1=?, photo2=?, photo3=?, photo4=?, photo5=?, photo6=?, photo7=?, photo8=?, photo9=? WHERE photoid=? AND account=?", str_TableName_Photo];
            
            b = [__db executeUpdate:sqlString withArgumentsInArray:@[photo.content, photo.createtime, photo.phototime, photo.updatetime, photo.location, photoDataArray[0], photoDataArray[1], photoDataArray[2], photoDataArray[3], photoDataArray[4], photoDataArray[5], photoDataArray[6], photoDataArray[7], photoDataArray[8], photo.photoid, photo.account]];
            
            FMDBQuickCheck(b, sqlString, __db);

        } else {
            
            sqlString = [NSString stringWithFormat:@"INSERT INTO %@(account, photoid, content, createtime, phototime, updatetime, location, photo1, photo2, photo3, photo4, photo5, photo6, photo7, photo8, photo9, isdeleted) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", str_TableName_Photo];
            
            b = [__db executeUpdate:sqlString withArgumentsInArray:@[photo.account, photo.photoid, photo.content, photo.createtime, photo.phototime, photo.updatetime, photo.location, photoDataArray[0], photoDataArray[1], photoDataArray[2], photoDataArray[3], photoDataArray[4], photoDataArray[5], photoDataArray[6], photoDataArray[7], photoDataArray[8], @"0"]];
            
            FMDBQuickCheck(b, sqlString, __db);
        }
        
        [NotificationCenter postNotificationName:Notify_Photo_Save object:nil];
        
        return b;
    }
}

#pragma mark -删除计划
+ (BOOL)deletePlan:(Plan *)plan {
    
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return NO;
            }
        }
        
//        if ([LogIn isLogin]) {
//            BmobUser *user = [BmobUser getCurrentUser];
//            plan.account = user.objectId;
//        } else {
//            plan.account = @"";
//        }
        plan.account = @"";
        
        BOOL hasRec = NO;
        NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE planid=? AND account=?", str_TableName_Plan];
        
        FMResultSet * rs = [__db executeQuery:sqlString withArgumentsInArray:@[plan.planid, plan.account]];
        hasRec = [rs next];
        [rs close];
        BOOL b = NO;
        if (hasRec) {

            sqlString = [NSString stringWithFormat:@"UPDATE %@ SET isdeleted=1  WHERE planid=? AND account=?", str_TableName_Plan];
            
            b = [__db executeUpdate:sqlString withArgumentsInArray:@[plan.planid, plan.account]];
            
            FMDBQuickCheck(b, sqlString, __db);
            
            //取消提醒
            if (b && [plan.isnotify isEqualToString:@"1"]) {
                
                [self cancelLocalNotification:plan.planid];
            }
        }
        
        [NotificationCenter postNotificationName:Notify_Plan_Save object:nil];
        
        return b;
    }
}

+ (BOOL)deletePhoto:(Photo *)photo {
    
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return NO;
            }
        }
        
//        if ([LogIn isLogin]) {
//            BmobUser *user = [BmobUser getCurrentUser];
//            photo.account = user.objectId;
//        } else {
//            photo.account = @"";
//        }
        photo.account = @"";
        
        BOOL hasRec = NO;
        NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE photoid=? AND account=?", str_TableName_Photo];
        
        FMResultSet * rs = [__db executeQuery:sqlString withArgumentsInArray:@[photo.photoid, photo.account]];
        hasRec = [rs next];
        [rs close];
        BOOL b = NO;
        if (hasRec) {
            
            sqlString = [NSString stringWithFormat:@"UPDATE %@ SET isdeleted=1  WHERE photoid=? AND account=?", str_TableName_Photo];
            
            b = [__db executeUpdate:sqlString withArgumentsInArray:@[photo.photoid, photo.account]];
            
            FMDBQuickCheck(b, sqlString, __db);
        }
        
        [NotificationCenter postNotificationName:Notify_Photo_Save object:nil];
        
        return b;
    }
}

#pragma mark -获取个人设置
+ (Settings *)getPersonalSettings {
    
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return nil;
            }
        }

        Settings *settings = [[Settings alloc] init];
//        if ([LogIn isLogin]) {
//            BmobUser *user = [BmobUser getCurrentUser];
//            settings.account = user.objectId;
//        } else {
//            settings.account = @"";
//        }
        settings.account = @"";
        
        NSString *sqlString = [NSString stringWithFormat:@"SELECT nickname, birthday, email, gender, lifespan, syntime FROM %@ WHERE account=?", str_TableName_Settings];
        
        FMResultSet * rs = [__db executeQuery:sqlString withArgumentsInArray:@[settings.account]];
        while ([rs next]) {
            
            settings.nickname = [rs stringForColumn:@"nickname"];
            settings.birthday = [rs stringForColumn:@"birthday"];
            settings.email = [rs stringForColumn:@"email"];
            settings.gender = [rs stringForColumn:@"gender"];
            settings.lifespan = [rs stringForColumn:@"lifespan"];
            settings.syntime = [rs stringForColumn:@"syntime"];
        }
        [rs close];
        
        return settings;
        
    }
}

#pragma mark -获取计划
+ (NSArray *)getPlanByPlantype:(NSString *)plantype {
    
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return nil ;
            }
        }
        
        NSString *account = @"";
//        if ([LogIn isLogin]) {
//            BmobUser *user = [BmobUser getCurrentUser];
//            account = user.objectId;
//        }
        
        NSMutableArray *array = [NSMutableArray array];
        NSString *sqlString = [NSString stringWithFormat:@"SELECT planid, content, createtime, completetime, updatetime, iscompleted, isnotify, notifytime, plantype FROM %@ WHERE plantype=? AND account=? AND isdeleted=0 ORDER BY createtime DESC", str_TableName_Plan];
        
        FMResultSet * rs = [__db executeQuery:sqlString withArgumentsInArray:@[plantype, account]];
        
        while ([rs next]) {
            
            Plan *plan = [[Plan alloc] init];
            plan.account = account;
            plan.planid = [rs stringForColumn:@"planid"];
            plan.content = [rs stringForColumn:@"content"];
            plan.createtime = [rs stringForColumn:@"createtime"];
            plan.completetime = [rs stringForColumn:@"completetime"];
            plan.updatetime = [rs stringForColumn:@"updatetime"];
            plan.iscompleted = [rs stringForColumn:@"iscompleted"];
            plan.isnotify = [rs stringForColumn:@"isnotify"];
            plan.notifytime = [rs stringForColumn:@"notifytime"];
            plan.plantype = [rs stringForColumn:@"plantype"];
            
            [array addObject:plan];
        }
        [rs close];
        
        return array;
    }
}

+ (NSArray *)getPhoto {
    
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return nil ;
            }
        }
        
        NSString *account = @"";
//        if ([LogIn isLogin]) {
//            BmobUser *user = [BmobUser getCurrentUser];
//            account = user.objectId;
//        }
        
        NSMutableArray *array = [NSMutableArray array];
        NSString *sqlString = [NSString stringWithFormat:@"SELECT photoid, content, createtime, phototime, updatetime, location, photo1, photo2, photo3, photo4, photo5, photo6, photo7, photo8, photo9 FROM %@ WHERE account=? AND isdeleted=0 ORDER BY phototime DESC, createtime DESC", str_TableName_Photo];
        
        FMResultSet * rs = [__db executeQuery:sqlString withArgumentsInArray:@[account]];
        
        while ([rs next]) {
            
            Photo *photo = [[Photo alloc] init];
            photo.account = account;
            photo.photoid = [rs stringForColumn:@"photoid"];
            photo.content = [rs stringForColumn:@"content"];
            photo.createtime = [rs stringForColumn:@"createtime"];
            photo.phototime = [rs stringForColumn:@"phototime"];
            photo.updatetime = [rs stringForColumn:@"updatetime"];
            photo.location = [rs stringForColumn:@"location"];
            photo.photoArray = [NSMutableArray array];
            
            NSData *imageData = [rs dataForColumn:@"photo1"];
            if (imageData) {

                [photo.photoArray addObject:[UIImage imageWithData:imageData]];
            }
            imageData = [rs dataForColumn:@"photo2"];
            if (imageData) {
                
                [photo.photoArray addObject:[UIImage imageWithData:imageData]];
            }
            imageData = [rs dataForColumn:@"photo3"];
            if (imageData) {
                
                [photo.photoArray addObject:[UIImage imageWithData:imageData]];
            }
            imageData = [rs dataForColumn:@"photo4"];
            if (imageData) {
                
                [photo.photoArray addObject:[UIImage imageWithData:imageData]];
            }
            imageData = [rs dataForColumn:@"photo5"];
            if (imageData) {
                
                [photo.photoArray addObject:[UIImage imageWithData:imageData]];
            }
            imageData = [rs dataForColumn:@"photo6"];
            if (imageData) {
                
                [photo.photoArray addObject:[UIImage imageWithData:imageData]];
            }
            imageData = [rs dataForColumn:@"photo7"];
            if (imageData) {
                
                [photo.photoArray addObject:[UIImage imageWithData:imageData]];
            }
            imageData = [rs dataForColumn:@"photo8"];
            if (imageData) {
                
                [photo.photoArray addObject:[UIImage imageWithData:imageData]];
            }
            imageData = [rs dataForColumn:@"photo9"];
            if (imageData) {
                
                [photo.photoArray addObject:[UIImage imageWithData:imageData]];
            }
            
            [array addObject:photo];
        }
        [rs close];
        
        return array;
    }
}

+ (Photo *)getPhotoById:(NSString *)photoid {
    
    @synchronized(__db) {
        
        Photo *photo = [[Photo alloc] init];
        
        if (!__db.open) {
            if (![__db open]) {
                return photo ;
            }
        }
        
        NSString *account = @"";
//        if ([LogIn isLogin]) {
//            BmobUser *user = [BmobUser getCurrentUser];
//            account = user.objectId;
//        }
        
        NSString *sqlString = [NSString stringWithFormat:@"SELECT photoid, content, createtime, phototime, updatetime, location, photo1, photo2, photo3, photo4, photo5, photo6, photo7, photo8, photo9 FROM %@ WHERE account=? AND photoid=? AND isdeleted=0 ORDER BY createtime DESC", str_TableName_Photo];
        
        FMResultSet * rs = [__db executeQuery:sqlString withArgumentsInArray:@[account, photoid]];
        
        while ([rs next]) {
            
            photo.account = account;
            photo.photoid = [rs stringForColumn:@"photoid"];
            photo.content = [rs stringForColumn:@"content"];
            photo.createtime = [rs stringForColumn:@"createtime"];
            photo.phototime = [rs stringForColumn:@"phototime"];
            photo.updatetime = [rs stringForColumn:@"updatetime"];
            photo.location = [rs stringForColumn:@"location"];
            photo.photoArray = [NSMutableArray array];
            
            NSData *imageData = [rs dataForColumn:@"photo1"];
            if (imageData) {
                
                [photo.photoArray addObject:[UIImage imageWithData:imageData]];
            }
            imageData = [rs dataForColumn:@"photo2"];
            if (imageData) {
                
                [photo.photoArray addObject:[UIImage imageWithData:imageData]];
            }
            imageData = [rs dataForColumn:@"photo3"];
            if (imageData) {
                
                [photo.photoArray addObject:[UIImage imageWithData:imageData]];
            }
            imageData = [rs dataForColumn:@"photo4"];
            if (imageData) {
                
                [photo.photoArray addObject:[UIImage imageWithData:imageData]];
            }
            imageData = [rs dataForColumn:@"photo5"];
            if (imageData) {
                
                [photo.photoArray addObject:[UIImage imageWithData:imageData]];
            }
            imageData = [rs dataForColumn:@"photo6"];
            if (imageData) {
                
                [photo.photoArray addObject:[UIImage imageWithData:imageData]];
            }
            imageData = [rs dataForColumn:@"photo7"];
            if (imageData) {
                
                [photo.photoArray addObject:[UIImage imageWithData:imageData]];
            }
            imageData = [rs dataForColumn:@"photo8"];
            if (imageData) {
                
                [photo.photoArray addObject:[UIImage imageWithData:imageData]];
            }
            imageData = [rs dataForColumn:@"photo9"];
            if (imageData) {
                
                [photo.photoArray addObject:[UIImage imageWithData:imageData]];
            }
            
        }
        [rs close];
        
        return photo;
    }
}

+ (NSString *)getPlanTotalCountByPlantype:(NSString *)plantype {
    
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return nil ;
            }
        }
        
        NSString *account = @"";
//        if ([LogIn isLogin]) {
//            BmobUser *user = [BmobUser getCurrentUser];
//            account = user.objectId;
//        }
        
        NSString *total = @"0";
        NSString *sqlString = [NSString stringWithFormat:@"SELECT COUNT(*) as total FROM %@ WHERE plantype=? AND account=? AND isdeleted=0", str_TableName_Plan];
        
        FMResultSet * rs = [__db executeQuery:sqlString withArgumentsInArray:@[plantype, account]];
        
        if([rs next]) {
            
            total = [rs stringForColumn:@"total"];
        }
        [rs close];
        
        return total;
    }
}

+ (NSString *)getPlanCompletedCountByPlantype:(NSString *)plantype {
    
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return nil ;
            }
        }
        
        NSString *account = @"";
//        if ([LogIn isLogin]) {
//            BmobUser *user = [BmobUser getCurrentUser];
//            account = user.objectId;
//        }
        
        NSString *completed = @"0";
        NSString *sqlString = [NSString stringWithFormat:@"SELECT COUNT(*) as completed FROM %@ WHERE plantype=? AND account=? AND iscompleted=1 AND isdeleted=0", str_TableName_Plan];
        
        FMResultSet * rs = [__db executeQuery:sqlString withArgumentsInArray:@[plantype, account]];
        
        if([rs next]) {
            
            completed = [rs stringForColumn:@"completed"];
        }
        [rs close];
        
        return completed;
    }
}

+ (void)addLocalNotification:(Plan *)plan {
    //时间格式：yyyy-MM-dd HH:mm
    NSDate *date = [CommonFunction NSStringDateToNSDate:plan.notifytime formatter:str_DateFormatter_yyyy_MM_dd_HHmm];
    
    if (!date) return;
    
    NSMutableDictionary *destDic = [NSMutableDictionary dictionary];
    [destDic setObject:plan.planid forKey:@"tag"];
    [destDic setObject:@([date timeIntervalSince1970]) forKey:@"time"];
    [destDic setObject:@(NotificationTypePlan) forKey:@"type"];
    
    [destDic setObject:plan.createtime forKey:@"createtime"];
    [destDic setObject:plan.plantype forKey:@"plantype"];
    [destDic setObject:plan.iscompleted forKey:@"iscompleted"];
    [destDic setObject:plan.completetime forKey:@"completetime"];
    [destDic setObject:plan.content forKey:@"content"];
    [destDic setObject:plan.notifytime forKey:@"notifytime"];
    [LocalNotificationManager createLocalNotification:date userInfo:destDic alertBody:plan.content];
}

+ (void)updateLocalNotification:(Plan *)plan {
    //首先取消该计划的本地所有通知
    [self cancelLocalNotification:plan.planid];
    
    //重新添加新的通知
    [self addLocalNotification:plan];
}

+ (void)cancelLocalNotification:(NSString*)planid {
    //取消该计划的本地所有通知
    NSArray *array = [LocalNotificationManager getNotificationWithTag:planid type:NotificationTypePlan];
    for (UILocalNotification *item in array) {
        [LocalNotificationManager cancelNotification:item];
    }
}

+ (void)setFiveDayNotification {
    
    BOOL hasFiveDayNotification = NO;
    
    NSArray *arry = [LocalNotificationManager getAllLocalNotification];
    //查询是否已经添加过5天未新建计划的提醒
    for (UILocalNotification *item in arry) {
        NSDictionary *sourceN = item.userInfo;
        NSString *tag = [sourceN objectForKey:@"tag"];
        if ([tag longLongValue] == [Notify_FiveDay_Tag longLongValue]) {
            
            hasFiveDayNotification = YES;
            break;
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:str_DateFormatter_yyyy_MM_dd_HHmm];
    NSString *fiveDayLater = [dateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:5 * 24 * 3600]];
    
    Plan *fiveDayPlan = [[Plan alloc] init];
    fiveDayPlan.planid = Notify_FiveDay_Tag;
    fiveDayPlan.createtime = Notify_FiveDay_Time;
    fiveDayPlan.plantype = @"2";
    fiveDayPlan.iscompleted = @"0";
    fiveDayPlan.completetime = Notify_FiveDay_Time;
    fiveDayPlan.content = str_Notify_Tips2;
    fiveDayPlan.notifytime = fiveDayLater;
    
    if (hasFiveDayNotification) {//更新提醒时间
        
        [self updateLocalNotification:fiveDayPlan];
    } else {//新建提醒
        
        [self addLocalNotification:fiveDayPlan];
    }
    
}

+ (void)linkedLocalDataToAccount {
    
    BmobUser *user = [BmobUser getCurrentUser];
    
    BOOL hasRec = NO;
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE account=?", str_TableName_Settings];
    FMResultSet * rs = [__db executeQuery:sqlString withArgumentsInArray:@[@""]];
    hasRec = [rs next];
    [rs close];
    if (hasRec) {
        
        NSString *sqlString = [NSString stringWithFormat:@"UPDATE %@ SET account=? WHERE account=?", str_TableName_Settings];
        
        BOOL b = [__db executeUpdate:sqlString withArgumentsInArray:@[user.objectId, @""]];
     
        FMDBQuickCheck(b, sqlString, __db);
    }
    
    hasRec = NO;
    sqlString = [NSString stringWithFormat:@"SELECT planid FROM %@ WHERE account=?", str_TableName_Plan];
    
    rs = [__db executeQuery:sqlString withArgumentsInArray:@[@""]];
    hasRec = [rs next];
    [rs close];
    if (hasRec) {
        
        sqlString = [NSString stringWithFormat:@"UPDATE %@ SET account=? WHERE account=?", str_TableName_Plan];
        
        BOOL b = [__db executeUpdate:sqlString withArgumentsInArray:@[user.objectId, @""]];
        
        FMDBQuickCheck(b, sqlString, __db);
    }
}

+ (NSArray *)getPlanForSync:(NSString *)syntime {
    
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return nil ;
            }
        }
        
        NSMutableArray *array = [NSMutableArray array];
        
        NSString *account = @"";
        if ([LogIn isLogin]) {
            BmobUser *user = [BmobUser getCurrentUser];
            account = user.objectId;
        } else {
            
            return array;
            
        }
        
        NSString *sqlString = @"";
        if (syntime) {
            sqlString = [NSString stringWithFormat:@"SELECT planid, content, createtime, completetime, updatetime, iscompleted, isnotify, notifytime, plantype, isdeleted FROM %@ WHERE account=? AND updatetime >=?", str_TableName_Plan];
        } else {
            sqlString = [NSString stringWithFormat:@"SELECT planid, content, createtime, completetime, updatetime, iscompleted, isnotify, notifytime, plantype, isdeleted FROM %@ WHERE account=?", str_TableName_Plan];
        }
        
        FMResultSet * rs = syntime == nil ? [__db executeQuery:sqlString withArgumentsInArray:@[account]] : [__db executeQuery:sqlString withArgumentsInArray:@[account, syntime]];
        
        while ([rs next]) {
            
            Plan *plan = [[Plan alloc] init];
            plan.planid = [rs stringForColumn:@"planid"];
            plan.content = [rs stringForColumn:@"content"];
            plan.createtime = [rs stringForColumn:@"createtime"];
            plan.completetime = [rs stringForColumn:@"completetime"];
            plan.updatetime = [rs stringForColumn:@"updatetime"];
            plan.iscompleted = [rs stringForColumn:@"iscompleted"];
            plan.isnotify = [rs stringForColumn:@"isnotify"];
            plan.notifytime = [rs stringForColumn:@"notifytime"];
            plan.plantype = [rs stringForColumn:@"plantype"];
            plan.isdeleted = [rs stringForColumn:@"isdeleted"];
            
            [array addObject:plan];
        }
        [rs close];
        
        return array;
    }
}

+ (Plan *)findPlan:(NSString *)account planid:(NSString *)planid {
    @synchronized(__db) {
        
        if (!__db.open) {
            if (![__db open]) {
                return nil ;
            }
        }
        
        NSString *sqlString = [NSString stringWithFormat:@"SELECT planid, content, createtime, completetime, updatetime, iscompleted, isnotify, notifytime, plantype, isdeleted FROM %@ WHERE account=? AND planid =?", str_TableName_Plan];
        
        FMResultSet * rs = [__db executeQuery:sqlString withArgumentsInArray:@[account, planid]];
        
        Plan *plan = [[Plan alloc] init];
        while ([rs next]) {
            
            plan.account = account;
            plan.planid = [rs stringForColumn:@"planid"];
            plan.content = [rs stringForColumn:@"content"];
            plan.createtime = [rs stringForColumn:@"createtime"];
            plan.completetime = [rs stringForColumn:@"completetime"];
            plan.updatetime = [rs stringForColumn:@"updatetime"];
            plan.iscompleted = [rs stringForColumn:@"iscompleted"];
            plan.isnotify = [rs stringForColumn:@"isnotify"];
            plan.notifytime = [rs stringForColumn:@"notifytime"];
            plan.plantype = [rs stringForColumn:@"plantype"];
            plan.isdeleted = [rs stringForColumn:@"isdeleted"];
            
        }
        [rs close];
        
        return plan;
    }
}

@end
