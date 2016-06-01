//
//  TCPayParseModel.m
//  TourCloud
//
//  Created by pachongshe on 16/5/31.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCPayParseModel.h"

@implementation TCPayParseModel

//@synthesize height;
//@synthesize Class;
//@synthesize reuseIdentify;
//@synthesize isRegisterByClass;

- (instancetype)initWithDictionry:(NSDictionary *)dictionry
{
    if (self = [super init]) {
        
        [self ms_reflectDataFromOtherDictionary:dictionry];
    }
    
    return self;
}

- (instancetype)parse:(NSDictionary *)info options:(NSUInteger)options
{
    
    return [self initWithDictionry:info];
}

@end
