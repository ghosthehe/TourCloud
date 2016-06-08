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
#import "TCSectionView.h"
#import "TCMainPageCellModel.h"

@interface TCMainPageViewController ()<MainPageCycleViewDelegate>
{
    MainPageCycleView *_mainPageCycle;
    NSInteger _currentPage;

}

@end

@implementation TCMainPageViewController

- (void)dealloc
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"heanlineData" object:nil];
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
    _currentPage = 1;
    
    if (_model == nil) {
        _model = [[TCMainPageRequestModel alloc] init];
        
        _model.URLString = Url;
        
        self.model.datas[pageSize] = @(4);
        self.model.parameter[cmd] = @"313";
        self.model.parameter[ver] = @"1_4";
    }
}

- (void)headerRefreshing
{
    _currentPage = 1;

    self.model.datas[pageIndex] = @(_currentPage);
    self.model.parameter[@"data"] = self.model.datas;
    [super headerRefreshing];
}

- (void)footerRefreshing
{
    _currentPage += 1;
    self.model.datas[pageIndex] = @(_currentPage);
    self.model.parameter[@"data"] = self.model.datas;
    [super footerRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO];
    
}

- (void)headLineCycleRequest
{
    TCHeadlineRequestModel *headlindeRequestModel = [[TCHeadlineRequestModel alloc] init];
    
    [headlindeRequestModel getHeadlineData];
    
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

#pragma mark --- tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataSource) {
        id<MSCellModel> item = [self.dataSource itemAtIndexPath:indexPath];
        if ([item isKindOfClass:[TCMainPageCellModel class]]) {
            
            TCMainPageCellModel *cellModel = (TCMainPageCellModel *)item;
//            TCWebController *webController = [[TCWebController alloc] init];
//            webController.htmlUrl = @"";
//            [self.navigationController pushViewController:webController animated:YES];
        }
    }

    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = [[self.dataSource sections] objectAtIndex:section];
    if ([title length]>0) {
    
        TCSectionView *sectionView = [[TCSectionView alloc] initWithFrame:CGRectMake(0, 0, MSScreenWidth(), 38)];
        sectionView.backgroundColor = [UIColor whiteColor];
        sectionView.titleLabel.text = title;
        
        return sectionView;
    }else{
        
        return nil;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *title = [[self.dataSource sections] objectAtIndex:section];
    if ([title length]>0) {
        return 38;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else{
        return 0;
    }
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
