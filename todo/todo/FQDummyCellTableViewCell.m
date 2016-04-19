//
//  FQDummyCellTableViewCell.m
//  todo
//
//  Created by IMAC on 16/4/18.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import "FQDummyCellTableViewCell.h"

@implementation FQDummyCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)CellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"dummycell";
    FQDummyCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[FQDummyCellTableViewCell alloc] initWithReuseIdentifier:ID];
    }
    cell.contentView.backgroundColor = [UIColor blackColor];
    return cell;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        
    }
    return  self;
}

@end
