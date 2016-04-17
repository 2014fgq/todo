//
//  ViewController.m
//  todo
//
//  Created by IMAC on 16/3/11.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import "ViewController.h"
//#import "JTTransformableTableViewCell.h"
//#import "JTTableViewGestureRecognizer.h"
#import "UIColor+JTGestureBasedTableViewHelper.h"
#import "UIColor+Hex.h"
#import "FQTodoHomeCell.h"
#import "DetailViewController.h"
#import "FQGroupBL+PLIST.h"
// Configure your viewController to conform to JTTableViewGestureEditingRowDelegate
// and/or JTTableViewGestureAddingRowDelegate depends on your needs
@interface ViewController () //

@property (strong, nonatomic) NSMutableArray *groupArray;
- (void)moveRowToBottomForIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ViewController
@synthesize tableViewRecognizer;

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

    self.title = @"Todo";
    
    self.groups = self.groupArray;

}

#pragma mark - 懒加载
# warning todo, 懒加载数据应该使用中文实例
- (NSMutableArray *)groupArray
{
    if(!_groupArray)
    {
        _groupArray = [self.bl findAll];
        if (_groupArray.count == 0) {
            _groupArray = [FQGroup GroupsWithDefaultRows];
        }
        _groupArray = [self sortByIsFinish:_groupArray];
        NSLog(@"lazy Ok! load counts %ld", (unsigned long)_groupArray.count);
    }
    
    return _groupArray;
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
          NSStringFromCGRect(self.tableView.frame), NSStringFromCGRect(self.navigationController.navigationBar.frame), self.tableView.contentOffset.y, (long)IdxPath.row);
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
    NSLog(@"Row %ld Begin to Edit! %lu", (long)IdxPath.row, (unsigned long)[self.bl findAll].count);
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

    NSLog(@"Row %ld End to Edit! count is %lu", (long)IdxPath.row, (unsigned long)[self.bl findAll].count);
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
    NSLog(@"End to Edit! cell %ld text is Null!", (long)IndexPath.row);
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
    NSLog(@"moveRowToBottomForIndexPath move %ld to %ld", (long)indexPath.row, (long)desIndexPath.row);
    
    [self.tableView beginUpdates];
    
    [self.tableView moveRowAtIndexPath:indexPath toIndexPath:desIndexPath];

    [self.tableView endUpdates];

    //[self.tableView performSelector:@selector(reloadVisibleRowsExceptIndexPath:) withObject:lastIndexPath afterDelay:JTTableViewRowAnimationDuration];
}


#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NORMAL_CELL_FINISHING_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tableView:didSelectRowAtIndexPath: %@", indexPath);
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    FQGroup *group = [self.groups objectAtIndex:indexPath.row];
    detailViewController.title = group.groupname;
    [self.navigationController pushViewController:detailViewController animated:YES];
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
