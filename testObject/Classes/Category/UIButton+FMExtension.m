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
    //四个参数：源对象，关键字，关联的对象和一个关联策略
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
//以上主要是实现两个方法的互换,load是gcd的只shareinstance，果断保证执行一次
+ (void)load {
    //获取着两个方法
    //系统方法
    Method sysMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysM = @selector(sendAction:to:forEvent:);
    //自定义方法
    Method myMethod = class_getInstanceMethod(self, @selector(fm_sendAction:to:forEvent:));
    SEL myM = @selector(fm_sendAction:to:forEvent:);
    //添加方法进去（系统方法名执行自己的自定义函数，相当于重写父类方法）
    BOOL overrideSuccess = class_addMethod(self, sysM, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
    //如果添加成功
    if (overrideSuccess) {
        //自定义函数名执行系统函数
        class_replaceMethod(self, myM, method_getImplementation(sysMethod), method_getTypeEncoding(sysMethod));
    } else {
        method_exchangeImplementations(sysMethod, myMethod);
    }
    //这样也可以（但是注意顺序）
    /******
     *
     *个人理解：
     *不管是add还是replace和系统重名的方法，都是相当于复制了一个和系统重名的函数（也就是
     *相当于继承重写了父类方法 ps:分类中不支持继承！系统发现有这个方法会优先调用）
     *系统自动复制一个与自己同名的方法给开发人员用，但是method_getImplementation(systemMethod)
     *还是获取系统自带方法的属性
     *
     ******/
    /*
    class_replaceMethod(self, sysM, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
    class_replaceMethod(self, myM, method_getImplementation(sysMethod), method_getTypeEncoding(sysMethod));
     */
}

- (void)fm_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (NSDate.date.timeIntervalSince1970 - self.fm_acceptEventTime < self.fm_multipleClickInterval) return;
    if (self.fm_multipleClickInterval > 0) {
        self.fm_acceptEventTime = NSDate.date.timeIntervalSince1970;//记录上次点击的时间
    }
    //这里并不是循环调用，由于交换了两个方法，fm_sendAction:to:forEvent:现在就是sendAction:to:forEvent:
    [self fm_sendAction:action to:target forEvent:event];
}

@end
