//
//  TCPayParseModel.h
//  TourCloud
//
//  Created by pachongshe on 16/5/31.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "MSParseableObject.h"
#import "MSCellModel.h"
#import "NSObject+reflect.h"

@interface TCPayParseModel : MSParseableObject//<MSCellModel>

@property(strong,nonatomic) NSString * oderName;

@property(strong,nonatomic) NSString * oderPrice;

@property(strong,nonatomic) NSString * shangpingname;

@property(strong,nonatomic) NSString * shangpindeatil;

@property(strong,nonatomic) NSString * preice;

@property(strong,nonatomic) NSString * dingdanhao;


@property(strong,nonatomic) NSString * appId;       //appid

@property(strong,nonatomic) NSString * mchId;

@property(strong,nonatomic) NSString *  sign ;

@property(strong,nonatomic) NSString * oderid; //订单号

@property(strong,nonatomic) NSString * PayPath; // 用来支付后回跳判断标示

@end
