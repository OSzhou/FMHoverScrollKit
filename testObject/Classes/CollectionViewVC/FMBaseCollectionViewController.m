//
//  FMBaseCollectionViewController.m
//  testObject
//
//  Created by Smile on 2018/7/30.
//  Copyright © 2018 Windy. All rights reserved.
//

#import "FMBaseCollectionViewController.h"
static const CGFloat FMDefaultTopMargin = 200.f;
static NSString *FMBaseID = @"FMBaseID";
#define View_W [UIScreen mainScreen].bounds.size.width
#define View_H [UIScreen mainScreen].bounds.size.height
@interface FMBaseCollectionViewController ()
- (CGFloat)topMargin;
@end

@implementation FMBaseCollectionViewController

- (CGFloat)topMargin {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewContentInsetOfTopWith:)]) {
        return [self.delegate collectionViewContentInsetOfTopWith:self.collectionView];
    } else {
        return FMDefaultTopMargin;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

#pragma mark --- collectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(View_W / 2 - .5, (250.0 / 667.0) * View_H);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FMBaseID forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark --- lazyLoading
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(self.topMargin, 0, 0, 0);
        _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(self.topMargin, 0, 0, 0);
        _collectionView.scrollsToTop = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:FMBaseID];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return _collectionView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewContentOffset:withColletionView:)]) {
        [self.delegate collectionViewContentOffset:scrollView.contentOffset.y withColletionView:self.collectionView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat y = targetContentOffset->y;
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewDidEndDragging:withContentOffset:)]) {
        [self.delegate collectionViewDidEndDragging:self.collectionView withContentOffset:y];
    }
}

@end
