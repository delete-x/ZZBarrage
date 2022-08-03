//
//  ZZBarrageRenderView.m
//  SCSocialMovieHallModule
//
//  Created by 任强宾 on 2019/7/1.
//

#import "ZZBarrageRenderView.h"
#import "ZZBarrageTrack.h"              // 虚拟弹道
#import "ZZBarrageValueHelper.h"        // 内部值记录Helper


@interface ZZBarrageRenderView () <UITableViewDelegate>

@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *itemQueue;
@property (nonatomic, strong) dispatch_source_t queueTimer;
@property (nonatomic, strong) NSMutableArray<ZZBarrageTrack *> *trackArray;
@property (nonatomic, strong) ZZBarrageConfig *config;
@property (nonatomic, strong) ZZBarrageValueHelper *valueHelper;

@end

@implementation ZZBarrageRenderView

- (instancetype)initWithConfig:(ZZBarrageConfig *)config {
    
    if (self = [super init]) {
        self.config = config;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    NSUInteger trackCount = self.config.trackCount;
    for (int i = 0; i < trackCount; i++) {
        ZZBarrageTrack *track = [[ZZBarrageTrack alloc] initWithConfig:self.config];
        [self.trackArray addObject:track];
    }
    [self addSubview:self.contentView];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0.0f]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapGestureRecognizer addTarget:self action:@selector(handleActionTapGestureRecognizer:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)layoutSubviews {
    
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

/// 启动(所有弹道)
- (void)start {
    
    for (ZZBarrageTrack *track in self.trackArray) {
        [track start];
    }
}

/// 暂停(所有弹道)
- (void)pause {
    
    for (ZZBarrageTrack *track in self.trackArray) {
        [track pause];
    }
}

/// 启动(某个弹道)
- (void)startWithTrackIndex:(NSUInteger)index {
    
    ZZBarrageTrack *track = [self getTrackWithIndex:index];
    [track start];
}

/// 暂停(某个弹道)
- (void)pauseWithTrackIndex:(NSUInteger)index {
    
    ZZBarrageTrack *track = [self getTrackWithIndex:index];
    [track pause];
}


/// 添加一个弹幕对象
/// @param itemObject 弹幕对象
- (void)addBarrageItemObject:(id<ZZBarrageItemObjectProtocol>)itemObject {
    
    // 检查对象是否合规，若不满足条件，则直接return
    if (![itemObject respondsToSelector:@selector(itemClass)] || ![itemObject respondsToSelector:@selector(itemSize)]) {
        return;
    }
    
    // 如果水平间距差大于0，则随机产生附加水平间距，并内部赋值
    if (self.config.horSpaceDiff > 0) {
        CGFloat additionalHorSpace = (arc4random() % 1000) / 999.0 * self.config.horSpaceDiff;
        [self.valueHelper setAdditionalHorSpace:additionalHorSpace forItemObject:itemObject];
    }
    
    // 涉及到UI操作，此处回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self tryShowBarrageItemObject:itemObject]) {
            return;
        }
        [self addQueueWithItemObject:itemObject];
    });
}


/// 尝试立即渲染弹幕
/// @param itemObject 弹幕对象
/// @return 是否渲染成功
- (BOOL)tryShowBarrageItemObject:(id<ZZBarrageItemObjectProtocol>)itemObject {
    
    // 被允许展示弹幕的弹道数组
    NSMutableArray *allowTrackArray = [NSMutableArray array];
    
    NSArray *trackIndexArray = nil;
    if ([itemObject respondsToSelector:@selector(trackIndexArray)]) {
        if ([itemObject.trackIndexArray isKindOfClass:[NSArray class]]) {
            trackIndexArray = itemObject.trackIndexArray;
        }
    }
    
    if (trackIndexArray.count == 0) {
        [allowTrackArray addObjectsFromArray:_trackArray];
    } else {
        for (NSNumber *indexNum in trackIndexArray) {
            if ([indexNum isKindOfClass:[NSNumber class]]) {
                NSInteger index = [indexNum integerValue];
                if (index < _trackArray.count) {
                    [allowTrackArray addObject:_trackArray[index]];
                }
            }
        }
    }
    
    // 当前可以展示弹幕的弹道数组
    NSMutableArray *canDisplayTrackArray = [NSMutableArray array];
    for (ZZBarrageTrack *track in allowTrackArray) {
        CGFloat additionalHorSpace = [self.valueHelper additionalHorSpaceForItemObject:itemObject];
        if ([track isCanDisplayItemObject:itemObject additionalHorSpace:additionalHorSpace]) {
            [canDisplayTrackArray addObject:track];
        }
    }
    
    // 在符合条件的弹道里面随机挑选一个添加弹幕item
    if (canDisplayTrackArray.count > 0) {
        
        NSUInteger randomIndex = arc4random() % canDisplayTrackArray.count;
        ZZBarrageTrack *selectedTrack = canDisplayTrackArray[randomIndex];
        if ([_itemQueue containsObject:itemObject]) {
            [_itemQueue removeObject:itemObject];
        }
        CGRect frame = [selectedTrack getInitialFrameWithItemObject:itemObject];
        Class itemClass = [itemObject itemClass];
        UIView<ZZBarrageItemViewProtocol> *itemView = [[itemClass alloc] initWithFrame:frame];
        ZZBarrageItemTuple *itemTuple = [ZZBarrageItemTuple tupleWithItemView:itemView itemObject:itemObject];
        [selectedTrack addDisplayingItemTuple:itemTuple];
        [self.contentView addSubview:itemView];
        if ([itemView respondsToSelector:@selector(shouldUpdateItemWithObject:)]) {
            [itemView shouldUpdateItemWithObject:itemObject];
        }
        
        if ([itemView respondsToSelector:@selector(barrageView:itemDidAddedOnContentView:trackIndex:object:removeHandler:)]) {
            ZZBarrageItemRemoveHandler removeHandler = ^{
                // 弹道展示的弹幕视图数组移除视图对象
                [selectedTrack removeDisplayingItemTuple:itemTuple];
                [itemView removeFromSuperview];
            };
            [itemView barrageView:self itemDidAddedOnContentView:itemView.superview trackIndex:randomIndex object:itemObject removeHandler:removeHandler];
        }
        
        if ([self.delegate respondsToSelector:@selector(barrageView:didUpdateBufferQueue:)]) {
            [self.delegate barrageView:self didUpdateBufferQueue:[NSArray arrayWithArray:self.itemQueue]];
        }
        
        // valueHelper移除itemObject
        [self.valueHelper removeItemObject:itemObject];
        
        return YES;
    }
    
    return NO;
}


