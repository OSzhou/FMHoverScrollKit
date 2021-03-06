//
//  FMMixScollFatherViewController.m
//  FMHoverScrollKit
//
//  Created by Zhouheng on 2020/5/14.
//  Copyright © 2020 Windy. All rights reserved.
//

#import "FMMixScollFatherViewController.h"
#import "FMT1ViewController.h"
#import "FMT2ViewController.h"
#import "FMT3ViewController.h"
#import "FMC1ViewController.h"
#import "FMMixScollFatherViewController.h"
#import "FMMixScrollBaseDelegateManager.h"

@interface FMMixScollFatherViewController () <FMMixScrollManagerDelegate>
@property (nonatomic, strong) FMMixScrollBaseDelegateManager *manager;
@end

@implementation FMMixScollFatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FMMixScrollConfig *config = [FMMixScrollConfig new];
    
    FMT1ViewController *t1 = [[FMT1ViewController alloc] init];
    t1.tableViewStyle = FMTableViewStyleGrouped;
    FMC1ViewController *c1 = [[FMC1ViewController alloc] init];
    FMT3ViewController *t3= [[FMT3ViewController alloc] init];
    
    config.childVCArr = @[t1, c1, t3];
    config.scrollTorCArr = @[t1.tableView, c1.collectionView, t3.tableView];
    
    //    config.headImage_H = 500;
    config.isTest = YES;
    _manager = [[FMMixScrollBaseDelegateManager alloc] initWithConfig:config fatherController:self];
    _manager.delegate = self;
    t1.delegate = _manager;
    c1.delegate = _manager;
    t3.delegate = _manager;
//    [_manager scrollToIndex:1];
}

- (void)currentSelectedIndex:(NSInteger)index {
    NSLog(@"current seleted index --- %ld", (long)index);
}

- (void)dealloc {
    NSLog(@"FMMixScollFatherViewController --- dealloc");
}

@end
