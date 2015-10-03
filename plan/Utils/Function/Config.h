//
//  Config.h
//  plan
//
//  Created by Fengzy on 15/8/28.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "Settings.h"
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, OperationType) {
    Add = 1,
    Edit,
    Delete,
};

@interface Config : NSObject

@property (nonatomic, strong) Settings *settings;

+(instancetype)shareInstance;

//保存用户头像到本地缓存
- (void)saveAvatar:(UIImage *)image;
//获取用户本地缓存头像
- (UIImage *)getAvatar;

//获取app当前版本号
- (NSString *)appVersion;

@end