/// 添加一个弹幕对象
/// @param itemObject 弹幕对象
- (void)addQueueWithItemObject:(id<ZZBarrageItemObjectProtocol>)itemObject {
    
    if ([self.itemQueue containsObject:itemObject]) {
        return;
    }
    ZZBarrageItemQueuePriority queuePriority = ZZBarrageItemQueuePriorityLow;
    if ([itemObject respondsToSelector:@selector(queuePriority)]) {
        queuePriority = [itemObject queuePriority];
    }
    switch (queuePriority) {
        case ZZBarrageItemQueuePriorityLow:
        {
            [self.itemQueue addObject:itemObject];
        }
            break;
        case ZZBarrageItemQueuePriorityHigh:
        {
            NSArray *tempItemQueue = [NSArray arrayWithArray:self.itemQueue];
            if (tempItemQueue.count > 0) {
                for (int i = 0; i < tempItemQueue.count; i++) {
                    id<ZZBarrageItemObjectProtocol> theItemObject = tempItemQueue[i];
                    ZZBarrageItemQueuePriority theQueuePriority = ZZBarrageItemQueuePriorityLow;
                    if ([theItemObject respondsToSelector:@selector(queuePriority)]) {
                        theQueuePriority = [theItemObject queuePriority];
                    }
                    if (theQueuePriority < queuePriority) {
                        if (self.itemQueue.count >= i) {
                            [self.itemQueue insertObject:itemObject atIndex:i];
                        }
                        break;
                    } else if (i == self.itemQueue.count - 1) {
                        [self.itemQueue addObject:itemObject];
                    }
                }
            } else {
                [self.itemQueue addObject:itemObject];
            }
            
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


- (void)clear {
    
    for (ZZBarrageTrack *track in _trackArray) {
        [track clear];
    }
    [self.itemQueue removeAllObjects];
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    if ([self.delegate respondsToSelector:@selector(barrageView:didUpdateBufferQueue:)]) {
        [self.delegate barrageView:self didUpdateBufferQueue:nil];
    }
}


#pragma mark - private

- (ZZBarrageTrack *)getTrackWithIndex:(NSUInteger)index {
    
    if (index >= 0 && index < self.trackArray.count) {
        return self.trackArray[index];
    }
    return nil;
}


#pragma mark - lazy

- (ZZBarrageConfig *)config {
    
    if (!_config) {
        self.config = [ZZBarrageConfig new];
    }
    return _config;
}

- (UIView *)contentView {
    
    if (!_contentView) {
        self.contentView = [UIView new];
    }
    return _contentView;
}

- (NSMutableArray<ZZBarrageTrack *> *)trackArray {
    
    if (!_trackArray) {
        self.trackArray = [NSMutableArray array];
    }
    return _trackArray;
}

- (NSMutableArray *)itemQueue {
    
    if (!_itemQueue) {
        self.itemQueue = [NSMutableArray array];
    }
    return _itemQueue;
}

- (ZZBarrageValueHelper *)valueHelper {
    
    if (!_valueHelper) {
        self.valueHelper = [[ZZBarrageValueHelper alloc] init];
    }
    return _valueHelper;
}

- (dispatch_source_t)queueTimer {
    
    if (!_queueTimer) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.queueTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_queueTimer, dispatch_walltime(NULL, 0.1 * NSEC_PER_SEC), 0.1 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(_queueTimer, ^{
            if (weakSelf.itemQueue.count > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    id<ZZBarrageItemObjectProtocol> itemObject = weakSelf.itemQueue[0];
                    [weakSelf tryShowBarrageItemObject:itemObject];
                });
            }
        });
    }
    return _queueTimer;
}


#pragma mark - event

- (void)handleActionTapGestureRecognizer:(UITapGestureRecognizer *)tap {
    
    CGPoint point = [tap locationInView:self];
    for (ZZBarrageTrack *track in _trackArray) {
        for (ZZBarrageItemTuple *itemTuple in track.displayingItemTuples) {
            UIView<ZZBarrageItemViewProtocol> *itemView = itemTuple.itemView;
            CGRect presentingRect = itemView.frame;
            // 如果不在动画中则presentationLayer为空，在动画中就需要实时的判断点击是否点中动画中的动画
            if (itemView.layer.presentationLayer) {
                presentingRect = itemView.layer.presentationLayer.frame;
            }
            BOOL isInside = CGRectContainsPoint(presentingRect, point);
            if (isInside) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(barrageView:didSelectItemView:itemObject:)]) {
                    
                    [self.delegate barrageView:self didSelectItemView:itemView itemObject:itemTuple.itemObject];
                }
            }
        }
    }
}


#pragma mark - dealloc

- (void)dealloc {
    
    if (_queueTimer) {
        if (@available(iOS 8.0, *)) {
            dispatch_cancel(_queueTimer);
        }
    }
    self.queueTimer = nil;
}

@end
