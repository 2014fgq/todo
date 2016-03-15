//
//  ViewController.m
//  todo
//
//  Created by IMAC on 16/3/11.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import "ViewController.h"
#import "JTTransformableTableViewCell.h"
#import "JTTableViewGestureRecognizer.h"
#import "UIColor+JTGestureBasedTableViewHelper.h"
#import "UIColor+Hex.h"
#import "FQTodoHomeCell.h"

// Configure your viewController to conform to JTTableViewGestureEditingRowDelegate
// and/or JTTableViewGestureAddingRowDelegate depends on your needs
@interface ViewController () <JTTableViewGestureEditingRowDelegate, JTTableViewGestureAddingRowDelegate, JTTableViewGestureMoveRowDelegate, FQTodoHomeCellDelegate>
@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) JTTableViewGestureRecognizer *tableViewRecognizer;
@property (nonatomic, strong) id grabbedObject;
@property (nonatomic, strong) NSIndexPath *IdxPath;
- (void)moveRowToBottomForIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ViewController
@synthesize rows;
@synthesize tableViewRecognizer;
@synthesize grabbedObject;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Setup your tableView.delegate and tableView.datasource,
    // then enable gesture recognition in one line.
    self.tableViewRecognizer = [self.tableView enableGestureTableViewWithDelegate:self];
    
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight       = NORMAL_CELL_FINISHING_HEIGHT;
    
    self.title = @"Todo";
    [self tableview_navigationview_setup:self];
    //[self install_keyboardNoti];
}

#pragma mark - 监听键盘
-(void) install_keyboardNoti
{
    //监听键盘弹出事件
    //监听键盘通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //UIKeyboardDidShowNotification,键盘显示
    //UIKeyboardDidHideNotification,键盘隐藏
    //UIKeyboardWillChangeFrameNotification,键盘frame改变
    
}

#pragma mark - 键盘更改frame的时候，键盘弹出
//不适用willshow,willhide,didshow,didhide方法，因为hide太慢了,为了对称，show都不使用了
- (void)keyboardWillChangeFrame:(NSNotification*)notification
{
    //NSLog(@"keyboardWillChangeFrame %f", [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].origin.y);
    
    //获取键盘弹入弹出时的位置
    CGFloat keyboardbefore = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].origin.y;
    CGFloat keyboardend = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat diff = keyboardend - keyboardbefore;
    NSInteger scroll = 0;
    NSInteger Idx = self.IdxPath.row;
    //根据diff来判断键盘是弹入还是弹出
    if(diff < 0) //弹出
        scroll = -Idx*NORMAL_CELL_FINISHING_HEIGHT;
    else
        scroll = 0;//不滚动，为0
    
    //动画展示键盘弹入弹出
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, scroll);
    }];
    //NSIndexPath *randomIdxPath = [NSIndexPath indexPathForRow:4 inSection:0];
    //[self.tableView scrollToRowAtIndexPath:randomIdxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)keyboardWillDidShow:(NSNotification*)notification
{
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    //NSLog(@"keyboardWillChangeFrame %f", [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].origin.y);
}

#pragma mark - FQTodoHomeCellDelegate
- (void) SetCurCellByIdxPath:(NSIndexPath *)IdxPath
{
    //设置当前的IdxPath
    self.IdxPath = IdxPath;
}

- (void)ScrollUpWithIdxPath:(NSIndexPath *)IdxPath
{
    //计算滚动量，滚动量=-(cell高*当前cell的Idx - tableview已经向上滚的滚动量)
    NSInteger scroll = self.tableView.contentOffset.y-NORMAL_CELL_FINISHING_HEIGHT*IdxPath.row;
    NSLog(@"table=%@, navi=%@, contest=%f",
          NSStringFromCGRect(self.tableView.frame), NSStringFromCGRect(self.navigationController.navigationBar.frame), self.tableView.contentOffset.y);
    //动画展示键盘弹入
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, scroll);
    }];
}

-(void)ScrollDownWithIdxPath:(NSIndexPath *)IdxPath
{
    NSInteger scroll = 0;
    //动画展示键盘弹入弹出
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, scroll);
    }];
    
}

- (void)needsDiscardRowAtIdxPath:(NSIndexPath *)IdxPath{
    [self.groups removeObjectAtIndex:IdxPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:IdxPath] withRowAnimation:UITableViewRowAnimationLeft];
    //[self.tableView reloadData];
}
#pragma mark - 懒加载
- (NSMutableArray *)groups
{
    if(!_groups)
    {
        _groups = [FQGroup GroupsWithDefaultRows];
    }
    return _groups;
}

