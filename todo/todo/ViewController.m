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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingLatestDaily:) name:NOTI_LASTDATA object:nil];
    // Setup your tableView.delegate and tableView.datasource,
    // then enable gesture recognition in one line.
    self.tableViewRecognizer = [self.tableView enableGestureTableViewWithDelegate:self];

    self.title = @"Todo";
    
    self.groups = self.groupArray;
    //self.cellClass = [FQTodoHomeCell class];
    //self.cellModelClass = [FQGroup class];
}

- (void)dealloc
{
    debugMethod();
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_LASTDATA object:nil];
}

#pragma mark - 懒加载
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

@end
