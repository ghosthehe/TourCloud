//
//  MainPageHotCell.m
//  TourCloud
//
//  Created by pachongshe on 16/6/6.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "MainPageHotCell.h"
#import "TCMainPageParserItem.h"

@implementation MainPageHotCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)update:(id<MSCellModel>)cellModel
{
    if ([cellModel isKindOfClass:[TCMainPageParserItem class]]) {
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
