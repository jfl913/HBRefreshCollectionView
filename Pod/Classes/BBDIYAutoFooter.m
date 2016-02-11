//
//  BBDIYAutoFooter.m
//  Pods
//
//  Created by JunfengLi on 16/2/11.
//
//

#import "BBDIYAutoFooter.h"
#import "UIColor+Hex.h"

#define kViewHeight 45
#define kFontSize 12
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

@interface BBDIYAutoFooter ()

@property (nonatomic, strong) UILabel *idleLabel;
@property (nonatomic, strong) UIView *refreshingView;
@property (nonatomic, strong) UIView *noMoreView;

@end

@implementation BBDIYAutoFooter

// 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    self.mj_h = kViewHeight;
    
    [self addSubview:self.idleLabel];
    [self addSubview:self.refreshingView];
    [self addSubview:self.noMoreView];
}

// 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.idleLabel.frame = self.bounds;
    self.refreshingView.frame = self.bounds;
    self.noMoreView.frame = self.bounds;
}

// 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

// 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

// 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

// 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle: {
            self.idleLabel.hidden = NO;
            self.refreshingView.hidden = YES;
            self.noMoreView.hidden = YES;
            break; }
        case MJRefreshStateRefreshing: {
            self.idleLabel.hidden = YES;
            self.refreshingView.hidden = NO;
            self.noMoreView.hidden = YES;
            break; }
        case MJRefreshStateNoMoreData: {
            self.idleLabel.hidden = YES;
            self.refreshingView.hidden = YES;
            self.noMoreView.hidden = NO;
            break; }
        default:
            break;
    }
}

- (CGSize)calculateLabelSizeWithText:(NSString *)text font:(UIFont *)font andWidth:(CGFloat)width
{
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName : font}
                                     context:nil].size;
    return size;
}

#pragma mark - Accessors

- (UILabel *)idleLabel
{
    if (!_idleLabel) {
        _idleLabel = [UILabel new];
        _idleLabel.text = @"上拉加载更多";
        _idleLabel.font = [UIFont systemFontOfSize:kFontSize];
        _idleLabel.textColor = [UIColor colorWithHex:0xb2b2b2];
        _idleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _idleLabel;
}

- (UIView *)refreshingView
{
    if (!_refreshingView) {
        _refreshingView = [UIView new];
        
        UILabel *loadingLabel = [UILabel new];
        loadingLabel.text = @"加载中...";
        loadingLabel.font = [UIFont systemFontOfSize:kFontSize];
        loadingLabel.textColor = [UIColor colorWithHex:0xb2b2b2];
        CGSize loadingLabelSize = [self calculateLabelSizeWithText:loadingLabel.text font:loadingLabel.font andWidth:CGRectGetWidth([UIScreen mainScreen].bounds)];
        NSInteger loadingLabelWidth = ceil(loadingLabelSize.width);
        NSInteger loadingLabelHeight = ceil(loadingLabelSize.height);
        CGFloat loadingLabelXPos = (kScreenWidth - loadingLabelWidth) / 2.0;
        CGFloat loadingLabelYPos = (kViewHeight - loadingLabelHeight) / 2.0;
        loadingLabel.frame = CGRectMake(loadingLabelXPos, loadingLabelYPos, loadingLabelWidth, loadingLabelHeight);
        [_refreshingView addSubview:loadingLabel];
        
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.mj_x = loadingLabel.mj_x - 20 - activityIndicatorView.mj_w;
        activityIndicatorView.mj_y = (kViewHeight - activityIndicatorView.mj_h) / 2.0;
        [activityIndicatorView startAnimating];
        [_refreshingView addSubview:activityIndicatorView];
    }
    
    return _refreshingView;
}


- (UIView *)noMoreView
{
    if (!_noMoreView) {
        _noMoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kViewHeight)];
        _noMoreView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        CGFloat leftLineLeftSpacing = 12.0;
        CGFloat leftLineRightSpacing = 8.0;

        UILabel *noMoreLabel = [UILabel new];
        noMoreLabel.backgroundColor = [UIColor clearColor];
        noMoreLabel.text = @"没有啦";
        noMoreLabel.font = [UIFont systemFontOfSize:kFontSize];
        noMoreLabel.textColor = [UIColor colorWithHex:0xb2b2b2];
        [_noMoreView addSubview:noMoreLabel];

        UIView *leftLineView = [UIView new];
        leftLineView.backgroundColor = [UIColor colorWithHex:0xe4e4e4];
        UIView *rightLineView = [UIView new];
        rightLineView.backgroundColor = [UIColor colorWithHex:0xe4e4e4];
        [_noMoreView addSubview:leftLineView];
        [_noMoreView addSubview:rightLineView];

        CGSize noMoreLabelSize = [self calculateLabelSizeWithText:noMoreLabel.text font:noMoreLabel.font andWidth:kScreenWidth];
        NSInteger noMoreLabelWidth = ceil(noMoreLabelSize.width);
        NSInteger noMoreLabelHeight = ceil(noMoreLabelSize.height);

        CGFloat noMoreLabelXPos = (kScreenWidth - noMoreLabelWidth) / 2.0;
        CGFloat noMoreLabelYPos = (kViewHeight - noMoreLabelHeight) / 2.0;
        noMoreLabel.frame = CGRectMake(noMoreLabelXPos, noMoreLabelYPos, noMoreLabelWidth, noMoreLabelHeight);

        CGFloat lineWidth = noMoreLabelXPos - leftLineLeftSpacing - leftLineRightSpacing;
        CGFloat lineHeight = 1.0 / [UIScreen mainScreen].scale;
        CGFloat lineYPos = (_noMoreView.mj_h - lineHeight) / 2.0;
        leftLineView.frame = CGRectMake(leftLineLeftSpacing, lineYPos, lineWidth, lineHeight);
        rightLineView.frame = CGRectMake(noMoreLabel.mj_x + noMoreLabel.mj_w + leftLineRightSpacing, lineYPos, lineWidth, lineHeight);
    }

    return _noMoreView;
}

@end
