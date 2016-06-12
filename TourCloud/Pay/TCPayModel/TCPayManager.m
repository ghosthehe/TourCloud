//
//  TCPayManager.m
//  TourCloud
//
//  Created by pachongshe on 16/5/31.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCPayManager.h"
#import "WXApi.h"
#import "DefineUntil.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UMSocialSnsService.h"

@implementation TCPayManager

+ (TCPayManager *)sharePayManager
{
    static TCPayManager *payManager = nil;
    static dispatch_once_t payOnce;
    dispatch_once(&payOnce, ^{
        payManager = [[self alloc] init];
    });
    
    return payManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [WXApi registerApp:WXAppId withDescription:@"demo 2.0"];

    }

    return self;
}

- (BOOL)handleOpenUrl:(NSURL *)url sourceApplication:(NSString *)sourceApplication
{   
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
        }];
    }
    else
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    //跳转处理
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;

}

- (void)onResp:(BaseResp *)resp {
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = @"发送媒体消息结果";
    }
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:{
                strMsg = @"恭喜您，支付成功!";
                
                //                [MYNotificationCenter postNotificationName:@"weixinPaystatusSuccess" object:nil userInfo:@{@"status":@"success"}];
                
                break;
            }
            case WXErrCodeUserCancel:{
                strMsg = @"已取消支付!";
                //                [MYNotificationCenter postNotificationName:@"weixinPaystatusSuccess" object:nil userInfo:@{@"status":@"cancle"}];
                break;
            }
            default:{
                
                strMsg = [NSString stringWithFormat:@"支付失败 !"];
                //                [MYNotificationCenter postNotificationName:@"weixinPaystatusSuccess" object:nil userInfo:@{@"status":@"cancle"}];
                break;
            }
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

@end
