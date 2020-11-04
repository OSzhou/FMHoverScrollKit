//
//  FMMixScrollConfig.h
//  FMHoverScrollKit
//
//  Created by Zhouheng on 2020/5/14.
//  Copyright © 2020 Windy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HeadView.h"
#import "FMMixScrollProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMMixScrollConfig : NSObject

/** 传入的子控制器的数组 ps:不可变数组, 最多不要超过5个（暂不支持滑动）*/
@property (nonatomic, strong) NSArray <UIViewController *>*childVCArr;
/** 传入的UITableView 或 UICollectionView数组 ps:不可变数组, 最多不要超过5个（暂不支持滑动）*/
@property (nonatomic, strong) NSArray <UIScrollView *>*scrollTorCArr;
/** 转入的头部视图的image图片的名称 */
@property (nonatomic, strong) NSString *headImageName;
/** 是否允许headView缩放，默认NO */
@property (nonatomic, assign) BOOL isStretch;
/** 顶部图片高度 */
@property (nonatomic, assign) CGFloat headImage_H;
/** 按钮的高度 ps:宽度由按钮个数决定，平分屏幕宽度 */
@property (nonatomic, assign) CGFloat button_H;
/** bar悬停的位置 ps:默认为navigationBar + statusBar的高度 */
@property (nonatomic, assign) CGFloat barStop_H;
/** button下面指示条的颜色 */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 是否隐藏指示条 */
@property (nonatomic, assign) BOOL isIndicatorHidden;
/** button的名称 */
@property (nonatomic, strong) NSArray *btnTitleArr;
/** button的选中名称 */
@property (nonatomic, strong) NSArray *btnSelectedTitleArr;
/** button的font */
@property (nonatomic, strong) UIFont *btnFont;
/** button的selected title color */
@property (nonatomic, strong) UIColor *btnSelectedTitleColor;
/** button的normal titl color*/
@property (nonatomic, strong) UIColor *btnNormalTitleColor;
/** button的背景颜色 */
@property (nonatomic, strong) UIColor *btnBackColor;
/** view 是否需要懒加载,ps:为YES时，子视图初次初始化时，若bar不在原位，会自动置回 */
@property (nonatomic, assign) BOOL shouldLazyLoad;
/// 测试使用
@property (nonatomic, assign) BOOL isTest;

@end

@protocol FMMixScrollManagerDelegate <NSObject>

- (void)currentSelectedIndex:(NSInteger)index;

@end

@interface FMMixScrollBaseDelegateManager : NSObject <FMBaseTableViewDelegate, FMBaseCollectionViewDelegate>

@property (nonatomic, weak) id <FMMixScrollManagerDelegate> delegate;
/** 头部视图，可以自己向上面添加自定义的控件 */
@property (nonatomic, strong) HeadView *headView;

@property (nonatomic, strong) UIView *bar;
@property (nonatomic, strong) UIScrollView *horizontalSV;

- (instancetype)initWithConfig:(FMMixScrollConfig *)config fatherController:(UIViewController *)fatherController;

- (void)scrollToIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
