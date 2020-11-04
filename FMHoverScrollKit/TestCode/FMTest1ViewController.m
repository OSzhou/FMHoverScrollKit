//
//  FMTest1ViewController.m
//  FMHoverScrollKit
//
//  Created by Zhouheng on 2020/5/15.
//  Copyright © 2020 Windy. All rights reserved.
//

#import "FMTest1ViewController.h"
#import "FMTest2ViewController.h"

@interface FMTest1ViewController ()

@end

@implementation FMTest1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(150, 200, 114, 60);
    btn.backgroundColor = [UIColor cyanColor];
    [btn setTitle:@"vc 1" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)testButtonClick:(UIButton *)sender {
    FMTest2ViewController *vc = [[FMTest2ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
