//
//  PlanCell.h
//  plan
//
//  Created by Fengzy on 15/8/30.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight
} CellState;

extern NSUInteger const kPlanCellHeight;

typedef void(^PlanCellDetailBlock)();

typedef void(^PlanCellCompleteBlock)();

typedef void(^PlanCellDeleteBlock)();

@interface PlanCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, copy) PlanCellDetailBlock detailBlock;
@property (nonatomic, copy) PlanCellCompleteBlock completeBlock;
@property (nonatomic, copy) PlanCellDeleteBlock deleteBlock;

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSString *isCompleted; //1是 0否
@property (nonatomic, strong, readwrite) UIButton *completedButton;
@property (nonatomic, strong, readwrite) UIButton *deleteButton;

@end
