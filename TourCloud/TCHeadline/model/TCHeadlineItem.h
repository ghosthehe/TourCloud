//
//  TCHeadlineParaModel.h
//  TourCloud
//
//  Created by pachongshe on 16/6/8.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "MSParseableObject.h"

@interface TCHeadlineItem : MSParseableObject

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *firstpic;
@property (nonatomic, strong) NSString *lastupdateddatetime;
@property (nonatomic, assign) NSInteger newsid;
@property (nonatomic, strong) NSString *newstitle;
@property (nonatomic, strong) NSString *organizer;
@property (nonatomic, assign) NSInteger scannum;

@end
