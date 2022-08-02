//
//  ZZBarrageTrack.h
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZBarrageConfig.h"                 // 弹幕配置
#import "ZZBarrageItemObjectProtocol.h"     // 弹幕对象协议
#import "ZZBarrageItemProtocol.h"           // 弹幕单元协议


@interface ZZBarrageTrack : NSObject

/// 弹道的虚拟frame
@property (nonatomic, assign) CGRect frame;
/// 当前正在本弹道展示的弹幕item数组
@property (nonatomic, strong, readonly) NSMutableArray<UIView<ZZBarrageItemProtocol> *> *displayingItems;
/// 是否是可用状态
@property (nonatomic, assign) BOOL available;


/// 自定义配置初始化
/// @param config 配置
- (instancetype)initWithConfig:(ZZBarrageConfig *)config;

/// 启动
- (void)start;

/// 暂停
- (void)pause;

/// 判断当前弹道是否可以立马展示弹幕
/// @param itemObject 弹幕对象
/// @return 是否可以立马展示
- (BOOL)isCanDisplayItemObject:(id<ZZBarrageItemObjectProtocol>)itemObject;

/// 获取弹幕初始的frame
/// @param itemObject 弹幕对象
/// @return frame
- (CGRect)getInitialFrameWithItemObject:(id<ZZBarrageItemObjectProtocol>)itemObject;

/// 添加显示的弹幕item记录
/// @param barrageItem 弹幕item
- (void)addDisplayingItem:(UIView<ZZBarrageItemProtocol> *)barrageItem;

/// 移除显示的弹幕item记录
/// @param barrageItem 弹幕item
- (void)removeDisplayingItem:(UIView<ZZBarrageItemProtocol> *)barrageItem;

/// 清空记录
- (void)clear;

@end
