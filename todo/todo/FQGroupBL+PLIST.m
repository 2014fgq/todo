//
//  FQGroup+PLIST.m
//  todo
//
//  Created by IMAC on 16/3/17.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import "FQGroupBL+PLIST.h"

@interface FQGroupBL ()
#define TODO_PLIST @"todo.plist"
- (NSString *)applicationDocumentsDirectoryFile;
- (void)createEditableCopyOfDatabaseIfNeeded;
@end

@implementation FQGroupBL
static FQGroupBL *sharedManager = nil;
+ (instancetype)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
        [sharedManager createEditableCopyOfDatabaseIfNeeded];
    });
    CHECK_NULLPOINTER(sharedManager)
    return sharedManager;
}
//插入方法
- (BOOL)insertwithmodel:(FQGroup *)model atIdx:(NSInteger)Idx
{
    CHECK_NULLPOINTER(model)
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    NSDictionary* dict = [FQGroup DictWithModel:model];
    
    [array insertObject:dict atIndex:Idx];
    
    return [array writeToFile:path atomically:YES];
}

//更新方法
- (BOOL)replacewithmodel:(FQGroup *)model atIdx:(NSInteger)Idx
{
    CHECK_NULLPOINTER(model)
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    NSDictionary *dict = [FQGroup DictWithModel:model];
    [array replaceObjectAtIndex:Idx withObject:dict];
    return [array writeToFile:path atomically:YES];
}

//删除方法
- (BOOL)remove:(FQGroup *)model atIdx:(NSInteger)Idx
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
        FQGroup* group = [FQGroup groupWithDict:dict];
        [listData addObject:group];
    }
    return listData;
}

//按照主键查询数据方法
-(FQGroup*) findById:(FQGroup*)model
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    for (NSDictionary* dict in array) {
        FQGroup *group = [FQGroup groupWithDict:dict];
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
    for (FQGroup *group in array) {
        NSDictionary *dict = [FQGroup DictWithModel:group];
        [mutablearray addObject:dict];
    }
    return [mutablearray writeToFile:path atomically:YES];
}


//判断是否需要创建初值
- (void)createEditableCopyOfDatabaseIfNeeded {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
    
    //判断是否存在writableDBPath文件
    BOOL dbexits = [fileManager fileExistsAtPath:writableDBPath];
    
    //[self reloaddata];//test，测试方法，重新加载测试数据
    
    //回读数据
    if(dbexits)
    {
        NSArray *_array = [NSArray arrayWithContentsOfFile:writableDBPath];
        NSLog(@"readData from %@ is:\n%@", writableDBPath, _array);
    }
    if (!dbexits) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:TODO_PLIST];
        
        NSError *error;
        BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
            NSArray *array = [FQGroup GroupsWithDefaultRows];
            NSMutableArray *mutablearray = [NSMutableArray array];
            for (FQGroup *group in array) {
                NSDictionary *dict = [FQGroup DictWithModel:group];
                [mutablearray addObject:dict];
            }
            success = [mutablearray writeToFile:writableDBPath atomically:YES];
            NSArray *_array = [NSArray arrayWithContentsOfFile:writableDBPath];
            NSLog(@"[%d]%@", success, _array);
            //if (!success) {
                //NSAssert1(0, @"错误写入文件：'%@'。", [error localizedDescription]);
            //}
        }
    }
}

- (NSString *)applicationDocumentsDirectoryFile {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:TODO_PLIST];
    
    return path;
}

#pragma mark - just for test
- (BOOL) reloaddata
{
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
    NSArray *array = [FQGroup GroupsWithDefaultRows];
    NSMutableArray *mutablearray = [NSMutableArray array];
    for (FQGroup *group in array) {
        NSDictionary *dict = [FQGroup DictWithModel:group];
        [mutablearray addObject:dict];
    }
    return [mutablearray writeToFile:writableDBPath atomically:YES];
}
@end
