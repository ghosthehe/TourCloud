//
//  ViewController.h
//  ScrollView2010Demo
//
//  Created by Chen Weigang on 12-7-3.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSViewController.h"

@protocol MSMultiPagingProtocol;
@class MSMultiPagingBaseController;

static const NSInteger kMultiPageControllerLoopSize;
static const NSInteger kMultiPageControllerLoopSizeMax;


@protocol EMMultiPagingDataSource <NSObject>

@required

- (NSArray *)titlesOfPages;
- (int)numberOfPages;
- (UIViewController <MSMultiPagingProtocol> *)multiPagingController:(MSMultiPagingBaseController *)multiPagingController controllerAtPageIndex:(int)index;

@end

/*
 多页面滚动基类
 */
@interface MSMultiPagingBaseController : MSViewController <UIScrollViewDelegate> {
    
    BOOL                _isPageIndexInited;         // 页面是否初始化
    int                 _initPageIndex;             // 初始化页面下标，默认0
    
    NSArray             *_pageTitles;               // 资讯标题或个股代码
    
    UIScrollView        *_pagingScrollView;         // 滚动的scrollview
    
    
    NSMutableSet        *_visibleControlls;         // 当前显示的controller
    NSMutableSet        *_recycledControlls;        // 回收的controller
    
    int                 _currentDisplayPageIndex;   // 当前显示页下标
    
    int                 _lastDisplayFirstIndex;     // 第一个页面的下标
    int                 _lastDisplayLastIndex;      // 最有一个页面的下标
    
    CGFloat             _padding;                   // 左右滚动时的边框 默认10
    
    int                 _isLoop;                    // 是否支持循环滚动
}

@property (nonatomic, assign, readonly) BOOL isPageIndexInited;
@property (nonatomic, assign, readonly) int isLoop; // 是否循环滚动
@property (nonatomic, assign, readonly) int loopSize;

@property (nonatomic, assign, readonly) int currentDisplayPageIndex; // 当前显示页下标
@property (nonatomic, assign, readonly) UIViewController<MSMultiPagingProtocol> *currentDisplayController; // 当前显示的Controller

@property (nonatomic, assign) BOOL isPushBack; // 是否pushViewController返回

@property (nonatomic, assign) id<EMMultiPagingDataSource> dataSource;


// 取回收的controller
- (UIViewController<MSMultiPagingProtocol> *)dequeueReusableControllerByClassName:(NSString *)className;

// 直接跳转某页
- (void)setCurrentPageIndex:(int)page
                   animated:(BOOL)animated
                 reloadData:(BOOL)needReloadData;

// 当前的页面发包
- (void)requestCurrentDisplayPageDataSource;

@end




/* 滚动的子controller必须实现*/
@protocol MSMultiPagingProtocol <NSObject>

@property (nonatomic, assign) NSUInteger multiPageIndex;
@property (nonatomic, assign) MSMultiPagingBaseController *multiPagingController;


// 有一些EMController老的接口, 如果EMController, 则可以杠掉
- (void)refreshDelay:(CGFloat)interval;
- (void)cancelRefresh;
- (void)cancelRequest;

- (void)requestDatasource; // 发包操作, 滑动停下后当前页面会调用到
- (BOOL)loadCacheData; // 读取缓存操作, 滑动停下后当前页面会调用到

- (void)clearBeforeReuse; // 重用前清理数据

@optional
/**
 pageViewDidEndDecelerating
 滚动停止时调用到，如果不实现，则默认如果当前页,发包requestDataSource, 如果时当前页两边, 取缓存updateResult
 
 pageViewDidAddToScrollView
 当page加到scrollView上时调用到, 如果不实现，默认什么也不干
 
 pageViewDidRemoveFromScrollView
 当page从scrollView上移除时调用到, 如果不实现，默认什么也不干
 */

- (void)pageViewDidEndDecelerating:(MSMultiPagingBaseController *)controller;
- (void)pageViewDidAddToScrollView:(MSMultiPagingBaseController *)controller;
- (void)pageViewDidRemoveFromScrollView:(MSMultiPagingBaseController *)controller;

// 调用multiPagingController的navigationController
- (UINavigationController *)navigationController;

@end

