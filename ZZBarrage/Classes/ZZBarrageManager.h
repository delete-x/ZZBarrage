//
//  ZZBarrageManager.h
//  SCSocialMovieHallModule
//
//  Created by 任强宾 on 2019/7/1.
//

#import <Foundation/Foundation.h>
#import "ZZBarrageRenderView.h"


@interface ZZBarrageManager : NSObject

@property (nonatomic, strong, readonly) ZZBarrageRenderView *renderView;

- (void)renderBarrageItemObject:(ZZBarrageItemObject *)itemObject;

@end

