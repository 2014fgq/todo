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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NewDetailWhenDisplay:) name:NOTI_NEWDETAILWHENDISPLAY object:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    debugMethod();
}

- (void)dealloc
{
    debugMethod();
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_NEWDETAILWHENDISPLAY object:nil];
}

- (void) NewDetailWhenDisplay:(NSNotification *)noti{
    if(noti.object == [DetailViewController class])
    {
        if(self.groups.count != 0)
            self.newdetailView.alpha = 0.f;
        else
            self.newdetailView.alpha = 1.f;
    }
}

@end
