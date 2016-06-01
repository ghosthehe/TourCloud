//
//  TCMessageManager.h
//  TourCloud
//
//  Created by pachongshe on 16/5/30.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCMessageManager : NSObject

+ (TCMessageManager *)shareMessageManager;

- (void)getOptions:(NSDictionary *)launchOptions;

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

@end
