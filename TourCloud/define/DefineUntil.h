//
//  DefineUntil.h
//  TourCloud
//
//  Created by pachongshe on 16/5/30.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#ifndef DefineUntil_h
#define DefineUntil_h

#define titlecolor  UIColorFromRGB(0x4c4c4c)
#define leftFont  [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:12.0]

//根视图
#define TCApplication [UIApplication sharedApplication]

// 通知
#define TCNotificationCenter [NSNotificationCenter defaultCenter]

//归档
#define TCUserDefaults [NSUserDefaults standardUserDefaults]

/** 多线程GCD*/
#define TCGlobalGCD(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MYMainGCD(block) dispatch_async(dispatch_get_main_queue(),block)


//项目里面访问AppDelegate做全局变量
#define TCAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

// 颜色
#define TCColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

////颜色和透明度设置
#define RGBA(r,g,b,a)  [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

/**字体*/
#define MYSFont(x) [UIFont systemFontOfSize:x]
#define MYFont(x) [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:x]

#define UMappkey        @"574ba7cbe0f55ac173002c2d"
#define MobAppKey       @"134e99110be22"
#define MobAppSecret    @"87db99a4f2de96fc0ea946af053fd999"
#define WXAppId         @""
#define PartnerID @"2088911581092103"
#define SellerID  @"srdzdzsw@163.com"
#define RSAPrivateKey @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBALFmaZisTQ+ZYZAjJffnkugcGP2Q/Jv7sV5puan0JTAbz1EmvazT6ZNEZB46VmHegJjpeDs4WFCIYpOKj0whAQv9WTtgOJ5Ubz4O4i9T3YYqhvxP0zSCfOv3AT5sEn+0Q69sF5iDVOwdnZfedNc64nTDmdQ4b4gI3FVlgdAQPCX7AgMBAAECgYEAjS6hKWUu6xQ5hhnC9Nmym9EIvnxt3cHgte/UWAK6ud/YDZCUcYAxKwfJ2hi5eKg4lflwu0irWGRCd4NVadP2XPx0phpZbxebYSIYCBMOpMSvOEVq0gr4jTidZuIKhoRS0vYRLJvIBYKcR19JhQzDou4mqgbN8JE+38xe3PVEIhkCQQDrugBeEoThWVC8bgvH+DwtZ4Pb89OQNtJhQbZDpRkN92WJU5SEn3aijJxYM2bV3jhriamOLN6tEAb8/nFXkYQFAkEAwKg8AnreJdUPj0zvjsm64cn1hY+9bcXCBBKrn3DWw8e9XindEVop9EqhTY+U7iZfyFx1sgA5+X5KEDDTg0Eh/wJBAMOvvEBb9U2xvJFAda1CyIoUxeThS/8LU6iDSZBsTRlICFVxOfjC/FRCkEO0IClo+cNkG4q4ev6GMJbzjxnX5hUCQA5lQ76nsavABN6fUBMqTbWLYrYtLGlkan/laT+LrfCJH0RG+obOZu4jGXRzMxysb2HITt8TF0HmRuB41YUsO78CQQCkaKzLAgHTI1V6qrDqD5wDNvjqIyE5QLxYgvm1sawOR0HgHTQPXyZRsreVorL6CLvCd7CWJCBG1X7s9Y96rcD9"

#define GaodeMapKey @"7ed34eeb8e5daf22c1a7e69365245d01"

#endif /* DefineUntil_h */
