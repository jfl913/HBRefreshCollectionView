//
//  HBRefreshCollectionView.h
//  Pods
//
//  Created by JunfengLi on 16/1/10.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EmptyDataStatus) {
    EmptyDataStatusLoading,
    EmptyDataStatusEmpty,
    EmptyDataStatusError,
};

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
@property (nonatomic) EmptyDataStatus emptyDataStatus;

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout;

- (void)finishLoadCollectionViewDataSource:(NSArray *)dataSource
                                    atPage:(NSInteger)currentPage;

- (void)failLoadCollectionViewData;

@end
