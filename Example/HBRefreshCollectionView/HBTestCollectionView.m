//
//  HBTestCollectionView.m
//  HBRefreshCollectionView
//
//  Created by JunfengLi on 16/1/10.
//  Copyright © 2016年 JunfengLi. All rights reserved.
//

#import "HBTestCollectionView.h"

static NSString *const cellReuseIdentifier = @"color";

#define MJRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

@interface HBTestCollectionView () <HBRefreshCollectionViewDelegate>


@end

@implementation HBTestCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.refreshDelegate = self;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
        [self sendFirstPageRequest];
    }
    
    return self;
}

#pragma mark - HBRefreshCollectionViewDelegate

- (void)sendFirstPageRequest
{
    NSMutableArray *tmpArray = [@[] mutableCopy];
    for (int i = 0; i < 10; i++) {
        [tmpArray addObject:MJRandomColor];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self finishLoadCollectionViewDataSource:tmpArray atPage:1];
    });
}

- (void)sendNextPageRequest
{
    NSMutableArray *tmpArray = [@[] mutableCopy];
    for (int i = 0; i < 20; i++) {
        [tmpArray addObject:MJRandomColor];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self finishLoadCollectionViewDataSource:tmpArray atPage:(self.currentPage + 1)];
    });
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = self.modelsArray[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

@end
