//
//  FMTest2ViewController.m
//  FMHoverScrollKit
//
//  Created by Zhouheng on 2020/5/15.
//  Copyright © 2020 Windy. All rights reserved.
//

#import "FMTest2ViewController.h"
#import "FMMixScollFatherViewController.h"

@interface FMTest2ViewController ()

@end

@implementation FMTest2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(150, 200, 114, 60);
    btn.backgroundColor = [UIColor purpleColor];
    [btn setTitle:@"vc 2" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)testButtonClick:(UIButton *)sender {
    FMMixScollFatherViewController *vc = [[FMMixScollFatherViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
