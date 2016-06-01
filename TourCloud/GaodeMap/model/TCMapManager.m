//
//  TCMapManager.m
//  TourCloud
//
//  Created by pachongshe on 16/6/2.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCMapManager.h"
#import "DefineUntil.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapServices.h>

@implementation TCMapManager

+ (TCMapManager *)shareMapManger
{
    static TCMapManager *mapManager = nil;
    dispatch_once_t mapOnce;
    dispatch_once(&mapOnce, ^{
        mapManager = [[self alloc] init];
    });
    
    return mapManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        if ([GaodeMapKey length] == 0)
        {
#define kMALogTitle @"提示"
#define kMALogContent @"apiKey为空，请检查key是否正确设置"
            
            NSString *log = [NSString stringWithFormat:@"[MAMapKit] %@", kMALogContent];
            NSLog(@"%@", log);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMALogTitle message:kMALogContent delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
            });
        }

        [AMapServices sharedServices].apiKey = GaodeMapKey;
        
    }
    
    return self;
}

@end
