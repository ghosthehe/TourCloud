//
//  BaseRefreshTableController.m
//  GhostSpeed
//
//  Created by ghost on 16/4/22.
//  Copyright © 2016年 ghost. All rights reserved.
//

#import "BaseRefreshTableController.h"
#import "MSTableEmptyView.h"

@interface BaseRefreshTableController ()

@end

@implementation BaseRefreshTableController


- (BOOL)willRefreshHeaderWhenViewWillAppear:(BOOL *)animated
{
    *animated = NO;
    return YES;
}


- (BOOL)willRefreshHeaderWhenViewDidAppear:(BOOL *)animated
{
    *animated = NO;
    
    return NO;
}


- (void)refreshHeaderDidRefresh:(MJRefreshHeader *)refreshHeader
{
    [self headerRefreshing];
}


- (void)refreshFooterDidRefresh:(MJRefreshFooter *)refreshFooter
{
    [self footerRefreshing];
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _refreshType = TableHeaderRefreshTypeIncreased;
    }
    return self;
}

- (void)loadView
{
    [self loadModel];
    [self modelDidLoad];
    [super loadView];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self applyTheme];
    self.tableView.scrollsToTop = YES;
    self.hasRefreshFooter = YES;
}

# pragma mark -
# pragma mark load model

- (void)loadModel
{
    if (_model == nil) {
        _model = [[BaseTableModel alloc] init];
    }
}

- (void)modelDidLoad
{
    if (self.model.paramSetter == nil)
    {
        self.model.paramSetter = ^(NSMutableDictionary *param,EMTableRequestType requestType) {
            param[@"pageSize"] = @"6";
        };
    }
}

# pragma mark - MSRefreshProtocol


- (MJRefreshHeader *)refreshHeaderOfTableView
{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:NULL];
    [header applyEMRefreshStyle];
    return header;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self cancelTasks];
}

- (void)cancelTasks
{
    if ([self.model respondsToSelector:@selector(cancelTasks)])
        [self.model cancelTasks];
    
    for (NSURLSessionTask *task in _operationArray) {
        [task cancel];
    }
}

- (void)doRefresh
{
    [self headerRefreshing];
}

- (void)headerRefreshing
{
    if (self.model.URLString && self.model.URLString.length)
    {
        EMTableRequestType requestType = EMTableRequestTypeDefault;
        if (_refreshType == TableHeaderRefreshTypeIncreased && self.model.dataSource)
        {
            requestType = EMTableRequestTypePageUp;
        }
        
        [self.model requestWithType:requestType
                         completion:^(MSHTTPResponse *response, BOOL success) {
                             
                             if([response.error code] == NSURLErrorCancelled)
                             {
                                 return;
                             }
                             
                             if (success) {
                                 [self responseWithModel:self.model];
                             }
                             
                             [self endHeaderRefreshing];
                             
                             if (self.model.canPageDown) {
                                 [self setRefreshFooterStatus:MSRefreshFooterStatusIdle];
                             }
                             else {
                                 if (self.hasRefreshFooter) {
                                     [self setRefreshFooterStatus:MSRefreshFooterStatusNoMoreData];
                                 }
                                 else {
                                     [self setRefreshFooterStatus:MSRefreshFooterStatusHidden];
                                 }
                             }
                         }];
    }else{
        
        [self performSelector:@selector(endHeaderRefreshing) withObject:nil afterDelay:15];
    }
    
}




- (void)footerRefreshing
{
    if (self.model.canPageDown) {
        
        [self.model requestWithType:EMTableRequestTypePageDown
                         completion:^(MSHTTPResponse *response, BOOL success) {
                             
                             if([response.error code] == NSURLErrorCancelled){
                                 return;
                             }
                             
                             if (success) {
                                 [self responseWithModel:self.model];
                             }
                             
                             [self updateFooterWhenRequestFinished];
                         }];
        
    }
    else {
        [self setRefreshFooterStatus:MSRefreshFooterStatusNoMoreData];
    }
}


- (void)responseWithModel:(id)model
{
    if (self.model.dataSource) {
        [self reloadPages:self.model.dataSource];
    }
}


- (void)didReceiveMemoryWarning
{
    if ([self isViewLoaded] && self.view.window == nil)
    {
        _tableView = nil;
        _model = nil;
    }
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)updateFooterWhenRequestFinished
{
    [self endFooterRefreshing];
    
    if (self.model.canPageDown) {
        [self setRefreshFooterStatus:MSRefreshFooterStatusIdle];
    }
    else {
        if (self.hasRefreshFooter)
        {
            [self setRefreshFooterStatus:MSRefreshFooterStatusNoMoreData];
        }
        else
        {
            [self setRefreshFooterStatus:MSRefreshFooterStatusHidden];
        }
    }
}

# pragma mark - theme

- (MJRefreshFooter *)refreshFooterOfTableView
{
    return [MJRefreshAutoNormalFooter footerWithRefreshingBlock:NULL];
}

- (void)applyTheme
{
//    self.tableView.backgroundColor = [MSThemeManager colorForKey:@"common_tableBackgroundColor"];
//    self.tableView.separatorColor = [UIColor colorForKey:@"common_tableSeperateColor"];
    
    [(MJRefreshGifHeader *)self.refreshHeader applyEMRefreshStyle];
}

- (UIView *)emptyView
{
    if (_emptyView == nil) {
        MSTableEmptyView *tableEmptyView = [[MSTableEmptyView alloc] initWithFrame:_tableView.frame];
//        tableEmptyView.backgroundColor = [MSThemeManager colorForKey:@"common_tableBackgroundColor"];
//        tableEmptyView.iconImageView.image = [UIImage themeImageNamed:@"message_tips_nodata"];
        _emptyView = tableEmptyView;
    }
    
    return _emptyView;
}

@end

@implementation MJRefreshGifHeader(EMRefreshTableViewController)

- (void)applyEMRefreshStyle
{
    NSArray *imageNames = @[@"refreshHeader_img_1", @"refreshHeader_img_2", @"refreshHeader_img_3"];
    NSMutableArray *images = [NSMutableArray array];
    
//    for (NSString *name in imageNames) {
//        UIImage *img = [UIImage themeImageNamed:name];
//        [images addObject:img];
//    }
    
    [self setImages:images forState:MJRefreshStateIdle];
    [self setImages:images forState:MJRefreshStatePulling];
    [self setImages:images forState:MJRefreshStateRefreshing];
    [self setImages:images forState:MJRefreshStateWillRefresh];
    
//    self.stateLabel.textColor = [MSThemeManager colorForKey:@"common_menuHighlightedColor"];
    
    [self setTitle:@"下拉刷新..." forState:MJRefreshStateIdle];
    [self setTitle:@"松开刷新..." forState:MJRefreshStatePulling];
    [self setTitle:@"玩命刷新中..." forState:MJRefreshStateRefreshing];
    
    self.lastUpdatedTimeLabel.hidden = YES;
}

@end
