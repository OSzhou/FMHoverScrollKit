//
//  FMMixScrollConfig.m
//  testObject
//
//  Created by Zhouheng on 2020/5/14.
//  Copyright © 2020 Windy. All rights reserved.
//

#import "FMMixScrollBaseDelegateManager.h"
#import "FMConst.h"

#define FMView_W [UIScreen mainScreen].bounds.size.width
#define FMView_H [UIScreen mainScreen].bounds.size.height

@implementation FMMixScrollConfig

- (instancetype)init {
    if (self = [super init]) {
        _barStop_H = [self isiPhoneX] ? 88.0 : 64.0;
        _headImage_H = 200.f;//默认值
        _button_H = 50.f;//默认值
        //此示例资源图较大，不需要者，自行删除
        _headImageName = @"FMPicture.bundle/picture_2";
        _indicatorColor = [UIColor colorWithRed:0.14 green:0.18 blue:0.21 alpha:1.0];
        _btnNormalTitleColor = [UIColor colorWithRed:0.56 green:0.65 blue:0.7 alpha:1.0];
        _btnSelectedTitleColor = [UIColor colorWithRed:0.14 green:0.18 blue:0.21 alpha:1.0];
    }
    return self;
}

- (BOOL)isiPhoneX {
    if(@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        
        CGFloat bottomSafeInset = keyWindow.safeAreaInsets.bottom;
        
        if(bottomSafeInset == 34.0f|| bottomSafeInset == 21.0f) {
            return YES;
        }
    }
    return NO;
}

@end

@interface FMMixScrollBaseDelegateManager () <UIScrollViewDelegate, UITableViewDelegate>

@property (nonatomic, strong) FMMixScrollConfig *config;
/** 父控制器 必须有*/
@property (nonatomic, weak) UIViewController *fatherController;
/** 当前正在展示的tableView 或 collectionView */
@property (nonatomic, strong) UIScrollView *currentShowV;
/** 指示条 */
@property (nonatomic, strong) UIView *indicatorView;
/** childVcArr */
@property (nonatomic, strong) NSArray *tOrcArr;
/** childVcCount */
@property (nonatomic, assign) NSInteger cvcCount;
/** 上个tableView的偏移量 */
@property (nonatomic, assign) CGFloat preTOffsetY;
/** 顶部图片 */
@property (nonatomic, strong) UIImageView *headImageView;

@end
//*** 有时候bar在顶部时，有时点击会突然跳回，是因为触发了tableViewe的scrollToTop属性 已关闭，需要此功能的请自行打开***
@implementation FMMixScrollBaseDelegateManager

- (instancetype)initWithConfig:(FMMixScrollConfig *)config fatherController:(UIViewController *)fatherController {
    if (self = [super init]) {
        _preTOffsetY = -200.f;//默认值
        _config = config;
        _fatherController = fatherController;
        [self configUI];
    }
    return self;
}

- (void)configUI {
  
    _cvcCount = self.config.childVCArr.count;
    _tOrcArr = _config.scrollTorCArr;
    for (int i = 0; i < _cvcCount; i++) {
        
        UIViewController *vc = _config.childVCArr[i];
        [self.fatherController addChildViewController:vc];
        
        //在这添加达不到懒加载的效果
        if (!_config.shouldLazyLoad) {
            UIScrollView *sv = _config.scrollTorCArr[i];
            vc.view.frame = CGRectMake(i * FMView_W, 0, FMView_W, FMView_H - _config.button_H - _config.barStop_H);
            sv.frame = CGRectMake(0, 0, FMView_W, FMView_H - _config.button_H - _config.barStop_H);
            [self.horizontalSV addSubview:vc.view];
        }
        
    }
    //都加在垂直的scrollview上
    [self.fatherController.view addSubview:self.horizontalSV];
    [self.fatherController.view addSubview:self.headView];
    [self.headView addSubview:self.bar];
    _config.isIndicatorHidden?:
    [self.bar addSubview:self.indicatorView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:HeadViewTouchMoveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endNotification:) name:HeadViewTouchEndNotification object:nil];
     [self scrollViewDidEndScrollingAnimation:self.horizontalSV];
    
    NSArray *gestureArray = self.fatherController.navigationController.view.gestureRecognizers;
    // 当是侧滑手势的时候设置scrollview需要此手势失效即可
    for (UIGestureRecognizer *gesture in gestureArray) {
        if ([gesture isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            [_horizontalSV.panGestureRecognizer requireGestureRecognizerToFail:gesture];
            break;
        }
    }
    
}

