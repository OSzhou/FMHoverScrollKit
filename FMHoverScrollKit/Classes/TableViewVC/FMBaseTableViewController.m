//
//  FMBaseTableViewController.m
//  FMHoverScrollKit
//
//  Created by Windy on 2016/10/21.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "FMBaseTableViewController.h"

static const CGFloat FMDefaultTopMargin = 200.f;
@interface FMBaseTableViewController ()

- (CGFloat)topMargin;

@end

@implementation FMBaseTableViewController

- (instancetype)init {
    if (self = [super init]) {
    }
    return [self initWithTableViewStyle:FMTableViewStylePlain];
}

- (instancetype)initWithTableViewStyle:(FMTableViewStyle)tableViewStyle {
    if (self = [super init]) {
        _tableViewStyle = tableViewStyle;
    }
    return self;
}

- (CGFloat)topMargin {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewContentInsetOfTopWith:)]) {
        return [self.delegate tableViewContentInsetOfTopWith:self.tableView];
    } else {
        return FMDefaultTopMargin;
    }
}

- (void)setTableViewStyle:(FMTableViewStyle)tableViewStyle {
    _tableViewStyle = tableViewStyle;
}

/** tableView */
- (UITableView *)tableView {
    if (!_tableView) {
        if (_tableViewStyle == FMTableViewStylePlain) {
            _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        } else {
            _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(self.topMargin, 0, 0, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.topMargin, 0, 0, 0);
        _tableView.scrollsToTop = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

#pragma mark --- tableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewDidEndDecelerating:)]) {
        [self.delegate tableViewDidEndDecelerating:self.tableView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewContentOffset:withTableView:)]) {
        [self.delegate tableViewContentOffset:scrollView.contentOffset.y withTableView:self.tableView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat y = targetContentOffset->y;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewDidEndDragging:withContentOffset:)]) {
        [self.delegate tableViewDidEndDragging:self.tableView withContentOffset:y];
    }
}

@end
