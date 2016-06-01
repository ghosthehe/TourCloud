//
//  EMCycleCollectionViewCell.m
//  EMCycleCollectionView
//
//  Created by Lyy on 15/10/26.
//  Copyright © 2015年 emoney. All rights reserved.
//

#import "EMCycleCollectionViewCell.h"
#import "EMCycleItem.h"
#import "UIImageView+WebCache.h"

@interface EMCycleCollectionViewCell ()
{
     UIImageView *_imageView;
}
@end

@implementation EMCycleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
    }
    
    return self;
}

- (void)update:(id<MSCollectionCellModel>)cellModel {
//    EMCycleItem *cycleItem = (EMCycleItem *)cellModel;
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:cycleItem.imageUrl] placeholderImage:nil];
}

- (void)setupImageView
{
//    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
//    _imageView.contentMode = UIViewContentModeScaleAspectFill;
//    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    _imageView.clipsToBounds = YES;
//    [self addSubview:_imageView];
}

@end
