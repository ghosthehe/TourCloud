//
//  TCPayRequestModel.m
//  TourCloud
//
//  Created by pachongshe on 16/5/30.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCPayRequestModel.h"
#import "WXApi.h"
#import "TCUrlDefineUntil.h"
#import "MSHTTPResponse.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DefineUntil.h"

static TCPayRequestModel *payRequestModel = nil;

@implementation TCPayRequestModel

+ (TCPayRequestModel *)sharePayRequestModel
{
    if (!payRequestModel) {
        payRequestModel = [[TCPayRequestModel alloc] init];
    }
    
    return payRequestModel;
}

#pragma mark --微信支付
- (void)postPayRequest
{
    if (![WXApi isWXAppInstalled]) {
        NSLog(@"没有安装微信");
        return;
    }else if (![WXApi isWXAppSupportApi]){
        NSLog(@"不支持微信支付");
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    params setObject:<#(nonnull id)#> forKey:<#(nonnull id<NSCopying>)#>
    [self POST:WXUrl param:params block:^(MSHTTPResponse *response, NSURLSessionTask *task, BOOL success) {
       
        if (success) {
            
            NSDictionary *dict = response.originData;
            
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                
            }else{
                NSLog(@"%@",[dict objectForKey:@"retmsg"]);
            }
        }
        //客户端提示信息
       
    }];
}

#pragma makr --支付宝支付
- (void)jumpToPay:(NSDictionary *)orderDic
{
    
    Order *order = [self genOrder:orderDic];
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(RSAPrivateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:self.appScheme callback:^(NSDictionary *resultDic) {
            
            NSString * strTitle = [NSString stringWithFormat:@"支付结果"];
            NSString *strMsg;
            
            //【callback处理支付结果】
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                
                strMsg = @"恭喜您，支付成功!";
                //
                //                for (UIViewController *controller in self.navigationController.viewControllers) {
                //
                //                    if([self.PayPath isEqualToString:@"1"]){
                //
                //                        if ([controller isKindOfClass:[MYOrderViewController class]]) {
                //
                //                            [self.navigationController popToViewController:controller animated:YES];
                //                        }
                //
                //                    }else{
                //                        if ([controller isKindOfClass:[MYHomeHospitalDeatilViewController class]]) {
                //
                //                            [self.navigationController popToViewController:controller animated:YES];
                //                        }
                //                    }
                //                }
                
//                MYQuickPaySuccessViewController *PaySuccessVc = [[MYQuickPaySuccessViewController alloc]init];
//                PaySuccessVc.PayPath = self.PayPath;
//                
//                [self.navigationController pushViewController:PaySuccessVc animated:YES];
                
                
                
                
                
            }else if([resultDic[@"resultStatus"] isEqualToString:@"6001"])
            {
                strMsg = @"已取消支付!";
                
            }else{
                
                strMsg = @"支付失败!";
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
        }];
    }
}


- (Order *)genOrder:(NSDictionary *)orderDic {
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    //使用私钥进行签名
    //生成点单
    Order *order = [[Order alloc]init];
    //合作者身份(PID)
    order.partner =PartnerID;
    //商家支付宝账号
    order.seller = SellerID;
    //订单ID
    order.tradeNO = [self generateTradeNO];
    order.productName = @"商品名称";
    order.productDescription = @"商品描述";
    //商品价格
    order.amount =@"0.01";
    //回调URL
    order.notifyURL = @"http://www.baidu.com";
    //Bundle ID
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    //编码格式
    order.inputCharset = @"utf-8";
    //订单超时时间
    order.itBPay = @"30m";
    
    self.appScheme = @"alisdkdemo";
//    NSString *orderSpec = [order description];
    
    
    return order;
}

- (NSString *)returnErrorMessage:(NSInteger)status {
    NSDictionary *errorDic = [self errrorMessage];
    NSString *message = @"";
    switch(status)
    {
        case 9000:message = errorDic[@9000];break;
        case 8000:message = errorDic[@8000];break;
        case 4000:message = errorDic[@4000];break;
        case 6001:message = errorDic[@6001];break;
        case 6002:message = errorDic[@6002];break;
        default:message = @"未知错误";
    }
    return message;
}

- (NSDictionary *)errrorMessage {
    return @{@9000: @"订单支付成功",
             @8000: @"正在处理中",
             @4000: @"订单支付失败",
             @6001: @"用户中途取消",
             @6002: @"网络连接出错"};
}

#pragma mark----生成订单号
- (NSString*)generateTradeNO{
    NSString *soureString = @"0123456789ABCDEFGHIGKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [[NSMutableString alloc]init];
    for (NSInteger i = 0; i < 15; i++) {
        NSInteger index = arc4random()%(soureString.length);
        NSString *charactor = [soureString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:charactor];
    }
    return result;
}

- (NSDictionary *)separated:(NSString *)string byString:(NSString *)byString{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *aa = string;
    NSArray *aaArray = [aa componentsSeparatedByString:byString];
    for (NSString *bb in aaArray) {
        NSArray *bbArray = [bb componentsSeparatedByString:@"="];
        if (bbArray && bbArray.count == 2) {
            [dic setValue:bbArray[1] forKey:bbArray[0]];
        }
    }
    return dic;
}


@end
