//
//  ViewController.m
//  ScrollView2010Demo
//
//  Created by Chen Weigang on 12-7-3.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import "MSMultiPagingBaseController.h"
#import "MSUIKitCore.h"

static const NSInteger kMultiPagingPadding = 10;
static const NSInteger kMultiPageControllerLoopSize = (16*2);
static const NSInteger kMultiPageControllerLoopSizeMax = 512;

@interface MSMultiPagingBaseController() {
    int _firstVisiblePageIndexBeforeRotation;
    CGFloat _percentScrolledIntoFirstVisiblePage;
    int _loopSize;
}

- (void)reloadControllersAndPages;// 重新加载页面
@end

@implementation MSMultiPagingBaseController

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        self.title = @"MultiPageScroll";
        _isPushBack = NO;
        _padding = kMultiPagingPadding;
        _isLoop = NO;
        _isPageIndexInited = NO;
    }
    
    return self;
}

# pragma mark - Life Cycle

- (void)loadView
{
    [super loadView];
    [self loadControllersAndScrollView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addDisplayedControllers];
    [self setCurrentPageIndex:_currentDisplayPageIndex
                     animated:NO
                   reloadData:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 子类列表refresh会自动刷新, 所以这里不刷新, 如果子类不会自己刷新, 则需要调用一下
//    if (!self.isPushBack) {
//        [self requestCurrentDisplayPageDataSource];
//    }
    self.isPushBack = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    if ([self isViewLoaded] && self.view.window == nil)
    {
        _isPushBack = NO;
        _isPageIndexInited = NO;
        [self clearControllersAndScrollView];
        self.view = nil;
    }
    
    [super didReceiveMemoryWarning];
}


- (void)loadControllersAndScrollView
{
    [self initPageIndex];
    [self initControllers];
    [self loadScrollView];
    [self addDisplayedControllers];
}

- (void)initPageIndex
{
    _currentDisplayPageIndex = -1;
    _lastDisplayFirstIndex = -1;
    _lastDisplayLastIndex = -1;
    
    if (!_isPageIndexInited) {
        int page = _initPageIndex;
        
        if (page<0 || page>=[self _numberOfPages]) {
            page = 0;
        }
        
        page = page + (_isLoop ? [self _numberOfPages]*self.loopSize/2 : 0);
        
        _lastDisplayFirstIndex = page;
        _lastDisplayLastIndex = page+1;
        _currentDisplayPageIndex = page;
        
        _isPageIndexInited = YES;
    }
}

- (void)initControllers
{
    [self clearControllers];
    
    if (_visibleControlls==nil) {
        _visibleControlls  = [[NSMutableSet alloc] init];
    }
    
    if (_recycledControlls==nil) {
        _recycledControlls = [[NSMutableSet alloc] init];
    }
}

- (void)clearControllers
{
    if (_visibleControlls) {
        [_visibleControlls removeAllObjects];
        _visibleControlls = nil;
    }
    
    if (_recycledControlls) {
        [_recycledControlls removeAllObjects];
        _recycledControlls = nil;
    }
}

- (void)loadScrollView
{
    [self clearScrollView];
    
    if (_pagingScrollView==nil) {
        CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
        _pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
        _pagingScrollView.pagingEnabled = YES;
        _pagingScrollView.backgroundColor = RGB(31, 31, 31);
        _pagingScrollView.showsVerticalScrollIndicator = NO;
        _pagingScrollView.showsHorizontalScrollIndicator = NO;
        _pagingScrollView.delegate = self;
        _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
        _pagingScrollView.directionalLockEnabled = YES;
    }
    [self.view addSubview:_pagingScrollView];
}

- (void)clearControllersAndScrollView
{
    [self clearControllers];
    [self clearScrollView];
}

- (void)clearScrollView
{
    if (_pagingScrollView) {
        [_pagingScrollView removeFromSuperview];
        _pagingScrollView = nil;
    }
}

- (UIViewController<MSMultiPagingProtocol> *)currentDisplayController
{
    NSAssert(_currentDisplayPageIndex>=0 && _isPageIndexInited, @"尚未初始化, 不应该调用这个函数!");

    for (UIViewController<MSMultiPagingProtocol> *controller in _visibleControlls) {
        if (controller.multiPageIndex == _currentDisplayPageIndex) {
            return controller;
        }
    }
    
    return nil;
}

- (int)loopSize
{
    if (_loopSize==0) {
        _loopSize = 1;
        
        if (_isLoop) {
            int sizeMax = [self _numberOfPages] * kMultiPageControllerLoopSize;
            
            if (sizeMax <= kMultiPageControllerLoopSizeMax) {
                _loopSize = kMultiPageControllerLoopSize;
            }
            else{
                _loopSize = kMultiPageControllerLoopSizeMax / [self _numberOfPages] / 2 * 2;
            }
        }
    }
    
    return _loopSize;
}


- (void)requestCurrentDisplayPageDataSource
{
    NSAssert(_isPageIndexInited, @"没初始化 不应该调用这个方法");
    
    for (UIViewController<MSMultiPagingProtocol> *controller in _visibleControlls) {
        if (controller.multiPageIndex==_currentDisplayPageIndex) {
            [controller requestDatasource];
            break;
        }
    }
}

- (void)setCurrentPageIndex:(int)page
                   animated:(BOOL)animated
                reloadData:(BOOL)needReloadData
{
    if (page<0) {
        page = 0;
    }
    if (page>[self _numberOfPages]*self.loopSize-1) {
        page=[self _numberOfPages]*self.loopSize-1;
    }
    
    CGPoint origin = CGPointMake([self frameForPageAtIndex:page].origin.x-_padding,
                                 [self frameForPageAtIndex:page].origin.y);
    
    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            [_pagingScrollView setContentOffset:origin];
        } completion:^(BOOL finished) {
            if (CGPointEqualToPoint(origin, _pagingScrollView.contentOffset)) {
                [self deceleratingScrollView:_pagingScrollView animated:NO sendPackage:needReloadData];
            }
        }];
    }
    else{
        [_pagingScrollView setContentOffset:origin];
        if (CGPointEqualToPoint(origin, _pagingScrollView.contentOffset)) {
            [self deceleratingScrollView:_pagingScrollView animated:NO sendPackage:needReloadData];
        }
    }
}


