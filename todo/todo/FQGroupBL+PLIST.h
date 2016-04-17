//
//  FQGroup+PLIST.h
//  todo
//
//  Created by IMAC on 16/3/17.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FQGroup.h"
#import "Header.h"
@class FQGroup;

@interface FQGroupBL : NSObject 
- (BOOL)remove:(FQGroup *)model atIdx:(NSInteger)Idx;
- (BOOL)insertwithmodel:(FQGroup *)model atIdx:(NSInteger)Idx;
- (BOOL)replacewithmodel:(FQGroup *)model atIdx:(NSInteger)Idx;
- (BOOL)writewithArray:(NSArray *)array;
-(NSMutableArray *)findAll;

+ (instancetype)sharedManager;
@end

//@interface FQGroupBL: NSObject
//@property (strong, nonatomic) YTKKeyValueStore *store;
//+ (FQGroupBL *)sharedManager;
//- (void)create:(FQGroup *)model;
//- (void)update:(FQGroup *)model;
//- (void)read:(FQGroup *)model;
//- (void)delete:(FQGroup *)model;
//-(NSArray *)findAll;
//@end