- (void)endNotification:(NSNotification *)noti {
    for (int i = 0; i < _cvcCount; i++) {
        if ([_tOrcArr[i] isKindOfClass:[UICollectionView class]]) {
            UICollectionView *cv = _tOrcArr[i];
            if ([cv isEqual:self.currentShowV]) {
                if (cv.contentSize.height <= FMView_H - _config.headImage_H -_config.button_H - _config.barStop_H) {
                    _headView.frame = CGRectMake(0, _config.barStop_H, FMView_W, _config.headImage_H + _config.button_H);
                    cv.contentOffset = CGPointMake(0, - _config.headImage_H);
                }
                continue;
            } else {
                cv.contentOffset = self.currentShowV.contentOffset.y < -_config.headImage_H ? CGPointMake(0, -_config.headImage_H) : self.currentShowV.contentOffset;
            }
        } else if ([_tOrcArr[i] isKindOfClass:[UITableView class]]) {
            UITableView *tv = _tOrcArr[i];
            if ([tv isEqual:self.currentShowV]) {
                if (tv.contentSize.height <= FMView_H - _config.headImage_H - _config.button_H - _config.barStop_H) {
                    _headView.frame = CGRectMake(0, _config.barStop_H, FMView_W, _config.headImage_H + _config.button_H);
                    tv.contentOffset = CGPointMake(0, - _config.headImage_H);
                }
                continue;
            } else {
                tv.contentOffset = self.currentShowV.contentOffset.y < -_config.headImage_H ? CGPointMake(0, -_config.headImage_H) : self.currentShowV.contentOffset;
            }
        } else {
        }
    }
}

- (void)notification:(NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    NSNumber *offsetY = dict[@"offsetY"];
    CGFloat Y = [offsetY integerValue];
    CGFloat tableVOffset = self.currentShowV.contentOffset.y;
    self.currentShowV.contentOffset = CGPointMake(0, tableVOffset - Y);
    
}

#pragma mark --- FMBaseTableViewDelegate
- (void)tableViewContentOffset:(CGFloat)tableViewY withTableView:(UITableView *)tableView{
    if ([tableView isEqual:self.currentShowV]) {
        [self resetHeaderViewFrameWith:tableViewY];
    }
}

- (void)tableViewDidEndDecelerating:(UITableView *)tableView {
   /* CGRect frame = _headView.frame;
    frame.size.height = _headImage_H + _button_H;
    _headView.frame = frame;
    _bar.frame = CGRectMake(0, (CGRectGetHeight(_headView.frame) - _button_H), FMView_W, _button_H);
    _headImageView.frame = frame;*/
}

- (void)tableViewDidEndDragging:(UITableView *)tableView withContentOffset:(CGFloat)offsetY {
    //判断bar是否在顶部
    if (offsetY > 0) {//在
      /*  for (int i = 0; i < _cvcCount; i++) {
            FMBaseTableViewController *ftv = _tOrcArr[i];
            if ([ftv.tableView isEqual:self.tableV]) {
                continue;
            } else {
                CGFloat Y = ftv.tableView.contentOffset.y;
                if (Y > 0) {
                } else
                ftv.tableView.contentOffset = CGPointMake(0, 0);
            }
        }*/
        // code review
        [self scrollToVisibleViewPositionWith:offsetY barIsTop:YES];
    } else {//不在
  /*      for (int i = 0; i < _cvcCount; i++) {
            FMBaseTableViewController *ftv = _tOrcArr[i];
            if ([ftv.tableView isEqual:self.tableV]) {
                continue;
            } else {
                ftv.tableView.contentOffset = CGPointMake(0, offsetY);
            }
        }*/
        // code review
        [self scrollToVisibleViewPositionWith:offsetY barIsTop:NO];
    }
}

- (CGFloat)tableViewContentInsetOfTopWith:(UITableView *)tableView {
    return _config.headImage_H;
}
#pragma mark --- collectionView Delegate
- (void)collectionViewContentOffset:(CGFloat)collectionViewY withColletionView:(UICollectionView *)collectionView {
    if ([collectionView isEqual:self.currentShowV]) {
        [self resetHeaderViewFrameWith:collectionViewY];
    }
}

- (void)collectionViewDidEndDragging:(UICollectionView *)collectionView withContentOffset:(CGFloat)offsetY {
    //判断bar是否在顶部
    if (offsetY > 0) {//在
        [self scrollToVisibleViewPositionWith:offsetY barIsTop:YES];
    } else {//不在
        [self scrollToVisibleViewPositionWith:offsetY barIsTop:NO];
    }
}

- (CGFloat)collectionViewContentInsetOfTopWith:(UICollectionView *)collectionView {
    return _config.headImage_H;
}

