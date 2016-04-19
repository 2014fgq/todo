//
//  todo_home_cell.h
//  todo
//
//  Created by IMAC on 16/3/4.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQBaseTodoTableViewCell.h"
//@class FQGroup;

@interface FQTodoHomeCell : FQBaseTodoTableViewCell

@property (weak, nonatomic) UILabel *label;

+ (instancetype)TodoHomeCellWithTableView:(UITableView *)tableView;
@end

