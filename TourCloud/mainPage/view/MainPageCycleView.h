//
//  MainPageCycleView.h
//  TourCloud
//
//  Created by pachongshe on 16/6/6.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainPageCycleViewDelegate <NSObject>

- (void)headLineBtnClick;

- (void)telBtnClick;

@end

@interface MainPageCycleView : UIView


@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) NSArray *slideBtns;


@end
