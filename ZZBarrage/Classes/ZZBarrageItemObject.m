//
//  ZZBarrageItemObject.m
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import "ZZBarrageItemObject.h"
#import "ZZBarrageItem.h"

@implementation ZZBarrageItemObject

- (instancetype)init
{
    if (self = [super init]) {
        self.minFrontSpace = 10.0f;
    }
    return self;
}

- (Class)itemClass
{
    // 默认绑定的Item的基类
    return [ZZBarrageItem class];
}

// 绑定的Item的布局大小
- (CGSize)itemSize
{
    // 默认布局大小
    return CGSizeMake(60.0f, 36.0f);
}

// 指定的弹道数组(如果为空，则随机)
- (NSArray <NSNumber *>*)trackIndexArray
{
    return _trackIndexArray;
}

// 距离前面最小间距
- (CGFloat)minFrontSpace
{
    return _minFrontSpace;
}

- (ZZBarrageItemQueuePriority)queuePriority
{
    // 默认优先级: 低
    return ZZBarrageItemQueuePriorityLow;
}

@end
