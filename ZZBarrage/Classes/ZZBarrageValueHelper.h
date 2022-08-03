//
//  ZZBarrageValueHelper.h
//  ZZBarrage
//
//  Created by 任强宾 on 2022/8/2.
//

#import <Foundation/Foundation.h>
#import "ZZBarrageItemObjectProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/*
 用于记录内部所用的值
 */
@interface ZZBarrageValueHelper : NSObject

- (void)setAdditionalHorSpace:(CGFloat)additionalHorSpace forItemObject:(id<ZZBarrageItemObjectProtocol>)itemObject;

- (CGFloat)additionalHorSpaceForItemObject:(id<ZZBarrageItemObjectProtocol>)itemObject;

- (void)removeItemObject:(id<ZZBarrageItemObjectProtocol>)itemObject;

@end

NS_ASSUME_NONNULL_END
