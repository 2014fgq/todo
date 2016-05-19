//
//  todo_home_cell.m
//  todo
//
//  Created by IMAC on 16/3/4.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import "FQTodoHomeCell.h"


@implementation FQTodoHomeCell 
{
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//自定义单元格
+ (instancetype)TodoHomeCellWithTableView:(UITableView *)tableView
{
    return [FQTodoHomeCell CellWithTableView:tableView];
}

+ (instancetype)CellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"todohomecell";
    FQTodoHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[FQTodoHomeCell alloc] initWithReuseIdentifier:ID];
    }

    cell.contentView.frame = CGRectMake(0, 0, cell.contentView.frame.size.width+100, cell.contentView.frame.size.height);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //配置cell的颜色，而不是配置cell.contentView的背景色
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

//重写initWithReuseIdentifier方法，在创建cell的时候，同时创建子控件
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {        
        UILabel *label = [[UILabel alloc] init];
        self.label  = label;
        [self.contentView addSubview:self.label];
        
        self->_tickLabel.alpha = 0.f;
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
    [super setGroupModel:groupModel];

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
    self.label.text = [NSString stringWithFormat:@"%ld / %ld", (long)groupModel.todoOK, (long)groupModel.todoAll];
    self.label.textColor = [UIColor colorWithHex:0x71859B];
    self.label.font = [UIFont fontWithName:@"Helvetica" size:10];
    self.label.backgroundColor = [UIColor colorWithHex:0x44566A];
}
@end