- (void)scrollToVisibleViewPositionWith:(CGFloat)offsetY barIsTop:(BOOL)isTop {
    for (int i = 0; i < _cvcCount; i++) {
        if ([_tOrcArr[i] isKindOfClass:[UICollectionView class]]) {
            UICollectionView *cv = _tOrcArr[i];
            if ([cv isEqual:self.currentShowV]) {
                continue;
            } else {
                CGFloat Y = cv.contentOffset.y;
                if (isTop && (Y > 0)) {
                } else {
                    cv.contentOffset = CGPointMake(0, offsetY > 0 ? 0 : offsetY);
                }
            }
        } else if ([_tOrcArr[i] isKindOfClass:[UITableView class]]) {
            UITableView *tv = _tOrcArr[i];
            if ([tv isEqual:self.currentShowV]) {
                continue;
            } else {
                CGFloat Y = tv.contentOffset.y;
                if (isTop && (Y > 0)) {
                } else {
                    tv.contentOffset = CGPointMake(0, offsetY > 0 ? 0 : offsetY);
                }
            }
        } else {
        }
    }
}

- (void)resetHeaderViewFrameWith:(CGFloat)offSetY {
    CGRect frame = CGRectMake(0, _config.barStop_H, FMView_W, _config.headImage_H + _config.button_H);
    //tableViewY有初始值（设置了UIEdgeIntset）为 -(headFMView_H - BTN_BG_H)
    _preTOffsetY = offSetY;
    if (offSetY > -(_config.headImage_H)) {
        if (offSetY > 0) {
            frame.origin.y = -(_config.headImage_H) + _config.barStop_H;
        } else {
            frame.origin.y = -(_config.headImage_H + offSetY) + _config.barStop_H;
        }
        _headView.frame = frame;
        _bar.frame = CGRectMake(0, (CGRectGetHeight(_headView.frame) - _config.button_H), FMView_W, _config.button_H);
    } else {
        // pull down stretching
        frame.origin.y = 0;
        if (_config.isStretch) {
            frame.size.height = -_preTOffsetY + _config.button_H;
            [self resetTableViewContentOffsetYWithFrame:frame];
        } else {
            _headView.frame = CGRectMake(0, _config.barStop_H, FMView_W, _config.headImage_H + _config.button_H);
        }
    }
}

- (void)resetTableViewContentOffsetYWithFrame:(CGRect)frame {
    self.headView.frame = CGRectMake(0, _config.barStop_H, CGRectGetWidth(frame), CGRectGetHeight(frame));
    _bar.frame = CGRectMake(0, (CGRectGetHeight(self.headView.frame) - _config.button_H), FMView_W, _config.button_H);
    _headImageView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
}

- (void)scrollToIndex:(NSInteger)index {
    CGPoint offset = self.horizontalSV.contentOffset;
    offset.x = index * FMView_W;
    [self.horizontalSV setContentOffset:offset animated:YES];
}

- (void)btnClick:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    CGPoint offset = self.horizontalSV.contentOffset;
    offset.x = index * FMView_W;
    [self.horizontalSV setContentOffset:offset animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.horizontalSV) {
        
        CGFloat w = FMView_W;
        CGFloat offSetX = scrollView.contentOffset.x;
        NSInteger index = offSetX / w;
        
        if (index < _tOrcArr.count) {
            self.currentShowV = _tOrcArr[index];
        }
        
        CGFloat tableOSY = 0;
        if ((int)_preTOffsetY > -(_config.headImage_H) && (int)_preTOffsetY <= 0) {
            tableOSY = (int)self.currentShowV.contentOffset.y;
        } else if ((int)_preTOffsetY > 0) {
            tableOSY = 0;
        } else {
            tableOSY = -_config.headImage_H;
        }
        
        CGRect frame = self.indicatorView.frame;
        frame.origin.x = index * FMView_W / _cvcCount;
        self.indicatorView.frame = frame;
        if (offSetX < 0 || offSetX > _cvcCount * w) return;
        for (UIView *view in self.bar.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)view;
                if (btn.tag == index + 100) {
                    btn.selected = YES;
                } else {
                    btn.selected = NO;
                }
            }
        }
        if ([_tOrcArr[index] isKindOfClass:[UICollectionView class]]) {
            UICollectionView *cv = (UICollectionView *)_tOrcArr[index];
            self.currentShowV = cv;
            if (((int)_preTOffsetY > 0) && (self.currentShowV.contentOffset.y > 0)) {
            } else {
                self.currentShowV.contentOffset = CGPointMake(0, tableOSY);
            }
            
            if (_config.shouldLazyLoad) {
                //已下四行代码，使页面用到时再加载，达到懒加载的目的
                UIViewController *fcv = _fatherController.childViewControllers[index];
                if ([fcv isViewLoaded]) return;
                fcv.view.frame = CGRectMake(index * FMView_W, 0, FMView_W, FMView_H - _config.button_H - _config.barStop_H);
                cv.frame = CGRectMake(0, 0, FMView_W, FMView_H - _config.button_H - _config.barStop_H);
                [self.horizontalSV addSubview:fcv.view];
            }
            
        } else if ([_tOrcArr[index] isKindOfClass:[UITableView class]]) {
            UITableView *tv = (UITableView *)_tOrcArr[index];
            self.currentShowV = tv;
            if (((int)_preTOffsetY > 0) && (self.currentShowV.contentOffset.y > 0)) {
            } else {
                self.currentShowV.contentOffset = CGPointMake(0, tableOSY);
            }
            
            if (_config.shouldLazyLoad) {
                //已下四行代码，使页面用到时再加载，达到懒加载的目的
                UIViewController *ftv = self.fatherController.childViewControllers[index];
                if ([ftv isViewLoaded]) return;
                ftv.view.frame = CGRectMake(index * FMView_W, 0, FMView_W, FMView_H - _config.button_H - _config.barStop_H);
                tv.frame = CGRectMake(0, 0, FMView_W, FMView_H - _config.button_H - _config.barStop_H);
                [self.horizontalSV addSubview:ftv.view];
            }
            
        } else {
        }
    }
}

