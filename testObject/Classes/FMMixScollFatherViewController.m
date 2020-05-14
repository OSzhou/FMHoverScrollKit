//
//  FMMixScollFatherViewController.m
//  testObject
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

@interface FMMixScollFatherViewController ()
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
    
    t1.delegate = _manager;
    c1.delegate = _manager;
    t3.delegate = _manager;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    
}

@end
