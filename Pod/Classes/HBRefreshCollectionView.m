//
//  HBRefreshCollectionView.m
//  Pods
//
//  Created by JunfengLi on 16/1/10.
//
//

#import "HBRefreshCollectionView.h"
#import "MJRefresh.h"
#import "BBDIYHeader.h"
#import "BBDIYAutoFooter.h"
#import "BBPodBundle.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UIColor+Hex.h"

@interface HBRefreshCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation HBRefreshCollectionView

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, width, height) collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        __weak typeof(self) weakSelf = self;
        self.collectionView.mj_header = [BBDIYHeader headerWithRefreshingBlock:^{
            if ([weakSelf.refreshDelegate respondsToSelector:@selector(loadNewData)]) {
                [weakSelf.refreshDelegate loadNewData];
            }
        }];
        self.collectionView.mj_footer = [BBDIYAutoFooter footerWithRefreshingBlock:^{
            if ([weakSelf.refreshDelegate respondsToSelector:@selector(loadMoreData)]) {
                [weakSelf.refreshDelegate loadMoreData];
            }
        }];

        self.collectionView.mj_footer.hidden = YES;
        [self addSubview:self.collectionView];
        
        self.collectionView.emptyDataSetSource = self;
        self.collectionView.emptyDataSetDelegate = self;
        
        self.goTopImageView.hidden = YES;
        [self addSubview:self.goTopImageView];
        
        self.modelsArray = [@[] mutableCopy];
        
        self.emptyDataStatus = EmptyDataStatusLoading;
    }
    
    return self;
}

- (void)finishLoadCollectionViewDataSource:(NSArray *)dataSource atPage:(NSInteger)currentPage
{
    self.currentPage = currentPage;
    
    if (self.currentPage == 1) {
        [self.modelsArray removeAllObjects];
    }
    
    if (dataSource.count > 0) {
        [self.modelsArray addObjectsFromArray:dataSource];
        [self.collectionView reloadData];
        if (self.currentPage == 1) {
            [self.collectionView.mj_header endRefreshing];
        } else {
            [self.collectionView.mj_footer endRefreshing];
        }
        self.collectionView.mj_footer.hidden = NO;
    } else {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)failLoadCollectionViewData
{
    self.emptyDataStatus = EmptyDataStatusError;
    [self.collectionView reloadEmptyDataSet];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.emptyDataStatus == EmptyDataStatusError) {
        NSString *text = @"网络不给力，请稍后再试";
        NSDictionary *attrs = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
        return [[NSAttributedString alloc] initWithString:text attributes:attrs];
    } else {
        return nil;
    }
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    UIImage *image;
    if (self.emptyDataStatus == EmptyDataStatusError) {
        image = [UIImage imageNamed:[BBPodBundle getImagePath:@"default_avatar_img"]];
    } else if (self.emptyDataStatus == EmptyDataStatusEmpty) {
        image = [UIImage imageNamed:[BBPodBundle getImagePath:@"order_empty"]];
    }

    return image;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.emptyDataStatus == EmptyDataStatusLoading) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        return activityView;
    } else {
        return nil;
    }
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20;
}

#pragma mark - DZNEmptyDataSetDelegate

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    if (self.emptyDataStatus == EmptyDataStatusError) {
        self.emptyDataStatus = EmptyDataStatusLoading;
        [self.collectionView reloadEmptyDataSet];
        if ([self.refreshDelegate respondsToSelector:@selector(loadNewData)]) {
            [self.refreshDelegate loadNewData];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self displayGoTopImageView:scrollView];
}

- (void)displayGoTopImageView:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat viewHeight = CGRectGetHeight(self.bounds);
    if (offset > viewHeight) {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.goTopImageView.hidden = NO;
                         } completion:nil];
        
    } else {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.goTopImageView.hidden = YES;
                         } completion:nil];
    }
}

#pragma mark - Gesture Method

- (void)goTop:(UITapGestureRecognizer *)tapGesture
{
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    self.goTopImageView.hidden = YES;
}

#pragma mark - Accessors

- (UIImageView *)goTopImageView
{
    if (!_goTopImageView) {
        CGFloat xPos = CGRectGetWidth(self.bounds) - 50;
        CGFloat yPos = CGRectGetHeight(self.bounds) - 50;
        CGFloat width = 40;
        CGFloat height = 40;
        _goTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
        _goTopImageView.image = [UIImage imageNamed:[BBPodBundle getImagePath:@"ic_switch_top"]];
        _goTopImageView.contentMode = UIViewContentModeCenter;
        _goTopImageView.backgroundColor = [UIColor colorWithRed:255.0/255.0
                                                          green:73.0/255.0
                                                           blue:101.0/255.0
                                                          alpha:0.7];
        _goTopImageView.layer.cornerRadius = width / 2.0;
        _goTopImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goTop:)];
        [_goTopImageView addGestureRecognizer:tapGesture];
    }
    
    return _goTopImageView;
}

- (void)setIsHiddenPullToRefresh:(BOOL)isHiddenPullToRefresh
{
    if (isHiddenPullToRefresh) {
        self.collectionView.mj_header = nil;
    }
}

@end
