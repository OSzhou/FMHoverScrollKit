//
//  HeadView.m
//  FMHoverScrollKit
//
//  Created by Windy on 16/10/13.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "HeadView.h"
#import "FMConst.h"

@implementation HeadView

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    // 获取UITouch对象
    UITouch *touch = [touches anyObject];
    
    // 获取当前点
    CGPoint curP = [touch locationInView:self];
    
    // 获取上一个点
    CGPoint preP = [touch previousLocationInView:self];
    
    // 获取x轴偏移量
//    CGFloat offsetX = curP.x - preP.x;
    
    // 获取y轴偏移量
    CGFloat offsetY = curP.y - preP.y;
    
    // 修改view的位置（frame,center,transform）
    if (offsetY + self.frame.origin.y > _barStop_H) {
        offsetY = 0;
    }
    self.transform = CGAffineTransformTranslate(self.transform, 0, offsetY);
    
    //    self.transform = CGAffineTransformMakeTranslation(offsetX, 0);
    [[NSNotificationCenter defaultCenter] postNotificationName:HeadViewTouchMoveNotification object:nil userInfo:@{@"offsetY":@(offsetY)}];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:HeadViewTouchEndNotification object:nil userInfo:nil];
}

@end
