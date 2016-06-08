//
//  MainPageHotCell.h
//  TourCloud
//
//  Created by pachongshe on 16/6/6.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCellUpdating.h"

@interface MainPageHotCell : UITableViewCell<MSCellUpdating>
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;
@property (weak, nonatomic) IBOutlet UILabel *hotTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotSubTitleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *typesCollection;

@end
