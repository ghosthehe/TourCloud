//
//  TCMapNavController.m
//  TourCloud
//
//  Created by pachongshe on 16/6/6.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCMapNavController.h"
#import <AMapNaviKit/AMapNaviKit.h>

@interface TCMapNavController ()<AMapNaviDriveManagerDelegate, AMapNaviWalkManagerDelegate>

@property (nonatomic, strong) AMapNaviDriveManager *driveManager;
@property (nonatomic, strong) AMapNaviWalkManager *walkManager;

@end

@implementation TCMapNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    
    
}

- (void)routeCal
{
    
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:39.989614 longitude:116.481763];
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:39.983456 longitude:116.315495];
    
    NSArray *startPoints = @[startPoint];
    NSArray *endPoints   = @[endPoint];
    
    //驾车路径规划（未设置途经点、导航策略为速度优先）
    [_driveManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];
    
    //步行路径规划
    [self.walkManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
}

- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
    }
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
