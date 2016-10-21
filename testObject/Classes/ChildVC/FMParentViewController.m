//
//  FMParentViewController.m
//  testObject
//
//  Created by Windy on 2016/10/21.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "FMParentViewController.h"

@interface FMParentViewController ()

@end

@implementation FMParentViewController

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

- (FMTableViewStyle)tableViewStyle {
    return _tableViewStyle;
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
        _tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(200, 0, 0, 0);
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

@end
