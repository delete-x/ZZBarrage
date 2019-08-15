//
//  ZZBarrageItem.m
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import "ZZBarrageItem.h"

@implementation ZZBarrageItem

- (void)shouldUpdateItemWithObject:(ZZBarrageItemObject *)object {};

- (void)barrageView:(ZZBarrageRenderView *)barrageView itemDidAddedOnContentView:(UIView *)contentView object:(ZZBarrageItemObject *)object removeHandler:(ZZBarrageItemRemoveHandler)removeHandler
{
    // 默认: 3秒后移除item
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        removeHandler();
    });
}

/**
 是否响应点击事件
 */
- (BOOL)responseTapGesture:(UITapGestureRecognizer *)tap
{
    return YES;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect presentingRect = self.frame;
    //如果不在动画中则presentationLayer为空，在动画中就需要实时的判断点击是否点中动画中的动画
    if (self.layer.presentationLayer) {
        presentingRect = self.layer.presentationLayer.frame;
        
    }
    CGPoint superPoint = [self convertPoint:point toView:self.superview];
    BOOL isInside = CGRectContainsPoint(presentingRect, superPoint);
    NSLog(@"%@", isInside ? @"YES" : @"NO");
    return isInside;
}

@end
