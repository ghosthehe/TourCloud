//
//  TCHeadlineRequestModel.h
//  TourCloud
//
//  Created by pachongshe on 16/6/8.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "BaseTableModel.h"

@interface TCHeadlineRequestModel : BaseTableModel

@property (nonatomic, strong) NSArray *headlineItems;

- (void)getHeadlineData;


@end
