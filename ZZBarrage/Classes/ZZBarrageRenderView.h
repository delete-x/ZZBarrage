//
//  ZZBarrageRenderView.h
//  SCSocialMovieHallModule
//
//  Created by 任强宾 on 2019/7/1.
//

#import <UIKit/UIKit.h>
#import "ZZBarrageConfig.h"
#import "ZZBarrageItemObjectProtocol.h"     // 弹幕对象协议
#import "ZZBarrageItemProtocol.h"           // 弹幕视图协议

@class ZZBarrageRenderView;
/*
 弹幕协议
 */
@protocol ZZBarrageRenderViewDelegate <NSObject>

@optional
// 弹幕队列更新时触发
- (void)barrageView:(ZZBarrageRenderView *)barrageView didUpdateBufferQueue:(NSArray *)bufferQueue;
// 弹幕被点击时触发
- (void)barrageView:(ZZBarrageRenderView *)barrageView didSelectItemObject:(id<ZZBarrageItemObjectProtocol>)itemObject;

@end

/*
 弹幕渲染View
 */
@interface ZZBarrageRenderView : UIView

@property (nonatomic, weak) id<ZZBarrageRenderViewDelegate> delegate;

/// 自定义配置初始化
/// @param config 配置对象
- (instancetype)initWithConfig:(ZZBarrageConfig *)config;

/// 添加一个弹幕对象
/// @param itemObject 弹幕对象
- (void)addBarrageItemObject:(id<ZZBarrageItemObjectProtocol>)itemObject;

/// 启动(所有弹道)
- (void)start;

/// 暂停(所有弹道)
- (void)pause;

/// 启动(某个弹道)
/// @param index 弹道的下标
- (void)startWithTrackIndex:(NSUInteger)index;

/// 暂停(某个弹道)
/// @param index 弹道的下标
- (void)pauseWithTrackIndex:(NSUInteger)index;


@end

