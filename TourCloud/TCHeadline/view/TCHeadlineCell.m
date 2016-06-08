//
//  TCHeadlineCell.m
//  TourCloud
//
//  Created by pachongshe on 16/6/8.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCHeadlineCell.h"
#import "UIImageView+DownloadIcon.h"

@implementation TCHeadlineCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)update:(id<MSCellModel>)cellModel
{
    if ([cellModel isKindOfClass:[TCHeadlineCellModel class]]) {
        
        self.headlineCellModel = (TCHeadlineCellModel *)cellModel;
        self.titleLabel.attributedText = self.headlineCellModel.title;
        [self.titleImageView ms_setImageWithURL:[NSURL URLWithString:self.headlineCellModel.item.firstpic] localCache:YES];
        self.timeAndAccessNum.attributedText = self.headlineCellModel.timeAndAccessNum;
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
