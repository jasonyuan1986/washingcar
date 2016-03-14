//
//  WeatherViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 1/29/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "WeatherViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <JSONKit-NoWarning/JSONKit.h>

@interface WeatherViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentWeatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentDescriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *nextDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextWeatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextTemperatureLabel;

@property (weak, nonatomic) IBOutlet UILabel *nextTwoDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextTwoWeatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextTwoTemperature;

@property (weak, nonatomic) IBOutlet UILabel *nextThreeDay;
@property (weak, nonatomic) IBOutlet UILabel *nextThreeWeather;
@property (weak, nonatomic) IBOutlet UILabel *nextThreeTemperature;

@property (weak, nonatomic) IBOutlet UILabel *nextFourDay;
@property (weak, nonatomic) IBOutlet UILabel *nextFourWeather;
@property (weak, nonatomic) IBOutlet UILabel *nextFourTemperature;
@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://192.168.1.9:8080/app/code/weather/%E4%B8%8A%E6%B5%B7" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [responseObject objectFromJSONData];
        NSArray *weatherArray = [result objectForKey:@"data"];
        
        for (int i = 0; i < 5; i++) {
            NSDictionary *weather = [weatherArray objectAtIndex:i];
            if (i == 0) {
                self.currentDayLabel.text = [weather objectForKey:@"weekNum"];
                self.currentStatusLabel.text = [weather objectForKey:@"washInd"];
                self.currentTemperatureLabel.text = [weather objectForKey:@"temp"];
                self.currentWeatherLabel.text = [NSString stringWithFormat:@"%@ %@", [weather objectForKey:@"info"], [weather objectForKey:@"wind"]];
                self.currentDescriptionLabel.text = [weather objectForKey:@"washDesc"];
            } else if (i == 1) {
                self.nextDayLabel.text = [weather objectForKey:@"weekNum"];
                self.nextWeatherLabel.text = [weather objectForKey:@"info"];
                self.nextTemperatureLabel.text = [weather objectForKey:@"temp"];
            } else if (i == 2) {
                self.nextTwoDayLabel.text = [weather objectForKey:@"weekNum"];
                self.nextTwoWeatherLabel.text = [weather objectForKey:@"info"];
                self.nextTwoTemperature.text = [weather objectForKey:@"temp"];
            } else if (i == 3) {
                self.nextThreeDay.text = [weather objectForKey:@"weekNum"];
                self.nextThreeWeather.text = [weather objectForKey:@"info"];
                self.nextThreeTemperature.text = [weather objectForKey:@"temp"];
            } else if (i == 4) {
                self.nextFourDay.text = [weather objectForKey:@"weekNum"];
                self.nextFourWeather.text = [weather objectForKey:@"info"];
                self.nextFourTemperature.text = [weather objectForKey:@"temp"];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
#ifdef DEBUGMODE
        LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerApp(1, @"Result: %@", result);
#endif
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
