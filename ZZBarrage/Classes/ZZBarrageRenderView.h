//
//  ZZBarrageRenderView.h
//  SCSocialMovieHallModule
//
//  Created by 任强宾 on 2019/7/1.
//

#import <UIKit/UIKit.h>
#import "ZZBarrageItemObject.h"
#import "ZZBarrageItem.h"
#import "ZZBarrageConfig.h"

@class ZZBarrageRenderView;
/*
 弹幕协议
 */
@protocol ZZBarrageRenderViewDelegate <NSObject>

@optional
// 弹幕更新时触发
- (void)barrageView:(ZZBarrageRenderView *)barrageView didUpdateBufferQueue:(NSArray *)bufferQueue;
// 弹幕被点击时触发
- (void)barrageView:(ZZBarrageRenderView *)barrageView didSelectItemObject:(ZZBarrageItemObject *)itemObject;
@end

@interface ZZBarrageRenderView : UIView

@property (nonatomic, weak) id<ZZBarrageRenderViewDelegate> delegate;

/**
 自定义配置初始化
 @param config        配置
 */
- (instancetype)initWithConfig:(ZZBarrageConfig *)config;

- (void)renderBarrageItemObject:(ZZBarrageItemObject *)itemObject;

@end

