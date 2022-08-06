//
//  ZZBarrageAAItem.m
//  ZZBarrage_Example
//
//  Created by 任强宾 on 2022/8/2.
//  Copyright © 2022 QB_Share. All rights reserved.
//

#import "ZZBarrageAAItem.h"
#import <Masonry/Masonry.h>
#import "ZZBarrageAAItemObject.h"
#import "ZZBarrageRenderView.h"


@interface ZZBarrageAAItem ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation ZZBarrageAAItem


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
- (void)shouldUpdateItemWithObject:(ZZBarrageAAItemObject *)object {
    
    _textLabel.text = object.text;
}


/// 新的item刚刚添加到父视图，此处用来自定义浮动动画
/// @param barrageView 弹幕View
/// @param contentView 装载弹幕Item的容器视图
/// @param trackIndex 弹道坐标
/// @param object 弹幕对象
/// @param removeHandler 弹幕Item的移除操作
- (void)barrageView:(ZZBarrageRenderView *)barrageView itemDidAddedOnContentView:(UIView *)contentView trackIndex:(NSUInteger)trackIndex object:(id<ZZBarrageItemObjectProtocol>)object removeHandler:(ZZBarrageItemRemoveHandler)removeHandler {

    
    // 飘到左边顶头之后，停留三秒再消失
    [UIView animateWithDuration:6.0f delay:0.0 options:(UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction) animations:^{

        self.transform = CGAffineTransformTranslate(self.transform, -barrageView.bounds.size.width, 0);
        
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.2 animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                removeHandler();
            }];
            
            
        });
        
    }];
}


#pragma mark - lazy

- (UILabel *)textLabel {
    if (!_textLabel) {
        self.textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        _textLabel.textColor = [UIColor redColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.layer.masksToBounds = YES;
        _textLabel.layer.cornerRadius = 20.0f;
        _textLabel.layer.borderWidth = 1.0;
        _textLabel.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _textLabel;
}

@end
