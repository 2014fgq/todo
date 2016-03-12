//
//  todo_home_cell.h
//  todo
//
//  Created by IMAC on 16/3/4.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MCSwipeTableViewCell.h"
//@interface FQTodoHomeCell : MCSwipeTableViewCell
@interface FQTodoHomeCell : UITableViewCell
@property (strong, nonatomic) UITextField *textfield;
@property (strong, nonatomic) UILabel *label;
+ (instancetype)TodoHomeCellWithTableView:(UITableView *)tableView;
@end

