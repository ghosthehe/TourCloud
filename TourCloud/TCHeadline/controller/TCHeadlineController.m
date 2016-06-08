//
//  TCHeadlineController.m
//  TourCloud
//
//  Created by pachongshe on 16/6/8.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCHeadlineController.h"
#import "TCHeadlineRequestModel.h"
#import "TCUrlDefineUntil.h"
#import "RDVTabBarController.h"
#import "TCHeadlineCell.h"
#import "JLRoutes.h"
#import "TCWebController.h"

@interface TCHeadlineController ()
{    
    NSInteger _currentPage;
}

@end

@implementation TCHeadlineController

- (void)dealloc
{
    
}

- (void)loadModel
{
    _currentPage = 1;
    
    if (_model == nil) {
        
        _model = [[TCHeadlineRequestModel alloc] init];
        
        self.model.datas[@"customerCode"] = @"lyy";
        self.model.datas[pageSize] = @(5);
        self.model.URLString = Url;
        self.model.parameter[cmd] = @"214";
        self.model.parameter[ver] = @"1_4";
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.tableView respondsToSelector:@selector(separatorInset)]) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataSource) {
        id<MSCellModel> item = [self.dataSource itemAtIndexPath:indexPath];
        if ([item isKindOfClass:[TCHeadlineCellModel class]]) {
            
            TCHeadlineCellModel *cellModel = (TCHeadlineCellModel *)item;
            TCWebController *webController = [[TCWebController alloc] init];
            webController.htmlUrl = @"";
            [self.navigationController pushViewController:webController animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)didReceiveMemoryWarning {
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
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
