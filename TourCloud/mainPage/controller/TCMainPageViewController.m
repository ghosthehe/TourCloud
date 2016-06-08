//
//  TCMainPageViewController.m
//  TourCloud
//
//  Created by pachongshe on 16/6/6.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCMainPageViewController.h"
#import "MainPageCycleView.h"
#import "MSUIKitCore.h"
#import "TCMainPageRequestModel.h"
#import "TCHeadlineController.h"
#import "TCHeadlineController.h"
#import "RDVTabBarController.h"
#import "TCHeadlineRequestModel.h"
#import "TCUrlDefineUntil.h"

@interface TCMainPageViewController ()<MainPageCycleViewDelegate>
{
    MainPageCycleView *_mainPageCycle;
    TCHeadlineRequestModel *_headlindeRequestModel;
}

@end

@implementation TCMainPageViewController

- (void)dealloc
{
    
}

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"首页";
    }
    
    return self;
}

- (void)loadModel
{
    if (_model == nil) {
        _model = [[TCMainPageRequestModel alloc] init];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
    
}

- (void)headLineCycleRequest
{
    _headlindeRequestModel = [[TCHeadlineRequestModel alloc] init];
    
    [_headlindeRequestModel getHeadlineData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self headLineCycleRequest];

    _tableView.frame = CGRectMake(0, 44, MSScreenWidth(), MSScreenHeight() - 44);
    
    self.emptyView.frame = _tableView.frame;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHeadlineData:) name:@"heanlineData" object:nil];
    
    [self reloadPages:self.model.dataSource];
}

- (void)getHeadlineData:(NSNotification *)noti
{
    
    NSDictionary *dic = noti.userInfo;
    _mainPageCycle = [[MainPageCycleView alloc] initWithFrame:CGRectMake(0, 0, MSScreenWidth(), 44)];
    _mainPageCycle.delegate = self;
    
    _mainPageCycle.slideBtns = dic[@"heanlineData"];
    [self.view addSubview:_mainPageCycle];

}
- (void)headLineBtnClick
{
    TCHeadlineController *headLineController = [[TCHeadlineController alloc] init];
    
    [self.navigationController pushViewController:headLineController animated:YES];
}

- (void)telBtnClick
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)didReceiveMemoryWarning {
    
    if ([self isViewLoaded] && self.view.window == nil) {
        _model.dataSource = nil;
    }
    [super didReceiveMemoryWarning];
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
