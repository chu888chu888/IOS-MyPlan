//
//  CommonFunction.h
//  plan
//
//  Created by Fengzy on 15/9/2.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonFunction : NSObject

//获取设备型号 iPhone4、iPhone6 Plus
+ (NSString *)getDeviceType;

//获取iOS系统版本号
+ (NSString *)getiOSVersion;

//获取当前时间字符串：yyyy-MM-dd HH:mm:ss
+ (NSString *)getTimeNowString;

+ (NSDateComponents *)getDateTime:(NSDate *)date;

//判断是否为空白字符串
+ (BOOL)isEmptyString:(NSString *)original;

//压缩图片
+ (UIImage *)compressImage:(UIImage *)image;

//NSString转换NSDate
+ (NSDate *)NSStringDateToNSDate:(NSString *)datetime formatter:(NSString *)format;

//NSDate转换NSString
+ (NSString *)NSDateToNSString:(NSDate *)datetime formatter:(NSString *)format;

@end
