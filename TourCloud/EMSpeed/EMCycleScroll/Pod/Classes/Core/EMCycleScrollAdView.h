//
//  EMCycleScrollView.h
//  Pods
//
//  Created by xoHome on 15/11/3.
//
//

#import "MSHorizontalCollectionView.h"

@class EMCycleScrollAdView;

@protocol EMCycleScrollAdViewDelegate <NSObject, UICollectionViewDelegate, MSHorizontalCollectionViewDelegate>

@optional
- (void)cycleScrollView:(EMCycleScrollAdView *)scrollView didSelectItem:(id<MSCollectionCellModel>)item;

/**
 *  当前显示页面的下标
 *
 *  @param scrollView EMCycleScrollAdView
 *  @param index      当前will显示页面的下标
 */
- (void)cycleScrollView:(EMCycleScrollAdView *)scrollView willChangeToIndex:(NSInteger)index;

@end

@interface EMCycleScrollAdView : MSHorizontalCollectionView

/**
 *
 *  @param frame           frame
 *  @param isInfiniteCycle 是否支持无限循环滚动
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
                infiniteCycle:(BOOL)isInfiniteCycle;

@property (nonatomic, assign, getter=isInfiniteCycle) BOOL infiniteCycle; //是否是循环滚动

@property (nonatomic ,weak) id<EMCycleScrollAdViewDelegate>delegate;

/**
 *  是否自动循环滚动，默认为NO
 */
@property (nonatomic ,assign) BOOL isAutoCycleScroll;

/**
 *  滚动间隔时间 ，默认是5s
 */
@property (nonatomic ,assign) NSTimeInterval autoScrollInterval;

@end
