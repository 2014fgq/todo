//
//  FQGroup.h
//  todo
//
//  Created by IMAC on 16/3/12.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FQTodo.h"


@class FQTodo;
//@interface FQGroup : FQTodo
@interface FQGroup : FQTodo
@property (nonatomic, assign) NSInteger todoOK;//完成个数
@property (nonatomic, assign) NSInteger todoAll;//完成总数
@property (strong, nonatomic) NSMutableArray *todo;


- (instancetype)initWithDict:(NSDictionary *)dict;
- (void)GroupCalcIsFinish;
+ (instancetype)groupWithDict:(NSDictionary *)dict;
+ (NSDictionary *)DictWithModel:(FQGroup *)model;
+ (instancetype)initwithdefaultobj:(NSString *)obj;
+(instancetype)initwithObj:(NSString *)obj withType:(NSInteger)type;
+ (NSMutableArray *)GroupsWithDefaultRows;

@end

