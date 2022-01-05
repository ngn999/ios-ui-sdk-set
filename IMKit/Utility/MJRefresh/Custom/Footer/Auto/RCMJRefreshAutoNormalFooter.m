//
//  RCMJRefreshAutoNormalFooter.m
//  RCMJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015 小码哥. All rights reserved.
//

#import "RCMJRefreshAutoNormalFooter.h"

@interface RCMJRefreshAutoNormalFooter ()
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@end

@implementation RCMJRefreshAutoNormalFooter
#pragma mark - 懒加载子控件
- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView =
            [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    _activityIndicatorViewStyle = activityIndicatorViewStyle;

    self.loadingView = nil;
    [self setNeedsLayout];
}
#pragma mark - 重写父类的方法
- (void)prepare {
    [super prepare];

    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)placeSubviews {
    [super placeSubviews];

    if (self.loadingView.constraints.count)
        return;

    // 圈圈
    CGFloat loadingCenterX = self.rcmj_w * 0.5;
    if (!self.isRefreshingTitleHidden) {
        loadingCenterX -= self.stateLabel.rcmj_textWidth * 0.5 + self.labelLeftInset;
    }
    CGFloat loadingCenterY = self.rcmj_h * 0.5;
    self.loadingView.center = CGPointMake(loadingCenterX, loadingCenterY);
}

- (void)setState:(RCMJRefreshState)state {
    RCMJRefreshCheckState

        // 根据状态做事情
        if (state == RCMJRefreshStateNoMoreData || state == RCMJRefreshStateIdle) {
        [self.loadingView stopAnimating];
    }
    else if (state == RCMJRefreshStateRefreshing) {
        [self.loadingView startAnimating];
    }
}

@end
