//
//  ZZBarrageValueHelper.m
//  ZZBarrage
//
//  Created by 任强宾 on 2022/8/2.
//

#import "ZZBarrageValueHelper.h"

@interface ZZBarrageValueHelper ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary *> *itemObjectValueDict;

@end

@implementation ZZBarrageValueHelper


- (void)setAdditionalHorSpace:(CGFloat)additionalHorSpace forItemObject:(id<ZZBarrageItemObjectProtocol>)itemObject {
    
    [[self muDicForItemObject:itemObject] setValue:@(additionalHorSpace) forKey:@"additionalHorSpace"];
}

- (CGFloat)additionalHorSpaceForItemObject:(id<ZZBarrageItemObjectProtocol>)itemObject {
    
    NSNumber *additionalHorSpaceNumber = [[self muDicForItemObject:itemObject] objectForKey:@"additionalHorSpace"];
    if ([additionalHorSpaceNumber isKindOfClass:[NSNumber class]]) {
        return [additionalHorSpaceNumber floatValue];
    } else {
        return 0.0f;
    }
}

- (void)removeItemObject:(id<ZZBarrageItemObjectProtocol>)itemObject {
    
    [self.itemObjectValueDict removeObjectForKey:[NSString stringWithFormat:@"%p", itemObject]];
}


#pragma mark - private

- (void)setMuDic:(NSMutableDictionary *)muDic forItemObject:(id<ZZBarrageItemObjectProtocol>)itemObject {
    
    [self.itemObjectValueDict setValue:muDic forKey:[NSString stringWithFormat:@"%p", itemObject]];
}

- (NSMutableDictionary *)muDicForItemObject:(id<ZZBarrageItemObjectProtocol>)itemObject {
    
    NSMutableDictionary *muDic = [self.itemObjectValueDict objectForKey:[NSString stringWithFormat:@"%p", itemObject]];
    if (!muDic) {
        muDic = [NSMutableDictionary dictionary];
        [self setMuDic:muDic forItemObject:itemObject];
    }
    return muDic;
}


#pragma mark - lazy

- (NSMutableDictionary<NSString *, NSMutableDictionary *> *)itemObjectValueDict {
    
    if (!_itemObjectValueDict) {
        self.itemObjectValueDict = [NSMutableDictionary dictionary];
    }
    return _itemObjectValueDict;
}

@end
