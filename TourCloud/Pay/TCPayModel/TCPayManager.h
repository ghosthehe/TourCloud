//
//  TCPayManager.h
//  TourCloud
//
//  Created by pachongshe on 16/5/31.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface TCPayManager : NSObject<WXApiDelegate>

+ (TCPayManager *)sharePayManager;

- (BOOL)handleOpenUrl:(NSURL *)url sourceApplication:(NSString *)sourceApplication;


@end
