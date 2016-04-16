//
//  FQGroup.h
//  todo
//
//  Created by IMAC on 16/3/12.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
//#import "YTKKeyValueStore.h"
typedef enum {
    GROUP_TYPE_NORMAL     = 0,
    GROUP_TYPE_DUMMY      = 1,
    GROUP_TYPE_DONE       = 2,
    GROUP_TYPE_PINCH_ON   = 3,
    GROUP_TYPE_PINCH_OK   = 4,
    GROUP_TYPE_ADDING_CELL = 5,
    GROUP_TYPE_ADDED_CELL = 6
}GROUPTYPE;

@interface FQGroup : NSObject

@property (strong, nonatomic) NSString *groupname;//组名
@property (nonatomic, assign) NSInteger todoOK;//完成个数
@property (nonatomic, assign) NSInteger todoAll;//完成总数
@property (nonatomic, assign) BOOL IsFinish;//是否完成
@property (nonatomic, assign) NSInteger type;
@property (strong, nonatomic) NSIndexPath *ID;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)groupWithDict:(NSDictionary *)dict;
+ (NSDictionary *)DictWithModel:(FQGroup *)model;
+ (instancetype)initwithdefaultobj:(NSString *)obj;
+(instancetype)initwithObj:(NSString *)obj withType:(NSInteger)type;
+ (NSMutableArray *)GroupsWithDefaultRows;

@end

