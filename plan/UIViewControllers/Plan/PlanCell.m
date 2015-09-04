//
//  PlanCell.m
//  plan
//
//  Created by Fengzy on 15/8/30.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "PlanCell.h"

NSUInteger const kPlanCellHeight = 60;
NSUInteger const kPlanCell_ButtonWidth = 60;

@interface PlanCell ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>{
     CellState _cellState;
}

@property (nonatomic, weak) UIScrollView *cellScrollView;
@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, strong, readwrite) UIButton *detailButton;
@property (nonatomic, strong, readwrite) UIView *separatorView;
@property (nonatomic, assign) CGFloat labelOriginX;

@end

@implementation PlanCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];

        UIScrollView *cellScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_FULL_SCREEN, kPlanCellHeight)];
        cellScrollView.contentSize = CGSizeMake(WIDTH_FULL_SCREEN + kPlanCell_ButtonWidth * 2, kPlanCellHeight);
        cellScrollView.contentOffset = CGPointMake(0, 0);
        cellScrollView.delegate = self;
        cellScrollView.showsHorizontalScrollIndicator = NO;
        cellScrollView.layer.borderWidth = .3;
        cellScrollView.layer.borderColor = [color_GrayLight CGColor];
        
        [self addSubview:cellScrollView];
        
        self.cellScrollView = cellScrollView;
        
        {
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(12, 0, WIDTH_FULL_SCREEN - 24, kPlanCellHeight)];
            label.textColor = color_GrayDark;
            [label setFont:font_Normal_20];
            [label setNumberOfLines:1];
            [label setBackgroundColor:[UIColor clearColor]];
            
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [label addGestureRecognizer:tapGestureRecognizer];
            label.userInteractionEnabled = YES;
            
            [self.cellScrollView addSubview:label];
            
            self.contentLabel = label;
        }
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_FULL_SCREEN, 0, kPlanCell_ButtonWidth, kPlanCellHeight)];
            [button setAllBackgroundImage:[UIImage imageNamed:png_Btn_Plan_Delete]];
            [button addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.cellScrollView addSubview:button];
            
            self.deleteButton = button;
        }
        
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_FULL_SCREEN + kPlanCell_ButtonWidth, 0, kPlanCell_ButtonWidth, kPlanCellHeight)];
            if ([self.isCompleted isEqualToString:@"1"]) {
                [button setAllBackgroundImage:[UIImage imageNamed:png_Btn_Plan_Doing]];
            } else {
                [button setAllBackgroundImage:[UIImage imageNamed:png_Btn_Plan_Completed]];
            }
            [button addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.cellScrollView addSubview:button];
            
            self.completedButton = button;
        }
    }
    return self;
}

- (void)setIsCompleted:(NSString *)isCompleted
{
    if ([isCompleted isEqualToString:@"1"]) {
        [self.completedButton setAllBackgroundImage:[UIImage imageNamed:png_Btn_Plan_Doing]];
    } else {
        [self.completedButton setAllBackgroundImage:[UIImage imageNamed:png_Btn_Plan_Completed]];
    }
}

- (void)detailAction:(UIButton *)button{
    if (self.detailBlock) {
        self.detailBlock();
    }
}

- (void)finishAction:(UIButton *)button{
    if (self.completeBlock) {

        [self backToCenter];
        self.completeBlock();
    }
}

- (void)deleteAction:(UIButton *)button{
    if (self.deleteBlock) {
        
        [self backToCenter];
        self.deleteBlock();
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tapRecognizer{
    
    if (_cellState == kCellStateRight) {
        
        [self backToCenter];
    } else {
        
        if (self.detailBlock) {
            self.detailBlock();
        }
    }
}

- (void)backToCenter
{
    self.cellScrollView.contentOffset = CGPointMake(0, 0);
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    switch (_cellState) {
        case kCellStateCenter:
            if (velocity.x >= 0.5f) {
                [self scrollToRight:targetContentOffset];
            } else {

                if (targetContentOffset->x > kPlanCell_ButtonWidth)
                    [self scrollToRight:targetContentOffset];
                else
                    [self scrollToCenter:targetContentOffset];
            }
            break;
        case kCellStateRight:
            if (velocity.x >= 0.5f) {
                //
            } else {
                if (targetContentOffset->x < kPlanCell_ButtonWidth)
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToRight:targetContentOffset];
            }
            break;
        default:
            break;
    }
}

- (void)scrollToRight:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = kPlanCell_ButtonWidth * 2;
    _cellState = kCellStateRight;
}

- (void)scrollToCenter:(inout CGPoint *)targetContentOffset {
    targetContentOffset->x = 0;
    _cellState = kCellStateCenter;
}

@end
