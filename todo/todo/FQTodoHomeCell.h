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
@protocol FQTodoHomeCellDelegate;

@interface FQTodoHomeCell : UITableViewCell <UITextFieldDelegate>
@property (strong, nonatomic) UITextField *textfield;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UILabel *seplabel;
@property (strong, nonatomic) FQGroup *groupModel;
@property (strong, nonatomic) id <FQTodoHomeCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *IdxPath;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
+ (instancetype)TodoHomeCellWithTableView:(UITableView *)tableView;
- (void)setGroupModel:(FQGroup *)groupModel;
@end

@protocol FQTodoHomeCellDelegate <NSObject>
- (void) SetCurCellByIdxPath:(NSIndexPath *)IdxPath;
@end