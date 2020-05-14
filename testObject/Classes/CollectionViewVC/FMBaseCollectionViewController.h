//
//  FMBaseCollectionViewController.h
//  testObject
//
//  Created by Smile on 2018/7/30.
//  Copyright © 2018 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMScrollProtocol.h"
@interface FMBaseCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/** collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 代理 */
@property (nonatomic, weak) id <FMBaseCollectionViewDelegate> delegate;

@end
