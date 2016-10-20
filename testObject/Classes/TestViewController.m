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

#define View_W [UIScreen mainScreen].bounds.size.width
#define View_H [UIScreen mainScreen].bounds.size.height
#define BTN_BG_H 50
@interface TestViewController () <UIScrollViewDelegate, UITableViewDelegate, tableViewOneDelegate>
@property (nonatomic, strong) UIView *bar;
@property (nonatomic, strong) UIScrollView *verticalSV;
@property (nonatomic, strong) UIScrollView *horizontalSV;
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableV;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    FirstTController *ftv = [[FirstTController alloc] init];
    SecondTController *stv = [[SecondTController alloc] init];
    ThirdTController *ttv = [[ThirdTController alloc] init];
    ftv.delegate = self;
    [self addChildViewController:ftv];
    [self addChildViewController:stv];
    [self addChildViewController:ttv];
    ftv.view.frame = CGRectMake(0, 0, View_W, View_H - BTN_BG_H);
    stv.view.frame = CGRectMake(View_W, 0, View_W, View_H - BTN_BG_H);
    ttv.view.frame = CGRectMake(2 * View_W, 0, View_W, View_H - BTN_BG_H);
    
    UIScrollView *verticalSV = [[UIScrollView alloc] init];
    verticalSV.frame = self.view.bounds;
    verticalSV.delegate = self;
    verticalSV.bounces = NO;
    verticalSV.clipsToBounds = NO;
    [verticalSV addSubview:[[UISwitch alloc] init]];
    verticalSV.contentSize = CGSizeMake(self.view.frame.size.width, View_H + 200);//大了3
    verticalSV.backgroundColor = [UIColor grayColor];
    self.verticalSV = verticalSV;
    [self.view addSubview:verticalSV];

    UIView *bar = [[UIView alloc] init];
    bar.frame = CGRectMake(0, 200, self.view.frame.size.width, BTN_BG_H);
    bar.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 50);
    btn.backgroundColor = [UIColor yellowColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:btn];
    self.bar = bar;
    [self.horizontalSV addSubview:ftv.view];
    [self.horizontalSV addSubview:stv.view];
    [self.horizontalSV addSubview:ttv.view];
    //都加在垂直的scrollview上
    [verticalSV addSubview:self.horizontalSV];
    [verticalSV addSubview:bar];
    
//    self.tableV = (UITableView *)stv.view;
//    self.tableV.delegate = self;

}

- (UIScrollView *)horizontalSV {
    if (!_horizontalSV) {
        _horizontalSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, View_H - BTN_BG_H)];
        _horizontalSV.backgroundColor = [UIColor cyanColor];
        _horizontalSV.clipsToBounds = NO;
        _horizontalSV.pagingEnabled = YES;
        _horizontalSV.alwaysBounceHorizontal = YES;
        _horizontalSV.contentSize = CGSizeMake(View_W * 3, 0);
    }
    return _horizontalSV;
}

#pragma mark --- tableViewOneDelegate
- (void)tableViewContentOffset:(CGFloat)tableViewY withTableView:(UITableView *)tableView{
    self.tableV = tableView;
    if (tableViewY > 0) {
//        [tableView addSubview:self.bar];
        [self.view addSubview:self.horizontalSV];
        self.bar.frame = CGRectMake(0, -50, self.view.frame.size.width, 50);
        self.verticalSV.contentOffset = CGPointMake(0, tableViewY);
        if (self.verticalSV.contentOffset.y >= 200) {
//            self.bar.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
            [self.view addSubview:self.bar];
            self.verticalSV.contentOffset = CGPointMake(0, 200);
            [self.verticalSV addSubview:self.horizontalSV];
        }
    } else {
        self.verticalSV.contentOffset = CGPointMake(0, 0);
//        self.bar.frame = CGRectMake(0, 200, self.view.frame.size.width, 50);
//        [self.verticalSV addSubview:self.bar];
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.verticalSV) {
        self.tableV.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
        if (scrollView.contentOffset.y >= 200) {
            self.bar.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
            [self.view addSubview:self.bar];
        } else {
            self.bar.frame = CGRectMake(0, 200, self.view.frame.size.width, 50);
            [scrollView addSubview:self.bar];
        }
    }
}

- (void)btnClick {
    NSLog(@"点击了按钮");
}

@end
