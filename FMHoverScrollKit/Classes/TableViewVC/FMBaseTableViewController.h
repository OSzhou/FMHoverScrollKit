//
//  FMBaseTableViewController.h
//  FMHoverScrollKit
//
//  Created by Windy on 2016/10/21.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMMixScrollProtocol.h"

typedef NS_ENUM(NSInteger, FMTableViewStyle) {
    FMTableViewStylePlain,          // regular table view
    FMTableViewStyleGrouped         // preferences style table view
};

//typedef NS_ENUM(NSInteger, FMControllerStyle) {
//    FMTableViewControllerStyle,
//    FMViewControllerStyle
//};

@interface FMBaseTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** tableView Style */
@property (nonatomic, assign)  FMTableViewStyle tableViewStyle;
/** controller Style */
//@property (nonatomic, assign) FMControllerStyle controllerStyle;
@property (nonatomic, weak) id <FMBaseTableViewDelegate> delegate;

- (instancetype)initWithTableViewStyle:(FMTableViewStyle)tableViewStyle;

@end
