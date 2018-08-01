//
//  FMBaseCollectionViewController.h
//  testObject
//
//  Created by Smile on 2018/7/30.
//  Copyright © 2018 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BaseCollectionViewDelegate <NSObject>
/** 一直拖拽时的y计算返回 */
- (void)collectionViewContentOffset:(CGFloat)collectionViewY withColletionView:(UICollectionView *)collectionView;
/** 惯性滑动停止的y计算 */
- (void)collectionViewDidEndDragging:(UICollectionView *)collectionView withContentOffset:(CGFloat)offsetY;
- (CGFloat)collectionViewContentInsetOfTopWith:(UICollectionView *)collectionView;
/** collectionView最终停止滑动 */
//- (void)collectionViewDidEndDecelerating:(UICollectionView *)collectionView;
@end
@interface FMBaseCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/** collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 代理 */
@property (nonatomic, weak) id <BaseCollectionViewDelegate> delegate;

@end
