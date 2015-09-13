//
//  PlanCell.h
//  plan
//
//  Created by Fengzy on 15/9/12.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "Plan.h"
#import <UIKit/UIKit.h>

extern NSUInteger const kPlanCellHeight;

@protocol PlanCellDelegate <NSObject>

-(void)didCellWillHide:(id)aSender;
-(void)didCellHided:(id)aSender;
-(void)didCellWillShow:(id)aSender;
-(void)didCellShowed:(id)aSender;
-(void)didCellClicked:(id)aSender;
-(void)didCellClickedDoneButton:(id)aSender;
-(void)didCellClickedDeleteButton:(id)aSender;

@end

@interface PlanCell : UITableViewCell<UIGestureRecognizerDelegate>
{
    CGFloat startLocation;
    BOOL    hideMenuView;
}

@property (nonatomic, strong) IBOutlet UIView *moveContentView;
@property (nonatomic, assign) id<PlanCellDelegate> delegate;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSString *isDone; //1是 0否
@property (nonatomic, strong) Plan *plan;

-(void)hideMenuView:(BOOL)aHide Animated:(BOOL)aAnimate;
-(void)addControl;

@end
