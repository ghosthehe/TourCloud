//
//  MainPageNewActionCell.h
//  TourCloud
//
//  Created by pachongshe on 16/6/6.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCellUpdating.h"

@interface MainPageNewActionCell : UITableViewCell<MSCellUpdating>

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
