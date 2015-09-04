//
//  AddPlanViewController.h
//  plan
//
//  Created by Fengzy on 15/8/30.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "Plan.h"
#import "FatherViewController.h"

typedef void(^FinishBlock)();

@interface AddPlanViewController : FatherViewController

@property (nonatomic, copy) FinishBlock finishBlock;
@property (nonatomic, assign) PlanType planType;
@property (nonatomic, assign) OperationType operationType;
@property (nonatomic, strong) Plan *plan;

@end
