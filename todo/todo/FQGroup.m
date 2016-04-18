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
+(instancetype)initwithdefaultobj:(NSString *)obj
{
    FQGroup *_group = [[FQGroup alloc] init];
    _group.groupname = obj;
    _group.type = 0;
    _group.todoOK = 0;
    _group.todoAll = 0;
    _group.IsFinish = false;
    _group.todo = [NSMutableArray new];
    return _group;
}

+(instancetype)initwithObj:(NSString *)obj withType:(NSInteger)type
{
    FQGroup *_group = [[FQGroup alloc] init];
    _group.groupname = obj;
    _group.type = type;
    _group.todoOK = 0;
    _group.todoAll = 0;
    _group.IsFinish = false;
    _group.todo = [NSMutableArray new];
    return _group;
}

+ (NSMutableArray *)GroupsWithDefaultRows
{
    // In this example, we setup self.rows as datasource
    NSMutableArray *rows = [NSMutableArray arrayWithObjects:
                 @"示例1",
                 @"示例2",
                 @"如何使用?",
                 nil];
    
    NSMutableArray *_array = [[NSMutableArray alloc] init];
    for (NSString *obj in rows) {
        FQGroup *_group = [FQGroup initwithdefaultobj:obj];
        [_array addObject:_group];
    }
    return  _array;
}

#pragma mark - 懒加载
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
        NSArray *array = [NSArray arrayWithArray:dict[@"todo"]];
        NSMutableArray *mutablearray = [NSMutableArray new];
        for (NSDictionary *dict in array) {
            FQTodo *todo = [FQTodo TodoWithDict:dict];
            [mutablearray addObject:todo];
        }
        self.todo = mutablearray;
    }
    return self;
}
+ (instancetype)groupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"ID"]) {
        NSLog(@"ignore the key %@" , key);
    }
    //if ([key isEqualToString:@"todo"]) {
    //    NSLog(@"ignore the key %@" , key);
    //}
}

#pragma mark - Model to dict
+ (NSDictionary *)DictWithModel:(FQGroup *)model
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:model.groupname forKey:@"groupname"];
    [dict setValue:[NSNumber numberWithInteger:model.type] forKey:@"type"];
    [dict setValue:[NSNumber numberWithInteger:model.IsFinish] forKey:@"IsFinish"];
    [dict setValue:[NSNumber numberWithInteger:model.todoOK] forKey:@"todoOK"];
    [dict setValue:[NSNumber numberWithInteger:model.todoAll] forKey:@"todoAll"];

    NSArray *array = model.todo;
    NSMutableArray *mutablearray = [NSMutableArray array];
    for (FQTodo *todo in array) {
        NSMutableDictionary *dict = [FQTodo DictWithModel:todo];
        [mutablearray addObject:dict];
    }
    
    [dict setValue:mutablearray  forKey:@"todo"];
    
    return  dict;
}

@end

#if 0
@implementation FQGroupBL
static FQGroupBL *sharedManager = nil;
#define DB_NAME @"todo.db"
#define DB_TABLE_HOME @"todo_home"

//+ (FQGroupBL *)sharedManager
//{
//    if(!_store)
//    {
//        _sharedManager = [[YTKKeyValueStore alloc] init];
//    }
//    static dispatch_once_t once;
//    dispatch_once(&once, ^{
//        sharedManager = [[self alloc] init];
//    });
//    return sharedManager;
//}
//
//- (YTKKeyValueStore *)store
//{
//    if(!_store)
//    {
//        _store = [[YTKKeyValueStore alloc] initDBWithName:DB_NAME];
//        [_store createTableWithName:DB_TABLE_HOME];
//        NSLog(@"%@", _store);
//    }
//    return _store;
//}
//
//#pragma mark - create
//- (void)create:(FQGroup *)model
//{
//    NSString *ID = [NSString stringWithFormat:@"abc%ld", (long)model.ID.row];
//    [_store putObject:model withId:ID intoTable:DB_TABLE_HOME];
//}
//#pragma mark - update
//- (void)update:(FQGroup *)model
//{
//    NSString *ID = [NSString stringWithFormat:@"%ld", (long)model.ID.row];
//    [_store putObject:(id)model withId:ID intoTable:DB_TABLE_HOME];
//}
//
//#pragma mark - delete
//- (void)delete:(FQGroup  *)model
//{
//    NSString *ID = [NSString stringWithFormat:@"%ld", (long)model.ID.row];
//    [_store deleteObjectById:ID fromTable:DB_TABLE_HOME];
//}
//
//+ (void)deleteNameAtIdx:(NSInteger)Idx
//{
//    [self removeKey:@"groupname" AtIdx:Idx];
//}
//
//+ (void)removeKey:(NSString *)key AtIdx:(NSInteger)Idx
//{
//    
//}
//#pragma mark - read
//-(FQGroup *)read:(FQGroup *)model
//{
//    NSString *ID = [NSString stringWithFormat:@"abc%ld", (long)model.ID.row];
//    return (FQGroup *)[self.store getObjectById:ID fromTable:DB_NAME];
//}
//
//-(NSArray *)findAll
//{
//    NSArray *array = [self.store getAllItemsFromTable:DB_TABLE_HOME];
//    return array;
//}
//
//@end
#endif