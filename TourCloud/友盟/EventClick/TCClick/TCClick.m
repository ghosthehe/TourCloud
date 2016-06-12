//
//  TCClick.m
//  TourCloud
//
//  Created by pachongshe on 16/5/30.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCClick.h"
#import <UMMobClick/MobClick.h>
#import "DefineUntil.h"
#import "MSUIKitCore.h"

static TCClick *click = nil;

@implementation TCClick

+ (TCClick *)shareClick
{
    if (click == nil) {
        click = [[TCClick alloc] init];
    }
    
    return click;
}

- (instancetype)init
{
    if (self = [super init ]) {
        
        [self eventClick];
    }
    
    return self;
}

/**
 *  友盟行为统计注册
 */
- (void)eventClick
{
    //    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = UMappkey;
    UMConfigInstance.channelId = @"";
    UMConfigInstance.ePolicy = BATCH;
    [MobClick startWithConfigure:UMConfigInstance];
    
    [MobClick setAppVersion:MSAppVersion()];
    
}
@end
