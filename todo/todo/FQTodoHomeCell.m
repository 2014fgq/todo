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

//自定义单元格
+ (instancetype)TodoHomeCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"todo_cell";
    FQTodoHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[FQTodoHomeCell alloc] initWithReuseIdentifier:ID];
    }

    //设置cell的属性
    // iOS 7 separator,没间距
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    
    //[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    //cell.contentView.backgroundColor = [UIColor grayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

//重写initWithReuseIdentifier方法，在创建cell的时候，同时创建子控件
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        //在这里加上子控件的代码
    }
    return self;
}

//保证cell的加载到父控件，frame不为0
- (void) layoutSubviews
{
    [super layoutSubviews];
}

- (void)setGroupModel:(FQGroup *)groupModel
{
    //赋值
    groupModel = groupModel;
    //配置cell左边的textfield
    //self.textfield.text = groupModel.groupname;
    //self.textfield.backgroundColor = self.contentView.backgroundColor;

    //配置右边的label
    self.label.adjustsFontSizeToFitWidth = YES;
    self.label.frame = CGRectMake(320, 20, 35, 20);
    //配置圆角
    [self.label.layer setBorderWidth:2.0];
    [self.label.layer setBorderColor:[UIColor colorWithHex:0x44566A].CGColor];
    self.label.layer.cornerRadius = 8;
    self.label.layer.masksToBounds = true;
    
    //配置内容
    self.label.textAlignment = NSTextAlignmentCenter;//UITextAlignmentCenter 在ios6废弃
    self.label.text = [NSString stringWithFormat:@"%ld / %ld", groupModel.todoOK, groupModel.todoAll];
    self.label.textColor = [UIColor colorWithHex:0x71859B];
    self.label.font = [UIFont fontWithName:@"Helvetica" size:10];
    self.label.backgroundColor = [UIColor colorWithHex:0x44566A];

    self.seplabel.backgroundColor = [UIColor lightGrayColor];
    self.seplabel.frame = CGRectMake(self.frame.origin.x, 0, self.frame.size.width+70, 0.2);
    //cell.seplabel.backgroundColor = backgroundColor;
    //cell.textfield.backgroundColor = backgroundColor;
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
