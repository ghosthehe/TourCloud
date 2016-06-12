//
//  TCAccountTool.h
//  TourCloud
//
//  Created by pachongshe on 16/6/13.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCWindow.h"

@class TCAccount;
@interface TCAccountTool : NSObject

+ (void)save:(TCAccount *)userInfo;
+ (TCAccount *)userInfo;

/** 记住用户登录状态 */
+ (void)saveFirstRunStatus:(NSString *)userStatus;
+ (BOOL)readUserStatus;

@end
