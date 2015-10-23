//
//  Settings.h
//  plan
//
//  Created by Fengzy on 15/8/29.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "ModelBase.h"

@interface Settings : ModelBase <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *gender; //性别：1男 0女
@property (nonatomic, strong) NSString *lifespan;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, strong) NSString *avatarURL;
@property (nonatomic, strong) NSString *syntime;
@property (nonatomic, strong) NSString *updatetime;

@end