//点击按钮时不会触发, 仅拖动scrollView时触发
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark --- 懒加载区
- (UIScrollView *)horizontalSV {
    if (!_horizontalSV) {
        //_horizontalSV 的y值 是 _button_H 所以tableView 的topContentInset只需要_headImage_H就可以了
        _horizontalSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _config.button_H + _config.barStop_H, FMView_W, FMView_H - _config.button_H -_config.barStop_H)];
        _horizontalSV.backgroundColor = [UIColor clearColor];
        _horizontalSV.bounces = NO;
        //        _horizontalSV.scrollEnabled = NO;
        _horizontalSV.alwaysBounceHorizontal = YES;
        _horizontalSV.delegate = self;
        _horizontalSV.pagingEnabled = YES;
        _horizontalSV.showsHorizontalScrollIndicator = NO;
        _horizontalSV.contentSize = CGSizeMake(FMView_W * _cvcCount, 0);
    }
    return _horizontalSV;
}

/** headView */
- (HeadView *)headView {
    if (!_headView) {
        _headView = [[HeadView alloc] init];
        _headView.barStop_H = _config.barStop_H;
        _headView.frame = CGRectMake(0, _config.barStop_H, FMView_W, _config.headImage_H + _config.button_H);
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FMView_W, (CGRectGetHeight(_headView.frame) - _config.button_H))];
        _headImageView.image = [UIImage imageNamed:_config.headImageName];
        //#warning 通过设置这个Mode，改变图片的高或宽（其中任意一个）能使图片等比例缩放
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        //裁剪去由于Mode引起的图片超出视图原定范围部分
        _headView.clipsToBounds = YES;
        [_headView addSubview:_headImageView];
        _headView.backgroundColor = [UIColor grayColor];
    }
    return _headView;
}

/** butBGView (在此根据要求自定义按钮)*/
- (UIView *)bar {
    if (!_bar) {
        _bar = [[UIView alloc] init];
        _bar.frame = CGRectMake(0, (CGRectGetHeight(_headView.frame) - _config.button_H), FMView_W, _config.button_H);
        CGFloat w = FMView_W;
        for (int i = 0; i < _cvcCount; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * w / _cvcCount, 0, w / _cvcCount, _config.button_H);
            
            if (_config.btnFont) {
                btn.titleLabel.font = _config.btnFont;
            } else {
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
            }
            
            if (_config.btnNormalTitleColor){
                [btn setTitleColor:_config.btnNormalTitleColor forState:UIControlStateNormal];
            }
            
            if (_config.btnSelectedTitleColor){
                [btn setTitleColor:_config.btnSelectedTitleColor forState:UIControlStateSelected];
            }
            
            if (_config.btnTitleArr.count > 0) {
                [btn setTitle:_config.btnTitleArr[i] forState:UIControlStateNormal];
            }
            
            if (_config.btnTitleArr && _config.btnTitleArr.count == _config.btnSelectedTitleArr.count) {
                [btn setTitle:_config.btnSelectedTitleArr[i] forState:UIControlStateSelected];
            }
            
            if (_config.btnBackColor) {
                btn.backgroundColor = _config.btnBackColor;
            }
            
            if (_config.isTest) {
                [btn setTitle:[NSString stringWithFormat:@"btn_%d", i] forState:UIControlStateNormal];
                [btn setTitle:[NSString stringWithFormat:@"selected_%d", i] forState:UIControlStateSelected];
                btn.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1.0];
            }
            
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 100 + i;
            if (i == 0) {
                btn.selected = YES;
            }
            [_bar addSubview:btn];
        }
    }
    return _bar;
}

/** 指示条 */
- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, _config.button_H - 2.0, FMView_W / _cvcCount, 2.0)];
        _indicatorView.backgroundColor = _config.indicatorColor;
    }
    return _indicatorView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
