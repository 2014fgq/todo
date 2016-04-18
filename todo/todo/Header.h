//
//  Header.h
//  todo
//
//  Created by IMAC on 16/3/19.
//  Copyright © 2016年 IMAC. All rights reserved.
//

#ifndef Header_h
#define Header_h

#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s-%@", __func__, [self class]);
#define debug(...)    NSLog(@"%s"__VA_ARGS__, __func__)
#define debugfunc(...)    NSLog(@"%s", __func__, __VA_ARGS__)
#define debugframe(view) debugLog(@"%@", NSStringFromCGRect(view.frame));
#else
#define debugLog(...)
#define debugMethod()
#endif

#define EMPTY_STRING        @""

#define STR(key)            NSLocalizedString(key, nil)

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

// UIConstants provides contants variables for UI control.
#define UI_NAVIGATION_BAR_HEIGHT    44
#define UI_TAB_BAR_HEIGHT           49
#define UI_STATUS_BAR_HEIGHT        20
#define UI_SCREEN_WIDTH             ([[UIScreen mainScreen] bounds].size.weight)
#define UI_SCREEN_HEIGHT            ([[UIScreen mainScreen] bounds].size.height)

#define UI_LABEL_LENGTH             200
#define UI_LABEL_HEIGHT             15
#define UI_LABEL_FONT_SIZE          12
#define UI_LABEL_FONT               [UIFont systemFontOfSize:UI_LABEL_FONT_SIZE]



/*
 *  System Versioning Preprocessor Macros
 */
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenBounds [UIScreen mainScreen].bounds
/*
 Usage sample:
 
 if (SYSTEM_VERSION_LESS_THAN(@"4.0")) {
 ...
 }
 
 if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"3.1.1")) {
 ...
 }
 
 */

#define  CHECK_NULLPOINTER(pointer) \
    if(!pointer)\
    {\
        NSLog(@"[%s]%s is null!", __func__, #pointer);\
    }

#define FQTODO_PANHEIGHT 80


#define FQTODO_NAVIGCOLOR 0x222e3b
#define COMMITING_CREATE_CELL_HEIGHT 60
#define NORMAL_CELL_FINISHING_HEIGHT 60


#define NOTI_LASTDATA @"UpdateLatestData"
#define NOTI_NEWDETAILWHENDISPLAY @"NewDetailIsDisplay"
#endif /* Header_h */
