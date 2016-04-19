//
//  BaseTableViewController.h
//  todo
//
//  Created by IMAC on 16/4/16.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "UIColor+Hex.h"
#import "JTTableViewGestureRecognizer.h"
@class FQGroupBL;
@interface BaseTableViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *groups;
@property (strong, nonatomic) JTTableViewGestureRecognizer *tableViewRecognizer;
@property (copy,   nonatomic) Class cellClass;
@property (copy,   nonatomic) Class cellModelClass;
- (NSMutableArray *) sortByIsFinish:(NSArray *)array;
- (NSInteger)GetLastUnFinish;

#define ADDING_CELL @"Continue..."
#define DONE_CELL @"Done"
#define DUMMY_CELL @"Dummy"
@end
