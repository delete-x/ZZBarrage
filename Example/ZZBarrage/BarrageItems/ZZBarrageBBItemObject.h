//
//  ZZBarrageBBItemObject.h
//  ZZBarrage_Example
//
//  Created by 任强宾 on 2022/8/2.
//  Copyright © 2022 QB_Share. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZZBarrage/ZZBarrageItemObjectProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZBarrageBBItemObject : NSObject <ZZBarrageItemObjectProtocol>

@property (nonatomic, copy) NSString *text;

@end

NS_ASSUME_NONNULL_END
