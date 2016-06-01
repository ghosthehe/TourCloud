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

@interface TCMainPageViewController ()
{
    MainPageCycleView *_mainPageCycle;
}

@end

@implementation TCMainPageViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _mainPageCycle = [[MainPageCycleView alloc] initWithFrame:CGRectMake(0, 0, MSScreenWidth(), 44)];
    
    [self.view addSubview:_mainPageCycle];
    
    _tableView.frame = CGRectMake(0, 44, MSScreenWidth(), MSScreenHeight() - 44);
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
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
