//
//  TCAccount.h
//  TourCloud
//
//  Created by pachongshe on 16/6/13.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCAccount : NSObject

+ (TCAccount *)shareAccount;

 /***  是否已经登录的标记 */
@property (assign, nonatomic) BOOL isLogin;

@end
