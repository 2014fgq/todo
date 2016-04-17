//
//  BaseTableViewController.m
//  todo
//
//  Created by IMAC on 16/4/16.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import "BaseTableViewController.h"
#import "FQGroupBL+PLIST.h"
#import "JTTransformableTableViewCell.h"
#import "FQTodoHomeCell.h"
@interface BaseTableViewController () <JTTableViewGestureAddingRowDelegate, JTTableViewGestureMoveRowDelegate, JTTableViewGestureEditingRowDelegate, FQTodoHomeCellDelegate>

@property (nonatomic, strong) id grabbedObject;
@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight       = NORMAL_CELL_FINISHING_HEIGHT;
    [self tableview_navigationview_setup:self];
    NSLog(@"viewDidLoad Is Finish!");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"dealloc");
}

#pragma mark - 懒加载
# warning 懒加载数据应该使用中文实例
- (FQGroupBL *)bl
{
    if(!_bl)
    {
        _bl = [FQGroupBL sharedManager];
    }
    return _bl;
}

- (void)SetGroups:(NSMutableArray *)groups
{
    _groups = groups;
    [self.tableView reloadData];
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
    NSLog(@"Finish %ld -- UnFinish %ld", (unsigned long)finisharray.count, (unsigned long)notfinisharray.count);
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

#pragma mark - Table view data source

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
    [UIColor colorWithHex:FQTODO_NAVIGCOLOR];
    //self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
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
    
    if([cell isKindOfClass:[FQTodoHomeCell class]]) {
        FQTodoHomeCell *fqcell = (FQTodoHomeCell *)cell;
        [fqcell handlePan:[gestureRecognizer valueForKey:@"panRecognizer"]];
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
    NSLog(@"Commiting Editing %ld %p", (long)indexPath.row, rowToBeMovedToBottom);
}

#pragma mark JTTableViewGestureMoveRowDelegate
# warning 如果移动的位置超过最后一个未完成的，变为完成的状态
- (BOOL)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCreatePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.grabbedObject = [self.groups objectAtIndex:indexPath.row];
    FQGroup *_group = [FQGroup initwithObj:DUMMY_CELL withType:GROUP_TYPE_DUMMY];
    [self.groups replaceObjectAtIndex:indexPath.row withObject:_group];
    NSLog(@"Begain to Move %lu", (unsigned long)[[self.bl findAll] count]);
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id object = [self.groups objectAtIndex:sourceIndexPath.row];
    [self.groups removeObjectAtIndex:sourceIndexPath.row];
    [self.groups insertObject:object atIndex:destinationIndexPath.row];
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsReplacePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.groups replaceObjectAtIndex:indexPath.row withObject:self.grabbedObject];
    self.grabbedObject = nil;
    
    debugLog(@"End to Move %d, %lu", [self.bl writewithArray:self.groups], (unsigned long)[[self.bl findAll] count]);
}

@end
