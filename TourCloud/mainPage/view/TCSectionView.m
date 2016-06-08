//
//  TCSectionView.m
//  TourCloud
//
//  Created by pachongshe on 16/6/12.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCSectionView.h"
#import "Masonry.h"

@implementation TCSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(@(0));
            make.left.equalTo(@(10));
            make.width.equalTo(@(120));
            make.bottom.equalTo(@(10));
            
        }];
    }
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
