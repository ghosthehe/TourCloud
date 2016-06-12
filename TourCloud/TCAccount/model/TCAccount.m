//
//  TCAccount.m
//  TourCloud
//
//  Created by pachongshe on 16/6/13.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCAccount.h"
#import "NSObject+MJCoding.h"

@implementation TCAccount

+ (TCAccount *)shareAccount
{
    static TCAccount *acconnt;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        acconnt = [[self alloc] init];
    });
    
    return acconnt;
}

MJCodingImplementation

@end
