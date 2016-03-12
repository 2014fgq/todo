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
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        //[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        //cell.contentView.backgroundColor = [UIColor grayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //配置cell左边的textfield
//    cell.textfield.text = @"";
//    cell.textfield.backgroundColor = cell.contentView.backgroundColor;
    
    //配置右边的label
    cell.label.adjustsFontSizeToFitWidth = YES;
    cell.label.frame = CGRectMake(320, 20, 35, 20);
    //配置圆角
    [cell.label.layer setBorderWidth:2.0];
    [cell.label.layer setBorderColor:[UIColor colorWithHex:0x44566A].CGColor];
    cell.label.layer.cornerRadius = 8;
    cell.label.layer.masksToBounds = true;
    
    //配置内容
    cell.label.textAlignment = NSTextAlignmentCenter;//UITextAlignmentCenter 在ios6废弃
    cell.label.text = @" 0/ 0";
    cell.label.textColor = [UIColor colorWithHex:0x71859B];
    cell.label.font = [UIFont fontWithName:@"Helvetica" size:10];
    cell.label.backgroundColor = [UIColor colorWithHex:0x44566A];
    
    cell.seplabel.backgroundColor = [UIColor blackColor];
    cell.seplabel.frame = CGRectMake(cell.frame.origin.x, 0, cell.frame.size.width+70, 1);
    //cell.seplabel.backgroundColor = backgroundColor;
    //cell.textfield.backgroundColor = backgroundColor;
    return cell;
}

- (UILabel *)seplabel
{
    if (!_seplabel) {
        _seplabel = [[UILabel alloc] init];
        [self addSubview:_seplabel];
    }
    return _seplabel;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(320, 20, 50, 30)];
        [self addSubview:_label];
    }
    return _label;
}

- (UITextField *)textfield
{
    if (!_textfield) {
        _textfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, 40, 35)];
        [self addSubview:_textfield];
    }
    return _textfield;
}

/*
 [self configurecellinfo:cell forRowAtIndexPath:indexPath];
 [self configureCell:cell forRowAtIndexPath:indexPath];*/
    
@end
