//
//  EMMultiPagingBaseController+EMMultiPagingSubclass.h
//  EMStock
//
//  Created by Mac mini 2012 on 14-4-3.
//
//

#import "MSMultiPagingBaseController.h"
#import <UIKit/UIKit.h>

@interface MSMultiPagingBaseController (ForSubclassEyesOnly)

- (void)initPageIndex;
- (void)initControllers;

- (void)loadMenu;
- (void)loadScrollView;
- (void)clearControllersAndScrollView;
- (void)layoutVisiblePages;
- (void)deceleratingScrollView:(UIScrollView *)scrollView
                      animated:(BOOL)animated
                   sendPackage:(BOOL)canSendPackage;
- (void)tilePages;

- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (void)recycleUnDisplayedControllers;
- (void)addDisplayedControllers;


// calc frame
- (CGRect)frameForPagingScrollView;
- (CGSize)contentSizeForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;

// private
- (int)_numberOfPages;
- (UIViewController<MSMultiPagingProtocol> *)_controllerAtPageIndex:(int)index;
- (NSArray *)_titlesOfPages;

@end
