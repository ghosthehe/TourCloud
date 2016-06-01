//
//  TCMapLocationController.m
//  TourCloud
//
//  Created by pachongshe on 16/6/6.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCMapLocationController.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface TCMapLocationController ()<AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;
@end

@implementation TCMapLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;

   
#pragma mark --- 持续定位
    //[self updatingLocation];
    
#pragma 单次定位
//    [self singleLocation];
    
    
#pragma mark ---后台定位
    [self backgroundLocation];
    
    
    
}

- (void)backgroundLocation
{
    //设置允许后台定位参数，保持不会被系统挂起
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];//iOS9(含)以上系统需设置
    
    //开始持续定位
    [self.locationManager startUpdatingLocation];
}


- (void)singleLocation
{
    
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，可修改，最小2s
    self.locationManager.locationTimeout = 3;
    //   逆地理请求超时时间，可修改，最小2s
    self.locationManager.reGeocodeTimeout = 3;
    
    // 带逆地理（返回坐标和地址信息）
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
//            if (error.code == AMapLocatingErrorLocateFailed)
//            {
//                return;
//            }
            return ;
        }
        
        NSLog(@"location:%@", location);
        
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
        }
    }];

}

- (void)updatingLocation
{
    [self.locationManager startUpdatingLocation];
    
    //停止持续定位
    //[self.locationManager stopUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
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
