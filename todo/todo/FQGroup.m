//
//  FQGroup.m
//  todo
//
//  Created by IMAC on 16/3/12.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import "FQGroup.h"

@implementation FQGroup
+ (instancetype)initwithdefaultrows:(NSString *)obj
{
    FQGroup *_group = [[FQGroup alloc] init];
    _group.groupname = obj;
    _group.todoOK = 0;
    _group.todoAll = 0;
    _group.IsFinish = false;
    return _group;
}

- (void)SetTypeByObj:(NSString *)obj
{
    if([obj isEqual:DONE_CELL])
        self.type = GROUP_TYPE_DUMMY;
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
