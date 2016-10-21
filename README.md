# WYYKTScroll
这是一个控件悬停的UI效果实现，类似于网易云课堂的详情页UI效果
###
#### 1.工程引入FMBaseViewController, 并添加要自定义的controller
#### 2.注意：自定义的controller 必须继承于FMBaseViewController.h, 并且子控制器暂时只支持UITableViewController
* 子控制器类型1 ：FMTableViewStylePlain 初始化代码如下：
````
FMT2ViewController *t2 = [[FMT2ViewController alloc] initWithTableViewStyle:FMTableViewStylePlain];
或者
FMT1ViewController *t1 = [[FMT1ViewController alloc] init];
````
* 子控制器类型2：FMTableViewStyleGroup 初始化代码如下：
````
FMT2ViewController *t2 = [[FMT2ViewController alloc] initWithTableViewStyle:FMTableViewStyleGrouped];
````
#### 3.自定义的子控制器必须实现此方法（及其方法内容）如下：

````
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewContentOffset:withTableView:)]) {
        [self.delegate tableViewContentOffset:scrollView.contentOffset.y withTableView:self.tableView];
    }
}
````
* 测试效果查看，在AppDelegate.m 的launch函数中添加（或替换）如下代码：
````
FMBaseViewController *bvc = [[FMBaseViewController alloc] init];
    self.window.rootViewController = bvc;
    [self.window makeKeyAndVisible];
````
* 自定义子controller初始化后传入该数组childVCArr，示例代码如下：
````
    FMBaseViewController *bvc = [[FMBaseViewController alloc] init];
    FMT1ViewController *t1 = [[FMT1ViewController alloc] init];
    FMT2ViewController *t2 = [[FMT2ViewController alloc] initWithTableViewStyle:FMTableViewStyleGrouped];
    FMT3ViewController *t3= [[FMT3ViewController alloc] init];
    bvc.childVCArr = @[t1, t2, t3];
````
####子控制器最好不要超过5个， 暂不支持滑动（以后可能添加，敬请期待！）
* headView上的内容可自定义添加，通过 ftc.headView可拿到head部分的视图添加自己的控件。
* 支持cocoaPods 安装 
````
pod search WYTest
在Podfile中添加
pod "WYTest"
pod install || pod update
````
##功能尚不完善， 持续更新中,敬请期待！
