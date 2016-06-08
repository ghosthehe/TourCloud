//
//  TCHeadlineParaModel.m
//  TourCloud
//
//  Created by pachongshe on 16/6/8.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCHeadlineItem.h"
#import "NSObject+Reflect.h"

@implementation TCHeadlineItem

- (instancetype)parse:(NSDictionary *)info options:(NSUInteger)options
{
    return [self initWithInfos:info];
}

- (instancetype)initWithInfos:(NSDictionary *)info
{
    if (self = [super init]) {
        
        [self ms_reflectDataRecursionFromOtherDictionary:info];
        
    }
    
    return self;
}

@end
