//
//  TestViewController.m
//  testObject
//
//  Created by Windy on 16/10/11.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "TestViewController.h"
#import "FirstTController.h"
#import "SecondTController.h"
#import "ThirdTController.h"
#import "HeadView.h"

#define View_W [UIScreen mainScreen].bounds.size.width
#define View_H [UIScreen mainScreen].bounds.size.height
#define BTN_BG_H 50
#define headView_H 250
@interface TestViewController () <UIScrollViewDelegate, UITableViewDelegate, tableViewOneDelegate>
@property (nonatomic, strong) UIView *bar;
@property (nonatomic, strong) HeadView *headView;
@property (nonatomic, strong) UIScrollView *horizontalSV;
@property (nonatomic, strong) UITableView *tableV;
/** 指示条 */
@property (nonatomic, strong) UIView *indicatorView;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    FirstTController *ftv = [[FirstTController alloc] init];
    SecondTController *stv = [[SecondTController alloc] init];
    ThirdTController *ttv = [[ThirdTController alloc] init];
    ftv.delegate = self;
    stv.delegate = self;
    ttv.delegate = self;
    [self addChildViewController:ftv];
    [self addChildViewController:stv];
    [self addChildViewController:ttv];
    ftv.view.frame = CGRectMake(0, 0, View_W, View_H - BTN_BG_H);
    stv.view.frame = CGRectMake(View_W, 0, View_W, View_H - BTN_BG_H);
    ttv.view.frame = CGRectMake(2 * View_W, 0, View_W, View_H - BTN_BG_H);
    
    [self.horizontalSV addSubview:ftv.view];
    [self.horizontalSV addSubview:stv.view];
    [self.horizontalSV addSubview:ttv.view];
    self.tableV = (UITableView *)ftv.view;
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
        _horizontalSV.contentSize = CGSizeMake(View_W * 3, 0);
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
        for (int i = 0; i < 3; i++) {
            NSArray *titleArr = @[@"btn_one", @"btn_two", @"btn_three"];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * w / 3, 0, w / 3, BTN_BG_H);
            btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
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
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, BTN_BG_H - 1.5, View_W / 3, 1.5)];
        _indicatorView.backgroundColor = [UIColor redColor];
    }
    return _indicatorView;
}
#pragma mark --- tableViewOneDelegate
- (void)tableViewContentOffset:(CGFloat)tableViewY withTableView:(UITableView *)tableView{
    self.tableV = tableView;
    CGRect frame = self.headView.frame;
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
        NSInteger index = offSetX / w;
        self.tableV = (UITableView *)self.childViewControllers[index].view;
        CGRect frame = self.indicatorView.frame;
        frame.origin.x = index * View_W / 3;
        self.indicatorView.frame = frame;
        if (offSetX < 0 || offSetX > 3 * w) return;
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
