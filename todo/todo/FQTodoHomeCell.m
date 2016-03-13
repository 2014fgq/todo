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
    self.textfield.frame = self.bounds;
}

- (void)setGroupModel:(FQGroup *)groupModel
{
    //赋值
    _groupModel = groupModel;

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

    //增加分割线
    self.seplabel.backgroundColor = [UIColor lightGrayColor];
    self.seplabel.frame = CGRectMake(self.frame.origin.x, 0, self.frame.size.width+70, 0.2);
    //cell.seplabel.backgroundColor = backgroundColor;
    //cell.textfield.backgroundColor = backgroundColor;
    
    //配置cell左边的textfield
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    self.textfield.leftView = leftview;
    self.textfield.leftViewMode = UITextFieldViewModeAlways;
    
    self.textfield.adjustsFontSizeToFitWidth = YES;
    self.textfield.backgroundColor = [UIColor clearColor];
    //self.textfield.shadowOffset = CGSizeMake(0, 1);
    //self.textfield.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    self.textfield.text = groupModel.groupname;
    self.textfield.textColor = [UIColor whiteColor];
    self.textfield.delegate = self;

    //修改显示内容
//    self.textLabel.adjustsFontSizeToFitWidth = YES;
//    self.textLabel.backgroundColor = [UIColor clearColor];
//    self.textLabel.shadowOffset = CGSizeMake(0, 1);
//    self.textLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
//    
//    self.textLabel.text = groupModel.groupname;
//    self.textLabel.textColor = [UIColor whiteColor];
    
    switch (groupModel.type)
    {
        case GROUP_TYPE_DUMMY:
        {
            self.textfield.textColor = [UIColor grayColor];
            self.contentView.backgroundColor = [UIColor darkGrayColor];
            break;
        }
        case GROUP_TYPE_DONE:
        {
            self.textfield.text = @"";
            self.contentView.backgroundColor = [UIColor blackColor];
        }
        default:
            break;
    }
}

#pragma mark - 子控件初始化
- (UILabel *)seplabel
{
    if (!_seplabel) {
        _seplabel = [[UILabel alloc] init];
        [self addSubview:_seplabel];
    }
    return _seplabel;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

#pragma mark - UITextField的协议
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touhes Began");
}

- (NSArray *)textfieldAtIndexes:(NSIndexSet *)indexes
{
    NSLog(@"%@", indexes);
    return nil;
}
- ( BOOL )textFieldShouldBeginEditing:( UITextField *)textField
{
    NSLog ( @"textFieldShouldBeginEditing");
    return YES ;
}
- (void)textFieldWillBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldWillBeginEditing");
}
- (void)textFieldWillEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldWillEndEditing");
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing");
    //当开始点击textfield的时候，光标进入，有且只有触发一次,调用代理，告诉当前点击的textfield。
    if([self.delegate respondsToSelector:@selector(SetCurCellByIdxPath:)])
        [self.delegate SetCurCellByIdxPath:self.IdxPath];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing");
}
/*
 [self configurecellinfo:cell forRowAtIndexPath:indexPath];
 [self configureCell:cell forRowAtIndexPath:indexPath];*/
    
@end
