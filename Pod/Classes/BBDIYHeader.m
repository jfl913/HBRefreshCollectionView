//
//  BBDIYHeader.m
//  Pods
//
//  Created by LiJunfeng on 16/1/27.
//
//

#import "BBDIYHeader.h"
#import "BBPodBundle.h"
#import "UIImage+GIF.h"

#define kIndicatorWidth 20
#define kBottomSpacing 10
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

@interface BBDIYHeader ()

@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UIImageView *logoGifImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation BBDIYHeader

// 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 65;
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIImage *titleImage = [UIImage imageNamed:[BBPodBundle getImagePath:@"img_c2c_refresh_down"]];
    self.titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    self.titleImageView.backgroundColor = [UIColor whiteColor];
    self.titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.titleImageView];
    
    UIImage *logoImage = [UIImage sd_animatedGIFNamed:@"img_xiaobei"];
    self.logoGifImageView = [[UIImageView alloc] initWithImage:logoImage];
    [self addSubview:self.logoGifImageView];
    
    UIImage *arrowImage = [UIImage imageNamed:[BBPodBundle getImagePath:@"ic_refresh_down"]];
    self.arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
    [self addSubview:self.arrowImageView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:self.activityIndicatorView];
    
}

// 设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    CGFloat titleImageHeight = 137;
    CGFloat titleImageYPos = self.mj_h - kBottomSpacing - kIndicatorWidth - titleImageHeight;
    self.titleImageView.frame = CGRectMake(0, titleImageYPos, kScreenWidth, titleImageHeight);
    
    CGFloat logoImageWidth = 55;
    CGFloat logoImageHeight = logoImageWidth;
    CGFloat logoImageXPos = self.mj_w - logoImageWidth - 16;
    CGFloat logoImageYPos = self.mj_h - logoImageHeight - kBottomSpacing / 2;
    self.logoGifImageView.frame = CGRectMake(logoImageXPos, logoImageYPos, logoImageWidth, logoImageHeight);
    
    CGFloat arrowImageWidth = 20;
    CGFloat arrowImageHeight = arrowImageWidth;
    CGFloat arrowImageXPos = (self.mj_w - arrowImageWidth) / 2;
    CGFloat arrowImageYPos = titleImageYPos + titleImageHeight;
    self.arrowImageView.frame = CGRectMake(arrowImageXPos, arrowImageYPos, arrowImageWidth, arrowImageHeight);
    
    CGFloat indicatorWidth = 20;
    CGFloat indicatorHeight = indicatorWidth;
    CGFloat indicatorXPos = arrowImageXPos;
    CGFloat indicatorYPos = arrowImageYPos;
    self.activityIndicatorView.frame = CGRectMake(indicatorXPos, indicatorYPos, indicatorWidth, indicatorHeight);
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
            if (oldState == MJRefreshStateRefreshing) {
                self.arrowImageView.transform = CGAffineTransformIdentity;
                [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                    self.activityIndicatorView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    if (self.state != MJRefreshStateIdle) return;
                    
                    self.activityIndicatorView.alpha = 1.0;
                    [self.activityIndicatorView stopAnimating];
                    self.arrowImageView.hidden = NO;
                }];
            } else {
                [self.activityIndicatorView stopAnimating];
                self.arrowImageView.hidden = NO;
                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                    self.arrowImageView.transform = CGAffineTransformIdentity;
                }];
            }
            break; }
        case MJRefreshStatePulling: {
            [self.activityIndicatorView stopAnimating];
            self.arrowImageView.hidden = NO;
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowImageView.transform = CGAffineTransformMakeRotation(- M_PI);
            }];
            break; }
        case MJRefreshStateRefreshing: {
            self.arrowImageView.hidden = YES;
            self.activityIndicatorView.alpha = 1.0;
            [self.activityIndicatorView startAnimating];
            break; }
        default:
            break;
    }
}

@end
