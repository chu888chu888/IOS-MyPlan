//
//  PlanCell.m
//  plan
//
//  Created by Fengzy on 15/9/12.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "PlanCell.h"


NSUInteger const kPlanCellHeight = 60;
NSUInteger const kBounceSpace = 20;

@implementation PlanCell {
    
    UIButton *doneButton;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (_moveContentView == nil) {
            _moveContentView = [[UIView alloc] init];
            _moveContentView.backgroundColor = [UIColor whiteColor];
        }
        [self.contentView addSubview:_moveContentView];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addControl];
        
    }
    return self;
    
}

- (void)awakeFromNib {
    
    [self addControl];
    
}

- (void)addControl {
    
    UIView *menuContetnView = [[UIView alloc] init];
    menuContetnView.hidden = YES;
    menuContetnView.tag = 100;
    
    UIButton *vDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vDoneButton setAllBackgroundImage:[UIImage imageNamed:png_Btn_Plan_Done]];
    [vDoneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [vDoneButton setTag:1001];
    
    doneButton = vDoneButton;
    
    UIButton *vDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vDeleteButton setAllBackgroundImage:[UIImage imageNamed:png_Btn_Plan_Delete]];
    [vDeleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [vDeleteButton setTag:1002];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, WIDTH_FULL_SCREEN - 24, kPlanCellHeight)];
    _contentLabel.textColor = color_GrayDark;
    [_contentLabel setFont:font_Normal_20];
    [_contentLabel setNumberOfLines:1];
    [_contentLabel setBackgroundColor:[UIColor clearColor]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didContentClicked:)];
    [_contentLabel addGestureRecognizer:tapGestureRecognizer];
    _contentLabel.userInteractionEnabled = YES;
    
    [menuContetnView addSubview:vDoneButton];
    [menuContetnView addSubview:vDeleteButton];
    [_moveContentView addSubview:_contentLabel];
    [self.contentView insertSubview:menuContetnView atIndex:0];
    
    UIPanGestureRecognizer *vPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    vPanGesture.delegate = self;
    [self.contentView addGestureRecognizer:vPanGesture];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];

    [_moveContentView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    UIView *vMenuView = [self.contentView viewWithTag:100];
    vMenuView.frame =CGRectMake(self.frame.size.width - kPlanCellHeight * 2, 0, kPlanCellHeight * 2, self.frame.size.height);
    
    UIView *vDoneButton = [self.contentView viewWithTag:1001];
    vDoneButton.frame = CGRectMake(kPlanCellHeight, 0, kPlanCellHeight, self.frame.size.height);
    UIView *vMoreButton = [self.contentView viewWithTag:1002];
    vMoreButton.frame = CGRectMake(0, 0, kPlanCellHeight, self.frame.size.height);
    
}

//此方法和下面的方法很重要,对ios 5SDK 设置不被Helighted
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    UIView *vMenuView = [self.contentView viewWithTag:100];
    if (vMenuView.hidden == YES) {
        [super setSelected:selected animated:animated];
    }
    
}

//此方法和上面的方法很重要，对ios 5SDK 设置不被Helighted
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    UIView *vMenuView = [self.contentView viewWithTag:100];
    if (vMenuView.hidden == YES) {
        [super setHighlighted:highlighted animated:animated];
    }
    
}

- (void)prepareForReuse {
    
    self.contentView.clipsToBounds = YES;
    [self hideMenuView:YES Animated:NO];
    
}


- (CGFloat)getMaxMenuWidth {
    
    return kPlanCellHeight * 2;
    
}

- (void)enableSubviewUserInteraction:(BOOL)enable {
    
    if (enable) {
        
        for (UIView *aSubView in self.contentView.subviews) {
            
            aSubView.userInteractionEnabled = YES;
            
        }
        
    } else {
        
        for (UIView *aSubView in self.contentView.subviews) {
            
            UIView *vDoneButtonView = [self.contentView viewWithTag:100];
            if (aSubView != vDoneButtonView) {
                
                aSubView.userInteractionEnabled = NO;
                
            }
        }
    }
}

