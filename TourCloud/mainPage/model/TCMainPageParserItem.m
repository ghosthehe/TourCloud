//
//  TCMainPageParserItem.m
//  TourCloud
//
//  Created by pachongshe on 16/6/6.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCMainPageParserItem.h"
#import "NSObject+reflect.h"
#import "MainPageHotCell.h"

@implementation TCMainPageParserItem

@synthesize Class;
@synthesize isRegisterByClass;
@synthesize reuseIdentify;
@synthesize height;

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

- (instancetype)init
{
    if (self = [super init]) {
        
        self.Class = [MainPageHotCell class];
        self.height = 217;
        self.reuseIdentify = @"MainPageHotCell";
        self.isRegisterByClass = NO;
    }
    
    return self;
}

@end