#pragma mark - fix the tablewview and navigationview
- (void)tableview_navigationview_setup:(UIViewController *)viewcontroller
{
    //由于是ios7以上才存在navigationview和tablewview之间留空的问题
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        viewcontroller.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    //添加一个HeaderView去占据那个位置，不过这个方法还是有遗留问题，当程序初始化的时候，会有一段空白
    //    UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, NORMAL_CELL_FINISHING_HEIGHT)];
    //    viewcontroller.tableView.tableHeaderView = headerView;
    
    //第二种方法，不行
    //viewcontroller.tableView.contentInset = UIEdgeInsetsMake(NORMAL_CELL_FINISHING_HEIGHT, 0, 0, 0);
    //viewcontroller.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(NORMAL_CELL_FINISHING_HEIGHT, 0, 0, 0);
    //配置UINavigationController
    self.navigationController.navigationBar.barTintColor =
        [UIColor colorWithHex:0x222e3b];
    //self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

#pragma mark Private Method

- (void)moveRowToBottomForIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    
    id object = [self.groups objectAtIndex:indexPath.row];
    [self.groups removeObjectAtIndex:indexPath.row];
    [self.groups addObject:object];

    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:[self.groups count] - 1 inSection:0];
    [self.tableView moveRowAtIndexPath:indexPath toIndexPath:lastIndexPath];

    [self.tableView endUpdates];

    [self.tableView performSelector:@selector(reloadVisibleRowsExceptIndexPath:) withObject:lastIndexPath afterDelay:JTTableViewRowAnimationDuration];
}

#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.groups count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FQGroup *group = [self.groups objectAtIndex:indexPath.row];
    //NSString *object = group.groupname;

    //UIColor *backgroundColor = [[UIColor redColor] colorWithHueOffset:0.12 * indexPath.row / [self tableView:tableView numberOfRowsInSection:indexPath.section]];
    UIColor *backgroundColor = [UIColor colorWithHex:0x2B3A4B];
    if (group.type == GROUP_TYPE_ADDING_CELL) {
        NSString *cellIdentifier = nil;
        JTTransformableTableViewCell *cell = nil;

        // IndexPath.row == 0 is the case we wanted to pick the pullDown style
        if (indexPath.row == 0) {
            cellIdentifier = @"PullDownTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil) {
                cell = [JTTransformableTableViewCell transformableTableViewCellWithStyle:JTTransformableTableViewCellStylePullDown
                                                                       reuseIdentifier:cellIdentifier];
                cell.textLabel.adjustsFontSizeToFitWidth = YES;
                cell.textLabel.textColor = [UIColor whiteColor];
            }
            
            cell.finishedHeight = COMMITING_CREATE_CELL_HEIGHT;
//            if (cell.frame.size.height > COMMITING_CREATE_CELL_HEIGHT * 2) {
//                cell.imageView.image = [UIImage imageNamed:@"reload.png"];
//                cell.tintColor = [UIColor blackColor];
//                cell.textLabel.text = @"Return to list...";
//            } else
            if (cell.frame.size.height > COMMITING_CREATE_CELL_HEIGHT) {
                cell.imageView.image = nil;
                // Setup tint color
                cell.tintColor = backgroundColor;
                cell.textLabel.text = @"⬆️ 释放新建列表";
            } else {
                cell.imageView.image = nil;
                // Setup tint color
                cell.tintColor = backgroundColor;
                cell.textLabel.text = @"⬇️ 下拉新建列表";
            }
            cell.contentView.backgroundColor = [UIColor blackColor];
            cell.textLabel.shadowOffset = CGSizeMake(0, 1);
            cell.textLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
            return cell;

        } else {
            // Otherwise is the case we wanted to pick the pullDown style
            cellIdentifier = @"UnfoldingTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

            if (cell == nil) {
                cell = [JTTransformableTableViewCell transformableTableViewCellWithStyle:JTTransformableTableViewCellStyleUnfolding
                                                                       reuseIdentifier:cellIdentifier];
                cell.textLabel.adjustsFontSizeToFitWidth = YES;
                cell.textLabel.textColor = [UIColor whiteColor];
            }
            
            cell.finishedHeight = COMMITING_CREATE_CELL_HEIGHT;
            if (cell.frame.size.height > COMMITING_CREATE_CELL_HEIGHT) {
                cell.textLabel.text = @"释放新建列表";
            } else {
                cell.textLabel.text = @"请继续捏合";
            }
            
            // Setup tint color,backgroup color
            cell.tintColor = backgroundColor;
            cell.contentView.backgroundColor = backgroundColor;
            
            cell.textLabel.shadowOffset = CGSizeMake(0, 1);
            cell.textLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
            return cell;
        }
    
    } else {
        FQTodoHomeCell *cell = [FQTodoHomeCell TodoHomeCellWithTableView:self.tableView];
        //设置cell的默认底色
        cell.contentView.backgroundColor = backgroundColor;
        
        //记录tap
        cell.IdxPath = indexPath;
        
        //设置delegate
        cell.delegate = self;
        
        //将obj赋给model.groupname
        //[group SetTypeByObj:(NSString *)object];
        cell.groupModel = group;
//        NSLog(@"%@, %@", NSStringFromCGRect(cell.frame), NSStringFromCGRect(cell.contentView.frame));
//        NSLog(@"%ld", (long)self.tableView.style);
        
        return cell;
    }
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NORMAL_CELL_FINISHING_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tableView:didSelectRowAtIndexPath: %@", indexPath);
}

