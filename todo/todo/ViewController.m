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
#import "FQGroupBL+PLIST.h"
// Configure your viewController to conform to JTTableViewGestureEditingRowDelegate
// and/or JTTableViewGestureAddingRowDelegate depends on your needs
@interface ViewController () <JTTableViewGestureAddingRowDelegate, JTTableViewGestureMoveRowDelegate, JTTableViewGestureEditingRowDelegate, FQTodoHomeCellDelegate>//
@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) JTTableViewGestureRecognizer *tableViewRecognizer;
@property (nonatomic, strong) id grabbedObject;
@property (nonatomic, strong) NSIndexPath *IdxPath;
@property (strong, nonatomic) FQGroupBL *bl;
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
    NSLog(@"viewDidLoad Is Finish!");
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning");
}

- (void)dealloc {
    NSLog(@"dealloc");
}

#pragma mark - FQTodoHomeCellDelegate
# warning cell的delegate不太规范，应该包含cell的参数
# warning 滚动变色的功能有bug,在tablewview中间捏合加入cell之后，点击修改的效果有bug
- (void)ScrollUpWithIdxPath:(NSIndexPath *)IdxPath
{
    //[self.tableView addSubview:_windowsview];
    //计算滚动量，滚动量=-(cell高*当前cell的Idx - tableview已经向上滚的滚动量)
    NSInteger scroll = self.tableView.contentOffset.y-NORMAL_CELL_FINISHING_HEIGHT*IdxPath.row;
    NSLog(@"table=%@, navi=%@, contest=%f, Idx=%ld",
          NSStringFromCGRect(self.tableView.frame), NSStringFromCGRect(self.navigationController.navigationBar.frame), self.tableView.contentOffset.y, IdxPath.row);
    //动画展示键盘弹入
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, scroll);
    }];
    UITableViewCell *editingCell = [self.tableView cellForRowAtIndexPath:IdxPath];
//    float _editingOffset = self.tableView.contentOffset.y - editingCell.frame.origin.y;
//    
    for(UITableViewCell* cell in [self.tableView visibleCells])
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             if (cell != editingCell) {
                                 cell.alpha = 0.3;
                             }
                         }];
    }
    NSLog(@"Row %ld Begin to Edit! %lu", IdxPath.row, (unsigned long)[self.bl findAll].count);
}

-(void)ScrollDownWithIdxPath:(NSIndexPath *)IdxPath
{
    NSInteger scroll = 0;
    //动画展示键盘弹入弹出
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, scroll);
    }];
    for(FQTodoHomeCell* cell in [self.tableView visibleCells])
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             cell.alpha = 1;
                         }];
    }
    
    [self.bl writewithArray:self.groups];
    //FQTodoHomeCell *cell = [self.tableView cellForRowAtIndexPath:IdxPath];
    //if([cell isKindOfClass:[FQGroup class]])
        //[self.bl replacewithmodel:cell.groupModel atIdx:IdxPath.row];

    NSLog(@"Row %ld End to Edit! count is %lu", IdxPath.row, (unsigned long)[self.bl findAll].count);
}

//如果textfield获取的数据为空，清空数据，重新计算Indexpath，不然所有cell的IndexPath.row会增加1
- (void)needsDiscardRowAtIdxPath:(NSIndexPath *)IdxPath{
    //重算cell.groupModel.ID,先重算Index,再删除cell，因为动画效果很差
    NSIndexPath *IndexPath = IdxPath;
    NSIndexPath *IndexPath_tmp = IndexPath;
    [self.tableView reloadData];
    for(FQTodoHomeCell* cell in [self.tableView visibleCells])
    {
        //判断是否为FQToDoHomeCell
        if([cell isKindOfClass:[FQTodoHomeCell class]])
        {
            IndexPath_tmp = cell.groupModel.ID;
            cell.groupModel.ID = IndexPath;
            IndexPath = IndexPath_tmp;
        }
    }
    
    //清空Model和tableview的数据
    [self.groups removeObjectAtIndex:IdxPath.row];
    [self.bl remove:nil atIdx:IdxPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:IdxPath] withRowAnimation:UITableViewRowAnimationLeft];
    NSLog(@"End to Edit! cell %ld text is Null!", IndexPath.row);
}
#pragma mark - 懒加载
# warning 懒加载数据应该使用中文实例
- (NSMutableArray *)groups
{
    if(!_bl)
    {
        _bl = [FQGroupBL sharedManager];
    }
    if(!_groups)
    {
        _groups = [_bl findAll];
        if (_groups.count == 0) {
            _groups = [FQGroup GroupsWithDefaultRows];
        }
        _groups = [self sortByIsFinish:_groups];
        NSLog(@"lazy Ok! load counts %ld", _groups.count);
    }
    
    return _groups;
}

