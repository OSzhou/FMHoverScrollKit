# WYYKTScroll
## 工程引入FMBaseViewController, 并添加要自定义的controller，注意：自定义的controller 必须继承于FMATController, 并且子控制器暂时只支持UITableViewController

````
FMBaseViewController *bvc = [[FMBaseViewController alloc] init];
    FMATController *ftv = [[FMATController alloc] init];
    FMBTController *stv = [[FMBTController alloc] init];
    FMCTController *ttv = [[FMCTController alloc] init];
    FourTController *v3 = [[FourTController alloc] init];
    FiveTController *v4 = [[FiveTController alloc] init];
    bvc.childVCArr = @[ftv, stv, ttv, v3, v4];
    self.window.rootViewController = bvc;
````
用cocoaPods 可安装 pod "WYTest"
##功能尚不完善， 持续更新中！
