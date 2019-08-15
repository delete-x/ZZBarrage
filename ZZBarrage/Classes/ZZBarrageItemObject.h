//
//  ZZBarrageItemObject.h
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZBarrageItemObjectProtocol.h"

/*
 弹幕的ItemObject的基类
 */
@interface ZZBarrageItemObject : NSObject <ZZBarrageItemObjectProtocol>

// 指定的弹道数组(如果为空，则随机)
@property (nonatomic, strong) NSArray<NSNumber *> *trackIndexArray;
@property (nonatomic, assign) CGFloat minFrontSpace;

@end
