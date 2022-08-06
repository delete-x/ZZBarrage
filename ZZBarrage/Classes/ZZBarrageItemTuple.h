//
//  ZZBarrageItemTuple.h
//  ZZBarrage
//
//  Created by 任强宾(QQ:1850665560) on 2022/8/3.
//

#import <Foundation/Foundation.h>
#import "ZZBarrageItemObjectProtocol.h"
#import "ZZBarrageItemViewProtocol.h"


NS_ASSUME_NONNULL_BEGIN
/*
 item元组，用于包装itemobject与对应的item
 */
@interface ZZBarrageItemTuple : NSObject

+ (ZZBarrageItemTuple *)tupleWithItemView:(UIView<ZZBarrageItemViewProtocol> *)itemView itemObject:(id<ZZBarrageItemObjectProtocol>)itemObject;

@property (nonatomic, strong, readonly) UIView<ZZBarrageItemViewProtocol> *itemView;
@property (nonatomic, strong, readonly) id<ZZBarrageItemObjectProtocol> itemObject;

@end

NS_ASSUME_NONNULL_END
