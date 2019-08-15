//
//  ZZBarrageRenderView.m
//  SCSocialMovieHallModule
//
//  Created by 任强宾 on 2019/7/1.
//

#import "ZZBarrageRenderView.h"
#import "ZZBarrageTrack.h"              // 虚拟弹道
#import "UIView+BlockAction.h"

@interface ZZBarrageRenderView ()

@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong) UIView *lowContentView;
@property (nonatomic, strong) UIView *highContentView;
@property (nonatomic, strong) NSMutableArray *itemQueue;
@property (nonatomic, strong) dispatch_source_t queueTimer;
@property (nonatomic, strong) NSMutableArray<ZZBarrageTrack *> *trackArray;
@property (nonatomic, strong) ZZBarrageConfig *config;

@end

@implementation ZZBarrageRenderView

- (instancetype)initWithConfig:(ZZBarrageConfig *)config
{
    if (self = [super init]) {
        self.config = config;
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    NSUInteger trackCount = self.config.trackCount;
    for (int i = 0; i < trackCount; i++) {
        ZZBarrageTrack *track = [[ZZBarrageTrack alloc] initWithConfig:self.config];
        [self.trackArray addObject:track];
    }
    [self addSubview:self.highContentView];
    self.highContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.highContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.highContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.highContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.highContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0.0f]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    if (!CGSizeEqualToSize(size, _size) && !CGSizeEqualToSize(size, CGSizeZero)) {
        NSUInteger trackCount = _trackArray.count;
        CGFloat trackHeight = size.height / trackCount * 1.0;
        CGFloat trackTop = 0;
        for (int i = 0; i < trackCount; i++) {
            ZZBarrageTrack *track = _trackArray[i];
            track.frame = CGRectMake(0, trackTop, size.width, trackHeight);
            trackTop += trackHeight;
        }
        self.size = size;
    }
}

/**
 添加一个弹幕单元
 @param itemObject    弹幕单元对象
 */
- (void)renderBarrageItemObject:(ZZBarrageItemObject *)itemObject
{
    // 因为内部UI操作，此处回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self tryShowBarrageItemObject:itemObject]) {
            return;
        }
        [self addQueueWithItemObject:itemObject];
    });
}

// 尝试立即渲染弹幕单元
- (BOOL)tryShowBarrageItemObject:(ZZBarrageItemObject *)itemObject
{
    NSMutableArray *muTrackArray = [NSMutableArray array];
    NSArray *trackIndexArray = itemObject.trackIndexArray;
    if (trackIndexArray.count == 0) {
        [muTrackArray addObjectsFromArray:_trackArray];
    } else {
        for (NSNumber *indexNum in trackIndexArray) {
            if ([indexNum isKindOfClass:[NSNumber class]]) {
                NSInteger index = [indexNum integerValue];
                if (index < _trackArray.count) {
                    [muTrackArray addObject:_trackArray[index]];
                }
            }
        }
    }
    
    NSMutableArray *canDisplayTrackArray = [NSMutableArray array];
    for (ZZBarrageTrack *track in muTrackArray) {
        if ([track isCanDisplayItemObject:itemObject]) {
            [canDisplayTrackArray addObject:track];
        }
    }
    
    if (canDisplayTrackArray.count > 0) {
        NSUInteger randomIndex = arc4random() % canDisplayTrackArray.count;
        ZZBarrageTrack *selectedTrack = canDisplayTrackArray[randomIndex];
        if ([_itemQueue containsObject:itemObject]) {
            [_itemQueue removeObject:itemObject];
        }
        CGRect frame = [selectedTrack getInitialFrameWithItemObject:itemObject];
        Class itemClass = [itemObject itemClass];
        ZZBarrageItem *item = [[itemClass alloc] initWithFrame:frame];
        [selectedTrack addDisplayingItem:item];
        [self.highContentView addSubview:item];
        if ([item respondsToSelector:@selector(shouldUpdateItemWithObject:)]) {
            [item shouldUpdateItemWithObject:itemObject];
        }
        __weak typeof(item) weakItem = item;
        __weak typeof(self) weakSelf = self;
        [item setTouchAction:^(UIView *sender, UITapGestureRecognizer *tap) {
            
            __strong typeof(weakItem) strongItem = weakItem;
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([strongItem respondsToSelector:@selector(responseTapGesture:)]) {
                if ([strongItem responseTapGesture:tap]) {
                    if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(barrageView:didSelectItemObject:)]) {
                        [strongSelf.delegate barrageView:strongSelf didSelectItemObject:itemObject];
                    }
                }
            }
        }];
        
        if ([item respondsToSelector:@selector(barrageView:itemDidAddedOnContentView:object:removeHandler:)]) {
            ZZBarrageItemRemoveHandler removeHandler = ^{
                [selectedTrack removeDisplayingItem:item];
                [item removeFromSuperview];
            };
            [item barrageView:self itemDidAddedOnContentView:item.superview object:itemObject removeHandler:removeHandler];
        }
        
        if ([self.delegate respondsToSelector:@selector(barrageView:didUpdateBufferQueue:)]) {
            [self.delegate barrageView:self didUpdateBufferQueue:[NSArray arrayWithArray:self.itemQueue]];
        }
        return YES;
    }
    
    return NO;
}

