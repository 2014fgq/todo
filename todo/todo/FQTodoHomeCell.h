//
//  todo_home_cell.h
//  todo
//
//  Created by IMAC on 16/3/4.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQGroup.h"
//#import "MCSwipeTableViewCell.h"
//@interface FQTodoHomeCell : MCSwipeTableViewCell
#import "UIColor+Hex.h"
@class FQGroup;
@protocol FQTodoHomeCellDelegate;

@interface FQTodoHomeCell : UITableViewCell <UITextFieldDelegate>
@property (weak, nonatomic) UITextField *textfield;
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UILabel *seplabel;
@property (strong, nonatomic) FQGroup *groupModel;
@property (strong, nonatomic) id <FQTodoHomeCellDelegate> delegate;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
+ (instancetype)TodoHomeCellWithTableView:(UITableView *)tableView;
- (void)setGroupModel:(FQGroup *)groupModel;
- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
@end

@protocol FQTodoHomeCellDelegate <NSObject>
- (void)SetCurCellByIdxPath:(NSIndexPath *)IdxPath;
- (void)ScrollUpWithIdxPath:(NSIndexPath *)IdxPath;
- (void)ScrollDownWithIdxPath:(NSIndexPath *)IdxPath;
- (void)needsDiscardRowAtIdxPath:(NSIndexPath *)IdxPath;
@end