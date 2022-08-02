//
//  ZZBarrageTrack.m
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import "ZZBarrageTrack.h"          

@interface ZZBarrageTrack ()

@property (nonatomic, strong) NSMutableArray<UIView<ZZBarrageItemProtocol> *> *displayingItems;
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
    for (UIView *itemView in _displayingItems) {
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
    for (UIView *itemView in _displayingItems) {
        CALayer *layer = itemView.layer;
        CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
        layer.speed = 0.0;
        layer.timeOffset = pausedTime;
    }
}


/// 判断当前弹道是否可以立马展示弹幕
/// @param itemObject 弹幕对象
/// @return 是否可以立马展示
- (BOOL)isCanDisplayItemObject:(id<ZZBarrageItemObjectProtocol>)itemObject {
    
    if (!_available) {
        return NO;
    }
    CGFloat right = [self getCurrentDisplayingItemsRight];
    CGFloat minFrontSpace = self.config.defaultMinFrontSpace;
    if ([itemObject respondsToSelector:@selector(minFrontSpace)]) {
        minFrontSpace = itemObject.minFrontSpace;
    }
    if (right + minFrontSpace > self.frame.size.width) {
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
    CGFloat y = self.frame.origin.y + (self.frame.size.height - itemSize.height) / 2.0;
    return CGRectMake(x, y, itemSize.width, itemSize.height);
}


/// 添加显示的弹幕item记录
/// @param barrageItem 弹幕item
- (void)addDisplayingItem:(UIView<ZZBarrageItemProtocol> *)barrageItem {
    
    [self.displayingItems addObject:barrageItem];
}


/// 移除显示的弹幕item记录
/// @param barrageItem 弹幕item
- (void)removeDisplayingItem:(UIView<ZZBarrageItemProtocol> *)barrageItem {
    
    [self.displayingItems removeObject:barrageItem];
}


- (void)clear {
    
    [self.displayingItems removeAllObjects];
}


#pragma mark - private


/// 获取当前展示的多个或者一个弹幕整体右侧位置
- (CGFloat)getCurrentDisplayingItemsRight {
    
    CGFloat right = 0;
    for (UIView *itemView in _displayingItems) {
        CGRect itemFrame = itemView.layer.presentationLayer.frame;
        CGFloat frameRight = itemFrame.origin.x + itemFrame.size.width;
        if (frameRight > right) {
            right = frameRight;
        }
    }
    return right;
}

#pragma mark - getter

- (NSMutableArray<UIView<ZZBarrageItemProtocol> *> *)displayingItems {
    
    if (!_displayingItems) {
        self.displayingItems = [NSMutableArray array];
    }
    return _displayingItems;
}

@end
