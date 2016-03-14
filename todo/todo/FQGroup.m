//
//  FQGroup.m
//  todo
//
//  Created by IMAC on 16/3/12.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import "FQGroup.h"

@implementation FQGroup
#pragma mark - Inif Default
+ (instancetype)initwithdefaultobj:(NSString *)obj
{
    FQGroup *_group = [[FQGroup alloc] init];
    _group.groupname = obj;
    _group.todoOK = 0;
    _group.todoAll = 0;
    _group.IsFinish = false;
    return _group;
}

+ (NSMutableArray *)GroupsWithDefaultRows
{
    // In this example, we setup self.rows as datasource
    NSMutableArray *rows = [NSMutableArray arrayWithObjects:
                 @"Swipe to the right to complete",
                 @"Swipe to left to delete",
                 @"Drag down to create a new cell",
                 @"Pinch two rows apart to create cell",
                 @"Long hold to start reorder cell",
                 nil];
    
    NSMutableArray *_array = [[NSMutableArray alloc] init];
    for (NSString *obj in rows) {
        FQGroup *_group = [FQGroup initwithdefaultobj:obj];
        [_array addObject:_group];
    }
    return  _array;
}

#pragma mark - Set
- (void)SetTypeByObj:(NSString *)obj
{
    if([obj isEqual:DONE_CELL])
        self.type = GROUP_TYPE_DONE;
    else if ([obj isEqual:DUMMY_CELL])
        self.type = GROUP_TYPE_DUMMY;
    else
        self.type = GROUP_TYPE_NORMAL;
}

- (void)initWithDict
{
    
}
- (void)groupWithDict
{
    
}

#pragma mark - create
#pragma mark - updat
#pragma mark - delete

#pragma mark - remove
- (void)removeNameAtIdx:(NSInteger)Idx
{
    [self removeKey:@"groupname" AtIdx:Idx];
}

- (void)removeKey:(NSString *)key AtIdx:(NSInteger)Idx
{
    
}

@end
