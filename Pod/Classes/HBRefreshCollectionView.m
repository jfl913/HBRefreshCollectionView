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
#import "BBPodBundle.h"
#import "UIScrollView+EmptyDataSet.h"

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
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        __weak typeof(self) weakSelf = self;
        self.collectionView.mj_header = [BBDIYHeader headerWithRefreshingBlock:^{
            if ([weakSelf.refreshDelegate respondsToSelector:@selector(sendFirstPageRequest)]) {
                [weakSelf.refreshDelegate sendFirstPageRequest];
            }
        }];
        self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if ([weakSelf.refreshDelegate respondsToSelector:@selector(sendNextPageRequest)]) {
                [weakSelf.refreshDelegate sendNextPageRequest];
            }
        }];
        MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.collectionView.mj_footer;
        [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
        self.collectionView.mj_footer.hidden = YES;
        [self addSubview:self.collectionView];
        
        self.collectionView.emptyDataSetSource = self;
        self.collectionView.emptyDataSetDelegate = self;
        
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
        if ([self.refreshDelegate respondsToSelector:@selector(sendFirstPageRequest)]) {
            [self.refreshDelegate sendFirstPageRequest];
        }
    }
}

@end
