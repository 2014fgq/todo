//
//  ViewController.h
//  todo
//
//  Created by IMAC on 16/3/11.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQGroup.h"
@interface ViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *groups;
#define ADDING_CELL @"Continue..."
#define DONE_CELL @"Done"
#define DUMMY_CELL @"Dummy"
#define COMMITING_CREATE_CELL_HEIGHT 60
#define NORMAL_CELL_FINISHING_HEIGHT 60
@end

