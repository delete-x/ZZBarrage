//
//  ZZViewController.m
//  ZZBarrage
//
//  Created by QB_Share on 08/15/2019.
//  Copyright (c) 2019 QB_Share. All rights reserved.
//

#import "ZZViewController.h"
#import <Masonry/Masonry.h>
#import <ZZBarrageRenderView.h>
#import "ZZBarrageAAItemObject.h"
#import "ZZBarrageBBItemObject.h"

@interface ZZViewController () <ZZBarrageRenderViewDelegate>

@property (nonatomic, strong) ZZBarrageRenderView *barrageRenderView;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *pauseBtn;
@property (nonatomic, strong) UIButton *addAABtn;
@property (nonatomic, strong) UIButton *addBBBtn;

// 弹幕下方btn（测试弹幕view的事件穿透）
@property (nonatomic, strong) UIButton *testThroughBtn;

@end

@implementation ZZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSMutableArray *muArray = [NSMutableArray arrayWithArray:@[@"1", @"2"]];
//    [muArray insertObject:@"3" atIndex:2];
//    NSLog(@"%@", muArray);
    
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.navigationController.navigationBar setShadowImage:nil];
     [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    self.title = @"ZZBarrage";
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.testThroughBtn];
    
    [self.view addSubview:self.barrageRenderView];
    [self.view addSubview:self.startBtn];
    [self.view addSubview:self.pauseBtn];
    [self.view addSubview:self.addAABtn];
    [self.view addSubview:self.addBBBtn];
    
    [self.testThroughBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(0);
        make.width.offset(100);
        make.height.offset(40);
    }];
    
    [self.barrageRenderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(60.0 * 3);
    }];
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_barrageRenderView.mas_bottom).offset(50);
        make.left.offset(20);
        make.width.offset(80);
        make.height.offset(50);
    }];
    [self.pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_startBtn.mas_bottom).offset(10);
        make.left.equalTo(_startBtn);
        make.width.offset(80);
        make.height.offset(50);
    }];
    
    [self.addAABtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_barrageRenderView.mas_bottom).offset(50);
        make.right.offset(-20);
        make.width.offset(80);
        make.height.offset(50);
    }];
    [self.addBBBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addAABtn.mas_bottom).offset(10);
        make.right.equalTo(_addAABtn);
        make.width.offset(80);
        make.height.offset(50);
    }];
    
}


#pragma mark - handle action

- (void)handleActionStartBtn:(UIButton *)sender {
    
    [self handleAlertWithIsPause:NO];
}

- (void)handleActionPauseBtn:(UIButton *)sender {
    
    [self handleAlertWithIsPause:YES];
}

- (void)handleActionAddAABtn:(UIButton *)sender {
    
    ZZBarrageAAItemObject *aaItemObject = [[ZZBarrageAAItemObject alloc] init];
    aaItemObject.text = @"弹幕AA";
    [self.barrageRenderView addBarrageItemObject:aaItemObject];
}

- (void)handleActionAddBBBtn:(UIButton *)sender {
    
    ZZBarrageBBItemObject *bbItemObject = [[ZZBarrageBBItemObject alloc] init];
    bbItemObject.text = @"弹幕BB";
    [self.barrageRenderView addBarrageItemObject:bbItemObject];
}

- (void)handleActionTestThroughBtn:(UIButton *)sender {
    
    NSLog(@"弹幕下面的按钮被点击到了!");
}

- (void)handleAlertWithIsPause:(BOOL)isPause {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选项" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *allAlertAction = [UIAlertAction actionWithTitle:@"全部" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        if (isPause) {
            [self.barrageRenderView pause];
        } else {
            [self.barrageRenderView start];
        }
    }];
    UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"弹道1" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        if (isPause) {
            [self.barrageRenderView pauseWithTrackIndex:0];
        } else {
            [self.barrageRenderView startWithTrackIndex:0];
        }
    }];
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"弹道2" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        if (isPause) {
            [self.barrageRenderView pauseWithTrackIndex:1];
        } else {
            [self.barrageRenderView startWithTrackIndex:1];
        }
    }];
    UIAlertAction *alertAction3 = [UIAlertAction actionWithTitle:@"弹道3" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        if (isPause) {
            [self.barrageRenderView pauseWithTrackIndex:2];
        } else {
            [self.barrageRenderView startWithTrackIndex:2];
        }
    }];
    UIAlertAction *cannelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:allAlertAction];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [alertController addAction:alertAction3];
    [alertController addAction:cannelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - ZZBarrageRenderViewDelegate

// 弹幕被点击时触发
- (void)barrageView:(ZZBarrageRenderView *)barrageView didSelectItemView:(UIView<ZZBarrageItemViewProtocol> *)itemView itemObject:(id<ZZBarrageItemObjectProtocol>)itemObject {
    
    
    NSLog(@"弹幕%@被点击，地址:%p", NSStringFromClass(itemObject.itemClass), itemObject);
}

#pragma mark - lazy

- (ZZBarrageRenderView *)barrageRenderView {
    if (!_barrageRenderView) {
        ZZBarrageConfig *config = [ZZBarrageConfig new];
        config.trackCount = 3;
        config.minVerSpace = 2.0;
        config.horSpaceDiff = 20.0f;
        config.verSpaceDiff = 20.0f;
        config.throughEvents = YES;
        self.barrageRenderView = [[ZZBarrageRenderView alloc] initWithConfig:config];
        _barrageRenderView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        _barrageRenderView.delegate = self;
    }
    return _barrageRenderView;
}


- (UIButton *)startBtn {
    if (!_startBtn) {
        self.startBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_startBtn setTitle:@"开始" forState:(UIControlStateNormal)];
        [_startBtn setTitleColor:[UIColor greenColor] forState:(UIControlStateNormal)];
        [_startBtn addTarget:self action:@selector(handleActionStartBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _startBtn;
}


- (UIButton *)pauseBtn {
    if (!_pauseBtn) {
        self.pauseBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_pauseBtn setTitle:@"暂停" forState:(UIControlStateNormal)];
        [_pauseBtn setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
        [_pauseBtn addTarget:self action:@selector(handleActionPauseBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _pauseBtn;
}


- (UIButton *)addAABtn {
    if (!_addAABtn) {
        self.addAABtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_addAABtn setTitle:@"添加AA" forState:(UIControlStateNormal)];
        [_addAABtn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
        [_addAABtn addTarget:self action:@selector(handleActionAddAABtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addAABtn;
}


- (UIButton *)addBBBtn {
    if (!_addBBBtn) {
        self.addBBBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_addBBBtn setTitle:@"添加BB" forState:(UIControlStateNormal)];
        [_addBBBtn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
        [_addBBBtn addTarget:self action:@selector(handleActionAddBBBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addBBBtn;
}


- (UIButton *)testThroughBtn {
    if (!_testThroughBtn) {
        self.testThroughBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _testThroughBtn.backgroundColor = [UIColor redColor];
        [_testThroughBtn setTitle:@"弹幕View下面的按钮" forState:(UIControlStateNormal)];
        [_testThroughBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_testThroughBtn addTarget:self action:@selector(handleActionTestThroughBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _testThroughBtn;
}

@end
