//
//  FMATController.h
//  testObject
//
//  Created by Windy on 16/10/11.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol tableViewOneDelegate <NSObject>

- (void)tableViewContentOffset:(CGFloat)tableViewY withTableView:(UITableView *)tableView;

@end

@interface FMATController : UITableViewController

@property (nonatomic, weak) id <tableViewOneDelegate> delegate;

@end
