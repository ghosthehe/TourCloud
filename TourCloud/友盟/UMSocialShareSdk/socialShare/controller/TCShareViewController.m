//
//  TCShareViewController.m
//  TourCloud
//
//  Created by pachongshe on 16/5/30.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCShareViewController.h"
#import "TCShareView.h"
#import "TCShareBtn.h"
#import "MBProgressHUD+MJ.h"

//友盟
#import "UMSocialData.h"
#import "UMSocialControllerService.h"
#import "UMSocialSnsService.h"
#import "MSUIKitCore.h"
#import "UMSocialSnsPlatformManager.h"

#import "DefineUntil.h"

@interface TCShareViewController ()<TCShareViewDelegate>

@property (nonatomic, strong) NSString *currentURL;
@property (nonatomic, strong) NSString *webviewcurrentURL;

@end

@implementation TCShareViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"分享";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)socialShare:(id)sender {
    
    TCShareView *shareView = [[TCShareView alloc] init];
    shareView.delegate = self;
    
    [shareView startShareWithText:@"分享" image:nil];
    
}

/**
 *  shareDelegate
 *
 *  @param shareView
 *  @param shareBtn  
 */
- (void)shareViewDidClickShareBtn:(TCShareView *)shareView selBtn:(TCShareBtn *)shareBtn
{
    
    [[UMSocialControllerService defaultControllerService] setShareText:shareView.shareText shareImage:shareView.shareImage socialUIDelegate:nil];
    
    if ((shareBtn.socalSnsType == UMSocialSnsTypeWechatTimeline) || (shareBtn.socalSnsType == UMSocialSnsTypeWechatSession) || (shareBtn.socalSnsType == UMSocialSnsTypeMobileQQ) || (shareBtn.socalSnsType == UMSocialSnsTypeSina)) {
        if ((shareView.shareImage != nil) || (shareView.shareText != nil)) {
            
            if (self.currentURL !=nil) {
                [UMSocialData defaultData].extConfig.wechatSessionData.title = @"旅游云";
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"旅游云";                [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@&qrc=1",self.currentURL];
                [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@&qrc=1",self.currentURL];
                //            [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"%@&qrc=1",self.currentURL];
                
            }else
            {
                [UMSocialData defaultData].extConfig.wechatSessionData.title = @"旅游云";
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"旅游云";
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@&qrc=1",self.webviewcurrentURL];
                [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@&qrc=1",self.webviewcurrentURL];
                
            }
        }
        else
        {
            
            [MBProgressHUD showError:@"分享失败,请稍候重试"];
            return;
        }
    }
    
    UMSocialSnsPlatform *platform = [UMSocialSnsPlatformManager getSocialPlatformWithName:[UMSocialSnsPlatformManager getSnsPlatformString:(shareBtn.socalSnsType)]];
    
    platform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
