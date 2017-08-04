//
//  UIButton+FMExtension.m
//  testObject
//
//  Created by Windy on 2016/11/16.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "UIButton+FMExtension.h"
#import <objc/runtime.h>
//reference to AF
static inline BOOL fm_addMethod(Class theClass, SEL selector, Method method) {
    return class_addMethod(theClass, selector, method_getImplementation(method), method_getTypeEncoding(method));
}

static inline void fm_methodSwizzling(Class theClass, SEL originalSelector, SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(theClass, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

@interface UIButton ()
/** 记录上一次接收点击事件的时间 */
@property(nonatomic, assign) NSTimeInterval fm_acceptEventTime;

@end
/** 关联关键字 */
static const char *UIControl_multipleClickInterval = "fm_multipleClickInterval";
static const char *UIControl_acceptEventTime = "fm_acceptEventTime";
@implementation UIButton (FMExtension)

+ (void)swizzleOriginalAndSwizzledMethodForClass:(Class)theClass {
    Method swizzledMethod = class_getInstanceMethod(self, @selector());
    if (fm_addMethod(theClass, @selector(), swizzledMethod)) {
        fm_methodSwizzling(theClass, @selector(), @selector());
    }
}

/**
 
 分类中用@property定义变量，只会生成变量的getter，setter方法的声明，不能生成方法实现和带下划线
 的成员变量。有没有解决方案呢？有，通过运行时建立关联引用。
 
 enum {
 OBJC_ASSOCIATION_ASSIGN = 0, //关联对象的属性是弱引用
 
 OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1, //关联对象的属性是强引用并且关联对象不使用原子性
 
 OBJC_ASSOCIATION_COPY_NONATOMIC = 3, //关联对象的属性是copy并且关联对象不使用原子性
 
 OBJC_ASSOCIATION_RETAIN = 01401, //关联对象的属性是copy并且关联对象使用原子性
 
 OBJC_ASSOCIATION_COPY = 01403 //关联对象的属性是copy并且关联对象使用原子性
 };
 /✨✨✨✨✨✨✨✨✨/
  UIView(frame)分类不用runtime动态绑定的原因是：我们只需要用到自己定义属性的setter，
 getter方法去设置，返回UIView ***“本身就有的属性”***。而正常情况下，自己定义的属性，
 setter是设置自定义属性的值，getter也是返回自定义属性的值,而此时分类是没有 “_” 开头
 的自定义属性字
 段的，必须动态绑定
 /✨✨✨✨✨✨✨✨✨/
 */

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
