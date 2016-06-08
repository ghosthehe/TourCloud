//
//  TCWindow.m
//  TourCloud
//
//  Created by pachongshe on 16/5/27.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCWindow.h"
#import "RDVTabBarController.h"
#import "TCShareViewController.h"
#import "TCPayController.h"
#import "TCWebController.h"
#import "TCMapMainController.h"
#import "RDVTabBarItem.h"
#import "TCMainPageViewController.h"

@implementation TCWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self loadTabBar];
        
    }
    return self;
}

- (void)loadTabBar
{
    TCMainPageViewController *mainController = [[TCMainPageViewController alloc] init];
    UINavigationController *mainNavController = [[UINavigationController alloc] initWithRootViewController:mainController];
    TCShareViewController *shareViewController = [[TCShareViewController alloc] init];
    UINavigationController *shareNavViewController = [[UINavigationController alloc] initWithRootViewController:shareViewController];
    TCPayController *payContrller = [[TCPayController alloc] init];
    UINavigationController *payNavController = [[UINavigationController alloc] initWithRootViewController:payContrller];
    TCWebController *webController = [[TCWebController alloc] init];
    UINavigationController *webNavController = [[UINavigationController alloc] initWithRootViewController:webController];
    TCMapMainController *mapController = [[TCMapMainController alloc] init];
    UINavigationController *mapNavController = [[UINavigationController alloc] initWithRootViewController:mapController];
    
    RDVTabBarController *rdvController = [[RDVTabBarController alloc] init];
    [rdvController setViewControllers:@[mainNavController,shareNavViewController,webNavController,mapNavController,payNavController]];
    [self customizeTabBarForController:rdvController];
    self.rootViewController = rdvController;
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    
    //    NSArray *tabBarItimageNameds = @[@"em-icon-mainpage", @"em-icon-zxg",@"em-icon-discovery",@"em-icon-PM",@"em-icon-news"];
    //    NSArray *tabBarItimageNamedsSelected = @[@"em-icon-mainpage-fill", @"em-icon-zxg-fill",@"em-icon-discovery-fill",@"em-icon-PM-fill",@"em-icon-news-fill"];
    
    //    NSInteger index = 0;
    
    for (RDVTabBarItem *item in [[tabBarController tabBar] items])
    {
        //        UIImage *selectedimage = [UIImage imageWithIcon:[tabBarItimageNamedsSelected objectAtIndex:index] highlighted:YES];
        //        UIImage *unselectedimage = [UIImage imageWithIcon:[tabBarItimageNameds objectAtIndex:index] highlighted:NO];
        //        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        //        index++;
        //        item.titlePositionAdjustment = UIOffsetMake(0, 6);
        
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            item.unselectedTitleAttributes = @{
                                               NSFontAttributeName: [UIFont systemFontOfSize:12],
                                               NSForegroundColorAttributeName: [UIColor grayColor],
                                               };
            
            item.selectedTitleAttributes = @{
                                             NSFontAttributeName: [UIFont systemFontOfSize:12],
                                             NSForegroundColorAttributeName: [UIColor blueColor],
                                             };
            
        } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            item.unselectedTitleAttributes = @{
                                               UITextAttributeFont: [UIFont systemFontOfSize:12],
                                               UITextAttributeTextColor: [UIColor menuNormalColor],
                                               };
            item.selectedTitleAttributes = @{
                                             UITextAttributeFont: [UIFont systemFontOfSize:12],
                                             UITextAttributeTextColor: [UIColor menuHighlightedColor],
                                             };
#endif
        }
    }
    //    tabBarController.tabBar.backgroundColor = [UIColor colorForKey:@"common_tabbarBgColor"];
    //    tabBarController.tabBar.backgroundView.backgroundColor = [UIColor colorForKey:@"common_tabbarBgColor"];
    //    tabBarController.view.backgroundColor = [UIColor colorForKey:@"common_bgColor"];
    CALayer *layer = [CALayer layer];
    layer.contentsScale = [UIScreen mainScreen].scale;
    //    layer.backgroundColor = [UIColor colorForKey:@"common_tabbarBorderColor"].CGColor;
    //    layer.frame = CGRectMake(0, 0, MSScreenWidth(), .5);
    [tabBarController.tabBar.backgroundView.layer addSublayer:layer];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
