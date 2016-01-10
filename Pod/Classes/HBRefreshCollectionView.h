//
//  HBRefreshCollectionView.h
//  Pods
//
//  Created by JunfengLi on 16/1/10.
//
//

#import <UIKit/UIKit.h>

@protocol HBRefreshCollectionViewDelegate <NSObject>

@optional

- (void)sendFirstPageRequest;
- (void)sendNextPageRequest;

@end

@interface HBRefreshCollectionView : UIView

@property (nonatomic, weak) id <HBRefreshCollectionViewDelegate> refreshDelegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *modelsArray;
@property (nonatomic) NSInteger currentPage;

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout;

- (void)finishLoadCollectionViewDataSource:(NSArray *)dataSource
                                    atPage:(NSInteger)currentPage;

@end
