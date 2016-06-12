//
//  TCShareManager.m
//  TourCloud
//
//  Created by pachongshe on 16/5/30.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCShareManager.h"

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
#import "DefineUntil.h"

//友盟
#import "UMSocialData.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialConfig.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"

@implementation TCShareManager

+ (TCShareManager *)shareManager
{
    static TCShareManager *shareManager = nil;
    dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc]init];
    });
    return shareManager;
    
}

- (instancetype)init
{
    if (self = [super init]) {
        [self socialShare];
    }
    
    return self;
}

- (void)socialShare
{
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UMappkey];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wxee3be451dbc68260" appSecret:@"e54139728a2da020eee38ba397f8c584" url:@"http://www.umeng.com/social"];
    
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3921700954"
                                              secret:@"04b48b094faeb16683c32669824ebdad"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQQ, UMShareToSina]];
    
    
    
}

@end
