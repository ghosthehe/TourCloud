//
//  WSNavigationView.h
//  网易新闻
//
//  Created by WackoSix on 15/12/27.
//  Copyright © 2015年 WackoSix. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MSNavigatorViewAligment) {
    MSNavigatorViewAligmentLeft,//靠左
    MSNavigatorViewAligmentAdjust,//仅在不滚动的情况下有效
};

typedef void (^itemClick)(NSInteger selectedIndex);

@protocol MSNavigatorView <NSObject>

@property (assign, nonatomic) NSInteger selectedItemIndex;
@property (strong, nonatomic) NSArray *items;
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

+ (instancetype)navigationViewWithItems:(NSArray<NSString *> *)items itemClick:(itemClick)itemClick;

@end

@interface MSNavigationView : UIView<MSNavigatorView>

@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *borderColor;//边框线颜色

@property (assign, nonatomic) NSInteger selectedItemIndex;

@property (strong, nonatomic) NSArray<NSString *> *items;
@property (assign, nonatomic) MSNavigatorViewAligment aligment;//default is MSNavigatorViewAligmentLeft

+ (instancetype)navigationViewWithItems:(NSArray<NSString *> *)items itemClick:(itemClick)itemClick;

@end
