//
//  UIButton+FMExtension.m
//  testObject
//
//  Created by Windy on 2016/11/16.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "UIButton+FMExtension.h"
#import <objc/runtime.h>

@interface UIButton ()
/** 记录上一次接收点击事件的时间 */
@property(nonatomic, assign) NSTimeInterval fm_acceptEventTime;

@end
static const char *UIControl_multipleClickInterval = "fm_multipleClickInterval";
static const char *UIControl_acceptEventTime = "fm_acceptEventTime";
@implementation UIButton (FMExtension)
//动态关联对象
- (void)setFm_multipleClickInterval:(NSTimeInterval)fm_multipleClickInterval {
    objc_setAssociatedObject(self, UIControl_multipleClickInterval, @(fm_multipleClickInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)fm_multipleClickInterval {
    return [objc_getAssociatedObject(self, UIControl_multipleClickInterval) doubleValue];
}

- (void)setFm_acceptEventTime:(NSTimeInterval)fm_acceptEventTime {
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(fm_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)fm_acceptEventTime {
    return [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}
//交换方法
+ (void)load {
    Method sysMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysM = @selector(sendAction:to:forEvent:);
    Method myMethod = class_getInstanceMethod(self, @selector(fm_sendAction:to:forEvent:));
    SEL myM = @selector(fm_sendAction:to:forEvent:);
    
    BOOL overrideSuccess = class_addMethod(self, sysM, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
    if (overrideSuccess) {
        class_replaceMethod(self, myM, method_getImplementation(sysMethod), method_getTypeEncoding(sysMethod));
    } else {
        method_exchangeImplementations(sysMethod, myMethod);
    }
    /*
    class_replaceMethod(self, sysM, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
    class_replaceMethod(self, myM, method_getImplementation(sysMethod), method_getTypeEncoding(sysMethod));
     */
}

- (void)fm_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (NSDate.date.timeIntervalSince1970 - self.fm_acceptEventTime < self.fm_multipleClickInterval) return;
    if (self.fm_multipleClickInterval > 0) {
        self.fm_acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    [self fm_sendAction:action to:target forEvent:event];
}

@end
