//
//  FQTodo.h
//  todo
//
//  Created by IMAC on 16/3/12.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
@interface FQTodo : NSObject
@property (strong, nonatomic) NSIndexPath *ID;
@property (strong, nonatomic) NSString *groupname;//组名
@property (nonatomic, assign) BOOL IsFinish;//是否完成
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger todoOK;//完成个数
@property (nonatomic, assign) NSInteger todoAll;//完成总数

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)TodoWithDict:(NSDictionary *)dict;
+ (NSMutableDictionary *)DictWithModel:(FQTodo *)model;
@end
