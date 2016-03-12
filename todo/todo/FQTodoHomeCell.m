//
//  todo_home_cell.m
//  todo
//
//  Created by IMAC on 16/3/4.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import "FQTodoHomeCell.h"


@implementation FQTodoHomeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (instancetype) init:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return self;
//}
//
//- (void)configureCell:(todo_home_cell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//}

+ (instancetype)TodoHomeCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"todo_cell";
    FQTodoHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[FQTodoHomeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
        // iOS 7 separator
        //if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            //cell.separatorInset = UIEdgeInsetsZero;
        //}
        
        //[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        //cell.contentView.backgroundColor = [UIColor grayColor];
        //cell.textfield.adjustsFontSizeToFitWidth = YES;
        //cell.textfield.backgroundColor = [UIColor clearColor];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (!cell.textfield) {
        cell.textfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, 40, 35)];
        [cell addSubview:cell.textfield];
        cell.textfield.backgroundColor = cell.contentView.backgroundColor;
    }
    
    if (!cell.label) {
        cell.label = [[UILabel alloc] initWithFrame:CGRectMake(320, 20, 50, 30)];
        [cell.label.layer setBorderWidth:2.0];
        [cell.label.layer setBorderColor:[UIColor blueColor].CGColor];
        cell.label.layer.cornerRadius = 8;
        cell.label.layer.masksToBounds = true;
        [cell addSubview:cell.label];
    }
    cell.label.text = @" 0/ 0";
    //cell.label.backgroundColor = [UIColor whiteColor];
    
    return cell;
}
    
/*
 [self configurecellinfo:cell forRowAtIndexPath:indexPath];
 [self configureCell:cell forRowAtIndexPath:indexPath];*/
    
@end
