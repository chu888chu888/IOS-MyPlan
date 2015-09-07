//
//  CommonFunction.m
//  plan
//
//  Created by Fengzy on 15/9/2.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "UIDevice+Util.h"
#import "CommonFunction.h"

@implementation CommonFunction

#pragma mark -获取设备型号 iPhone4、iPhone6 Plus
+ (NSString *)getDeviceType
{
    return [[UIDevice currentDevice] platformString];
}

+ (NSDateComponents *)getDateTime:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    if (date == nil) {
        date = [NSDate date];
    }
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    
    return comps;
}

//NSString转换NSDate
+ (NSDate *)NSStringDateToNSDate:(NSString *)datetime formatter:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:datetime];
    return date;
}

//NSDate转换NSString
+ (NSString *)NSDateToNSString:(NSDate *)datetime formatter:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSString *dateStr = [formatter stringFromDate:datetime];
    return dateStr;
}

@end
