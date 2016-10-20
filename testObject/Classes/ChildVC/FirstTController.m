//
//  FirstTController.m
//  testObject
//
//  Created by Windy on 16/10/11.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "FirstTController.h"
#import "TestCell.h"

@interface FirstTController ()
@end

@implementation FirstTController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor cyanColor];
    
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TestCell class]) bundle:nil] forCellReuseIdentifier:@"ID"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.clipsToBounds = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TestCell class]) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewContentOffset:withTableView:)]) {
        [self.delegate tableViewContentOffset:scrollView.contentOffset.y withTableView:self.tableView];
    }
}

@end
