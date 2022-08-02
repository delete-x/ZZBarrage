//
//  ZZBarrageConfig.m
//  SCSocialMovieHallModule
//
//  Created by 任强宾 on 2019/7/1.
//

#import "ZZBarrageConfig.h"

@implementation ZZBarrageConfig

- (instancetype)init {
    if (self = [super init]) {
        // 设置默认值
        self.trackCount = 3;
        self.defaultMinFrontSpace = 10.0f;
    }
    return self;
}

@end
