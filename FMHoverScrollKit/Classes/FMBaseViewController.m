//
//  FMBaseViewController.m
//  FMHoverScrollKit
//
//  Created by Windy on 2016/10/20.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "FMBaseViewController.h"
#import "FMT1ViewController.h"
#import "FMT2ViewController.h"
#import "FMT3ViewController.h"
#import "FMC1ViewController.h"
#import "FMConst.h"

#define View_W [UIScreen mainScreen].bounds.size.width
#define View_H [UIScreen mainScreen].bounds.size.height
@interface FMBaseViewController () <UIScrollViewDelegate, UITableViewDelegate, FMBaseTableViewDelegate, FMBaseCollectionViewDelegate>
@property (nonatomic, strong) UIView *bar;
@property (nonatomic, strong) UIScrollView *horizontalSV;
//@property (nonatomic, strong) UITableView *tableV;
//@property (nonatomic, strong) UICollectionView *collectionV;
/** 当前正在展示的tableView 或 collectionView */
@property (nonatomic, strong) UIScrollView *currentShowV;
/** 指示条 */
@property (nonatomic, strong) UIView *indicatorView;
/** childVcArr */
@property (nonatomic, strong) NSArray *childArr;
/** childVcCount */
@property (nonatomic, assign) NSInteger cvcCount;
/** 上个tableView的偏移量 */
@property (nonatomic, assign) CGFloat preTOffsetY;
/** 顶部图片 */
@property (nonatomic, strong) UIImageView *headImageView;

@end
//*** 有时候bar在顶部时，有时点击会突然跳回，是因为触发了tableViewe的scrollToTop属性 已关闭，需要此功能的请自行打开***
@implementation FMBaseViewController

