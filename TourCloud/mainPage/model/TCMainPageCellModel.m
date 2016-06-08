//
//  TCMainPageCellModel.m
//  TourCloud
//
//  Created by pachongshe on 16/6/6.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCMainPageCellModel.h"
#import "MainPageNewActionCell.h"

@implementation TCMainPageCellModel
@synthesize height;
@synthesize Class;
@synthesize reuseIdentify;
@synthesize isRegisterByClass;

- (void)parseItem:(id)item
{
    _item = item;
    
    self.height = 170;
    self.Class = [MainPageNewActionCell class];
    self.isRegisterByClass = NO;
    self.reuseIdentify = @"MainPageNewActionCell";
    
}

@end