# pragma mark - Layout

- (void)viewDidLayoutSubviews
{
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    _pagingScrollView.frame = pagingScrollViewFrame;
    [self layoutVisiblePages];
}

- (void)layoutVisiblePages
{
    for (UIViewController<MSMultiPagingProtocol> *controller in _visibleControlls) {
        NSUInteger infoPageIndex = controller.multiPageIndex;
        controller.view.frame = [self frameForPageAtIndex:infoPageIndex];
    }
}

- (BOOL)isTilePageIndexesChanged
{
    CGRect visibleBounds = _pagingScrollView.bounds;
    
    // 正常情况是不用-1/+1的缓存2个界面，这里想多缓存1个界面 以保证流畅滑动
    int firstNeededPageIndex = floorf((CGRectGetMinX(visibleBounds)) / CGRectGetWidth(visibleBounds)) - 1;
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)) / CGRectGetWidth(visibleBounds)) + 1;
    
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [self _numberOfPages]*self.loopSize);
    
    // 保证最多只显示3页
    if (firstNeededPageIndex==0) {
        lastNeededPageIndex = MIN([self _numberOfPages]*self.loopSize, 3);
    }
    if (lastNeededPageIndex==[self _numberOfPages]*self.loopSize) {
        firstNeededPageIndex = MAX(0, [self _numberOfPages]*self.loopSize - 3);
    }
    //    assert(lastNeededPageIndex-firstNeededPageIndex<=3);
    
//    NSLog(@"first = %d last = %d", firstNeededPageIndex, lastNeededPageIndex);
    
    if (_lastDisplayFirstIndex == firstNeededPageIndex && _lastDisplayLastIndex == lastNeededPageIndex) {
        return NO;
    }
    _lastDisplayFirstIndex = firstNeededPageIndex;
    _lastDisplayLastIndex = lastNeededPageIndex;
    
    return YES;
}

- (void)recycleUnDisplayedControllers
{
    // 回收不显示的界面
    for (UIViewController<MSMultiPagingProtocol> *controller in _visibleControlls) {
        if (controller.multiPageIndex < _lastDisplayFirstIndex
            || controller.multiPageIndex > _lastDisplayLastIndex) {
            controller.multiPagingController = nil;
            [_recycledControlls addObject:controller];
            [controller viewWillDisappear:NO];
            [controller.view removeFromSuperview];
            [controller viewDidDisappear:NO];
            
            if ([controller respondsToSelector:@selector(pageViewDidRemoveFromScrollView:)]) {
                [controller pageViewDidRemoveFromScrollView:self];
            }
        }
    }
    [_visibleControlls minusSet:_recycledControlls];
}

- (void)addDisplayedControllers
{
    // 添加新进入的界面
    for (int index = _lastDisplayFirstIndex; index < _lastDisplayLastIndex; index++) {
        UIViewController<MSMultiPagingProtocol> *controller = [self isDisplayingPageForIndex:index];
        if (controller == nil) {
            
            controller = [self _controllerAtPageIndex:index]; // 用户提供
            controller.multiPagingController = self;
            controller.multiPageIndex = index;
            if (![[controller class] conformsToProtocol:NSProtocolFromString(@"MSMultiPagingProtocol")]) {
                NSAssert(0, @"controller 必须实现 MSMultiPagingProtocol");
            }
            controller.view.frame = [self frameForPageAtIndex:index];
//            NSLog(@"frame = %@", NSStringFromCGRect(controller.view.frame));
            [controller viewWillAppear:NO];
            [_pagingScrollView addSubview:controller.view];
            [controller viewDidAppear:NO];
            [_pagingScrollView sendSubviewToBack:controller.view];
            
            [_visibleControlls addObject:controller];
            if ([_recycledControlls containsObject:controller]) {
                [_recycledControlls removeObject:controller];// 可能是回收的, 从recycle中删掉
            }
            if ([controller respondsToSelector:@selector(pageViewDidAddToScrollView:)]) {
                [controller pageViewDidAddToScrollView:self];
            }
        }
    }
}

