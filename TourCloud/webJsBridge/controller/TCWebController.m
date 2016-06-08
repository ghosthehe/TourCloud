//
//  TCWebController.m
//  TourCloud
//
//  Created by pachongshe on 16/5/31.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCWebController.h"
#import "Masonry.h"
//#import "MSUIKitCore.h"
#import "UIWebView+jsToObject.h"

@interface TCWebController()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@end

@implementation TCWebController

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"网页";
        
        self.hidesBottomBarWhenPushed = YES;
        self.synchronizeDocumentTitle = YES;
        
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeAll;
        }

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scrollView.backgroundColor = [UIColor whiteColor];
    
    _webView.opaque = NO;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _webView.scrollView.clipsToBounds = YES;
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    
    NSURL *url =[[NSURL alloc] initWithString:@"http://api.eshimin.com/api/oauth/authorize?client_id=99TbKCNy7v&redirect_uri=http://m.pachongshe.com/app/lvyouyun/eshimin/eshimin.html&scope=read&response_type=code"];
    
    NSURLRequest *request =  [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];

    
}

#pragma mark UIWebView delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self showNetworkActivityIndicator:NO];
    NSLog(@"%@ %ld", error.domain, (long)error.code);
    
    if (-1202 == error.code)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示"
                                                        message: @"请确认网页的证书"
                                                       delegate: nil
                                              cancelButtonTitle: nil
                                              otherButtonTitles: @"确定", nil];
        [alert show];
    }
}

- (void)showNetworkActivityIndicator:(BOOL)visible {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:visible];
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    //执行脚本
    [_webView loadActionJavaScript];
    
    [self showNetworkActivityIndicator:NO];
    
    if (self.synchronizeDocumentTitle)
    {
        [self reloadTitle];
    }
    
    if (!_longPress) {
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(coverWebviewAction:)];
        _longPress.minimumPressDuration = 0.4;
        _longPress.numberOfTouchesRequired = 1;
        [webView.scrollView addGestureRecognizer:_longPress];
    }
}

- (void)coverWebviewAction:(UIGestureRecognizer *)gesture {
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        if ([url.scheme isEqualToString:@""]) {
            
        }
    }
    
    return YES;
}

- (void)reloadTitle
{        //提取页面的标题作为当前controller的标题
    NSString *title = [self remoteTitle];
    if (title && title.length)
    {
        self.title = title;
    }
}

- (NSString *)remoteTitle {
    return [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
