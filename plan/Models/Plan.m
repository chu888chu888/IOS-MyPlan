//
//  Plan.m
//  plan
//
//  Created by Fengzy on 15/8/29.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "Plan.h"

NSString *const kPlan_PlanId = @"planid";
NSString *const kPlan_Account = @"account";
NSString *const kPlan_Content = @"content";
NSString *const kPlan_CreateTime = @"createtime";
NSString *const kPlan_CompleteTime = @"completetime";
NSString *const kPlan_UpdateTime = @"updatetime";
NSString *const kPlan_IsCompleted = @"iscompleted";
NSString *const kPlan_PlanType = @"plantype";


@implementation Plan

@synthesize planid = _planid;
@synthesize account = _account;
@synthesize content = _content;
@synthesize createtime = _createtime;
@synthesize completetime = _completetime;
@synthesize updatetime = _updatetime;
@synthesize iscompleted = _iscompleted;
@synthesize plantype = _plantype;


- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]])
    {
        self.planid = [dict objectOrNilForKey:kPlan_PlanId];
        self.account = [dict objectOrNilForKey:kPlan_Account];
        self.content = [dict objectOrNilForKey:kPlan_Content];
        self.createtime = [dict objectOrNilForKey:kPlan_CreateTime];
        self.completetime = [dict objectOrNilForKey:kPlan_CompleteTime];
        self.updatetime = [dict objectOrNilForKey:kPlan_UpdateTime];
        self.iscompleted = [dict objectOrNilForKey:kPlan_IsCompleted];
        self.plantype = [dict objectOrNilForKey:kPlan_PlanType];
    }
    
    return self;
    
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.planid = [aDecoder decodeObjectForKey:kPlan_PlanId];
    self.account = [aDecoder decodeObjectForKey:kPlan_Account];
    self.content = [aDecoder decodeObjectForKey:kPlan_Content];
    self.createtime = [aDecoder decodeObjectForKey:kPlan_CreateTime];
    self.completetime = [aDecoder decodeObjectForKey:kPlan_CompleteTime];
    self.updatetime = [aDecoder decodeObjectForKey:kPlan_UpdateTime];
    self.iscompleted = [aDecoder decodeObjectForKey:kPlan_IsCompleted];
    self.plantype = [aDecoder decodeObjectForKey:kPlan_PlanType];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_planid forKey:kPlan_PlanId];
    [aCoder encodeObject:_account forKey:kPlan_Account];
    [aCoder encodeObject:_content forKey:kPlan_Content];
    [aCoder encodeObject:_createtime forKey:kPlan_CreateTime];
    [aCoder encodeObject:_completetime forKey:kPlan_CompleteTime];
    [aCoder encodeObject:_updatetime forKey:kPlan_UpdateTime];
    [aCoder encodeObject:_iscompleted forKey:kPlan_IsCompleted];
    [aCoder encodeObject:_plantype forKey:kPlan_PlanType];
}

- (id)copyWithZone:(NSZone *)zone
{
    Plan *copy = [[Plan alloc] init];
    
    copy.planid = [self.planid copyWithZone:zone];
    copy.account = [self.account copyWithZone:zone];
    copy.content = [self.content copyWithZone:zone];
    copy.createtime = [self.createtime copyWithZone:zone];
    copy.completetime = [self.completetime copyWithZone:zone];
    copy.updatetime = [self.updatetime copyWithZone:zone];
    copy.iscompleted = [self.iscompleted copyWithZone:zone];
    copy.plantype = [self.plantype copyWithZone:zone];
    
    return copy;
}


@end
