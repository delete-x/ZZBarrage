//
//  ZZBarrageBBItemObject.m
//  ZZBarrage_Example
//
//  Created by 任强宾 on 2022/8/2.
//  Copyright © 2022 QB_Share. All rights reserved.
//

#import "ZZBarrageBBItemObject.h"
#import "ZZBarrageBBItem.h"

@implementation ZZBarrageBBItemObject

// 绑定的弹幕item视图的类名
- (Class<ZZBarrageItemViewProtocol>)itemClass {
    
    return [ZZBarrageBBItem class];
}

// 绑定的弹幕item视图的布局大小
- (CGSize)itemSize {
    
    return CGSizeMake(100, 30);
}

// 排队优先级
- (ZZBarrageItemQueuePriority)queuePriority {
    
    return ZZBarrageItemQueuePriorityHigh;
}

@end
