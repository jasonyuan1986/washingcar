//
//  MapViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 2/25/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "MapViewController.h"
#import "ReGeocodeAnnotation.h"
#import "SharedInfo.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface MapViewController () <MAMapViewDelegate, AMapSearchDelegate, UIGestureRecognizerDelegate>
{
    MAMapView *myMapView;
    AMapSearchAPI *mySearch;
    ReGeocodeAnnotation *myAnnotation;
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    UIBarButtonItem *confirmBarButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmBarButtonPressed:)];
    [confirmBarButton setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = confirmBarButton;
    
    [MAMapServices sharedServices].apiKey = AMAPAPIKEY;
    
    mySearch = [[AMapSearchAPI alloc] initWithSearchKey:AMAPSEARCHKEY Delegate:self];
    
    myMapView = [[MAMapView alloc] init];
    myMapView.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [myMapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading];
    myMapView.distanceFilter = 50.0;
    myMapView.frame = self.view.bounds;
    myMapView.delegate = self;
    myMapView.showsUserLocation = YES;
    [self.view addSubview:myMapView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5;
    
    [self.view addGestureRecognizer:longPress];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    myMapView.showsUserLocation = NO;
    myMapView.delegate = nil;
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmBarButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setMapAddress" object:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Handle Gesture

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        CLLocationCoordinate2D coordinate = [myMapView convertPoint:[longPress locationInView:self.view]
                                                  toCoordinateFromView:myMapView];
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        regeo.requireExtension = YES;
        [SharedInfo shared].currentLatitude = coordinate.latitude;
        [SharedInfo shared].currentLongitude = coordinate.longitude;
        [mySearch AMapReGoecodeSearch:regeo];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[ReGeocodeAnnotation class]])
    {
        static NSString *invertGeoIdentifier = @"invertGeoIdentifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[myMapView dequeueReusableAnnotationViewWithIdentifier:invertGeoIdentifier];
        
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:invertGeoIdentifier];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(annotationViewTaped:)];
            [poiAnnotationView addGestureRecognizer:tap];
            tap.delegate = self;
        }
        
        poiAnnotationView.image = [UIImage imageNamed:@"userLocation"];
        //设置中心心点偏移,使得标注底部中间点成为经纬度对应点
        poiAnnotationView.centerOffset = CGPointMake(0.0, 0.0);
        poiAnnotationView.animatesDrop              = YES;
        poiAnnotationView.canShowCallout            = YES;
        
        UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 50, 30);
        [leftButton setBackgroundColor:[UIColor clearColor]];
        [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftButton setTitle:@"确定" forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        poiAnnotationView.rightCalloutAccessoryView = leftButton;
        
        return poiAnnotationView;
    }
    
    return nil;
}

- (void)leftButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setMapAddress" object:self];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation {
    if(updatingLocation) {
        //取出当前位置的坐标
        CLLocation *newLocation = userLocation.location;

        //判断水平精度是否有效
        if (newLocation.horizontalAccuracy < 0) {
            return;
        }
        
        //根据业务需求，进行水平精度判断，获取所需位置信息（100可改为业务所需值）
        NSLog(@"%f", newLocation.horizontalAccuracy);
        if(newLocation.horizontalAccuracy < 100){
            //取出当前位置的坐标
            NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
            AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
            regeo.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
            regeo.requireExtension = YES;
            
            [mySearch AMapReGoecodeSearch:regeo];
        }
    }
}

#pragma mark - AMapSearchDelegate

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        AMapStreetNumber *streetNumber = response.regeocode.addressComponent.streetNumber;
        [SharedInfo shared].mapAddress = [NSString stringWithFormat:@"%@%@%@%@", response.regeocode.addressComponent.district,   streetNumber.street, streetNumber.number, response.regeocode.addressComponent.building];
        if (myAnnotation != nil) {
            [myMapView removeAnnotation:myAnnotation];
        }
        myMapView.showsUserLocation = NO;
        myAnnotation = [[ReGeocodeAnnotation alloc] initWithCoordinate:coordinate reGeocode:response.regeocode];
        
        [myMapView addAnnotation:myAnnotation];
        [myMapView selectAnnotation:myAnnotation animated:YES];
    }
}

- (void)annotationViewTaped:(UITapGestureRecognizer*)gestureRecognizer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setMapAddress" object:self];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
