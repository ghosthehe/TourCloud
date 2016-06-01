//
//  TCMapController.h
//  TourCloud
//
//  Created by pachongshe on 16/6/1.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface TCMapController : UIViewController

{
    MAMapView *_mapView;
}

@property (nonatomic, strong) MAMapView *mapView;

@end
