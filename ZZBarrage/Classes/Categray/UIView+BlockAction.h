//
//  UIView+BlockAction.h
//  ZZRandomBarrageExample
//
//  Created by 任强宾 on 2019/3/15.
//  Copyright © 2019 renqiangbin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchAction)(UIView *sender, UITapGestureRecognizer *tap);

@interface UIView (BlockAction)

- (void)setTouchAction:(TouchAction)action;

@end
