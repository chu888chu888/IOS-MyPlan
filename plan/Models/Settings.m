//
//  Settings.m
//  plan
//
//  Created by Fengzy on 15/8/29.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "Settings.h"

NSString *const kSettings_Account = @"account";
NSString *const kSettings_NickName = @"nickname";
NSString *const kSettings_Birthday = @"birthday";
NSString *const kSettings_Email = @"email";
NSString *const kSettings_Gender = @"gender";
NSString *const kSettings_Lifespan = @"lifespan";
NSString *const kSettings_Password = @"password";


@implementation Settings

@synthesize account = _account;
@synthesize nickname = _nickname;
@synthesize birthday = _birthday;
@synthesize email = _email;
@synthesize gender = _gender;
@synthesize lifespan = _lifespan;
@synthesize password = _password;


- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.account = [dict objectOrNilForKey:kSettings_Account];
        self.nickname = [dict objectOrNilForKey:kSettings_NickName];
        self.birthday = [dict objectOrNilForKey:kSettings_Birthday];
        self.email = [dict objectOrNilForKey:kSettings_Email];
        self.gender = [dict objectOrNilForKey:kSettings_Gender];
        self.lifespan = [dict objectOrNilForKey:kSettings_Lifespan];
        self.password = [dict objectOrNilForKey:kSettings_Password];
    }
    
    return self;
    
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    self.account = [aDecoder decodeObjectForKey:kSettings_Account];
    self.nickname = [aDecoder decodeObjectForKey:kSettings_NickName];
    self.birthday = [aDecoder decodeObjectForKey:kSettings_Birthday];
    self.email = [aDecoder decodeObjectForKey:kSettings_Email];
    self.gender = [aDecoder decodeObjectForKey:kSettings_Gender];
    self.lifespan = [aDecoder decodeObjectForKey:kSettings_Lifespan];
    self.password = [aDecoder decodeObjectForKey:kSettings_Password];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_account forKey:kSettings_Account];
    [aCoder encodeObject:_nickname forKey:kSettings_NickName];
    [aCoder encodeObject:_birthday forKey:kSettings_Birthday];
    [aCoder encodeObject:_email forKey:kSettings_Email];
    [aCoder encodeObject:_gender forKey:kSettings_Gender];
    [aCoder encodeObject:_lifespan forKey:kSettings_Lifespan];
    [aCoder encodeObject:_password forKey:kSettings_Password];
}

- (id)copyWithZone:(NSZone *)zone {
    Settings *copy = [[Settings alloc] init];
    
    copy.account = [self.account copyWithZone:zone];
    copy.nickname = [self.nickname copyWithZone:zone];
    copy.birthday = [self.birthday copyWithZone:zone];
    copy.email = [self.email copyWithZone:zone];
    copy.gender = [self.gender copyWithZone:zone];
    copy.lifespan = [self.lifespan copyWithZone:zone];
    copy.password = [self.password copyWithZone:zone];
    
    return copy;
}

@end