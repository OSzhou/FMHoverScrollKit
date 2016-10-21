//
//  FMATController.m
//  testObject
//
//  Created by Windy on 16/10/11.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "FMATController.h"

@interface FMATController ()
@end

static NSString  *ID = @"test1";
@implementation FMATController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor cyanColor];
    
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FMTestCell class]) bundle:nil] forCellReuseIdentifier:@"ID"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(200, 0, 0, 0);
//    UITableView *tableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
//    tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    tableview.delegate = self;
//    tableview.dataSource = self;
//    self.view = tableview;
//    self.view.backgroundColor = [UIColor grayColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"test1 --- %zd", indexPath.row];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewContentOffset:withTableView:)]) {
        [self.delegate tableViewContentOffset:scrollView.contentOffset.y withTableView:self.tableView];
    }
}

@end
