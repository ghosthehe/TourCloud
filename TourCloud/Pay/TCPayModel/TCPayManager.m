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
        [WXApi registerApp:WXAppId];

    }

    return self;
}

- (BOOL)handleOpenUrl:(NSURL *)url
{   
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSString *message = @"";
            switch([[resultDic objectForKey:@"resultStatus"] integerValue])
            {
                case 9000:message = @"订单支付成功";break;
                case 8000:message = @"正在处理中";break;
                case 4000:message = @"订单支付失败";break;
                case 6001:message = @"用户中途取消";break;
                case 6002:message = @"网络连接错误";break;
                default:message = @"未知错误";
            }
            
            UIAlertController *aalert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            [aalert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
            UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
            [root presentViewController:aalert animated:YES completion:nil];
            
            NSLog(@"result = %@",resultDic);
        }];
    }
    else
    {
        return  [[TCPayManager sharePayManager] handleOpenUrl:url];;
    }
    return YES;
}

@end