// 把弹幕单元添加到缓冲队列
- (void)addQueueWithItemObject:(ZZBarrageItemObject *)itemObject
{
    if ([self.itemQueue containsObject:itemObject]) {
        return;
    }
    switch ([itemObject queuePriority]) {
            case ZZBarrageItemQueuePriorityLow:
        {
            [self.itemQueue addObject:itemObject];
        }
            break;
            case ZZBarrageItemQueuePriorityHigh:
        {
            [self.itemQueue insertObject:itemObject atIndex:0];
        }
            break;
        default:
            break;
    }
    if (!_queueTimer) {
        dispatch_resume(self.queueTimer);
    }
    if ([self.delegate respondsToSelector:@selector(barrageView:didUpdateBufferQueue:)]) {
        [self.delegate barrageView:self didUpdateBufferQueue:[NSArray arrayWithArray:self.itemQueue]];
    }
}

- (void)clear
{
    for (ZZBarrageTrack *track in _trackArray) {
        [track clear];
    }
    [self.itemQueue removeAllObjects];
    for (UIView *subView in self.highContentView.subviews) {
        [subView removeFromSuperview];
    }
    if ([self.delegate respondsToSelector:@selector(barrageView:didUpdateBufferQueue:)]) {
        [self.delegate barrageView:self didUpdateBufferQueue:nil];
    }
}

#pragma mark - getter
- (ZZBarrageConfig *)config
{
    if (!_config) {
        self.config = [ZZBarrageConfig new];
    }
    return _config;
}

- (UIView *)lowContentView
{
    if (!_lowContentView) {
        self.lowContentView = [UIView new];
    }
    return _lowContentView;
}

- (UIView *)highContentView
{
    if (!_highContentView) {
        self.highContentView = [UIView new];
    }
    return _highContentView;
}

- (NSMutableArray<ZZBarrageTrack *> *)trackArray
{
    if (!_trackArray) {
        self.trackArray = [NSMutableArray array];
    }
    return _trackArray;
}

- (NSMutableArray *)itemQueue
{
    if (!_itemQueue) {
        self.itemQueue = [NSMutableArray array];
    }
    return _itemQueue;
}

- (dispatch_source_t)queueTimer
{
    if (!_queueTimer) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.queueTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_queueTimer, dispatch_walltime(NULL, 0.3 * NSEC_PER_SEC), 0.3 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(_queueTimer, ^{
            if (weakSelf.itemQueue.count > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ZZBarrageItemObject *itemObject = weakSelf.itemQueue[0];
                    [weakSelf tryShowBarrageItemObject:itemObject];
                });
            }
        });
    }
    return _queueTimer;
}

- (void)dealloc
{
    if (_queueTimer) {
        if (@available(iOS 8.0, *)) {
            dispatch_cancel(_queueTimer);
        }
    }
    self.queueTimer = nil;
}

@end
