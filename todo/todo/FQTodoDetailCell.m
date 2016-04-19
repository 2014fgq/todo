//
//  FQTodoDetailCell.m
//  todo
//
//  Created by IMAC on 16/4/18.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import "FQTodoDetailCell.h"

@implementation FQTodoDetailCell

+ (instancetype)CellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"tododetailcell";
    FQTodoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[FQTodoDetailCell alloc] initWithReuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //配置cell的颜色，而不是配置cell.contentView的背景色
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

//重写initWithReuseIdentifier方法，在创建cell的时候，同时创建子控件
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.textfield.frame = CGRectMake(0, 0, 100, self.contentView.frame.size.height);
    }
    return self;
}

@end
