//
//  ZZBarrageTrack.m
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import "ZZBarrageTrack.h"          

@interface ZZBarrageTrack ()

@property (nonatomic, strong) NSMutableArray<ZZBarrageItemTuple *> *displayingItemTuples;
@property (nonatomic, strong) ZZBarrageConfig *config;

@end

@implementation ZZBarrageTrack


#pragma mark - public

- (instancetype)initWithConfig:(ZZBarrageConfig *)config {
    
    if (self = [super init]) {
        self.config = config;
    }
    return self;
}


/// 启动
- (void)start {
    
    if (_available) {
        return;
    }
    self.available = YES;
    for (ZZBarrageItemTuple *itemTuple in _displayingItemTuples) {
        UIView *itemView = itemTuple.itemView;
        CALayer *layer = itemView.layer;
        CFTimeInterval pausedTime = [layer timeOffset];
        layer.speed = 1.0;
        layer.timeOffset = 0.0;
        layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        layer.beginTime = timeSincePause;
    }
}


/// 暂停
- (void)pause {
    
    if (!_available) {
        return;
    }
    self.available = NO;
    for (ZZBarrageItemTuple *itemTuple in _displayingItemTuples) {
        UIView *itemView = itemTuple.itemView;
        CALayer *layer = itemView.layer;
        CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
        layer.speed = 0.0;
        layer.timeOffset = pausedTime;
    }
}


/// 判断当前弹道是否可以立马展示弹幕
/// @param itemObject 弹幕对象
/// @param additionalHorSpace 附加水平间距
/// @return 是否可以立马展示
- (BOOL)isCanDisplayItemObject:(id<ZZBarrageItemObjectProtocol>)itemObject additionalHorSpace:(CGFloat)additionalHorSpace {
    
    if (!_available) {
        return NO;
    }
    CGFloat right = [self getCurrentDisplayingItemsRight];
    CGFloat minHorSpace = self.config.minHorSpace + additionalHorSpace;
    if (right + minHorSpace > self.frame.size.width) {
        return NO;
    }
    return YES;
}


/// 获取弹幕初始的frame
/// @param itemObject 弹幕对象
/// @return frame
- (CGRect)getInitialFrameWithItemObject:(id<ZZBarrageItemObjectProtocol>)itemObject {
    
    CGSize itemSize = CGSizeMake(0, 0);
    if ([itemObject respondsToSelector:@selector(itemSize)]) {
        itemSize = itemObject.itemSize;
    }
    CGFloat x = self.frame.size.width;
    // 默认居中
    CGFloat y = self.frame.origin.y + (self.frame.size.height - itemSize.height) / 2.0;
    // 如果有间距差，则在可随机范围内随机出y值
    if (self.config.verSpaceDiff > 0) {
        // 先判断是否有可浮动的垂直空间
        CGFloat yDiff = (self.frame.size.height - itemSize.height) - self.config.minVerSpace;
        if (yDiff > 0) {
            yDiff = (arc4random() % 1000) / 999.0 * MIN(yDiff, self.config.verSpaceDiff) / 2.0;
            CGFloat additionalVerSpace = (arc4random() % 2) > 0 ? yDiff : -yDiff;
            y = y + additionalVerSpace;
        }
    }
    return CGRectMake(x, y, itemSize.width, itemSize.height);
}


/// 添加显示的弹幕item记录
/// @param itemTuple 弹幕元组
- (void)addDisplayingItemTuple:(ZZBarrageItemTuple *)itemTuple {
    
    [self.displayingItemTuples addObject:itemTuple];
}


/// 移除显示的弹幕item记录
/// @param itemTuple 弹幕元组
- (void)removeDisplayingItemTuple:(ZZBarrageItemTuple *)itemTuple {
    
    [self.displayingItemTuples removeObject:itemTuple];
}


/// 清空记录
- (void)clear {
    
    [self.displayingItemTuples removeAllObjects];
}


#pragma mark - private


/// 获取当前展示的多个或者一个弹幕整体右侧位置
- (CGFloat)getCurrentDisplayingItemsRight {
    
    CGFloat right = 0;
    for (ZZBarrageItemTuple *itemTuple in _displayingItemTuples) {
        UIView *itemView = itemTuple.itemView;
        CGRect itemFrame = itemView.layer.presentationLayer.frame;
        CGFloat frameRight = itemFrame.origin.x + itemFrame.size.width;
        if (frameRight > right) {
            right = frameRight;
        }
    }
    return right;
}

#pragma mark - getter

- (NSMutableArray<ZZBarrageItemTuple *> *)displayingItemTuples {
    
    if (!_displayingItemTuples) {
        self.displayingItemTuples = [NSMutableArray array];
    }
    return _displayingItemTuples;
}

@end
