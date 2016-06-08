//
//  TCHeadlineCell.h
//  TourCloud
//
//  Created by pachongshe on 16/6/8.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCellUpdating.h"
#import "TCHeadlineCellModel.h"

@interface TCHeadlineCell : UITableViewCell<MSCellUpdating>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeAndAccessNum;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (nonatomic, strong) TCHeadlineCellModel *headlineCellModel;

@end
