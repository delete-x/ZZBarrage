//
//  ZZBarrageAAItemObject.m
//  ZZBarrage_Example
//
//  Created by 任强宾 on 2022/8/2.
//  Copyright © 2022 QB_Share. All rights reserved.
//

#import "ZZBarrageAAItemObject.h"
#import "ZZBarrageAAItem.h"

@implementation ZZBarrageAAItemObject

// 绑定的弹幕item视图的类名
- (Class<ZZBarrageItemProtocol>)itemClass {
    
    return [ZZBarrageAAItem class];
}

// 绑定的弹幕item视图的布局大小
- (CGSize)itemSize {
    
    return CGSizeMake(80, 40);
}

// 距离前面弹幕item视图的最小间距
- (CGFloat)minFrontSpace {
    
    return 10;
}

@end
