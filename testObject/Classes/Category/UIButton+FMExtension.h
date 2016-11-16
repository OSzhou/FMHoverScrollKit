//
//  UIButton+FMExtension.h
//  testObject
//
//  Created by Windy on 2016/11/16.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (FMExtension)
/** 两次点击最大时间间隔，在此时间内，所有点击事件不不执行 */
@property (nonatomic, assign) NSTimeInterval fm_multipleClickInterval;

@end
