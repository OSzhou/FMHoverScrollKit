//
//  FMCTController.m
//  testObject
//
//  Created by Windy on 16/10/13.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "FMCTController.h"

@interface FMCTController ()

@end

@implementation FMCTController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"test3"];
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
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test3" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"test3 --- %zd", indexPath.row];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewContentOffset:withTableView:)]) {
        [self.delegate tableViewContentOffset:scrollView.contentOffset.y withTableView:self.tableView];
    }
}

@end
