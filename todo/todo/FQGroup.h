//
//  FQGroup.h
//  todo
//
//  Created by IMAC on 16/3/12.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FQGroup : NSObject
@property (strong, nonatomic) NSString *groupname;//组名
@property (nonatomic, assign) NSInteger todoOK;//完成个数
@property (nonatomic, assign) NSInteger todoAll;//完成总数
@property (nonatomic, assign) BOOL IsFinish;//是否完成
- (void)initWithDict;
- (void)groupWithDict;
- (void)removeNameAtIdx:(NSInteger)Idx;
+ (instancetype)initwithdefaultrows:(NSString *)obj;
@end
