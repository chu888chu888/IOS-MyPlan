//
//  HitView.m
//  plan
//
//  Created by Fengzy on 15/9/12.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#import "HitView.h"

@implementation HitView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([_delegate respondsToSelector:@selector(hitViewHitTest:withEvent:TouchView:)]) {
        return  [_delegate hitViewHitTest:point withEvent:event TouchView:self];
    }
    return nil;
}

@end
