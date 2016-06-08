//
//  TCHeanlineCellModel.h
//  TourCloud
//
//  Created by pachongshe on 16/6/8.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "MSCellModel.h"
#import "TCHeadlineItem.h"

@interface TCHeadlineCellModel : MSCellModel

@property (nonatomic, strong) TCHeadlineItem *item;
@property (nonatomic, strong) NSAttributedString *title;
@property (nonatomic, strong) NSAttributedString *timeAndAccessNum;

@end