//数据进行重排，没完成的在前面，完成了的在后面
- (NSMutableArray *) sortByIsFinish:(NSArray *)array
{
    CHECK_NULLPOINTER(array)
    NSMutableArray *finisharray = [NSMutableArray array];
    NSMutableArray *notfinisharray = [NSMutableArray array];
    for (FQGroup *group in array) {
        if(group.IsFinish)
        {
            [finisharray addObject:group];
        }
        else
        {
            [notfinisharray addObject:group];
        }
    }
    NSLog(@"Finish %ld -- UnFinish %ld", finisharray.count, notfinisharray.count);
    [notfinisharray addObjectsFromArray:finisharray];
    return notfinisharray;
}


- (NSInteger)GetLastUnFinish
{
    NSInteger Idx = 0;
    //先进行排序
    self.groups = [self sortByIsFinish:self.groups];
    
    //获取
    for (FQGroup *group in self.groups) {
        if(group.IsFinish)
        {
            break;
        }
        else
        {
            Idx++;
        }
    }
    
    return Idx;
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
# warning 颜色可以不用16进制了。废弃16进制获取颜色的功能
    self.navigationController.navigationBar.barTintColor =
        [UIColor colorWithHex:0x222e3b];
    //self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

#pragma mark Private Method

- (void)moveRowToBottomForIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *desIndexPath = nil;
    FQGroup *group = [self.groups objectAtIndex:indexPath.row];
    
    if (group.IsFinish) {
        [self.groups removeObjectAtIndex:indexPath.row];
        [self.groups addObject:group];
        desIndexPath = [NSIndexPath indexPathForRow:[self.groups count] - 1 inSection:0];
    }
    else
    {
        desIndexPath = [NSIndexPath indexPathForRow:[self GetLastUnFinish]-1 inSection:0];
    }

    [self.bl writewithArray:self.groups];
    NSLog(@"moveRowToBottomForIndexPath move %ld to %ld", indexPath.row, desIndexPath.row);
    
    [self.tableView beginUpdates];
    
    [self.tableView moveRowAtIndexPath:indexPath toIndexPath:desIndexPath];

    [self.tableView endUpdates];

    //[self.tableView performSelector:@selector(reloadVisibleRowsExceptIndexPath:) withObject:lastIndexPath afterDelay:JTTableViewRowAnimationDuration];
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
        group.ID = indexPath;
        
        //设置delegate
        cell.delegate = self;
        
        //将obj赋给model.groupname
        //[group SetTypeByObj:(NSString *)object];
        cell.groupModel = group;
        //NSLog(@"%ld=%f", (long)cell.groupModel.ID.row, cell.alpha);
        
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    // 三个方法并用，实现自定义分割线效果
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = insets;
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:insets];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
}

