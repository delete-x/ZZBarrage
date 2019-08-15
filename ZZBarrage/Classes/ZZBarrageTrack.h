//
//  ZZBarrageTrack.h
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZBarrageConfig.h"             // 弹幕配置
#import "ZZBarrageItemObject.h"         // 弹幕单元Object
#import "ZZBarrageItem.h"               // 弹幕Item

@interface ZZBarrageTrack : NSObject

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong, readonly) NSMutableArray<ZZBarrageItem *> *displayingItems;

/**
 自定义配置初始化
 @param config        配置
 */
- (instancetype)initWithConfig:(ZZBarrageConfig *)config;

/**
 判断当前弹道是否可以立马展示弹幕单元
 @return 是否可以立马展示
 */
- (BOOL)isCanDisplayItemObject:(ZZBarrageItemObject *)itemObject;

/**
 获取一个初始的frame
 @param itemObject    弹幕单元对象
 @return 初始的frame
 */
- (CGRect)getInitialFrameWithItemObject:(ZZBarrageItemObject *)itemObject;

- (void)addDisplayingItem:(ZZBarrageItem *)barrageItem;
- (void)removeDisplayingItem:(ZZBarrageItem *)barrageItem;



/**
 判断当前弹道是否可以容纳一个尺寸
 @param aSize   一个尺寸
 @return 是否可以容纳
 */
- (BOOL)isCanHoldSize:(CGSize)aSize;

/**
 获取一个合适的frameValue
 @param itemObject    弹幕单元对象
 @return 合适的frameValue
 */
- (NSValue *)getSuitableFrameWithItemObject:(ZZBarrageItemObject *)itemObject;

/*
 移除frameValue
 @param frameValue    需要移除的frameValue
 */
- (void)removeItemFrameValue:(NSValue *)frameValue;

/**
 清空记录
 */
- (void)clear;

@end
