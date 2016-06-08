//
//  TCMainPageCellModel.h
//  TourCloud
//
//  Created by pachongshe on 16/6/6.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSCellModel.h"
#import "TCMainPageParserItem.h"

@interface TCMainPageCellModel : NSObject<MSCellModel>

@property (nonatomic, strong) TCMainPageParserItem *item;
@property (nonatomic, strong) NSMutableArray *items;

@end
