//
//  FQBaseTodoTableViewCell.m
//  todo
//
//  Created by IMAC on 16/4/17.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import "FQBaseTodoTableViewCell.h"
const float LABEL_LEFT_MARGIN = 15.0f;
const float UI_CUES_MARGIN = 10.0f;
const float UI_CUES_WIDTH = 50.0f;
@interface FQBaseTodoTableViewCell ()
{
    // Primary UI components
    CAGradientLayer* _gradientLayer;
    CALayer* _itemCompleteLayer;
    
    // Transient state
    bool _markCompleteOnDragRelease;
    bool _deleteOnDragRelease;
    CGPoint _originalCenter;
    NSUInteger taptime;
    NSUInteger IsDoubleClick;
    NSUInteger tapCount;
}
@end

@implementation FQBaseTodoTableViewCell
+ (instancetype)CellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"todobasiecell";
    FQBaseTodoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[FQBaseTodoTableViewCell alloc] initWithReuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, 40, 35)];
        self.textfield = textfield;
        [self.contentView addSubview:self.textfield];
        
        [self addpanLabel];
    }
    return  self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.textfield.frame = self.contentView.bounds;
    //self.textfield.frame = CGRectMake(0, 0, 320, NORMAL_CELL_FINISHING_HEIGHT);
    
    // ensure the gradient layers occupy the full bounds
    _gradientLayer.frame = self.contentView.bounds;
    _itemCompleteLayer.frame = self.contentView.bounds;
    
    // position the label and contextual cues
    _tickLabel.frame = CGRectMake(-UI_CUES_WIDTH - UI_CUES_MARGIN, 0,
                                  UI_CUES_WIDTH, self.contentView.bounds.size.height);
    _crossLabel.frame = CGRectMake(self.contentView.bounds.size.width + UI_CUES_MARGIN, 0,
                                   UI_CUES_WIDTH, self.contentView.bounds.size.height);
    
    if(self.groupModel.type == GROUP_TYPE_ADDED_CELL)
    {
        //允许修改，放在becomeFirstResponder失败，猜测becomeFirstResponder应该是即时运行的
        IsDoubleClick = true;
        [self.textfield becomeFirstResponder];
    }
}

- (void)setGroupModel:(FQTodo *)groupModel
{
    //赋值
    _groupModel = groupModel;

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
    //修改完成键
    self.textfield.returnKeyType = UIReturnKeyDone;
    
    [self JudgeSts];
}

//修改外部的状态标志位，判断当前的cell子控件的展示方式
- (void)JudgeSts
{
    switch (self.groupModel.type)
    {
        case GROUP_TYPE_DONE:
        {
            self.groupModel.IsFinish = !self.groupModel.IsFinish;
            self.groupModel.type = GROUP_TYPE_NORMAL;
        }
        default:
            break;
    }
    if(self.groupModel.IsFinish)
    {
        self.textfield.textColor = [UIColor grayColor];
        self.contentView.backgroundColor = [UIColor darkGrayColor];
    }
    else
    {
        self.textfield.textColor = [UIColor whiteColor];
        UIColor *backgroundColor = [UIColor colorWithHex:0x2B3A4B];
        self.contentView.backgroundColor = backgroundColor;//self.backgroundColor;
    }
}

#pragma mark - UITextField的协议
//实现点击返回键，退出键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textfield resignFirstResponder];
    return NO;
}
# warning 长按功能有bug
//实现单击跳转，双击修改textfield功能
- ( BOOL )textFieldShouldBeginEditing:( UITextField *)textField
{
    if(self.groupModel.type == GROUP_TYPE_ADDED_CELL)
    {
        //确保textfield已经被加载可见，可以成为第一焦点
        self.groupModel.type = GROUP_TYPE_NORMAL;
        return true;
    }
    //如果两次点击的时间间隔小于1秒，则断定为双击事件
    tapCount++;
    switch (tapCount)
    {
        case 1: //single tap
            [self performSelector:@selector(singleTap) withObject: nil afterDelay: .2];
            break;
        case 2: //double tap
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTap) object:nil];
            [self performSelector:@selector(doubleTap) withObject: nil];
            break;
        default:
            break;
    }
    
    return IsDoubleClick;
}

