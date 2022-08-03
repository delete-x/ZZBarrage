//
//  ZZBarrageItemTuple.m
//  ZZBarrage
//
//  Created by 任强宾 on 2022/8/3.
//

#import "ZZBarrageItemTuple.h"

@interface ZZBarrageItemTuple ()

@property (nonatomic, strong) UIView<ZZBarrageItemViewProtocol> *itemView;
@property (nonatomic, strong) id<ZZBarrageItemObjectProtocol> itemObject;

@end

@implementation ZZBarrageItemTuple

+ (ZZBarrageItemTuple *)tupleWithItemView:(UIView<ZZBarrageItemViewProtocol> *)itemView itemObject:(id<ZZBarrageItemObjectProtocol>)itemObject {
    
    ZZBarrageItemTuple *tuple = [[ZZBarrageItemTuple alloc] init];
    tuple.itemObject = itemObject;
    tuple.itemView = itemView;
    return tuple;
}

@end
