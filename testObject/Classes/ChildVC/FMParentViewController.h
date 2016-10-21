//
//  FMParentViewController.h
//  testObject
//
//  Created by Windy on 2016/10/21.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FMTableViewStyle) {
    FMTableViewStylePlain,          // regular table view
    FMTableViewStyleGrouped         // preferences style table view
};

//typedef NS_ENUM(NSInteger, FMControllerStyle) {
//    FMTableViewControllerStyle,
//    FMViewControllerStyle
//};

@protocol parentTableViewDelegate <NSObject>

- (void)tableViewContentOffset:(CGFloat)tableViewY withTableView:(UITableView *)tableView;

@end

@interface FMParentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** tableView Style */
@property (nonatomic, assign)  FMTableViewStyle tableViewStyle;
/** controller Style */
//@property (nonatomic, assign) FMControllerStyle controllerStyle;
@property (nonatomic, weak) id <parentTableViewDelegate> delegate;

- (instancetype)initWithTableViewStyle:(FMTableViewStyle)tableViewStyle;

@end
