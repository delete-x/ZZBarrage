//
//  ZZBarrageItemProtocol.h
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZBarrageItemObject.h"

@class ZZBarrageRenderView;

typedef void(^ZZBarrageItemRemoveHandler)(void);
/*
 弹幕item协议
 */
@protocol ZZBarrageItemProtocol <NSObject>

@required
/**
 根据object更新item
 @param object    弹幕Item object
 */
- (void)shouldUpdateItemWithObject:(ZZBarrageItemObject *)object;

/**
 新的item已经添加
 @param barrageView    弹幕View
 @param contentView    装载弹幕Item的容器视图
 @param object         弹幕Item object
 @param removeHandler  弹幕Item移除操作
 */
- (void)barrageView:(ZZBarrageRenderView *)barrageView itemDidAddedOnContentView:(UIView *)contentView object:(ZZBarrageItemObject *)object removeHandler:(ZZBarrageItemRemoveHandler)removeHandler;

/**
 是否响应点击事件
 */
- (BOOL)responseTapGesture:(UITapGestureRecognizer *)tap;

@end
