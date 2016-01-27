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

@interface HBRefreshCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

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
//        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            if ([weakSelf.refreshDelegate respondsToSelector:@selector(sendFirstPageRequest)]) {
//                [weakSelf.refreshDelegate sendFirstPageRequest];
//            }
//        }];
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
        self.collectionView.mj_footer.hidden = YES;
        [self addSubview:self.collectionView];
        
        self.modelsArray = [@[] mutableCopy];
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
        self.collectionView.mj_footer.hidden = YES;
    }
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

@end
