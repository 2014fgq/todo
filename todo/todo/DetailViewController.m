//
//  DetailViewController.m
//  todo
//
//  Created by IMAC on 16/4/16.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import "DetailViewController.h"
#import "FQGroupBL+PLIST.h"

@interface DetailViewController ()
@property (strong, nonatomic) NSMutableArray *groupArray;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NewDetailView *newdetailView = [[NewDetailView alloc] initWithFrame:kScreenBounds];
    self.newdetailView = newdetailView;
    [self.view addSubview:newdetailView];
    
    // Setup your tableView.delegate and tableView.datasource,
    // then enable gesture recognition in one line.
    self.tableViewRecognizer = [self.tableView enableGestureTableViewWithDelegate:self];

    //self.groups = self.groupArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    debugMethod();
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

@end
