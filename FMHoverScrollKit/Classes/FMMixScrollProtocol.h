//
//  FMScrollProtocol.h
//  FMHoverScrollKit
//
//  Created by Zhouheng on 2020/5/14.
//  Copyright © 2020 Windy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FMBaseCollectionViewDelegate <NSObject>
/** 一直拖拽时的y计算返回 */
- (void)collectionViewContentOffset:(CGFloat)collectionViewY withColletionView:(UICollectionView *)collectionView;
/** 惯性滑动停止的y计算 */
- (void)collectionViewDidEndDragging:(UICollectionView *)collectionView withContentOffset:(CGFloat)offsetY;
- (CGFloat)collectionViewContentInsetOfTopWith:(UICollectionView *)collectionView;
/** collectionView最终停止滑动 */
//- (void)collectionViewDidEndDecelerating:(UICollectionView *)collectionView;
@end

@protocol FMBaseTableViewDelegate <NSObject>
/** 一直拖拽时的y计算返回 */
- (void)tableViewContentOffset:(CGFloat)tableViewY withTableView:(UITableView *)tableView;
/** 惯性滑动停止的y计算 */
- (void)tableViewDidEndDragging:(UITableView *)tableView withContentOffset:(CGFloat)offsetY;
- (CGFloat)tableViewContentInsetOfTopWith:(UITableView *)tableView;
/** tableView最终停止滑动 */
- (void)tableViewDidEndDecelerating:(UITableView *)tableView;
@end
NS_ASSUME_NONNULL_END
