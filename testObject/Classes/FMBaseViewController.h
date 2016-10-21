//
//  FMBaseViewController.h
//  testObject
//
//  Created by Windy on 2016/10/20.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadView.h"
#import "FMParentViewController.h"

@interface FMBaseViewController : UIViewController

/** 传入的子控制器的数组 ps:不可变数组, 最多不要超过5个（暂不支持滑动）*/
@property (nonatomic, strong) NSArray *childVCArr;
@property (nonatomic, strong) HeadView *headView;

@end
