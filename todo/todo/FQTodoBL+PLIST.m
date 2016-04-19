//
//  FQTodoBL+PLIST.m
//  todo
//
//  Created by IMAC on 16/4/17.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import "FQTodoBL+PLIST.h"
@interface FQTodoBL ()
- (NSString *)applicationDocumentsDirectoryFile;
@end


@implementation FQTodoBL
#define TODO_PLIST @"todo.plist"
static FQTodoBL *sharedManager = nil;
+ (instancetype)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    CHECK_NULLPOINTER(sharedManager);
    return sharedManager;
}
//插入方法
- (BOOL)insertwithmodel:(FQTodo *)model atIdx:(NSInteger)Idx
{
    CHECK_NULLPOINTER(model)
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    NSDictionary* dict = [FQTodo DictWithModel:model];
    
    [array insertObject:dict atIndex:Idx];
    
    return [array writeToFile:path atomically:YES];
}

//更新方法
- (BOOL)replacewithmodel:(FQTodo *)model atIdx:(NSInteger)Idx
{
    CHECK_NULLPOINTER(model)
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    NSDictionary *dict = [FQTodo DictWithModel:model];
    [array replaceObjectAtIndex:Idx withObject:dict];
    return [array writeToFile:path atomically:YES];
}

//删除方法
- (BOOL)remove:(FQTodo *)model atIdx:(NSInteger)Idx
{
    CHECK_NULLPOINTER(model)
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    [array removeObjectAtIndex:Idx];
    return [array writeToFile:path atomically:YES];
}

//查找所有
-(NSMutableArray *)findAll
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    for (NSDictionary* dict in array) {
        FQTodo* group = [FQTodo TodoWithDict:dict];
        [listData addObject:group];
    }
    return listData;
}

//按照主键查询数据方法
-(FQTodo*) findById:(FQTodo*)model
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    for (NSDictionary* dict in array) {
        FQTodo *group = [FQTodo TodoWithDict:dict];
        //比较ID主键是否相等
        if ([group.ID isEqual:model.ID]){
            return group;
        }
    }
    return nil;
}
//根据数组将所有的东西写入plist
- (BOOL)writewithArray:(NSArray *)array
{
    CHECK_NULLPOINTER(array)
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *mutablearray = [NSMutableArray array];
    for (FQTodo *group in array) {
        NSDictionary *dict = [FQTodo DictWithModel:group];
        [mutablearray addObject:dict];
    }
    return [mutablearray writeToFile:path atomically:YES];
}

- (NSString *)applicationDocumentsDirectoryFile {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:TODO_PLIST];
    
    return path;
}
@end
