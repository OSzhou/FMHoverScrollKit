//
//  FMBaseViewController.m
//  testObject
//
//  Created by Windy on 2016/10/20.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "FMBaseViewController.h"
#import "FMBTController.h"
#import "FMCTController.h"

#define View_W [UIScreen mainScreen].bounds.size.width
#define View_H [UIScreen mainScreen].bounds.size.height
#define BTN_BG_H 50
#define headView_H 250
@interface FMBaseViewController () <UIScrollViewDelegate, UITableViewDelegate, tableViewOneDelegate>
@property (nonatomic, strong) UIView *bar;
@property (nonatomic, strong) UIScrollView *horizontalSV;
@property (nonatomic, strong) UITableView *tableV;
/** 指示条 */
@property (nonatomic, strong) UIView *indicatorView;
/** childVcArr */
@property (nonatomic, strong) NSArray *childArr;
/** childVcCount */
@property (nonatomic, assign) NSInteger cvcCount;
/** 上个tableView的偏移量 */
@property (nonatomic, assign) CGFloat preTOffsetY;
@end

@implementation FMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger count = self.childVCArr.count;
    if (count) {
        _childArr = _childVCArr;
    } else {
        self.view.backgroundColor = [UIColor yellowColor];
        FMATController *ftv = [[FMATController alloc] init];
        FMBTController *stv = [[FMBTController alloc] init];
        FMCTController *ttv = [[FMCTController alloc] init];
        _childArr = @[ftv,stv,ttv];
    }
    _cvcCount = _childArr.count;
    for (int i = 0; i < _childArr.count; i++) {
        FMATController *ftv = _childArr[i];
        if (i == 0) {
            self.tableV = (UITableView *)ftv.view;
        }
        ftv.delegate = self;
        [self addChildViewController:ftv];
        ftv.view.frame = CGRectMake(i * View_W, 0, View_W, View_H - BTN_BG_H);
        [self.horizontalSV addSubview:ftv.view];
    }
    //都加在垂直的scrollview上
    [self.view addSubview:self.horizontalSV];
    [self.view addSubview:self.headView];
    [self.headView addSubview:self.bar];
    [self.bar addSubview:self.indicatorView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"headView" object:nil];
}

- (void)notification:(NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    NSNumber *offsetY = dict[@"offsetY"];
    CGFloat Y = [offsetY integerValue];
    CGFloat tableVOffset = self.tableV.contentOffset.y;
    self.tableV.contentOffset = CGPointMake(0, tableVOffset - Y);
}
#pragma mark --- 懒加载区
- (UIScrollView *)horizontalSV {
    if (!_horizontalSV) {
        _horizontalSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, View_H - BTN_BG_H)];
        _horizontalSV.backgroundColor = [UIColor cyanColor];
        _horizontalSV.bounces = NO;
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
        _headView.frame = CGRectMake(0, 0, View_W, headView_H);
        [_headView addSubview:[[UISwitch alloc] init]];
        _headView.backgroundColor = [UIColor grayColor];
    }
    return _headView;
}
/** butBGView */
- (UIView *)bar {
    if (!_bar) {
        _bar = [[UIView alloc] init];
        _bar.frame = CGRectMake(0, (headView_H - BTN_BG_H), View_W, BTN_BG_H);
        _bar.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        CGFloat w = View_W;
        for (int i = 0; i < _cvcCount; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * w / _cvcCount, 0, w / _cvcCount, BTN_BG_H);
            btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [btn setTitle:[NSString stringWithFormat:@"btn_%zd", i] forState:UIControlStateNormal];
            [btn setTitle:@"被选中" forState:UIControlStateSelected];
            btn.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1.0];
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
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, BTN_BG_H - 1.5, View_W / _cvcCount, 1.5)];
        _indicatorView.backgroundColor = [UIColor redColor];
    }
    return _indicatorView;
}
#pragma mark --- tableViewOneDelegate
- (void)tableViewContentOffset:(CGFloat)tableViewY withTableView:(UITableView *)tableView{
    self.tableV = tableView;
    CGRect frame = self.headView.frame;
    //tableViewY有初始值（设置了UIEdgeIntset）为 -(headView_H - BTN_BG_H)
    _preTOffsetY = tableViewY;
    if (tableViewY > -(headView_H - BTN_BG_H) ) {
        frame.origin.y = -((headView_H - BTN_BG_H) + tableViewY);
        if (tableViewY > 0) {
            frame.origin.y = -(headView_H - BTN_BG_H);
        } else {
        }
        self.headView.frame = frame;
    } else {
        frame.origin.y = 0;
        self.headView.frame = frame;
    }
}

- (void)btnClick:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    CGPoint offset = self.horizontalSV.contentOffset;
    offset.x = index * View_W;
    [self.horizontalSV setContentOffset:offset animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ((scrollView = self.horizontalSV)) {
        CGFloat w = View_W;
        CGFloat offSetX = scrollView.contentOffset.x;
        CGFloat tableOSY = 0;
        if ((int)_preTOffsetY > -(headView_H - BTN_BG_H) &&  (int)_preTOffsetY < 0) {
            tableOSY = (int)self.tableV.contentOffset.y;
        } else if ((int)_preTOffsetY >= 0) {
            tableOSY = 0;
        } else {
            tableOSY = -200;
        }
        NSInteger index = offSetX / w;
        self.tableV = (UITableView *)self.childViewControllers[index].view;
        self.tableV.contentOffset = CGPointMake(0, tableOSY);
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
    }
}

//点击按钮时不会触发, 仅拖动scrollView时触发
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

