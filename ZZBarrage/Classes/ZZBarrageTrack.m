//
//  ZZBarrageTrack.m
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import "ZZBarrageTrack.h"          // 虚拟弹道

@interface ZZBarrageTrack ()

@property (nonatomic, strong) NSMutableArray<ZZBarrageItem *> *displayingItems;
@property (nonatomic, strong) ZZBarrageConfig *config;
@property (nonatomic, strong) NSMutableArray *itemFrameArray;

@end

@implementation ZZBarrageTrack

#pragma mark - public
- (instancetype)initWithConfig:(ZZBarrageConfig *)config
{
    if (self = [super init]) {
        self.config = config;
    }
    return self;
}

/**
 判断当前弹道是否可以立马展示弹幕单元
 @return 是否可以立马展示
 */
- (BOOL)isCanDisplayItemObject:(ZZBarrageItemObject *)itemObject
{
    if (_displayingItems.count > 0) {
        ZZBarrageItem *item = [_displayingItems lastObject];
        if (item.layer.presentationLayer) {
            CGRect itemFrame = item.layer.presentationLayer.frame;
            if (self.frame.size.width < (itemFrame.origin.x + itemFrame.size.width + itemObject.minFrontSpace)) {
                return NO;
            }
        } else {
            return NO;
        }
    }
    return YES;
}

/**
 获取一个初始的frame
 @param itemObject    弹幕单元对象
 @return 初始的frame
 */
- (CGRect)getInitialFrameWithItemObject:(ZZBarrageItemObject *)itemObject
{
    CGSize itemSize = [itemObject itemSize];
    CGFloat x = self.frame.size.width;
    CGFloat y = self.frame.origin.y + (self.frame.size.height - itemSize.height) / 2.0;
    return CGRectMake(x, y, itemSize.width, itemSize.height);
}

- (void)addDisplayingItem:(ZZBarrageItem *)barrageItem
{
    [self.displayingItems addObject:barrageItem];
}

- (void)removeDisplayingItem:(ZZBarrageItem *)barrageItem
{
    [self.displayingItems removeObject:barrageItem];
}

- (BOOL)isCanHoldSize:(CGSize)aSize
{
    CGFloat margin = 0;
    CGFloat left = margin;
    CGFloat right;
    for (int i = 0; i < _itemFrameArray.count + 1; i++) {
        NSValue *frameValue = nil;
        if (i < _itemFrameArray.count) {
            frameValue = _itemFrameArray[i];
            right = frameValue.CGRectValue.origin.x;
        } else {
            right = self.frame.size.width - margin;
        }
        CGFloat width = right - left;
        // 筛选出符合条件的空隙
        if (width >= aSize.width) {
            return YES;
        }
        if (frameValue) {
            left = frameValue.CGRectValue.origin.x + frameValue.CGRectValue.size.width;
        }
    }
    return NO;
}

/**
 获取一个右侧初始的frameValue
 @param itemObject    弹幕单元对象
 @return 右侧初始的frameValue
 */
- (NSValue *)getRightFrameWithItemObject:(ZZBarrageItemObject *)itemObject
{
    CGSize itemSize = [itemObject itemSize];
    CGFloat x = self.frame.size.width;
    CGFloat y = self.frame.origin.y + (self.frame.size.height - itemSize.height) / 2.0;
    NSValue *frameValue = [NSValue valueWithCGRect:CGRectMake(x, y, itemSize.width, itemSize.height)];
    return frameValue;
}

- (NSValue *)getSuitableFrameWithItemObject:(ZZBarrageItemObject *)itemObject
{
    CGSize itemSize = [itemObject itemSize];
    NSMutableArray *spaceArray = [NSMutableArray array];
    CGFloat margin = 0;
    CGFloat height = self.frame.size.height;
    CGFloat left = margin;
    CGFloat right;
    for (int i = 0; i < _itemFrameArray.count + 1; i++) {
        NSValue *frameValue = nil;
        if (i < _itemFrameArray.count) {
            frameValue = _itemFrameArray[i];
            right = frameValue.CGRectValue.origin.x;
        } else {
            right = self.frame.size.width - margin;
        }
        CGFloat width = right - left;
        // 筛选出符合条件的空隙
        if (width >= itemSize.width) {
            NSValue *value = [NSValue valueWithCGRect:CGRectMake(left, 0, width, height)];
            [spaceArray addObject:@{@"rect":value, @"index":@(i)}];
        }
        if (frameValue) {
            left = frameValue.CGRectValue.origin.x + frameValue.CGRectValue.size.width;
        }
    }
    if (spaceArray.count == 0) {
        return nil;
    }
    NSUInteger index = arc4random() % spaceArray.count;
    NSDictionary *dic = spaceArray[index];
    NSValue *rectValue = dic[@"rect"];
    NSUInteger arrIndex = [dic[@"index"] integerValue];
    CGRect rect = rectValue.CGRectValue;
    CGPoint point = [self getItemPointWithSize:itemSize inRect:rect itemObject:itemObject];
    NSValue *frameValue = [NSValue valueWithCGRect:CGRectMake(point.x, point.y + self.frame.origin.y, itemSize.width, itemSize.height)];
    [self.itemFrameArray insertObject:frameValue atIndex:arrIndex];
    return frameValue;
}

- (void)removeItemFrameValue:(NSValue *)frameValue
{
    [self.itemFrameArray removeObject:frameValue];
}

- (void)clear
{
    [self.itemFrameArray removeAllObjects];
}

#pragma mark - private
/**
 获取一个合适且随机的item的布局坐标
 @param aSize   一个尺寸
 @return 合适且随机的布局坐标
 */
- (CGPoint)getItemPointWithSize:(CGSize)aSize inRect:(CGRect)rect itemObject:(ZZBarrageItemObject *)itemObject
{
    CGFloat horSpace = 0;
//    CGFloat verMargin = 0;
    CGFloat diffX = [ZZBarrageTrack randomFloatBetweenFloat1:horSpace float2:rect.size.width - aSize.width - horSpace];
    CGFloat diffY = 0;
//    if (itemObject.randomY) {
//        diffY = [ZZBarrageTrack randomFloatBetweenFloat1:verMargin float2:rect.size.height - (aSize.height + verMargin)];
//    } else {
//        diffY = (rect.size.height - aSize.height) / 2.0f;
//    }
    return CGPointMake(ceilf(rect.origin.x + diffX), ceilf((rect.origin.y + diffY)));
}

/*
 产生一个区间的随机浮点数
 @param float1   其中一个浮点数
 @param float2   其中一个浮点数
 @return 随机结果
 */
+ (CGFloat)randomFloatBetweenFloat1:(CGFloat)float1 float2:(CGFloat)float2
{
    CGFloat diffValue = float1 - float2;
    return float1 - ((arc4random() % 10) / 9.0) * diffValue;
}

#pragma mark - getter
- (NSMutableArray *)itemFrameArray
{
    if (!_itemFrameArray) {
        self.itemFrameArray = [NSMutableArray array];
    }
    return _itemFrameArray;
}

- (NSMutableArray<ZZBarrageItem *> *)displayingItems
{
    if (!_displayingItems) {
        self.displayingItems = [NSMutableArray array];
    }
    return _displayingItems;
}

@end
