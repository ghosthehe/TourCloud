//
//  TCMapSearchController.m
//  TourCloud
//
//  Created by pachongshe on 16/6/2.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import "TCMapSearchController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "DefineUntil.h"
#import <MAMapKit/MAMapKit.h>

@interface TCMapSearchController ()<AMapSearchDelegate>
{
    AMapSearchAPI *_search;

}

@end

@implementation TCMapSearchController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
#pragma mark poi搜索
   // [self poiSearch];
    
#pragma mark --- 驾车线路查询
   // [self driverRoute];
    
#pragma mark --- 公交站查询
   // [self busStopSearch];

#pragma mark ---公交线路查询
   // [self busRoute];
    
#pragma mark ---搜索提示
    [self inputTipsSearch];
    
    
#pragma mark ---行政区划搜索
    [self districtSearch];
    
    
#pragma mark ---天气查询
    [self weatherSearch];
    

#pragma mark ---分享
    [self shareSearch];
    
    
    
    
    
    
    
}

- (void)shareSearch
{
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapPOIShareSearchRequest对象
    AMapPOIShareSearchRequest *request = [[AMapPOIShareSearchRequest alloc] init];
    request.uid = @"B000A7ZQYC";
    request.location = [AMapGeoPoint locationWithLatitude:39.978416 longitude:116.314458];
    request.name = @"金逸国际电影城(中关村店)";
    request.address = @"中关村大街19号B1层B180";
    
    //发起POI分享查询
    [_search AMapPOIShareSearch:request];
}

//实现短串分享回调函数
- (void)onShareSearchDone:(AMapShareSearchBaseRequest *)request response:(AMapShareSearchResponse *)response
{
    NSLog(@"share response: shareURL = %@", response.shareURL);
}

- (void)weatherSearch
{
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapWeatherSearchRequest对象，配置查询参数
    AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
    request.city = @"北京市直辖区";
    request.type = AMapWeatherTypeLive; //AMapWeatherTypeLive为实时天气；AMapWeatherTypeForecase为预报天气
    
    //发起行政区划查询
    [_search AMapWeatherSearch:request];
}

//实现天气查询的回调函数
- (void)onWeatherSearchDone:(AMapWeatherSearchRequest *)request response:(AMapWeatherSearchResponse *)response
{
    //如果是实时天气
    if(request.type == AMapWeatherTypeLive)
    {
        if(response.lives.count == 0)
        {
            return;
        }
        for (AMapLocalWeatherLive *live in response.lives) {
            
        }
    }
    //如果是预报天气
    else
    {
        if(response.forecasts.count == 0)
        {
            return;
        }
        for (AMapLocalWeatherForecast *forecast in response.forecasts) {
            
        }
    }
}

- (void)districtSearch
{
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapDistrictSearchRequest对象，keywords为必选项
    AMapDistrictSearchRequest *districtRequest = [[AMapDistrictSearchRequest alloc] init];
    districtRequest.keywords = @"北京市直辖市";
    districtRequest.requireExtension = YES;
    
    //发起行政区划查询
    [_search AMapDistrictSearch:districtRequest];
}


//实现行政区划查询的回调函数
- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response
{
    NSLog(@"response: %@", response);
    [self handleDistrictResponse:response];
}
- (void)handleDistrictResponse:(AMapDistrictSearchResponse *)response
{
    if (response == nil)
    {
        return;
    }
    //通过AMapDistrictSearchResponse对象处理搜索结果
    for (AMapDistrict *dist in response.districts)
    {
        MAPointAnnotation *poiAnnotation = [[MAPointAnnotation alloc] init];
        
        poiAnnotation.coordinate = CLLocationCoordinate2DMake(dist.center.latitude, dist.center.longitude);
        poiAnnotation.title      = dist.name;
        poiAnnotation.subtitle   = dist.adcode;
        
        [_mapView addAnnotation:poiAnnotation];
        
        if (dist.polylines.count > 0)
        {
            MAMapRect bounds = MAMapRectZero;
            
            for (NSString *polylineStr in dist.polylines)
            {
//                MAPolyline *polyline = [CommonUtility polylineForCoordinateString:polylineStr];
//                [_mapView addOverlay:polyline];
//                
//                bounds = MAMapRectUnion(bounds, polyline.boundingMapRect);
            }
            
            [_mapView setVisibleMapRect:bounds animated:YES];
        }
    }
}

