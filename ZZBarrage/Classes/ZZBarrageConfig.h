//
//  ZZBarrageConfig.h
//  SCSocialMovieHallModule
//
//  Created by 任强宾(QQ:1850665560) on 2019/7/1.
//

#import <Foundation/Foundation.h>


@interface ZZBarrageConfig : NSObject

/// 弹道个数 (default : 3)
@property (nonatomic, assign) NSUInteger trackCount;
/// 弹幕最小垂直间距 (default : 2.0f)
@property (nonatomic, assign) CGFloat minVerSpace;
/// 弹幕初始化最小水平间距 (default : 8.0f)
@property (nonatomic, assign) CGFloat minHorSpace;

/// 弹幕垂直间距差(间距差越大，排队的弹幕垂直间距随机范围越大) (default : 0.0f)
@property (nonatomic, assign) CGFloat verSpaceDiff;
/// 弹幕水平间距差(间距差越大，排队的弹幕水平间距随机范围越大) (default : 0.0f)
@property (nonatomic, assign) CGFloat horSpaceDiff;

/// 点击非弹幕的空白区域，是否把事件穿透到下层 (default : NO)
@property (nonatomic, assign) BOOL throughEvents;

@end

