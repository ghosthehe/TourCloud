//
//  TCPayController.m
//  TourCloud
//
//  Created by pachongshe on 16/5/30.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCPayController.h"

#define textfont  [UIFont systemFontOfSize:14]
#define textcolor  MYColor(80, 80, 80)
#define  alap 0.2

#import "WXApi.h"
#import "WXApiObject.h"

#import "masonry.h"
#import "MSUIKitCore.h"
#import "TCUrlDefineUntil.h"
#import "TCPayRequestModel.h"

@implementation TCPayController

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"支付";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [self addtopview];
    [self addboomview];
    
}
//上面视图
-(void)addtopview
{
    
}

-(void)addboomview
{
    
    UIButton *pay = [[UIButton alloc]init];
    [pay setTitle:@"微信支付" forState:UIControlStateNormal];
    pay.titleLabel.textAlignment = NSTextAlignmentRight;
    [pay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //view1.titleLabel.font = leftFont;
    [pay addTarget:self action:@selector(weixinzhifuBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pay];
    
    [pay mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(100));
        make.left.equalTo(@(50));
        make.width.equalTo(@(80));
        
    }];
    
    
    UIButton *canclePay = [[UIButton alloc]init];
    [canclePay setTitle:@"微信支付取消" forState:UIControlStateNormal];
    canclePay.titleLabel.textAlignment = NSTextAlignmentCenter;
    [canclePay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //canclePay.titleLabel.font = leftFont;
    [canclePay addTarget:self action:@selector(weixinquxiaoBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:canclePay];
    
    [canclePay mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(100));
        make.left.equalTo(@(150));
        make.right.equalTo(@(-50));
    }];
    
    
    UIButton *apliPay = [[UIButton alloc]init];
    [apliPay setTitle:@"aplipay支付" forState:UIControlStateNormal];
    apliPay.titleLabel.textAlignment = NSTextAlignmentRight;
    [apliPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //view1.titleLabel.font = leftFont;
    [apliPay addTarget:self action:@selector(apliPay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:apliPay];
    
    [apliPay mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(200));
        make.left.equalTo(@(20));
        make.width.equalTo(@(110));
        
    }];
    
    
    UIButton *cancleapliPay = [[UIButton alloc]init];
    [cancleapliPay setTitle:@"aplipay支付取消" forState:UIControlStateNormal];
    cancleapliPay.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancleapliPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //canclePay.titleLabel.font = leftFont;
    [cancleapliPay addTarget:self action:@selector(cancleapliPay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancleapliPay];
    
    [cancleapliPay mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(200));
        make.left.equalTo(@(150));
        make.right.equalTo(@(-20));
    }];


    
}

/**
 *  支付宝支付
 */
- (void)apliPay
{
    [[TCPayRequestModel sharePayRequestModel] jumpToPay:nil];;
}

- (void)cancleapliPay
{
    
}

//微信支付取消
-(void)weixinquxiaoBtn
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

/**
 *  微信支付
 */
-(void)weixinzhifuBtn
{
    [[TCPayRequestModel sharePayRequestModel] postPayRequest];;
}

@end
