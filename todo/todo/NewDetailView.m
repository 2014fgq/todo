//
//  NewDetailView.m
//  todo
//
//  Created by IMAC on 16/4/16.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import "NewDetailView.h"
@implementation NewDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
        self.label = label;
        //配置右边的label
        self.label.adjustsFontSizeToFitWidth = YES;
        //self.label.frame = CGRectMake(320, 20, 35, 20);
        //配置圆角
        [self.label.layer setBorderWidth:2.0];
        self.label.layer.cornerRadius = 8;
        self.label.layer.masksToBounds = true;
        
        //配置内容
        self.label.textAlignment = NSTextAlignmentCenter;//UITextAlignmentCenter 在ios6废弃
        self.label.text = [NSString stringWithFormat:@"%@", @"下拉新建事件"];
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont fontWithName:@"Helvetica" size:20];
        [self addSubview:self.label];
    }
    return self;
}

@end
