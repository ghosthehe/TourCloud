//
//  EMMultiPagingMenuController.h
//  EMStock
//
//  Created by Mac mini 2012 on 14-4-21.
//
//

#import "MSMultiPagingBaseController.h"
#import "MSMultiPagingMenu.h"



@interface MSMultiPagingMenuController : MSMultiPagingBaseController <MSMultiPagingMenuDelegate> {
    
    MSMultiPagingMenu   *_menu;                     // 标题栏
    BOOL                _isMenuHidden;              // 是否隐藏标题栏
}
- (void)setMenuHidden:(BOOL)hidden; // 隐藏菜单
- (void)MSMultiPagingMenuDidPressed:(MSMultiPagingMenu *)infoMenu
                            atIndex:(NSUInteger)index;
@end
