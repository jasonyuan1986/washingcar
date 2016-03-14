//
//  FindWorkerViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 2/28/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "FindWorkerViewController.h"
#import "ReGeocodeAnnotation.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface FindWorkerViewController () <MAMapViewDelegate, AMapSearchDelegate>
{
    MAMapView *myMapView;
    AMapSearchAPI *mySearch;
    ReGeocodeAnnotation *myAnnotation;
    UIImageView *findnoWorkerImage;
    UIImageView *findnoLocationImage;
    UIButton *subscribeButton;
}

@end

@implementation FindWorkerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    [MAMapServices sharedServices].apiKey = AMAPAPIKEY;
    
    mySearch = [[AMapSearchAPI alloc] initWithSearchKey:AMAPSEARCHKEY Delegate:self];
    
    myMapView = [[MAMapView alloc] init];
    myMapView.desiredAccuracy = kCLLocationAccuracyBest;
    [myMapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading];
    myMapView.frame = self.view.bounds;
    myMapView.delegate = self;
    myMapView.showsUserLocation = YES;
    [self.view addSubview:myMapView];
    
//    findnoWorkerImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 29.0/128.0, self.view.frame.size.width * 79.0/320.0, self.view.frame.size.width * 35.0/64.0, self.view.frame.size.width * 7.0/64.0)];
//    findnoWorkerImage.hidden = YES;
//    [findnoWorkerImage setImage:[UIImage imageNamed:@"findnoworker"]];
//    [self.view addSubview:findnoWorkerImage];
    
    
    
    subscribeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [subscribeButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [subscribeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [subscribeButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:18.0]];
    [subscribeButton setTitle:@"马上去预约" forState:UIControlStateNormal];
    [subscribeButton addTarget:self action:@selector(addTimePicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:subscribeButton];
    [subscribeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(subscribeButton.superview);
        make.bottom.equalTo(subscribeButton.superview).offset(-30);
        make.size.mas_equalTo(CGSizeMake(200.0, 40.0));
    }];
    
    findnoLocationImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 85.0/640.0, self.view.frame.size.width * 911.0/640.0, self.view.frame.size.width * 11.0/140.0, self.view.frame.size.width /8.0)];
    [findnoLocationImage setImage:[UIImage imageNamed:@"findnolocationimage"]];
    [self.view addSubview:findnoLocationImage];
    [findnoLocationImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(subscribeButton.mas_left).offset(-10);
        make.bottom.equalTo(findnoLocationImage.superview).offset(-30);
        make.size.mas_equalTo(CGSizeMake(25.0, 40.0));
    }];
    
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

- (void)addTimePicker:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addTimePicker" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
        [mySearch AMapReGoecodeSearch:regeo];
    }
}

#pragma mark- AMMap view delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[ReGeocodeAnnotation class]])
    {
        static NSString *invertGeoIdentifier = @"invertGeoIdentifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[myMapView dequeueReusableAnnotationViewWithIdentifier:invertGeoIdentifier];
        
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:invertGeoIdentifier];
        }
        
        poiAnnotationView.image = [UIImage imageNamed:@"userLocation"];
        //设置中心心点偏移,使得标注底部中间点成为经纬度对应点
        poiAnnotationView.centerOffset = CGPointMake(0, -18.0);
        poiAnnotationView.animatesDrop              = YES;
        poiAnnotationView.canShowCallout            = YES;
        
        return poiAnnotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation {
    if(updatingLocation) {
        //取出当前位置的坐标
        CLLocation *newLocation = userLocation.location;
        
        //判断水平精度是否有效
        if (newLocation.horizontalAccuracy < 0) {
            return;
        }
        
        //根据业务需求，进行水平精度判断，获取所需位置信息（100可改为业务所需值）
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
        NSLog(@"%@, %@, %@, %@, %@, %@", response.regeocode.addressComponent.province, response.regeocode.addressComponent.city, response.regeocode.addressComponent.district, response.regeocode.addressComponent.township, response.regeocode.addressComponent.neighborhood, response.regeocode.addressComponent.building);
        if (myAnnotation != nil) {
            [myMapView removeAnnotation:myAnnotation];
        }
        myMapView.showsUserLocation = NO;
        myAnnotation = [[ReGeocodeAnnotation alloc] initWithCoordinate:coordinate reGeocode:response.regeocode];
        
        [myMapView addAnnotation:myAnnotation];
        [myMapView selectAnnotation:myAnnotation animated:YES];
    }
}

@end