- (void)tilePages
{
    if ([self isTilePageIndexesChanged]) {
        [self recycleUnDisplayedControllers];
        [self addDisplayedControllers];
    }
}

- (void)refreshPageData
{
    int currentIndex = _pagingScrollView.contentOffset.x/_pagingScrollView.frame.size.width;
    if (!_isPageIndexInited || self.currentDisplayPageIndex!=currentIndex) {
        _currentDisplayPageIndex = currentIndex;
        
        for (UIViewController<MSMultiPagingProtocol> *controller in _visibleControlls) {
            if ([controller respondsToSelector:@selector(pageViewDidEndDecelerating:)]) {
                [controller pageViewDidEndDecelerating:self];
            }
            
            if (controller.multiPageIndex==currentIndex) {
                [controller requestDatasource]; // 当前页显示时，发包
            }
            else if (ABS(controller.multiPageIndex-currentIndex)==1){
                [controller loadCacheData]; // 当前页两边时，取缓存
            }
        }
    }
}

- (void)deceleratingScrollView:(UIScrollView *)scrollView
                      animated:(BOOL)animated
                   sendPackage:(BOOL)canSendPackage
{
    [self tilePages];
    if (canSendPackage) {
        [self refreshPageData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self deceleratingScrollView:scrollView
                        animated:NO
                     sendPackage:YES];
}

- (UIViewController<MSMultiPagingProtocol> *)dequeueReusableControllerByClassName:(NSString *)className
{
    Class class = NSClassFromString(className);
    UIViewController<MSMultiPagingProtocol> *result = nil;
    for (UIViewController<MSMultiPagingProtocol> *controller in [_recycledControlls allObjects]) {
        if ([controller isMemberOfClass:class]) {
            result =  controller;
            break;
        }
    }
    
    if (result && [result respondsToSelector:@selector(clearBeforeReuse)]) {
        [result clearBeforeReuse];
    }
    
    return result;
}

- (UIViewController<MSMultiPagingProtocol> *)isDisplayingPageForIndex:(int)pageIndex
{
    for (UIViewController<MSMultiPagingProtocol> *controller in [_visibleControlls allObjects]) {
        
        if (controller.multiPageIndex == pageIndex) {
            return controller;
        }
    }
    
    return nil;
}

#pragma mark - Calc frame

- (CGRect)frameForPagingScrollView {
    CGRect frame = self.view.bounds;
    frame.origin.x -= _padding;
    frame.size.width += (2 * _padding);
    return frame;
}

- (CGSize)contentSizeForPagingScrollView {
    CGRect bounds = _pagingScrollView.bounds;
    return CGSizeMake(bounds.size.width * [self _numberOfPages]*self.loopSize , bounds.size.height);
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    CGRect bounds = _pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * _padding);
    pageFrame.origin.x = (bounds.size.width * index) + _padding;
    return pageFrame;
}

#pragma mark - send package

- (void)requestRefresh:(CGFloat)interval
{
    [[self currentDisplayController] refreshDelay:interval];
}

- (void)updateResult
{
    [[self currentDisplayController] loadCacheData];
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // here, our pagingScrollView bounds have not yet been updated for the new interface orientation. So this is a good
    // place to calculate the content offset that we will need in the new orientation
    CGFloat offset = _pagingScrollView.contentOffset.x;
    CGFloat pageWidth = _pagingScrollView.bounds.size.width;
    if (offset >= 0) {
        _firstVisiblePageIndexBeforeRotation = floorf(offset / pageWidth);
        _percentScrolledIntoFirstVisiblePage = (offset - (_firstVisiblePageIndexBeforeRotation * pageWidth)) / pageWidth;
    } else {
        _firstVisiblePageIndexBeforeRotation = 0;
        _percentScrolledIntoFirstVisiblePage = offset / pageWidth;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // recalculate contentSize based on current orientation
    // adjust contentOffset to preserve page location based on values collected prior to location
    CGFloat pageWidth = _pagingScrollView.bounds.size.width;
    CGFloat newOffset = (_firstVisiblePageIndexBeforeRotation * pageWidth) + (_percentScrolledIntoFirstVisiblePage * pageWidth);
    _pagingScrollView.contentOffset = CGPointMake(newOffset, 0);
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;// 默认不支持旋转
}


- (void)setDataSource:(id<EMMultiPagingDataSource>)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
    }
}

# pragma mark - dataSource function

- (int)_numberOfPages
{
    NSAssert(self.dataSource!=nil, @"self.dataSource 为空!");
    
    return [self.dataSource numberOfPages];
}

- (UIViewController<MSMultiPagingProtocol> *)_controllerAtPageIndex:(int)index
{
    NSAssert(self.dataSource!=nil, @"self.dataSource 为空!");
    
    return [self.dataSource multiPagingController:self controllerAtPageIndex:index];
}

- (NSArray *)_titlesOfPages
{
    NSAssert(self.dataSource!=nil, @"self.dataSource 为空!");
    
    return [self.dataSource titlesOfPages];
}

@end

