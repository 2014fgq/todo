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
#import "FQTodoDetailCell.h"
#import "DetailViewController.h"
#import "FQGroupBL+PLIST.h"
#import "FQTodo.h"
// Configure your viewController to conform to JTTableViewGestureEditingRowDelegate
// and/or JTTableViewGestureAddingRowDelegate depends on your needs
@interface ViewController () //
@property (strong, nonatomic) FQGroupBL *bl;
@property (strong, nonatomic) NSMutableArray *groupArray;
@end

@implementation ViewController
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
    self.cellClass = [FQTodoHomeCell class];
    self.cellModelClass = [FQGroup class];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingLatestDaily:) name:NOTI_LASTDATA object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerWillShow:) name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerWillHide:) name:UIMenuControllerWillHideMenuNotification object:nil];

}

- (void)dealloc
{
    debugMethod();
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_LASTDATA object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerMenuFrameDidChangeNotification object:nil];
}

#pragma mark - 懒加载
- (FQGroupBL *)bl
{
    if(!_bl)
    {
        _bl = [FQGroupBL sharedManager];
    }
    return _bl;
}

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
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NORMAL_CELL_FINISHING_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tableView:didSelectRowAtIndexPath: %@", indexPath);
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    FQGroup *group = [self.groups objectAtIndex:indexPath.row];
    detailViewController.title = group.groupname;
    detailViewController.groups = group.todo;
    detailViewController.cellClass = [FQTodoDetailCell class];
    detailViewController.cellModelClass = [FQTodo class];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPaths
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

- (void)loadingLatestDaily:(NSNotification *)noti {
    debugMethod();
    debugLog(@"%@", noti);
    if((noti.object == [ViewController class]) ||
       (noti.object == [DetailViewController class]))
    {
        [self.bl writewithArray:self.groups];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    debugMethod();
    [super viewDidAppear:animated];
    for (FQGroup *group in self.groups) {
        [group GroupCalcIsFinish];
    }
    [self.tableView reloadData];
}

//左右拉完成以后
- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer commitEditingState:(JTTableViewCellEditingState)state forRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *tableView = gestureRecognizer.tableView;
    
    // Row color needs update after datasource changes, reload it.
    [tableView performSelector:@selector(reloadVisibleRowsExceptIndexPath:) withObject:indexPath afterDelay:JTTableViewRowAnimationDuration];
    
    [tableView beginUpdates];
    if (state == JTTableViewCellEditingStateLeft) {
        // An example to discard the cell at JTTableViewCellEditingStateLeft
        [self.groups removeObjectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_LASTDATA object:self.class userInfo:nil];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    } else if (state == JTTableViewCellEditingStateRight) {
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        // JTTableViewCellEditingStateMiddle shouldn't really happen in
        // - [JTTableViewGestureDelegate gestureRecognizer:commitEditingState:forRowAtIndexPath:]
    }
    [tableView endUpdates];
}

- (void)MenuControllerWhenHide:(NSNotification *)noti{
    debugMethod();
}

-(void)menuControllerWillShow:(NSNotification *)notification{
    debugMethod();
    //Remove Will Show Notif
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIMenuControllerWillShowMenuNotification object:nil];
    
    //[UIMenuController sharedMenuController].menuVisible = false;
    //Hide the Original View
    UIMenuController* menuController = [UIMenuController sharedMenuController];
    CGPoint origin = menuController.menuFrame.origin;
    CGSize size = menuController.menuFrame.size;
    CGRect menuFrame;
    menuFrame.origin = origin;
    menuFrame.size = size;
    //[menuController setMenuVisible:NO animated:NO];
    menuFrame.origin = CGPointMake(-250, -250);    
    //Modify its Target Rect
    menuController.arrowDirection = UIMenuControllerArrowUp;
    [menuController setTargetRect:menuFrame inView:self.view];
    [menuController setMenuVisible:YES animated:YES];
}

-(void)menuControllerWillHide:(NSNotification *)notification{
    debugMethod();
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerWillShow:) name:UIMenuControllerWillShowMenuNotification object:nil];
}


@end
