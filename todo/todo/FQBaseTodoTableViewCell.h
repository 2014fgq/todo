//
//  FQBaseTodoTableViewCell.h
//  todo
//
//  Created by IMAC on 16/4/17.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"
#import "FQGroup.h"
@class FQTodo;
@protocol FQBaseTodoTableViewCellDelegate;
@interface FQBaseTodoTableViewCell : UITableViewCell <UITextFieldDelegate>
{
    // Contextual cues
    UILabel* _tickLabel;
    UILabel* _crossLabel;
}
@property (weak, nonatomic) UITextField *textfield;
@property (weak, nonatomic) id <FQBaseTodoTableViewCellDelegate> delegate;
@property (strong, nonatomic) FQTodo *groupModel;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
+ (instancetype)CellWithTableView:(UITableView *)tableView;
- (void)setGroupModel:(FQTodo *)groupModel;
- (void)addpanLabel;
- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
- (void)JudgeSts;
@end

@protocol FQBaseTodoTableViewCellDelegate <NSObject>
- (void)ScrollUpWithIdxPath:(NSIndexPath *)IdxPath;
- (void)ScrollDownWithIdxPath:(NSIndexPath *)IdxPath;
- (void)needsDiscardRowAtIdxPath:(NSIndexPath *)IdxPath;
- (void)SingleTapWithCell:(FQBaseTodoTableViewCell *)cell;
@end