//
//  EMMultiPagingMenuController.m
//  EMStock
//
//  Created by Mac mini 2012 on 14-4-21.
//
//

#import "MSMultiPagingMenuController.h"
#import "MSMultiPagingSubclass.h"
//#import "MSCoreFunction.h"
//#import "MSCoreMetrics.h"

@interface MSMultiPagingMenuController ()

@end

@implementation MSMultiPagingMenuController

-(void)loadView
{
    [super loadView];
    // super loadView 中会调到 loadControllersAndScrollView
}

- (void)loadControllersAndScrollView
{
    [self initPageIndex];
    [self initControllers];
    [self loadScrollView];
    [self loadMenu];
    [self addDisplayedControllers];
}

- (void)loadMenu
{
    [self clearMenuView];
    
    if (_menu==nil) {
        _pageTitles = [[self _titlesOfPages] copy];
        _menu = [[MSMultiPagingMenu alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kMultiPagingMenuBarHeight)
                                                  titles:_pageTitles
                                                editable:NO];
        _menu.delegate = self;
        _menu.clipsToBounds = YES;
    }
    [self.view addSubview:_menu];
}


- (void)clearControllersAndScrollView
{
    [super clearControllersAndScrollView];
    [self clearMenuView];
}

- (void)clearMenuView
{
    [_menu removeFromSuperview];
    _menu = nil;
}

- (void)setMenuHidden:(BOOL)hidden
{
    _isMenuHidden = hidden;
    [self viewDidLayoutSubviews];
}

- (CGRect)frameForPagingScrollView {
    
    float titleMenuHeight = _isMenuHidden ? 0 : kMultiPagingMenuBarHeight;
    CGRect frame = self.view.bounds;
    
    frame.origin.x -= _padding;
    frame.size.width += (2 * _padding);
    frame.origin.y = titleMenuHeight;
    frame.size.height -= titleMenuHeight;
    return frame;
}


- (void)viewDidLayoutSubviews
{
    if (_isMenuHidden) {
        _menu.frame = CGRectZero;
    }
    else{
        _menu.frame = CGRectMake(0, 0, self.view.frame.size.width, kMultiPagingMenuBarHeight);
    }
    
    [super viewDidLayoutSubviews];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float calcOffset = scrollView.contentOffset.x + self.view.frame.size.width / 2;
    calcOffset = (calcOffset > scrollView.contentSize.width) ? scrollView.contentSize.width : calcOffset;
    int currentIndex = calcOffset / scrollView.frame.size.width;
    if (currentIndex != _menu.selectedIndex)
    {
        [_menu setCurrentMenuIndex:currentIndex animated:YES];
    }
}

# pragma mark - InfoMenuDelegate

- (void)MSMultiPagingMenuDidPressed:(MSMultiPagingMenu *)infoMenu
                            atIndex:(NSUInteger)index
{
    CGPoint origin = CGPointMake([self frameForPageAtIndex:index].origin.x-_padding,
                                 [self frameForPageAtIndex:index].origin.y);
    [_pagingScrollView setContentOffset:origin];
    if (CGPointEqualToPoint(origin, _pagingScrollView.contentOffset)) {
        [self scrollViewDidEndDecelerating:_pagingScrollView];
    }
    
    [_menu setCurrentMenuIndex:index animated:YES];
}

@end
