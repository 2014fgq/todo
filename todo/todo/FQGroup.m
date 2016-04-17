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

#pragma mark - 懒加载
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        //[self setValuesForKeysWithDictionary:dict];
        self.groupname = [dict valueForKey:@"GROUPNAME"];
        self.type = [[dict valueForKey:@"TYPE"] intValue];
        self.todoOK = [[dict valueForKey:@"TODOOK"] intValue];
        self.todoAll = [[dict valueForKey:@"TODOALL"] intValue];
        self.IsFinish = [[dict valueForKey:@"ISFINISH"] intValue];
    }
    return self;
}
+ (instancetype)groupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

#pragma mark - Model to dict
+ (NSDictionary *)DictWithModel:(FQGroup *)model
{
//    NSDictionary* dict = [NSDictionary
//                          dictionaryWithObjects:@[
//                            model.ID,
//                            model.groupname]
//                            //[NSNumber numberWithInteger:model.type],
//                            //[NSNumber numberWithInteger:model.IsFinish],
//                            //[NSNumber numberWithInteger:model.todoOK],
//                            //[NSNumber numberWithInteger:model.todoAll]]
//                          forKeys:@[@"ID",@"GROUPNAME"]];//]@"TYPE", @"ISFINISH", @"TODOOK", @"TODOALL"]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //[dict setValue:model.ID forKey:@"ID"];
    [dict setValue:model.groupname forKey:@"GROUPNAME"];
    [dict setValue:[NSNumber numberWithInteger:model.type] forKey:@"TYPE"];
    [dict setValue:[NSNumber numberWithInteger:model.IsFinish] forKey:@"ISFINISH"];
    [dict setValue:[NSNumber numberWithInteger:model.todoOK] forKey:@"TODOOK"];
    [dict setValue:[NSNumber numberWithInteger:model.todoAll] forKey:@"TODOALL"];
    
    //NSLog(@"%@", dict);
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

- (YTKKeyValueStore *)store
{
    if(!_store)
    {
        _store = [[YTKKeyValueStore alloc] initDBWithName:DB_NAME];
        [_store createTableWithName:DB_TABLE_HOME];
        NSLog(@"%@", _store);
    }
    return _store;
}

#pragma mark - create
- (void)create:(FQGroup *)model
{
    NSString *ID = [NSString stringWithFormat:@"abc%ld", (long)model.ID.row];
    [_store putObject:model withId:ID intoTable:DB_TABLE_HOME];
}
#pragma mark - update
- (void)update:(FQGroup *)model
{
    NSString *ID = [NSString stringWithFormat:@"%ld", (long)model.ID.row];
    [_store putObject:(id)model withId:ID intoTable:DB_TABLE_HOME];
}

#pragma mark - delete
- (void)delete:(FQGroup  *)model
{
    NSString *ID = [NSString stringWithFormat:@"%ld", (long)model.ID.row];
    [_store deleteObjectById:ID fromTable:DB_TABLE_HOME];
}

+ (void)deleteNameAtIdx:(NSInteger)Idx
{
    [self removeKey:@"groupname" AtIdx:Idx];
}

+ (void)removeKey:(NSString *)key AtIdx:(NSInteger)Idx
{
    
}
#pragma mark - read
-(FQGroup *)read:(FQGroup *)model
{
    NSString *ID = [NSString stringWithFormat:@"abc%ld", (long)model.ID.row];
    return (FQGroup *)[self.store getObjectById:ID fromTable:DB_NAME];
}

-(NSArray *)findAll
{
    NSArray *array = [self.store getAllItemsFromTable:DB_TABLE_HOME];
    return array;
}

@end
#endif