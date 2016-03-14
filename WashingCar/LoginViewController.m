//  来啦洗车登录
//  LoginViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 2/13/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "LoginViewController.h"
#import "SharedInfo.h"
#import "APService.h"
#import <AFNetworking/AFNetworking.h>
#import <JSONKit-NoWarning/JSONKit.h>
#import "ShopViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
{
    NSTimeInterval timeInterval;
    NSInteger seconds;
    NSTimer *myTimer;
    UIImageView *loginFieldBack;
    UIImageView *loginFieldBack2;
    UIImageView *loginFieldBack3;
    UITextField *phoneNumberField;
    UITextField *authCodeField;
    UITextField *tuijianField;
    UIButton *getAuthButton;
    UIButton *loginButton;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    timeInterval = 1.0;
    seconds = 60;
    
    loginFieldBack = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 158.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 96.0/640.0)];
    [loginFieldBack setImage:[UIImage imageNamed:@"loginFieldBack"]];
    [self.view addSubview:loginFieldBack];
    
    loginFieldBack2 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, loginFieldBack.frame.origin.y + loginFieldBack.frame.size.height, self.view.frame.size.width, self.view.frame.size.width * 96.0/640.0)];
    [loginFieldBack2 setImage:[UIImage imageNamed:@"loginFieldBack"]];
    [self.view addSubview:loginFieldBack2];
    
    loginFieldBack3 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, loginFieldBack2.frame.origin.y + loginFieldBack2.frame.size.height, self.view.frame.size.width, self.view.frame.size.width * 96.0/640.0)];
    [loginFieldBack3 setImage:[UIImage imageNamed:@"loginFieldBack"]];
    [self.view addSubview:loginFieldBack3];
    
    UIColor *color = [UIColor whiteColor];
    phoneNumberField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 86.0/640.0, loginFieldBack.frame.origin.y + self.view.frame.size.width * 18.0/640.0, 400.0, 30.0)];
    phoneNumberField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入手机号码" attributes:@{NSForegroundColorAttributeName: color}];
    [phoneNumberField setTextColor:color];
    phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberField.delegate = self;
    [self.view addSubview:phoneNumberField];
    
    getAuthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    getAuthButton.frame = CGRectMake(self.view.frame.size.width * 440.0/640.0, loginFieldBack.frame.origin.y, self.view.frame.size.width * 200.0/640.0, self.view.frame.size.width * 96.0/640.0);
    [getAuthButton setBackgroundColor:YELLOWCOLOR];
    [getAuthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [getAuthButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getAuthButton addTarget:self action:@selector(getAuthButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getAuthButton];
    
    authCodeField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 86.0/640.0, loginFieldBack2.frame.origin.y + self.view.frame.size.width * 18.0/640.0, 400.0, 30.0)];
    authCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入验证码" attributes:@{NSForegroundColorAttributeName: color}];
    [authCodeField setTextColor:color];
    authCodeField.keyboardType = UIKeyboardTypeNumberPad;
    authCodeField.delegate = self;
    [self.view addSubview:authCodeField];
    
    tuijianField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 86.0/640.0, loginFieldBack3.frame.origin.y + self.view.frame.size.width * 18.0/640.0, 400.0, 30.0)];
    tuijianField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"推荐码（选填）" attributes:@{NSForegroundColorAttributeName: color}];
    [tuijianField setTextColor:color];
//    authCodeField.keyboardType = UIKeyboardTypeNumberPad;
    tuijianField.delegate = self;
    [self.view addSubview:tuijianField];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(0.0, self.view.frame.size.width * 460.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 88.0/640.0);
    [loginButton setBackgroundColor:YELLOWCOLOR];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)getAuthButtonPressed:(id)sender {
    if (phoneNumberField.text.length != 11) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入正确的手机号";
        [phoneNumberField becomeFirstResponder];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        return;
    }
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerBegin:) userInfo:nil repeats:YES];
    getAuthButton.enabled = NO;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"phone": phoneNumberField.text};
    [manager POST:AUTHCODE parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerApp(1, @"Result: %@", result);
    }];
}

- (void)timerBegin:(id)sender {
    [getAuthButton setTitle:[NSString stringWithFormat:@"重发(%ld)", (long)seconds] forState:UIControlStateNormal];
    
    seconds--;
    
    if (seconds == 0) {
        [myTimer invalidate];
        [getAuthButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        getAuthButton.enabled = YES;
        seconds = 60;
    }
}

- (void)loginButtonPressed:(id)sender {
    if (phoneNumberField.text.length != 11) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入正确的手机号";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        return;
    }
    
    if (authCodeField.text.length != 6) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入收到的验证码";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        return;
    }
    
    [phoneNumberField resignFirstResponder];
    [authCodeField resignFirstResponder];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"phone": phoneNumberField.text, @"authCode": authCodeField.text, @"shareCode": tuijianField.text};
    [manager POST:NEWREGISTER parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        NSNumber *success = [resultDic objectForKey:@"success"];
        
        if ([success integerValue] == 1) {
            [manager GET:WASHPRICE parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSData *data = responseObject;
                NSDictionary *resultDic = [data objectFromJSONData];
                NSDictionary *dataDict = [resultDic objectForKey:@"data"];
                
                if ([[[dataDict objectForKey:@"firstOrder"] stringValue] isEqualToString:@"1"]) {
                    [SharedInfo shared].firstOrder = @"true";
                } else {
                    [SharedInfo shared].firstOrder = @"false";
                }
                [SharedInfo shared].washPrice = [dataDict objectForKey:@"list"];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                          [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                          [error.userInfo objectForKey:@"NSLocalizedDescription"]);
                NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
                LoggerApp(1, @"Result: %@", result);
            }];
            
            [manager GET:USERINFO parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSData *data = responseObject;
                NSDictionary *resultDic = [data objectFromJSONData];
                NSNumber *success = [resultDic objectForKey:@"success"];
                if ([success integerValue] == 1) {
                    [SharedInfo shared].userInfo = [resultDic objectForKey:@"data"];
                } else {
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"everSignedIn"];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                          [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                          [error.userInfo objectForKey:@"NSLocalizedDescription"]);
                NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
                LoggerApp(1, @"Result: %@", result);
            }];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everSignedIn"];
            NSArray *cookies = manager.session.configuration.HTTPCookieStorage.cookies;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"cookies"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasCookies"];
            
            NSString *phone = [resultDic objectForKey:@"phone"];
            
            [APService setTags:nil alias:phone callbackSelector:nil object:nil];
            
            if ([[SharedInfo shared].loginType isEqualToString:@"Wash"]) {
                [self performSegueWithIdentifier:@"showWashCar" sender:self];
            } else if ([[SharedInfo shared].loginType isEqualToString:@"Member"]) {
                [self performSegueWithIdentifier:@"showMember" sender:self];
            } else if ([[SharedInfo shared].loginType isEqualToString:@"Share"]) {
                [self performSegueWithIdentifier:@"showShare" sender:self];
            } else if ([[SharedInfo shared].loginType isEqualToString:@"Shop"]) {
                ShopViewController *shopViewController = [[ShopViewController alloc] init];
                [self.navigationController pushViewController:shopViewController animated:YES];
            } else {
                [self performSegueWithIdentifier:@"showMine" sender:self];
            }
        } else {
            NSString *message = [resultDic objectForKey:@"message"];
            if ([message isEqual:[NSNull null]]) {
                message = @"未知错误";
            }
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = message;
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerApp(1, @"Result: %@", result);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
