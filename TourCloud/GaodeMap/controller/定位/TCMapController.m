//
//  TCMapController.m
//  TourCloud
//
//  Created by pachongshe on 16/6/1.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCMapController.h"
#import "TCMapManager.h"
#import "MSUIKitCore.h"
#import "Masonry.h"


@interface TCMapController ()<MAMapViewDelegate,MAOverlay>

@end

@implementation TCMapController

@synthesize coordinate;
@synthesize boundingMapRect;

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"地图";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMapView];
    
    [self initView];
    
    [self initAnnotation];
    
    
}

#pragma mark --初始化地图
- (void)initMapView
{
    _mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
    
    //5米更新
    _mapView.distanceFilter = 5.0;
    
    //不显示用户位置
    _mapView.showsUserLocation = NO;
    
    _mapView.delegate = self;
    
    //不显示底层建筑
    _mapView.showsLabels = NO;
    
    //后台
    _mapView.pausesLocationUpdatesAutomatically = NO;
    _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    
    _mapView.showsCompass= YES; // 设置成NO表示关闭指南针；YES表示显示指南针
    
    _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 75); //设置指南针位置
    
//    _mapView.showsScale= YES;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    
    _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 75);  //设置比例尺位置
    
    _mapView.zoomEnabled = YES;    //NO表示禁用缩放手势，YES表示开启
//    [_mapView setZoomLevel:13 animated:YES]; //缩放比例
    
     _mapView.scrollEnabled = YES;    //NO表示禁用滑动手势，YES表示开启
    
    [_mapView setCenterCoordinate:_mapView.centerCoordinate animated:YES]; //地图平移时，缩放级别不变，可通过改变地图的中心点来移动地图
    
    _mapView.rotateEnabled= NO;    //NO表示禁用旋转手势，YES表示开启
    
    [self.view addSubview:_mapView];
}

#pragma mark ---初始化大头针
- (void)initAnnotation
{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
    pointAnnotation.title = @"方恒国际";
    pointAnnotation.subtitle = @"东大街6号";
    [_mapView addAnnotation:pointAnnotation];
    
//    _mapView addAnnotations:<#(NSArray *)#>
}

#pragma mark ---初始化覆盖物
- (void)initOverlayView
{
    //画折现
    //构造折线数据对象
    CLLocationCoordinate2D commonPolylineCoords[4];
    commonPolylineCoords[0].latitude = 39.832136;
    commonPolylineCoords[0].longitude = 116.34095;
    
    commonPolylineCoords[1].latitude = 39.832136;
    commonPolylineCoords[1].longitude = 116.42095;
    
    commonPolylineCoords[2].latitude = 39.902136;
    commonPolylineCoords[2].longitude = 116.42095;
    
    commonPolylineCoords[3].latitude = 39.902136;
    commonPolylineCoords[3].longitude = 116.44095;
    
    //构造折线对象
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:4];
    
    //在地图上添加折线对象
    [_mapView addOverlay: commonPolyline];
    
}

#pragma mark --初始化UI
- (void)initView
{
    //定位
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationBtn setTitle:@"定位" forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(showUserLocation) forControlEvents:
     UIControlEventTouchUpInside];
    locationBtn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:locationBtn];
    
    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(MSScreenHeight() - 120));
        make.left.equalTo(@(5));
        make.width.equalTo(@(50));
        
    }];
    
    //地图类型
    UISegmentedControl *mapTypeSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"普通地图",@"卫星地图",@"夜间地图"]];
    mapTypeSegmentedControl.selectedSegmentIndex = 0;
    [mapTypeSegmentedControl addTarget:self action:@selector(selecteMapType:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:mapTypeSegmentedControl];
    
    [mapTypeSegmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(MSScreenHeight() - 120));
        make.left.equalTo(@(150));
        make.right.equalTo(@(-10));
        
    }];
    
//    //覆盖物划线
//    UIButton *drawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [drawBtn setTitle:@"画折现" forState:UIControlStateNormal];
//    [drawBtn addTarget:self action:@selector(drawBtn) forControlEvents:
//     UIControlEventTouchUpInside];
//    drawBtn.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:drawBtn];
//    
//    [drawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(@(MSScreenHeight() - 120));
//        make.left.equalTo(@(5));
//        make.width.equalTo(@(50));
//        
//    }];

    
}

- (void)drawBtn
{
    [self initOverlayView];

}

- (void)selecteMapType:(UISegmentedControl *)segementControl
{
    if (segementControl.selectedSegmentIndex == 0) {
        _mapView.mapType = MAMapTypeStandard;
    }else if (segementControl.selectedSegmentIndex == 1){
        
        _mapView.mapType = MAMapTypeSatellite;
    }else{
        _mapView.mapType = MAMapTypeStandardNight;
    }
}

#pragma mark --显示用户位置
- (void)showUserLocation
{
    _mapView.showsUserLocation = YES;
    
    //地图跟着位置移动
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_mapView setUserTrackingMode: MAUserTrackingModeFollowWithHeading animated:YES];

    });

}

#pragma mark --Map delegate
//3D矢量地图
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    /* 自定义定位精度对应的MACircleView. */
    if (overlay == mapView.userLocationAccuracyCircle)
    {
        MACircleRenderer *accuracyCircleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        accuracyCircleRenderer.lineWidth    = 2.f;
        accuracyCircleRenderer.strokeColor  = [UIColor lightGrayColor];
        accuracyCircleRenderer.fillColor    = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        
        return accuracyCircleRenderer;
    }else if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
//        if (overlay == self.overlaysAboveLabels[OverlayViewControllerOverlayTypeTexturePolyline])
//        {
//            polylineRenderer.lineWidth    = 8.f;
//            [polylineRenderer loadStrokeTextureImage:[UIImage imageNamed:@"arrowTexture"]];
//            
//        }
//        else if(overlay == self.overlaysAboveLabels[OverlayViewControllerOverlayTypeArrowPolyline])
//        {
//            polylineRenderer.lineWidth    = 20.f;
//            polylineRenderer.lineCapType  = kMALineCapArrow;
//        }
//        else
//        {
//            polylineRenderer.lineWidth    = 8.f;
//            polylineRenderer.strokeColor  = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.6];
//            polylineRenderer.lineJoinType = kMALineJoinRound;
//            polylineRenderer.lineCapType  = kMALineCapRound;
//        }
        
        return polylineRenderer;
    }

    
    return nil;
}

//大头针
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

//当位置更新时，会进定位回调，通过回调函数，能获取到定位点的经纬度坐标，
//标示是否是location数据更新, YES:location数据更新 NO:heading数据更新
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
    updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
       // NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

//定位失败
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
