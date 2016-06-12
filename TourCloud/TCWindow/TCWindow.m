//
//  TCWindow.m
//  TourCloud
//
//  Created by pachongshe on 16/5/27.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCWindow.h"
#import "RDVTabBarController.h"
#import "TCNewViewController.h"
#import "TCAccountTool.h"
#import "TCAccount.h"
#import "DefineUntil.h"
#import "TCNewViewController.h"
#import "TCTabBarController.h"
#import "MSUIKitCore.h"

@implementation TCWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
#pragma mark --- 版本新特性
        /**判断是否是第一次启动*/
        if ([TCAccountTool readUserStatus]) {
            
            [self isSameVersion];
            
        }else{
            
            [TCAccountTool saveFirstRunStatus:@"第一次启动"];
            self.rootViewController = [[TCNewViewController alloc] init];
        }
        
        if ([TCUserDefaults boolForKey:@"loginStatus"]){//是否记住密码
            if ([TCUserDefaults boolForKey:@"hasLogin"]){//是否已经登陆过
                [TCAccount shareAccount].isLogin = YES;
            }
            
        }
    }
    return self;
}

- (void)isSameVersion
{
    
    // 取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:MSAppVersion()];
    
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[MSAppVersion()];
    if ([currentVersion isEqualToString:lastVersion]) {
        // 显示状态栏
        [UIApplication sharedApplication].statusBarHidden = NO;
        self.rootViewController = [[TCTabBarController alloc] init];
        
    } else { // 新版本
        
        self.rootViewController = [[TCNewViewController alloc] init];
        // 存储新版本
        [defaults setObject:currentVersion forKey:MSAppVersion()];
        [defaults synchronize];
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
