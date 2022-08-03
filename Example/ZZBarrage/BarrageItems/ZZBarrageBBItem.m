//
//  ZZBarrageBBItem.m
//  ZZBarrage_Example
//
//  Created by 任强宾 on 2022/8/2.
//  Copyright © 2022 QB_Share. All rights reserved.
//

#import "ZZBarrageBBItem.h"
#import <Masonry/Masonry.h>
#import "ZZBarrageBBItemObject.h"
#import "ZZBarrageRenderView.h"


@interface ZZBarrageBBItem ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation ZZBarrageBBItem


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    return self;
}


#pragma mark - ZZBarrageItemViewProtocol

/// 根据object更新item视图
/// @param object 弹幕对象
- (void)shouldUpdateItemWithObject:(ZZBarrageBBItemObject *)object {
    
    _textLabel.text = object.text;
}


/// 新的item刚刚添加到父视图，此处用来自定义浮动动画
/// @param barrageView 弹幕View
/// @param contentView 装载弹幕Item的容器视图
/// @param trackIndex 弹道坐标
/// @param object 弹幕对象
/// @param removeHandler 弹幕Item的移除操作
- (void)barrageView:(ZZBarrageRenderView *)barrageView itemDidAddedOnContentView:(UIView *)contentView trackIndex:(NSUInteger)trackIndex object:(id<ZZBarrageItemObjectProtocol>)object removeHandler:(ZZBarrageItemRemoveHandler)removeHandler {
    
    // 速度与其他AA的速度保持统一，计算出对应的duration
    CGFloat distance = barrageView.bounds.size.width + self.bounds.size.width;
    CGFloat duration = 6.0 * distance / barrageView.bounds.size.width;
    [UIView animateWithDuration:duration delay:0.0 options:(UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction) animations:^{

        self.transform = CGAffineTransformTranslate(self.transform, -(barrageView.bounds.size.width + self.bounds.size.width), 0);
        
    } completion:^(BOOL finished) {
        
        removeHandler();
    }];
}


#pragma mark - lazy

- (UILabel *)textLabel {
    if (!_textLabel) {
        self.textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor lightGrayColor];
        _textLabel.textColor = [UIColor blueColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.layer.masksToBounds = YES;
        _textLabel.layer.borderWidth = 1.0;
        _textLabel.layer.borderColor = [UIColor blueColor].CGColor;
    }
    return _textLabel;
}

@end
