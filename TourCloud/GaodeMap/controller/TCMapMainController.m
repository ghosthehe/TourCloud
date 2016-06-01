//
//  TCMapMainController.m
//  TourCloud
//
//  Created by pachongshe on 16/6/2.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCMapMainController.h"
#import "MSUIKitCore.h"
#import "TCMapController.h"
#import "TCMapSearchController.h"
#import "TCMapCodeController.h"
#import "TCMapLocationController.h"
#import "TCMapNavController.h"

@interface TCMapMainController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *mapFunctionNames;
@property (nonatomic, strong) UITableView *tableView;
@end
@implementation TCMapMainController

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"地图";
        
        self.mapFunctionNames = [[NSMutableArray alloc] initWithObjects:@"定位", @"搜索", @"导航" ,@"地理编码", nil];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MSScreenWidth(), MSScreenHeight() - 0) style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mapFunctionNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = self.mapFunctionNames[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(indexPath.row == 0)
    {
        TCMapLocationController *mapLocationController = [[TCMapLocationController alloc] init];
        
        [self.navigationController pushViewController:mapLocationController animated:YES];
        
    }else if(indexPath.row == 1){
        
        TCMapSearchController *mapSearchController = [[TCMapSearchController alloc] init];
        
        [self.navigationController pushViewController:mapSearchController animated:YES];
    }else if (indexPath.row == 2){
        
        TCMapNavController *mapNavController = [[TCMapNavController alloc] init];
        [self.navigationController pushViewController:mapNavController animated:YES];
        
    }
    else if(indexPath.row == 3){
        
        TCMapCodeController *mapCodeController = [[TCMapCodeController alloc]init];
        [self.navigationController pushViewController:mapCodeController animated:YES];
    }
    
}

@end
