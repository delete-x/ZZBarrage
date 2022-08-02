//
//  ZZBarrageConfig.h
//  SCSocialMovieHallModule
//
//  Created by 任强宾 on 2019/7/1.
//

#import <Foundation/Foundation.h>


@interface ZZBarrageConfig : NSObject

// 弹道个数 (default : 3)
@property (nonatomic, assign) NSUInteger trackCount;
/// 默认的最小前间隔（default : 10.0）
@property (nonatomic, assign) CGFloat defaultMinFrontSpace;

@end

