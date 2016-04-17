//
//  DetailViewController.h
//  todo
//
//  Created by IMAC on 16/4/16.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "NewDetailView.h"
#import "BaseTableViewController.h"
@interface DetailViewController : BaseTableViewController
@property (weak, nonatomic) NewDetailView *newdetailView;
@end