- (void)hideMenuView:(BOOL)hidden Animated:(BOOL)animated {
    
    if (self.selected) {
        
        [self setSelected:NO animated:NO];
        
    }
    CGRect vDestinaRect = CGRectZero;
    if (hidden) {
        
        vDestinaRect = self.contentView.frame;
        [self enableSubviewUserInteraction:YES];
        
    } else {
        
        vDestinaRect = CGRectMake(-[self getMaxMenuWidth], self.contentView.frame.origin.x, self.contentView.frame.size.width, self.contentView.frame.size.height);
        [self enableSubviewUserInteraction:NO];
        
    }
    
    CGFloat vDuration = animated ? 0.4 : 0.0;
    [UIView animateWithDuration:vDuration animations: ^{
        
        _moveContentView.frame = vDestinaRect;
        
    } completion:^(BOOL finished) {
        
        if (hidden) {
            
            if ([_delegate respondsToSelector:@selector(didCellHided:)]) {
                
                [_delegate didCellHided:self];
                
            }
            
        } else {
            
            if ([_delegate respondsToSelector:@selector(didCellShowed:)]) {
                
                [_delegate didCellShowed:self];
                
            }
        }
        UIView *vMenuView = [self.contentView viewWithTag:100];
        vMenuView.hidden = hidden;
    }];
    
}


- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        CGPoint vTranslationPoint = [gestureRecognizer translationInView:self.contentView];
        return fabs(vTranslationPoint.x) > fabs(vTranslationPoint.y);
        
    }
    return YES;
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        startLocation = [sender locationInView:self.contentView].x;
        CGFloat direction = [sender velocityInView:self.contentView].x;
        if (direction < 0) {
            
            if ([_delegate respondsToSelector:@selector(didCellWillShow:)]) {
                
                [_delegate didCellWillShow:self];
                
            }
            
        } else {
            
            if ([_delegate respondsToSelector:@selector(didCellWillHide:)]) {
                
                [_delegate didCellWillHide:self];
                
            }
        }
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        CGFloat vCurrentLocation = [sender locationInView:self.contentView].x;
        CGFloat vDistance = vCurrentLocation - startLocation;
        startLocation = vCurrentLocation;
        
        CGRect vCurrentRect = _moveContentView.frame;
        CGFloat vOriginX = MAX(-[self getMaxMenuWidth] - kBounceSpace, vCurrentRect.origin.x + vDistance);
        vOriginX = MIN(0 + kBounceSpace, vOriginX);
        _moveContentView.frame = CGRectMake(vOriginX, vCurrentRect.origin.y, vCurrentRect.size.width, vCurrentRect.size.height);
        
        CGFloat direction = [sender velocityInView:self.contentView].x;

        if (direction < - 30.0 || vOriginX <  - (0.5 * [self getMaxMenuWidth])) {
            
            hideMenuView = NO;
            UIView *vMenuView = [self.contentView viewWithTag:100];
            vMenuView.hidden = hideMenuView;
            
        } else if (direction > 20.0 || vOriginX >  - (0.5 * [self getMaxMenuWidth])) {
            
            hideMenuView = YES;
            
        }
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        [self hideMenuView:hideMenuView Animated:YES];
        
    }
}

- (void)setIsDone:(NSString *)isDone {
    
    if ([isDone isEqualToString:@"1"]) {
        
        [doneButton setAllBackgroundImage:[UIImage imageNamed:png_Btn_Plan_Doing]];
        
    } else {
        
        [doneButton setAllBackgroundImage:[UIImage imageNamed:png_Btn_Plan_Done]];
        
    }
}

- (void)didContentClicked:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(didCellClicked:)]) {
        
        [_delegate didCellClicked:self];
        
    }
}

- (void)deleteButtonClicked:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(didCellClickedDeleteButton:)]) {
        
        [_delegate didCellClickedDeleteButton:self];
        
    }
}

- (void)doneButtonClicked:(id)sender {
    
    [self.superview sendSubviewToBack:self];
    if ([_delegate respondsToSelector:@selector(didCellClickedDoneButton:)]) {
        
        [_delegate didCellClickedDoneButton:self];
        
    }
    
}


@end
