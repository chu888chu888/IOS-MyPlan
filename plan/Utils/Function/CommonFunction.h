//
//  CommonFunction.h
//  plan
//
//  Created by Fengzy on 15/9/2.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonFunction : NSObject

+ (NSString *)getDeviceType;

+ (NSDateComponents *)getDateTime:(NSDate *)date;

+ (NSDate *)NSStringDateToNSDate:(NSString *)datetime formatter:(NSString *)format;

@end