- (void)inputTipsSearch
{
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapInputTipsSearchRequest对象，设置请求参数
    AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    tipsRequest.keywords = @"肯德基";
    tipsRequest.city = @"北京";
    
    //发起输入提示搜索
    [_search AMapInputTipsSearch: tipsRequest];
}

//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    if(response.tips.count == 0)
    {
        return;
    }
    
    //通过AMapInputTipsSearchResponse对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld", (long)response.count];
    NSString *strtips = @"";
    for (AMapTip *p in response.tips) {
        strtips = [NSString stringWithFormat:@"%@\nTip: %@", strtips, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@", strCount, strtips];
    NSLog(@"InputTips: %@", result);
}

- (void)busRoute
{
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapBusLineNameSearchRequest对象
    AMapBusLineNameSearchRequest *lineRequest = [[AMapBusLineNameSearchRequest alloc] init];
    lineRequest.keywords = @"445";
    lineRequest.city = @"beijing";
    lineRequest.requireExtension = YES;
    
    //发起公交线路查询
    [_search AMapBusLineNameSearch:lineRequest];
}

//实现公交线路查询的回调函数
-(void)onBusLineSearchDone:(AMapBusLineBaseSearchRequest*)request response:(AMapBusLineSearchResponse *)response
{
    if(response.buslines.count == 0)
    {
        return;
    }
    
    //通过AMapBusLineSearchResponse对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",(long)response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strLine = @"";
    for (AMapBusLine *p in response.buslines) {
        strLine = [NSString stringWithFormat:@"%@\nLine: %@", strLine, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strLine];
    NSLog(@"Line: %@", result);
}

- (void)busStopSearch
{
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapBusStopSearchRequest对象
    AMapBusStopSearchRequest *stopRequest = [[AMapBusStopSearchRequest alloc] init];
    stopRequest.keywords = @"望京西";
    stopRequest.city = @"beijing";
    
    //发起公交站查询
    [_search AMapBusStopSearch: stopRequest];

}


- (void)poiSearch
{
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    request.keywords = @"上海";
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"餐饮服务|生活服务";
    request.sortrule = 0;
    request.requireExtension = YES;

    //发起周边搜索
    [_search AMapPOIAroundSearch: request];
    

}

//实现公交站查询的回调函数
-(void)onBusStopSearchDone:(AMapBusStopSearchRequest*)request response:(AMapBusStopSearchResponse *)response
{
    if(response.busstops.count == 0)
    {
        return;
    }
    
    //通过AMapBusStopSearchResponse对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",(long)response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strStop = @"";
    for (AMapBusStop *p in response.busstops) {
        strStop = [NSString stringWithFormat:@"%@\nStop: %@", strStop, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strStop];
    NSLog(@"Stop: %@", result);
}


//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过 AMapPOISearchResponse 对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",(long)response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
}

- (void)driverRoute
{
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    //构造AMapDrivingRouteSearchRequest对象，设置驾车路径规划请求参数
    AMapDrivingRouteSearchRequest *request = [[AMapDrivingRouteSearchRequest alloc] init];
    request.origin = [AMapGeoPoint locationWithLatitude:39.994949 longitude:116.447265];
    request.destination = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    request.strategy = 2;//距离优先
    request.requireExtension = YES;

    //发起路径搜索
    [_search AMapDrivingRouteSearch: request];
    
}

//实现路径搜索的回调函数
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if(response.route == nil)
    {
        return;
    }
    
    //通过AMapNavigationSearchResponse对象处理搜索结果
    NSString *route = [NSString stringWithFormat:@"Navi: %@", response.route];
    NSLog(@"%@", route);
}

//错误
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
   
    
}

@end
