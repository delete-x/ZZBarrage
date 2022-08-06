//
//  ZZBarrageConfig.m
//  SCSocialMovieHallModule
//
//  Created by 任强宾(QQ:1850665560) on 2019/7/1.
//

#import "ZZBarrageConfig.h"

@implementation ZZBarrageConfig

- (instancetype)init {
    if (self = [super init]) {
        // 设置默认值
        self.trackCount = 3;
        self.minVerSpace = 2.0f;
        self.minHorSpace = 8.0f;
        self.verSpaceDiff = 0.0f;
        self.horSpaceDiff = 0.0f;
        self.throughEvents = NO;
    }
    return self;
}

@end
