//
//  EMCycleItem.m
//  EMCycleCollectionView
//
//  Created by Lyy on 15/10/27.
//  Copyright (c) 2015年 emoney. All rights reserved.
//

#import "EMCycleItem.h"
#import "EMCycleCollectionViewCell.h"
#import "MSCoreMetrics.h"

@implementation EMCycleItem

@synthesize layoutSize;
@synthesize Class;
@synthesize reuseIdentify;
@synthesize isRegisterByClass;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isRegisterByClass = YES;
        self.Class = [EMCycleCollectionViewCell class];
        self.reuseIdentify = @"EMCycleCollectionViewCell";
        self.layoutSize = CGSizeMake(MSScreenWidth(), 0);
    }
    return self;
}

@end
