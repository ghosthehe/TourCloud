//
//  EMCycleItem.h
//  EMCycleCollectionView
//
//  Created by Lyy on 15/10/27.
//  Copyright (c) 2015年 emoney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSCollectionCellModel.h"

@interface EMCycleItem : NSObject<MSCollectionCellModel>

@property (nonatomic,strong) NSString *title;       // 标题
@property (nonatomic,strong) NSString *imageUrl;    // image url
@property (nonatomic,strong) NSString *url;         // 跳转url

@end
