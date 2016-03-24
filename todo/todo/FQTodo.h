//
//  FQTodo.h
//  todo
//
//  Created by IMAC on 16/3/12.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FQTodo : NSObject
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)TodoWithDict:(NSDictionary *)dict;
@end