#pragma mark - JTTableViewGestureAddingRowDelegate

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsAddRowAtIndexPath:(NSIndexPath *)indexPath {
    FQGroup *_group = [FQGroup initwithObj:ADDING_CELL withType:GROUP_TYPE_ADDING_CELL];
    [self.groups insertObject:_group atIndex:indexPath.row];
    [self.bl insertwithmodel:_group atIdx:indexPath.row];
    NSLog(@"begin to add! %lu", (unsigned long)[self.bl findAll].count);
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCommitRowAtIndexPath:(NSIndexPath *)indexPath {
    FQGroup *_group = [FQGroup initwithObj:@"" withType:GROUP_TYPE_ADDED_CELL];
    [self.groups replaceObjectAtIndex:indexPath.row withObject:_group];
    [self.bl replacewithmodel:_group atIdx:indexPath.row];

    UITableViewCell *cell = (id)[gestureRecognizer.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:([JTTransformableTableViewCell class])]) {
        ((JTTransformableTableViewCell *)cell).finishedHeight = NORMAL_CELL_FINISHING_HEIGHT;
    }

    [self.tableView reloadData];
    //[self.tableView beginUpdates];
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];//UITableViewRowAnimationLeft
    //[self.tableView endUpdates];
    NSLog(@"ADDED! %lu", (unsigned long)[self.bl findAll].count);
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsDiscardRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.groups removeObjectAtIndex:indexPath.row];
    [self.bl remove:nil atIdx:indexPath.row];
    NSLog(@"begin to delete! %lu", (unsigned long)[self.bl findAll].count);
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
//
//    UIColor *backgroundColor = nil;
//    switch (state) {
//        case JTTableViewCellEditingStateMiddle:
//            backgroundColor = [[UIColor redColor] colorWithHueOffset:0.12 * indexPath.row / [self tableView:self.tableView numberOfRowsInSection:indexPath.section]];
//            break;
//        case JTTableViewCellEditingStateRight:
//            backgroundColor = [UIColor greenColor];
//            break;
//        default:
//            backgroundColor = [UIColor darkGrayColor];
//            break;
//    }
//    cell.contentView.backgroundColor = backgroundColor;
//    if ([cell isKindOfClass:[JTTransformableTableViewCell class]]) {
//        ((JTTransformableTableViewCell *)cell).tintColor = backgroundColor;
//    }
    if([cell isKindOfClass:[FQTodoHomeCell class]]) {
        FQTodoHomeCell *fqcell = (FQTodoHomeCell *)cell;
        [fqcell handlePan:[gestureRecognizer valueForKey:@"panRecognizer"]];
    }
    
    
    //NSLog(@"Editing %ld", indexPath.row);
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
        [self.bl remove:nil atIdx:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    } else if (state == JTTableViewCellEditingStateRight) {
        // An example to retain the cell at commiting at JTTableViewCellEditingStateRight
        FQGroup *_group = [self.groups objectAtIndex:indexPath.row];
        _group.type = GROUP_TYPE_DONE;
        
        //改变cell的颜色
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        rowToBeMovedToBottom = indexPath;
    } else {
        // JTTableViewCellEditingStateMiddle shouldn't really happen in
        // - [JTTableViewGestureDelegate gestureRecognizer:commitEditingState:forRowAtIndexPath:]
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if([cell isKindOfClass:[FQTodoHomeCell class]]) {
            FQTodoHomeCell *fqcell = (FQTodoHomeCell *)cell;
            [fqcell handlePan:[gestureRecognizer valueForKey:@"panRecognizer"]];
        }
    }
    [tableView endUpdates];

    // Row color needs update after datasource changes, reload it.
    [tableView performSelector:@selector(reloadVisibleRowsExceptIndexPath:) withObject:indexPath afterDelay:JTTableViewRowAnimationDuration];

    //移动cell的位置
    if (rowToBeMovedToBottom) {
        [self performSelector:@selector(moveRowToBottomForIndexPath:) withObject:rowToBeMovedToBottom afterDelay:JTTableViewRowAnimationDuration * 2];
    }
    NSLog(@"Commiting Editing %ld %p", indexPath.row, rowToBeMovedToBottom);
}

#pragma mark JTTableViewGestureMoveRowDelegate

- (BOOL)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCreatePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.grabbedObject = [self.groups objectAtIndex:indexPath.row];
    FQGroup *_group = [FQGroup initwithObj:DUMMY_CELL withType:GROUP_TYPE_DUMMY];
    [self.groups replaceObjectAtIndex:indexPath.row withObject:_group];
    NSLog(@"Begain to Move %lu", [[self.bl findAll] count]);
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id object = [self.groups objectAtIndex:sourceIndexPath.row];
    [self.groups removeObjectAtIndex:sourceIndexPath.row];
    [self.groups insertObject:object atIndex:destinationIndexPath.row];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsReplacePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.groups replaceObjectAtIndex:indexPath.row withObject:self.grabbedObject];
    self.grabbedObject = nil;
    
    debugLog(@"End to Move %d, %lu", [self.bl writewithArray:self.groups], [[self.bl findAll] count]);
}

#pragma mark - hide keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

//滚动时退出键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging");
    [self.view endEditing:YES];
}

@end
