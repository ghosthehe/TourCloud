//
//  TCMainPageParserItem.h
//  TourCloud
//
//  Created by pachongshe on 16/6/6.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "MSParseableObject.h"
#import "MSCellModel.h"
@interface TCMainPageParserItem : MSParseableObject<MSCellModel>

@property (nonatomic, strong) NSString *enddatetime;
@property (nonatomic, strong) NSString *firstpic;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *startdatetime;
@property (nonatomic, strong) NSString *title;


@end
