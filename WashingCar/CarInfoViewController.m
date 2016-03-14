//
//  CarInfoViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 1/28/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "CarInfoViewController.h"
#import "SharedInfo.h"
#import <AFNetworking/AFNetworking.h>
#import <JSONKit-NoWarning/JSONKit.h>

@interface CarInfoViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate,UIGestureRecognizerDelegate>
{
    // Main View
    UIImageView *backgroundImage;
    UIImageView *carSelectBackground;
    UIButton *carBrandButton;
    UIButton *carTypeButton;
    UIButton *carColorButton;
    UIButton *provinceButton;
    UIButton *carAlphaButton;
    UITextField *carNumberField;
    UIButton *confirmButton;
    NSString *carTypeStr;
    NSString *carColorStr;
    
    // Picker View
    UIView *pickerBackView;
    UIImageView *pickerBackImage;
    UIButton *pickerConfirmButton;
    UIButton *pickerCancelButton;
    UIPickerView *myPickerView;
    NSArray *pickerViewArray;
    NSInteger currentRow;
    NSMutableArray *carTypeArray;
    NSMutableArray *carColorArray;
    NSInteger pickerType;
    NSInteger carTypeIndex;
    NSInteger carColorIndex;
}

@end

@implementation CarInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    UIControl *control = [[UIControl alloc] initWithFrame:self.view.bounds];
    [control setBackgroundColor:[UIColor blackColor]];
    [control addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    self.view = control;
    
    backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImage"]];
    backgroundImage.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:backgroundImage];
    
    carSelectBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carSelect1"]];
    carSelectBackground.frame = CGRectMake(0.0, (self.view.frame.size.width * 3.0/64.0 + 64.0), self.view.frame.size.width, self.view.frame.size.width * 0.15);
    [self.view addSubview:carSelectBackground];
    
    provinceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [provinceButton setFrame:CGRectMake(self.view.frame.size.width * 5.0/64.0, (carSelectBackground.frame.origin.y + carSelectBackground.frame.size.width * 12.5/320.0), self.view.frame.size.width * 11.0/64.0, 25.0)];
    [provinceButton setBackgroundColor:[UIColor clearColor]];
    [provinceButton setTitle:@"沪" forState:UIControlStateNormal];
    [provinceButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [provinceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [provinceButton addTarget:self action:@selector(provinceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:provinceButton];
    
    carAlphaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [carAlphaButton setFrame:CGRectMake(self.view.frame.size.width * 21.0/64.0, provinceButton.frame.origin.y, self.view.frame.size.width * 37.0/320.0, provinceButton.frame.size.height)];
    [carAlphaButton setBackgroundColor:[UIColor clearColor]];
    [carAlphaButton setTitle:@"A" forState:UIControlStateNormal];
    [carAlphaButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [carAlphaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [carAlphaButton addTarget:self action:@selector(carAlphaButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:carAlphaButton];
    
    UIColor *color = [UIColor whiteColor];
    carNumberField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 9.0/16.0, provinceButton.frame.origin.y, 120.0, 30.0)];
    carNumberField.delegate = self;
    carNumberField.borderStyle = UITextBorderStyleNone;
    [carNumberField setTextColor:[UIColor whiteColor]];
    [carNumberField setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    carNumberField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入车牌号码" attributes:@{NSForegroundColorAttributeName: color}];
    [self.view addSubview:carNumberField];
    
    carBrandButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, carSelectBackground.frame.origin.y + carSelectBackground.frame.size.height, carSelectBackground.frame.size.width, carSelectBackground.frame.size.width * 0.15)];
    [carBrandButton setBackgroundImage:[UIImage imageNamed:@"carButtonBack"] forState:UIControlStateNormal];
    [carBrandButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [carBrandButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    carBrandButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [carBrandButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 55.0, 0.0, 0.0)];
    [carBrandButton setTitle:@"您的车辆品牌" forState:UIControlStateNormal];
    [carBrandButton addTarget:self action:@selector(carBrandButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:carBrandButton];
    
    carTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, carBrandButton.frame.origin.y + carBrandButton.frame.size.height, carBrandButton.frame.size.width, carBrandButton.frame.size.width * 0.15)];
    [carTypeButton setBackgroundImage:[UIImage imageNamed:@"carButtonBack"] forState:UIControlStateNormal];
    [carTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    carTypeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [carTypeButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [carTypeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 55.0, 0.0, 0.0)];
    [carTypeButton setTitle:@"您的车辆型号" forState:UIControlStateNormal];
    [carTypeButton addTarget:self action:@selector(carTypeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:carTypeButton];
    
    carColorButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, carTypeButton.frame.origin.y + carTypeButton.frame.size.height, carTypeButton.frame.size.width, carTypeButton.frame.size.height)];
    [carColorButton setBackgroundImage:[UIImage imageNamed:@"carButtonBack"] forState:UIControlStateNormal];
    [carColorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [carColorButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    carColorButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [carColorButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 55.0, 0.0, 0.0)];
    [carColorButton setTitle:@"您的车辆颜色" forState:UIControlStateNormal];
    [carColorButton addTarget:self action:@selector(carColorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:carColorButton];
    
    confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(0.0, (carColorButton.frame.origin.y + self.view.frame.size.width * 95.0/320.0), self.view.frame.size.width, self.view.frame.size.width * 11.0/80.0)];
    [confirmButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    
    pickerBackView = [[UIView alloc] initWithFrame:CGRectMake(0.0, (self.view.frame.size.height - self.view.frame.size.width * 51.0/64.0), self.view.frame.size.width, self.view.frame.size.width * 51.0/64.0)];
    [pickerBackView setBackgroundColor:[UIColor blackColor]];
    pickerBackView.hidden = YES;
    
    pickerBackImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carInfoPickerBack"]];
    pickerBackImage.frame = pickerBackView.bounds;
    [pickerBackView addSubview:pickerBackImage];
    [self.view addSubview:pickerBackView];
    
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 10.0, self.view.frame.size.width, 300)];
    myPickerView.delegate = self;
    myPickerView.dataSource = self;
    [pickerBackView addSubview:myPickerView];
    UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    [myPickerView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.delegate = self;
    
    pickerConfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pickerConfirmButton setFrame:CGRectMake(0.0, 0.0, 80, 50)];
    [pickerConfirmButton setBackgroundColor:[UIColor clearColor]];
    [pickerConfirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [pickerConfirmButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:15.0]];
    [pickerConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pickerConfirmButton addTarget:self action:@selector(pickerConfirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [pickerBackView addSubview:pickerConfirmButton];
    
    pickerCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pickerCancelButton setFrame:CGRectMake(self.view.frame.size.width - 80.0, 0.0, 80.0, 50.0)];
    [pickerCancelButton setBackgroundColor:[UIColor clearColor]];
    [pickerCancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [pickerCancelButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:15.0]];
    [pickerCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pickerCancelButton addTarget:self action:@selector(pickerCancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [pickerBackView addSubview:pickerCancelButton];
    
    carTypeArray = [[NSMutableArray alloc] init];
    carColorArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in [SharedInfo shared].carTypeArray) {
        [carTypeArray addObject:[dict objectForKey:@"configName"]];
    }
    
    for (NSDictionary *dict in [SharedInfo shared].carColorArray) {
        [carColorArray addObject:[dict objectForKey:@"configName"]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAlpha:) name:@"selectAlpha" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectProvince:) name:@"selectProvince" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCarBrandAndModel:) name:@"setCarBrand" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchDown:(id)sender {
    [carNumberField resignFirstResponder];
}

- (void)carBrandButtonPressed:(id)sender {
    [carNumberField resignFirstResponder];
    [self performSegueWithIdentifier:@"showBrand" sender:self];
}

- (void)provinceButtonPressed:(id)sender {
    [carNumberField resignFirstResponder];
    [self performSegueWithIdentifier:@"showProvince" sender:self];
}

- (void)carAlphaButtonPressed:(id)sender {
    [carNumberField resignFirstResponder];
    [self performSegueWithIdentifier:@"showAlpha" sender:self];
}

- (void)carTypeButtonPressed:(id)sender {
    [carNumberField resignFirstResponder];
    pickerType = 1;
    pickerViewArray = carTypeArray;
    [myPickerView reloadAllComponents];
    pickerBackView.hidden = NO;
    pickerBackView.tag = 1;
}

- (void)carColorButtonPressed:(id)sender {
    [carNumberField resignFirstResponder];
    pickerType = 2;
    pickerViewArray = carColorArray;
    [myPickerView reloadAllComponents];
    pickerBackView.hidden = NO;
    pickerBackView.tag = 2;
}

- (void)confirmButtonPressed:(id)sender {
    if ([provinceButton.titleLabel.text isEqualToString:@"其他"]) {
        if (carNumberField.text.length > 7 ||
            [carNumberField.text isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请输入正确的车牌号码";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            return;
        }
        
        if ([carBrandButton.titleLabel.text isEqualToString:@"您的车辆品牌"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请选择车辆品牌";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            return;
        }
        
        if ([carTypeButton.titleLabel.text isEqualToString:@"您的车辆型号"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请选择车辆型号";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            return;
        }
        
        if ([carColorButton.titleLabel.text isEqualToString:@"您的车辆颜色"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请选择车辆颜色";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            return;
        }
        
        
        NSString *carNumberStr = [NSString stringWithFormat:@"%@", carNumberField.text];
        
        NSDictionary *dict = [[SharedInfo shared].carTypeArray objectAtIndex:carTypeIndex];
        NSString *carType = [dict objectForKey:@"configValue"];
        
        dict = [[SharedInfo shared].carColorArray objectAtIndex:carColorIndex];
        NSString *carColor = [dict objectForKey:@"configValue"];
        
        dict = [SharedInfo shared].carBrand;
        NSString *carBrand = [dict objectForKey:@"configValue"];
        
        dict = [SharedInfo shared].carModel;
        NSString *carModel = [dict objectForKey:@"configValue"];
        
        NSDictionary *paramDict = @{@"carNum": carNumberStr, @"carType": carType, @"carColor": carColor, @"carBrand": carBrand, @"carModel": carModel};
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:ADDCAR parameters:paramDict success:^(NSURLSessionDataTask *task, id responseObject) {
            NSData *data = responseObject;
            NSDictionary *resultDic = [data objectFromJSONData];
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",result);
            NSNumber *success = [resultDic objectForKey:@"success"];
            if ([[success stringValue] isEqualToString:@"1"]) {
//                [SharedInfo shared].currentCarIndex = [NSIndexPath indexPathForRow:0 inSection:0];
                [[NSUserDefaults standardUserDefaults] setObject:carNumberStr forKey:@"lastCarNumber"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"添加车辆失败,请重新添加";
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    // Do something...
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"网络错误";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                      [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                      [error.userInfo objectForKey:@"NSLocalizedDescription"]);
            NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
            LoggerApp(1, @"Result: %@", result);
        }];
    } else if (![provinceButton.titleLabel.text isEqualToString:@"其他"] &&
               [carAlphaButton.titleLabel.text isEqualToString:@"其他"]) {
        if (carNumberField.text.length > 6 ||
            [carNumberField.text isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请输入正确的车牌号码";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            return;
        }
        
        if ([carBrandButton.titleLabel.text isEqualToString:@"您的车辆品牌"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请选择车辆品牌";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            return;
        }
        
        if ([carTypeButton.titleLabel.text isEqualToString:@"您的车辆型号"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请选择车辆型号";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            return;
        }
        
        if ([carColorButton.titleLabel.text isEqualToString:@"您的车辆颜色"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请选择车辆颜色";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            return;
        }
        
        NSString *carNumberStr = [NSString stringWithFormat:@"%@%@", provinceButton.titleLabel.text, carNumberField.text];
        
        NSDictionary *dict = [[SharedInfo shared].carTypeArray objectAtIndex:carTypeIndex];
        NSString *carType = [dict objectForKey:@"configValue"];
        
        dict = [[SharedInfo shared].carColorArray objectAtIndex:carColorIndex];
        NSString *carColor = [dict objectForKey:@"configValue"];
        
        dict = [SharedInfo shared].carBrand;
        NSString *carBrand = [dict objectForKey:@"configValue"];
        
        dict = [SharedInfo shared].carModel;
        NSString *carModel = [dict objectForKey:@"configValue"];
        
        NSDictionary *paramDict = @{@"carNum": carNumberStr, @"carType": carType, @"carColor": carColor, @"carBrand": carBrand, @"carModel": carModel};
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:ADDCAR parameters:paramDict success:^(NSURLSessionDataTask *task, id responseObject) {
            NSData *data = responseObject;
            NSDictionary *resultDic = [data objectFromJSONData];
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",result);
            NSNumber *success = [resultDic objectForKey:@"success"];
            if ([[success stringValue] isEqualToString:@"1"]) {
//                [SharedInfo shared].currentCarIndex = [NSIndexPath indexPathForRow:0 inSection:0];
                [[NSUserDefaults standardUserDefaults] setObject:carNumberStr forKey:@"lastCarNumber"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"添加车辆失败,请重新添加";
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    // Do something...
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"网络错误";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                      [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                      [error.userInfo objectForKey:@"NSLocalizedDescription"]);
            NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
            LoggerApp(1, @"Result: %@", result);
        }];
    } else {
        if (carNumberField.text.length > 5 ||
            [carNumberField.text isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请输入正确的车牌号码";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            return;
        }
        
        if ([carBrandButton.titleLabel.text isEqualToString:@"您的车辆品牌"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请选择车辆品牌";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            return;
        }
        
        if ([carTypeButton.titleLabel.text isEqualToString:@"您的车辆型号"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请选择车辆型号";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            return;
        }
        
        if ([carColorButton.titleLabel.text isEqualToString:@"您的车辆颜色"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请选择车辆颜色";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            return;
        }
        
        NSString *carNumberStr = [NSString stringWithFormat:@"%@%@%@", provinceButton.titleLabel.text, carAlphaButton.titleLabel.text, carNumberField.text];
        
        NSDictionary *dict = [[SharedInfo shared].carTypeArray objectAtIndex:carTypeIndex];
        NSString *carType = [dict objectForKey:@"configValue"];
        
        dict = [[SharedInfo shared].carColorArray objectAtIndex:carColorIndex];
        NSString *carColor = [dict objectForKey:@"configValue"];
        
        dict = [SharedInfo shared].carBrand;
        NSString *carBrand = [dict objectForKey:@"configValue"];
        
        dict = [SharedInfo shared].carModel;
        NSString *carModel = [dict objectForKey:@"configValue"];
        
        NSDictionary *paramDict = @{@"carNum": carNumberStr, @"carType": carType, @"carColor": carColor, @"carBrand": carBrand, @"carModel": carModel};
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:ADDCAR parameters:paramDict success:^(NSURLSessionDataTask *task, id responseObject) {
            NSData *data = responseObject;
            NSDictionary *resultDic = [data objectFromJSONData];
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",result);
            NSNumber *success = [resultDic objectForKey:@"success"];
            if ([[success stringValue] isEqualToString:@"1"]) {
//                [SharedInfo shared].currentCarIndex = [NSIndexPath indexPathForRow:0 inSection:0];
                [[NSUserDefaults standardUserDefaults] setObject:carNumberStr forKey:@"lastCarNumber"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"添加车辆失败,请重新添加";
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    // Do something...
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"网络错误";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                      [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                      [error.userInfo objectForKey:@"NSLocalizedDescription"]);
            NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
            LoggerApp(1, @"Result: %@", result);
        }];
    }
}

- (void)pickerConfirmButtonPressed:(id)sender {
    pickerBackView.hidden = YES;
    
    if (pickerBackView.tag == 1) {
        carTypeStr = [pickerViewArray objectAtIndex:[myPickerView selectedRowInComponent:0]];
        [carTypeButton setTitle:carTypeStr forState:UIControlStateNormal];
    } else if (pickerBackView.tag == 2) {
        carColorStr = [pickerViewArray objectAtIndex:[myPickerView selectedRowInComponent:0]];
        [carColorButton setTitle:carColorStr forState:UIControlStateNormal];
    }
}

- (void)pickerCancelButtonPressed:(id)sender {
    pickerBackView.hidden = YES;
}

- (void)selectAlpha:(NSNotification *)sender {
    NSString *alpha = [sender.userInfo objectForKey:@"alpha"];
    [carAlphaButton setTitle:alpha forState:UIControlStateNormal];
}

- (void)selectProvince:(NSNotification *)sender {
    NSString *province = [sender.userInfo objectForKey:@"province"];
    [provinceButton setTitle:province forState:UIControlStateNormal];
}

- (void)setCarBrandAndModel:(id)sender {
    NSString *carBrand = [[SharedInfo shared].carBrand objectForKey:@"configName"];
    NSThread *carModel = [[SharedInfo shared].carModel objectForKey:@"configName"];
    [carBrandButton setTitle:[NSString stringWithFormat:@"%@ %@", carBrand, carModel] forState:UIControlStateNormal];
}

#pragma mark- Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark- Picker view dataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [pickerViewArray count];
}

#pragma mark- Picker view delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.view.frame.size.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return self.view.frame.size.width * 11.0/80.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (row == currentRow) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.width * 11.0/80.0)];
        [imageView setImage:[UIImage imageNamed:@"carInfoSelectedBack"]];
        UILabel *myLabel = [[UILabel alloc] initWithFrame:imageView.bounds];
        [myLabel setTextAlignment:NSTextAlignmentCenter];
        [myLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:12.0]];
        [myLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
        [myLabel setText:[pickerViewArray objectAtIndex:row]];
        [imageView addSubview:myLabel];
            
        return imageView;
    } else {
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.width * 11.0/80.0)];
        [myLabel setTextAlignment:NSTextAlignmentCenter];
        [myLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:12.0]];
        [myLabel setTextColor:[UIColor whiteColor]];
        [myLabel setText:[pickerViewArray objectAtIndex:row]];
        
        return myLabel;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    currentRow = row;
    
    if (pickerType == 1) {
        carTypeIndex = row;
    } else {
        carColorIndex = row;
    }
    
    [pickerView reloadAllComponents];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
   
    return true;
}

- (void)pickerViewTapGestureRecognized:(UITapGestureRecognizer*)gestureRecognizer
{
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    
    CGRect frame = myPickerView.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, myPickerView.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) )
    {
        NSInteger rowNm = [myPickerView selectedRowInComponent:0];
        
        if(currentRow == rowNm) {
            //触发确认事件
            NSLog( @"Selected Row: %@", [pickerViewArray objectAtIndex:rowNm] );
            
            pickerBackView.hidden = YES;
            
            if (pickerBackView.tag == 1) {
                carTypeStr = [pickerViewArray objectAtIndex:[myPickerView selectedRowInComponent:0]];
                [carTypeButton setTitle:carTypeStr forState:UIControlStateNormal];
            } else if (pickerBackView.tag == 2) {
                carColorStr = [pickerViewArray objectAtIndex:[myPickerView selectedRowInComponent:0]];
                [carColorButton setTitle:carColorStr forState:UIControlStateNormal];
            }
        }
        
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

@end
