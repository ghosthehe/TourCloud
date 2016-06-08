//
//  MainPageNewActionCell.m
//  TourCloud
//
//  Created by pachongshe on 16/6/6.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "MainPageNewActionCell.h"
#import "TCMainPageCellModel.h"
#import "UIImageView+DownloadIcon.h"

@implementation MainPageNewActionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)update:(id<MSCellModel>)cellModel
{
    if ([cellModel isKindOfClass:[TCMainPageCellModel class]]) {
        
        TCMainPageCellModel *model = (TCMainPageCellModel *)cellModel;
        [self.titleImageView ms_setImageWithURL:[NSURL URLWithString:model.item.firstpic] localCache:YES];
        
        self.titleLabel.text = model.item.title;
        self.dateLabel.text = model.item.name;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
