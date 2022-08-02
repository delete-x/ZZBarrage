//
//  ZZBarrageItemObjectProtocol.h
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZZBarrageItemProtocol;

typedef NS_ENUM(NSUInteger, ZZBarrageItemQueuePriority)
{
    ZZBarrageItemQueuePriorityLow = 1 << 0,
    ZZBarrageItemQueuePriorityHigh = 1 << 1
};

/*
 弹幕对象协议
 */
@protocol ZZBarrageItemObjectProtocol <NSObject>

@required

// 绑定的弹幕item视图的类名
- (Class<ZZBarrageItemProtocol>)itemClass;

// 绑定的弹幕item视图的布局大小
- (CGSize)itemSize;

@optional

// 距离前面弹幕item视图的最小间距
- (CGFloat)minFrontSpace;

// 指定的弹道下标数组(如果为空，则在所有弹道中随机；否则只在指定弹道中随机)
- (NSArray <NSNumber *>*)trackIndexArray;

// 排队优先级
- (ZZBarrageItemQueuePriority)queuePriority;

@end