#pragma mark - JTTableViewGestureAddingRowDelegate

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsAddRowAtIndexPath:(NSIndexPath *)indexPath {
    FQGroup *_group = [FQGroup initwithObj:ADDING_CELL withType:GROUP_TYPE_ADDING_CELL];
    [self.groups insertObject:_group atIndex:indexPath.row];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCommitRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(0,250, 320, 60)];
    //[self.tableView addSubview:textfield];
    //[textfield becomeFirstResponder];
    FQGroup *_group = [FQGroup initwithObj:@"Added!" withType:GROUP_TYPE_ADDED_CELL];
    [self.groups replaceObjectAtIndex:indexPath.row withObject:_group];
    
    UITableViewCell *cell = (id)[gestureRecognizer.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:([JTTransformableTableViewCell class])]) {
        ((JTTransformableTableViewCell *)cell).finishedHeight = NORMAL_CELL_FINISHING_HEIGHT;
    }

    [self.tableView reloadData];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsDiscardRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.groups removeObjectAtIndex:indexPath.row];
}

// Uncomment to following code to disable pinch in to create cell gesture
//- (NSIndexPath *)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer willCreateCellAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        return indexPath;
//    }
//    return nil;
//}

#pragma mark JTTableViewGestureEditingRowDelegate

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer didEnterEditingState:(JTTableViewCellEditingState)state forRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    UIColor *backgroundColor = nil;
    switch (state) {
        case JTTableViewCellEditingStateMiddle:
            backgroundColor = [[UIColor redColor] colorWithHueOffset:0.12 * indexPath.row / [self tableView:self.tableView numberOfRowsInSection:indexPath.section]];
            break;
        case JTTableViewCellEditingStateRight:
            backgroundColor = [UIColor greenColor];
            break;
        default:
            backgroundColor = [UIColor darkGrayColor];
            break;
    }
    cell.contentView.backgroundColor = backgroundColor;
    if ([cell isKindOfClass:[JTTransformableTableViewCell class]]) {
        ((JTTransformableTableViewCell *)cell).tintColor = backgroundColor;
    }
    else if([cell isKindOfClass:[FQTodoHomeCell class]]) {
        ((FQTodoHomeCell *)cell).tintColor = backgroundColor;
    }
}

// This is needed to be implemented to let our delegate choose whether the panning gesture should work
- (BOOL)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer commitEditingState:(JTTableViewCellEditingState)state forRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *tableView = gestureRecognizer.tableView;
    
    NSIndexPath *rowToBeMovedToBottom = nil;

    [tableView beginUpdates];
    if (state == JTTableViewCellEditingStateLeft) {
        // An example to discard the cell at JTTableViewCellEditingStateLeft
        [self.groups removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    } else if (state == JTTableViewCellEditingStateRight) {
        // An example to retain the cell at commiting at JTTableViewCellEditingStateRight
        FQGroup *_group = [self.groups objectAtIndex:indexPath.row];
        _group.type = GROUP_TYPE_DONE;
        //[self.groups replaceObjectAtIndex:indexPath.row withObject:_group];
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        rowToBeMovedToBottom = indexPath;
    } else {
        // JTTableViewCellEditingStateMiddle shouldn't really happen in
        // - [JTTableViewGestureDelegate gestureRecognizer:commitEditingState:forRowAtIndexPath:]
    }
    [tableView endUpdates];

    // Row color needs update after datasource changes, reload it.
    [tableView performSelector:@selector(reloadVisibleRowsExceptIndexPath:) withObject:indexPath afterDelay:JTTableViewRowAnimationDuration];

    if (rowToBeMovedToBottom) {
        [self performSelector:@selector(moveRowToBottomForIndexPath:) withObject:rowToBeMovedToBottom afterDelay:JTTableViewRowAnimationDuration * 2];
    }
}

#pragma mark JTTableViewGestureMoveRowDelegate

- (BOOL)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCreatePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.grabbedObject = [self.groups objectAtIndex:indexPath.row];
    FQGroup *_group = [FQGroup initwithObj:DUMMY_CELL withType:GROUP_TYPE_DUMMY];
    [self.groups replaceObjectAtIndex:indexPath.row withObject:_group];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id object = [self.groups objectAtIndex:sourceIndexPath.row];
    [self.groups removeObjectAtIndex:sourceIndexPath.row];
    [self.groups insertObject:object atIndex:destinationIndexPath.row];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsReplacePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.groups replaceObjectAtIndex:indexPath.row withObject:self.grabbedObject];
    self.grabbedObject = nil;
}

@end
