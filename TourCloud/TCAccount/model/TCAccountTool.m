//
//  TCAccountTool.m
//  TourCloud
//
//  Created by pachongshe on 16/6/13.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCAccountTool.h"
#import "TCAccount.h"
#import "TCNewViewController.h"
#import "TCTabBarController.h"
#import "DefineUntil.h"
#import "AppDelegate.h"

#define kUserInfoPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.data"]

#define kUserStatusPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userStatus.data"]


@implementation TCAccountTool

#pragma mark --- 存储 与 读取用户信息
+ (void)save:(TCAccount *)userInfo
{
    [NSKeyedArchiver archiveRootObject:userInfo toFile:kUserInfoPath];
    
}

+ (TCAccount *)userInfo
{
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:kUserInfoPath];
}

#pragma mark --- 记住用户登录状态
+ (void)saveFirstRunStatus:(NSString *)userStatus
{
    [NSKeyedArchiver archiveRootObject:userStatus toFile:kUserStatusPath];
}

+ (BOOL)readUserStatus
{
    BOOL status = [NSKeyedUnarchiver unarchiveObjectWithFile:kUserStatusPath];
    
    return  status;
    
}

@end