- (instancetype)init {
    if (self = [super init]) {
        _barStop_H = [self isiPhoneX] ? 88.0 : 64.0;
        _preTOffsetY = -200.f;//默认值
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

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger count = self.childVCArr.count;
    if (count) {
        _childArr = _childVCArr;
    } else {
        self.view.backgroundColor = [UIColor yellowColor];
        FMT1ViewController *t1 = [[FMT1ViewController alloc] init];
        FMC1ViewController *c2 = [[FMC1ViewController alloc] init];
        FMT3ViewController *t3 = [[FMT3ViewController alloc] init];
        _childArr = @[t1,c2,t3];
    }
    _cvcCount = _childArr.count;
    for (int i = 0; i < _childArr.count; i++) {
        if ([_childArr[i] isKindOfClass:[FMBaseCollectionViewController class]]) {
            FMBaseCollectionViewController *fcv = _childArr[i];
            fcv.delegate = self;//注意代码顺序，代理设置要放在前面
            if (i == 0) {
                self.currentShowV = (UICollectionView *)fcv.collectionView;
            }
            [self addChildViewController:fcv];
            
            //在这添加达不到懒加载的效果
            if (!_shouldLazyLoad) {
                fcv.view.frame = CGRectMake(i * View_W, 0, View_W, View_H - _button_H - _barStop_H);
                fcv.collectionView.frame = CGRectMake(0, 0, View_W, View_H - _button_H - _barStop_H);
                [self.horizontalSV addSubview:fcv.view];
            }
            
        } else if ([_childArr[i] isKindOfClass:[FMBaseTableViewController class]]) {
            FMBaseTableViewController *ftv = _childArr[i];
            ftv.delegate = self;//注意代码顺序，代理设置要放在前面
            if (i == 0) {
                self.currentShowV = (UITableView *)ftv.tableView;
            }
            [self addChildViewController:ftv];
            
            //在这添加达不到懒加载的效果
            if (!_shouldLazyLoad) {
                ftv.view.frame = CGRectMake(i * View_W, 0, View_W, View_H - _button_H - _barStop_H);
                ftv.tableView.frame = CGRectMake(0, 0, View_W, View_H - _button_H - _barStop_H);
                [self.horizontalSV addSubview:ftv.view];
            }
            
        } else {
        }
        
        
    }
    //都加在垂直的scrollview上
    [self.view addSubview:self.horizontalSV];
    [self.view addSubview:self.headView];
    [self.headView addSubview:self.bar];
    _isIndicatorHidden?:
    [self.bar addSubview:self.indicatorView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:HeadViewTouchMoveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endNotification:) name:HeadViewTouchEndNotification object:nil];
     [self scrollViewDidEndScrollingAnimation:self.horizontalSV];
    
    NSArray *gestureArray = self.navigationController.view.gestureRecognizers;
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
        if ([_childArr[i] isKindOfClass:[FMBaseCollectionViewController class]]) {
            FMBaseCollectionViewController *fcv = _childArr[i];
            if ([fcv.collectionView isEqual:self.currentShowV]) {
                continue;
            } else {
                fcv.collectionView.contentOffset = self.currentShowV.contentOffset.y < -_headImage_H ? CGPointMake(0, -_headImage_H) : self.currentShowV.contentOffset;
            }
        } else if ([_childArr[i] isKindOfClass:[FMBaseTableViewController class]]) {
            FMBaseTableViewController *ftv = _childArr[i];
            if ([ftv.tableView isEqual:self.currentShowV]) {
                continue;
            } else {
                ftv.tableView.contentOffset = self.currentShowV.contentOffset.y < -_headImage_H ? CGPointMake(0, -_headImage_H) : self.currentShowV.contentOffset;
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
    _bar.frame = CGRectMake(0, (CGRectGetHeight(_headView.frame) - _button_H), View_W, _button_H);
    _headImageView.frame = frame;*/
}

- (void)tableViewDidEndDragging:(UITableView *)tableView withContentOffset:(CGFloat)offsetY {
    //判断bar是否在顶部
    if (offsetY > 0) {//在
      /*  for (int i = 0; i < _cvcCount; i++) {
            FMBaseTableViewController *ftv = _childArr[i];
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
            FMBaseTableViewController *ftv = _childArr[i];
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
    return _headImage_H;
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
    return _headImage_H;
}

- (void)scrollToVisibleViewPositionWith:(CGFloat)offsetY barIsTop:(BOOL)isTop {
    for (int i = 0; i < _cvcCount; i++) {
        if ([_childArr[i] isKindOfClass:[FMBaseCollectionViewController class]]) {
            FMBaseCollectionViewController *fcv = _childArr[i];
            if ([fcv.collectionView isEqual:self.currentShowV]) {
                continue;
            } else {
                CGFloat Y = fcv.collectionView.contentOffset.y;
                if (isTop && (Y > 0)) {
                } else {
                    fcv.collectionView.contentOffset = CGPointMake(0, offsetY > 0 ? 0 : offsetY);
                }
            }
        } else if ([_childArr[i] isKindOfClass:[FMBaseTableViewController class]]) {
            FMBaseTableViewController *ftv = _childArr[i];
            if ([ftv.tableView isEqual:self.currentShowV]) {
                continue;
            } else {
                CGFloat Y = ftv.tableView.contentOffset.y;
                if (isTop && (Y > 0)) {
                } else {
                    ftv.tableView.contentOffset = CGPointMake(0, offsetY > 0 ? 0 : offsetY);
                }
            }
        } else {
        }
    }
}

- (void)resetHeaderViewFrameWith:(CGFloat)offSetY {
    CGRect frame = CGRectMake(0, _barStop_H, View_W, _headImage_H + _button_H);
    //tableViewY有初始值（设置了UIEdgeIntset）为 -(headView_H - BTN_BG_H)
    _preTOffsetY = offSetY;
    if (offSetY > -(_headImage_H)) {
        if (offSetY > 0) {
            frame.origin.y = -(_headImage_H) + _barStop_H;
        } else {
            frame.origin.y = -(_headImage_H + offSetY) + _barStop_H;
        }
        _headView.frame = frame;
        _bar.frame = CGRectMake(0, (CGRectGetHeight(_headView.frame) - _button_H), View_W, _button_H);
    } else {
        // pull down stretching
        frame.origin.y = 0;
        if (_isStretch) {
            frame.size.height = -_preTOffsetY + _button_H;
            [self resetTableViewContentOffsetYWithFrame:frame];
        } else {
            _headView.frame = CGRectMake(0, _barStop_H, View_W, _headImage_H + _button_H);;
        }
    }
}

- (void)resetTableViewContentOffsetYWithFrame:(CGRect)frame {
    self.headView.frame = CGRectMake(0, _barStop_H, CGRectGetWidth(frame), CGRectGetHeight(frame));
    _bar.frame = CGRectMake(0, (CGRectGetHeight(self.headView.frame) - _button_H), View_W, _button_H);
    _headImageView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
}

- (void)btnClick:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    CGPoint offset = self.horizontalSV.contentOffset;
    offset.x = index * View_W;
    [self.horizontalSV setContentOffset:offset animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.horizontalSV) {
        CGFloat w = View_W;
        CGFloat offSetX = scrollView.contentOffset.x;
        CGFloat tableOSY = 0;
        if ((int)_preTOffsetY > -(_headImage_H) && (int)_preTOffsetY <= 0) {
            tableOSY = (int)self.currentShowV.contentOffset.y;
        } else if ((int)_preTOffsetY > 0) {
            tableOSY = 0;
        } else {
            tableOSY = -_headImage_H;
        }
        NSInteger index = offSetX / w;
        CGRect frame = self.indicatorView.frame;
        frame.origin.x = index * View_W / _cvcCount;
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
        if ([self.childViewControllers[index] isKindOfClass:[FMBaseCollectionViewController class]]) {
            FMBaseCollectionViewController *fcv = self.childViewControllers[index];
            self.currentShowV = (UICollectionView *)fcv.collectionView;
            if (((int)_preTOffsetY > 0) && (self.currentShowV.contentOffset.y > 0)) {
            } else {
                self.currentShowV.contentOffset = CGPointMake(0, tableOSY);
            }
            
            if (_shouldLazyLoad) {
                //已下四行代码，使页面用到时再加载，达到懒加载的目的
                if ([fcv isViewLoaded]) return;
                fcv.view.frame = CGRectMake(index * View_W, 0, View_W, View_H - _button_H - _barStop_H);
                fcv.collectionView.frame = CGRectMake(0, 0, View_W, View_H - _button_H - _barStop_H);
                [self.horizontalSV addSubview:fcv.view];
            }
            
        } else if ([self.childViewControllers[index] isKindOfClass:[FMBaseTableViewController class]]) {
            FMBaseTableViewController *ftv = self.childViewControllers[index];
            self.currentShowV = (UITableView *)ftv.tableView;
            if (((int)_preTOffsetY > 0) && (self.currentShowV.contentOffset.y > 0)) {
            } else {
                self.currentShowV.contentOffset = CGPointMake(0, tableOSY);
            }
            
            if (_shouldLazyLoad) {
                //已下四行代码，使页面用到时再加载，达到懒加载的目的
                if ([ftv isViewLoaded]) return;
                ftv.view.frame = CGRectMake(index * View_W, 0, View_W, View_H - _button_H - _barStop_H);
                ftv.tableView.frame = CGRectMake(0, 0, View_W, View_H - _button_H - _barStop_H);
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

- (void)setIsStretch:(BOOL)isStretch {
    _isStretch = isStretch;
}

- (void)setHeadImageName:(NSString *)headImageName {
    _headImageName = headImageName;
}

- (void)setHeadImage_H:(CGFloat)headImage_H {
    _headImage_H = headImage_H;
}

- (void)setButton_H:(CGFloat)button_H {
    _button_H = button_H;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
}

- (void)setIsIndicatorHidden:(BOOL)isIndicatorHidden {
    _isIndicatorHidden = isIndicatorHidden;
}

- (void)setBtnBackColor:(UIColor *)btnBackColor {
    _btnBackColor = btnBackColor;
}

#pragma mark --- 懒加载区
- (UIScrollView *)horizontalSV {
    if (!_horizontalSV) {
        //_horizontalSV 的y值 是 _button_H 所以tableView 的topContentInset只需要_headImage_H就可以了
        _horizontalSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _button_H + _barStop_H, self.view.frame.size.width, View_H - _button_H -_barStop_H)];
        _horizontalSV.backgroundColor = [UIColor clearColor];
        _horizontalSV.bounces = NO;
        //        _horizontalSV.scrollEnabled = NO;
        _horizontalSV.alwaysBounceHorizontal = YES;
        _horizontalSV.delegate = self;
        _horizontalSV.pagingEnabled = YES;
        _horizontalSV.showsHorizontalScrollIndicator = NO;
        _horizontalSV.contentSize = CGSizeMake(View_W * _cvcCount, 0);
    }
    return _horizontalSV;
}

/** headView */
- (HeadView *)headView {
    if (!_headView) {
        _headView = [[HeadView alloc] init];
        _headView.barStop_H = _barStop_H;
        _headView.frame = CGRectMake(0, _barStop_H, View_W, _headImage_H + _button_H);
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, View_W, (CGRectGetHeight(_headView.frame) - _button_H))];
        _headImageView.image = [UIImage imageNamed:_headImageName];
        //#warning 通过设置这个Mode，改变图片的高或宽（其中任意一个）能使图片等比例缩放
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        //裁剪去由于Mode引起的图片超出视图原定范围部分
        _headView.clipsToBounds = YES;
        [_headView addSubview:_headImageView];
        _headView.backgroundColor = [UIColor grayColor];
    }
    return _headView;
}

- (void)setBtnTitleArr:(NSArray *)btnTitleArr {
    _btnTitleArr = btnTitleArr;
}

/** butBGView (在此根据要求自定义按钮)*/
- (UIView *)bar {
    if (!_bar) {
        _bar = [[UIView alloc] init];
        _bar.frame = CGRectMake(0, (CGRectGetHeight(_headView.frame) - _button_H), View_W, _button_H);
        _bar.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        CGFloat w = View_W;
        for (int i = 0; i < _cvcCount; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * w / _cvcCount, 0, w / _cvcCount, _button_H);
            
            if (_btnFont) {
                btn.titleLabel.font = _btnFont;
            } else {
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
            }
            
            if (_btnNormalTitleColor){
                [btn setTitleColor:_btnNormalTitleColor forState:UIControlStateNormal];
            }
            if (_btnSelectedTitleColor){
                [btn setTitleColor:_btnSelectedTitleColor forState:UIControlStateSelected];
            }
            
            [btn setTitle:_btnTitleArr.count > 0 ? _btnTitleArr[i] : [NSString stringWithFormat:@"btn_%d", i] forState:UIControlStateNormal];
            
            if (_btnTitleArr && _btnTitleArr.count == _btnSelectedTitleArr.count) {
                [btn setTitle:_btnSelectedTitleArr[i] forState:UIControlStateSelected];
            } else {
                [btn setTitle:[NSString stringWithFormat:@"selected_%d", i] forState:UIControlStateSelected];
            }
            
            btn.backgroundColor = _btnBackColor ?: [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1.0];
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
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, _button_H - 2.0, View_W / _cvcCount, 2.0)];
        _indicatorView.backgroundColor = _indicatorColor;
    }
    return _indicatorView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

