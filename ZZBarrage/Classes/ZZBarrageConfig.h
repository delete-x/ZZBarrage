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
// 缓冲队列最大并发数量 (default : 1)
@property (nonatomic, assign) NSUInteger maxQueueConcurrent;

@end

