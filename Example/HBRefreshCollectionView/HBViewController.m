//
//  HBViewController.m
//  HBRefreshCollectionView
//
//  Created by JunfengLi on 01/10/2016.
//  Copyright (c) 2016 JunfengLi. All rights reserved.
//

#import "HBViewController.h"
#import "HBTestCollectionView.h"

@interface HBViewController ()

@property (nonatomic, strong) HBTestCollectionView *testCollectionView;

@end

@implementation HBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.testCollectionView];
}

#pragma mark - Accessors

- (HBTestCollectionView *)testCollectionView
{
    if (!_testCollectionView) {
        CGFloat yPos = 20;
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds) - yPos;
        _testCollectionView = [[HBTestCollectionView alloc] initWithFrame:CGRectMake(0, yPos, width, height) collectionViewLayout:[UICollectionViewFlowLayout new]];
    }
    
    return _testCollectionView;
}

@end
