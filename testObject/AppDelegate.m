//
//  AppDelegate.m
//  testObject
//
//  Created by Windy on 16/10/11.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "AppDelegate.h"
#import "FMBaseViewController.h"
#import "FMT1ViewController.h"
#import "FMT2ViewController.h"
#import "FMT3ViewController.h"
#import "FMC1ViewController.h"
#import "FMMixScollFatherViewController.h"
#import "FMMixScrollBaseDelegateManager.h"
#import "FMTest1ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
//    FMBaseViewController *bvc = [[FMBaseViewController alloc] init];
    /** 属性设置 */
//    bvc.btnBackColor = [UIColor cyanColor];
//    bvc.btnTitleArr = @[@"张三", @"李四", @"王五"];
//    bvc.indicatorColor = [UIColor yellowColor];
//    bvc.isIndicatorHidden = YES;
//    bvc.headImage_H = 100;
//    bvc.button_H = 30;
//    bvc.headImageName = @"picture_3";
//    bvc.isStretch = NO;
//    [bvc.headView addSubview:[[UISwitch alloc] init]];
    /** 全是tableView */
    /*FMT1ViewController *t1 = [[FMT1ViewController alloc] init];
    t1.tableViewStyle = FMTableViewStyleGrouped;
    FMT2ViewController *t2 = [[FMT2ViewController alloc] initWithTableViewStyle:FMTableViewStyleGrouped];
    FMT3ViewController *t3= [[FMT3ViewController alloc] init];
    bvc.childVCArr = @[t1, t2, t3];*/
    /** 全是collectionView */
    /*FMC1ViewController *c1 = [[FMC1ViewController alloc] init];
    FMC1ViewController *c2 = [[FMC1ViewController alloc] init];
    FMC1ViewController *c3 = [[FMC1ViewController alloc] init];
    bvc.childVCArr = @[c1, c2, c3];*/
    /** tableView & collectionView混合 */
//    FMT1ViewController *t1 = [[FMT1ViewController alloc] init];
//    t1.tableViewStyle = FMTableViewStyleGrouped;
//    FMC1ViewController *c1 = [[FMC1ViewController alloc] init];
//    FMT3ViewController *t3= [[FMT3ViewController alloc] init];
//    bvc.childVCArr = @[t1, c1, t3];
    
//    FMMixScollFatherViewController *fvc = [[FMMixScollFatherViewController alloc] init];
    FMTest1ViewController *fvc = [[FMTest1ViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:fvc];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
