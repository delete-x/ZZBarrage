//
//  UIView+BlockAction.m
//  ZZRandomBarrageExample
//
//  Created by 任强宾 on 2019/3/15.
//  Copyright © 2019 renqiangbin. All rights reserved.
//

#import "UIView+BlockAction.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic, copy) TouchAction tapTouchAction;

@end

static void *keyTouchAction = &keyTouchAction;

@implementation UIView (BlockAction)

#pragma mark - setter getter
- (void)setTapTouchAction:(TouchAction)tapTouchAction
{
    objc_setAssociatedObject(self, &keyTouchAction, tapTouchAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (TouchAction)tapTouchAction
{
    return objc_getAssociatedObject(self, &keyTouchAction);
}

- (void)setTouchAction:(TouchAction)touchAction
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    self.tapTouchAction = touchAction;
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if (self.tapTouchAction) {
        self.tapTouchAction(tap.view, tap);
    }
}

@end
