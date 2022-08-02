//
//  ZZBarrageItemProtocol.h
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZBarrageItemObjectProtocol.h"     // 弹幕对象协议

@class ZZBarrageRenderView;

typedef void(^ZZBarrageItemRemoveHandler)(void);
/*
 弹幕item协议
 */
@protocol ZZBarrageItemProtocol <NSObject>

@required

/// 根据object更新item视图
/// @param object 弹幕对象
- (void)shouldUpdateItemWithObject:(id<ZZBarrageItemObjectProtocol>)object;


/// 新的item刚刚添加到父视图，此处用来自定义浮动动画
/// @param barrageView 弹幕View
/// @param contentView 装载弹幕Item的容器视图
/// @param trackIndex 弹道坐标
/// @param object 弹幕对象
/// @param removeHandler 弹幕Item的移除操作
- (void)barrageView:(ZZBarrageRenderView *)barrageView itemDidAddedOnContentView:(UIView *)contentView trackIndex:(NSUInteger)trackIndex object:(id<ZZBarrageItemObjectProtocol>)object removeHandler:(ZZBarrageItemRemoveHandler)removeHandler;


/// 是否响应点击事件
/// @param tap 单击手势
- (BOOL)responseTapGesture:(UITapGestureRecognizer *)tap;

@end