-(void) singleTap
{
    //if([self.delegate respondsToSelector:@selector(SingleTapWithCell:)])
    //    [self.delegate SingleTapWithCell:self];
    tapCount = 0;
}

- (void)doubleTap
{
    IsDoubleClick = true;
    tapCount = 0;
    [UIMenuController sharedMenuController].menuVisible = NO;
}

//- (void)textFieldWillBeginEditing:(UITextField *)textField
//{
//    NSLog(@"textFieldWillBeginEditing");
//}
//- (void)textFieldWillEndEditing:(UITextField *)textField
//{
//    NSLog(@"textFieldWillEndEditing");
//}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //NSLog(@"textFieldDidBeginEditing");
    //当开始点击textfield的时候，光标进入，有且只有触发一次,调用代理，告诉当前点击的textfield。
    //    if([self.delegate respondsToSelector:@selector(SetCurCellByIdxPath:)])
    //        [self.delegate SetCurCellByIdxPath:_groupModel.ID];
    //textfield输入时，键盘弹出，调用tableview上滚
    if([self.delegate respondsToSelector:@selector(ScrollUpWithIdxPath:)])
        [self.delegate ScrollUpWithIdxPath:_groupModel.ID];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //NSLog(@"textFieldDidEndEditing");
    //输入结束，记录输入结果，并保存到Model
    _groupModel.groupname = textField.text;
    //textfield输入完毕时，键盘收回，调用tableview下滚
    if([self.delegate respondsToSelector:@selector(ScrollDownWithIdxPath:)])
        [self.delegate ScrollDownWithIdxPath:_groupModel.ID];
    
    //根据输入是否为空去清空cell本身
    if ([textField.text isEqualToString:@""]) {
        if([self.delegate respondsToSelector:@selector(needsDiscardRowAtIdxPath:)])
            [self.delegate needsDiscardRowAtIdxPath:_groupModel.ID];
    }
    
    IsDoubleClick = NO;
}
#pragma mark - 实现左右拉的效果
- (void)addpanLabel
{
    // add a tick and cross
    _tickLabel = [self createCueLabel];
    _tickLabel.text = @"\u2713";
    _tickLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_tickLabel];
    _crossLabel = [self createCueLabel];
    _crossLabel.text = @"\u2717";
    _crossLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_crossLabel];
    
    // add a layer that overlays the cell adding a subtle gradient effect
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.colors = @[(id)[[UIColor colorWithWhite:0.2f alpha:0.4f] CGColor],
                              //(id)[[UIColor colorWithWhite:1.0f alpha:0.1f] CGColor],
                              (id)[[UIColor clearColor] CGColor],
                              (id)[[UIColor clearColor] CGColor],
                              (id)[[UIColor colorWithWhite:0.2f alpha:0.4f] CGColor]];
    _gradientLayer.locations = @[@0.00f,
                                 @0.01f,
                                 @0.98f,
                                 @1.00f];
    [self.contentView.layer insertSublayer:_gradientLayer atIndex:0];
}
// utility method for creating the contextual cues
- (UILabel*) createCueLabel
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectNull];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:32.0];
    label.backgroundColor = [UIColor blackColor];
    return label;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    //cell内部处理panBegin，panChanged， panEnd是tableviewcontroller处理
    
    // if the gesture has just started, record the current centre location
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        _originalCenter = self.contentView.center;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        // translate the center
        CGPoint translation = [recognizer translationInView:self];
        self.contentView.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        
        // determine whether the item has been dragged far enough to initiate a delete / complete
        _markCompleteOnDragRelease = self.contentView.frame.origin.x > FQTODO_PANHEIGHT;
        _deleteOnDragRelease = self.contentView.frame.origin.x < -FQTODO_PANHEIGHT;
        
        // indicate when the item have been pulled far enough to invoke the given action
        _tickLabel.textColor = _markCompleteOnDragRelease ?
        [UIColor greenColor] : [UIColor whiteColor];
        _crossLabel.textColor = _deleteOnDragRelease ?
        [UIColor redColor] : [UIColor whiteColor];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        // the frame this cell would have had before being dragged
        CGRect originalFrame = CGRectMake(0, self.contentView.frame.origin.y,
                                          self.contentView.bounds.size.width, self.contentView.bounds.size.height);
        
        // if the item is not being deleted, snap back to the original location
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.contentView.frame = originalFrame;
                         }
         ];
    }
}
@end
