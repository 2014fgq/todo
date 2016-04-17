//
//  FQTodo.m
//  todo
//
//  Created by IMAC on 16/3/12.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import "FQTodo.h"

@implementation FQTodo
#pragma mark - 懒加载
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)TodoWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSMutableDictionary *)DictWithModel:(FQTodo *)model
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:model.groupname forKey:@"groupname"];
    [dict setValue:[NSNumber numberWithInteger:model.type] forKey:@"type"];
    [dict setValue:[NSNumber numberWithInteger:model.IsFinish] forKey:@"IsFinish"];
    return dict;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"ID"]) {
        NSLog(@"ignore the key %@" , key);
    }
}
@end

