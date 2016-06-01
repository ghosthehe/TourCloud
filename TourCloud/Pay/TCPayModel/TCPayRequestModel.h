//
//  TCPayRequestModel.h
//  TourCloud
//
//  Created by pachongshe on 16/5/30.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "MSHTTPRequestModel.h"

@interface TCPayRequestModel : MSHTTPRequestModel

//与支付宝签约，获得商户ID（partner）和账号ID（seller)
//商户ID
@property (nonatomic, strong) NSString *partnerId;

//账号ID
@property (nonatomic, strong) NSString *sellerId;

//应用注册scheme,在AlixPayDemo-Info.plist定义URL types
@property (nonatomic, strong) NSString *appScheme;

//RAS私钥
@property (nonatomic, strong) NSString *RSAPrivateKey;

+ (TCPayRequestModel *)sharePayRequestModel;

- (void)postPayRequest;

- (void)jumpToPay:(NSDictionary *)orderDic;


@end
