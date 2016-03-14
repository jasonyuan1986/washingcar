//
//  MineViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 2/2/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "MineViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <JSONKit-NoWarning/JSONKit.h>

@interface MineViewController () <UITextFieldDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>
{
    UIImageView *backgroundImage;
    UIButton *myContactButton;
    UIImageView *myNameBack;
    UITextField *myNameField;
    UIImageView *myMoneyBack;
    UILabel *myMoneyLabel;
    UIButton *addMoneyButton;
    UIImageView *lailabiBack;
    UILabel *lailabiLabel;
    UIImageView *finishOrderBack;
    UILabel *finishOrderLabel;
    UILabel *contactLabel;
    UIImageView *phoneBack;
    UIButton *phoneLabel;
    UIImageView *emailBack;
    UIButton *emailLabel;
    
    // Add Money View
    UIControl *addMoneyBackView;
    UIImageView *addBackgroundImage;
    UIButton *pickerConfirmButton;
    UIButton *pickerCancelButton;
    UILabel *leftMoneyLabel;
    UIImageView *fieldBack;
    UITextField *addMoneyNumber;
}

@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:USERINFO parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSArray *cookies = manager.session.configuration.HTTPCookieStorage.cookies;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"cookies"];
        [self setUserInfo:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"网络连接异常";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        LoggerApp(1, @"Result: %@", [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:tap];
    
    backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backgroundImage setImage:[UIImage imageNamed:@"backgroundImage"]];
    [self.view addSubview:backgroundImage];
    
    myContactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myContactButton.frame = CGRectMake(0.0, self.view.frame.size.width * 79.0/320.0, self.view.frame.size.width, self.view.frame.size.width * 96.0/640.0);
    [myContactButton setBackgroundImage:[UIImage imageNamed:@"mycontact"] forState:UIControlStateNormal];
    [myContactButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [myContactButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [myContactButton setTitle:@"你的联系方式" forState:UIControlStateNormal];
    [myContactButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [myContactButton setContentEdgeInsets:UIEdgeInsetsMake(0.0, self.view.frame.size.width * 150.0/640.0, 0.0, 0.0)];
    [myContactButton addTarget:self action:@selector(myContactButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myContactButton];
    
    myNameBack = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, myContactButton.frame.origin.y + myContactButton.frame.size.height, self.view.frame.size.width, self.view.frame.size.width * 96.0/640.0)];
    [myNameBack setImage:[UIImage imageNamed:@"myname"]];
    [self.view addSubview:myNameBack];
    
    UIColor *color = [UIColor whiteColor];
    
    myNameField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 150.0/640.0, myNameBack.frame.origin.y + self.view.frame.size.width * 26.0/640.0, 260.0, 30.0)];
    myNameField.delegate = self;
    myNameField.tag = 1;
    myNameField.borderStyle = UITextBorderStyleNone;
    [myNameField setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [myNameField setTextColor:color];
    myNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"您的称呼，如：刘先生/女士" attributes:@{NSForegroundColorAttributeName: color}];
    [self.view addSubview:myNameField];
    
    myMoneyBack = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, myNameBack.frame.origin.y + myNameBack.frame.size.height, self.view.frame.size.width, self.view.frame.size.width * 96.0/640.0)];
    [myMoneyBack setImage:[UIImage imageNamed:@"mymoney"]];
    [self.view addSubview:myMoneyBack];
    
    myMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 150.0/640.0, myMoneyBack.frame.origin.y + self.view.frame.size.width * 32.0/640.0, 120.0, 21.0)];
    [myMoneyLabel setTextColor:color];
    [myMoneyLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [myMoneyLabel setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:myMoneyLabel];
    
    addMoneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addMoneyButton.frame = CGRectMake(self.view.frame.size.width * 440.0/640.0, myMoneyBack.frame.origin.y + self.view.frame.size.width * 18.0/640.0, 60.0, 30.0);
    [addMoneyButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
    [addMoneyButton setBackgroundColor:[UIColor clearColor]];
    [addMoneyButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
    [addMoneyButton setTitle:@"立即充值" forState:UIControlStateNormal];
    [addMoneyButton addTarget:self action:@selector(addMoneyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addMoneyButton];
    
    lailabiBack = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, myMoneyBack.frame.origin.y + myMoneyBack.frame.size.height, self.view.frame.size.width, self.view.frame.size.width * 96.0/640.0)];
    [lailabiBack setImage:[UIImage imageNamed:@"lailabi"]];
    [self.view addSubview:lailabiBack];
    
    lailabiLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 150.0/640.0, lailabiBack.frame.origin.y + self.view.frame.size.width * 32.0/640.0, 120.0, 21.0)];
    [lailabiLabel setTextColor:color];
    [lailabiLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [lailabiLabel setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:lailabiLabel];
    
    finishOrderBack = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, lailabiBack.frame.origin.y + lailabiBack.frame.size.height, self.view.frame.size.width, self.view.frame.size.width * 96.0/640.0)];
    finishOrderBack.userInteractionEnabled = YES;
    [finishOrderBack setImage:[UIImage imageNamed:@"myordercount"]];
    [self.view addSubview:finishOrderBack];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrder:)];
    [finishOrderBack addGestureRecognizer:tap2];
    
    finishOrderLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 150.0/640.0, finishOrderBack.frame.origin.y + self.view.frame.size.width * 32.0/640.0, 120.0, 21.0)];
    [finishOrderLabel setTextColor:color];
    [finishOrderLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [finishOrderLabel setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:finishOrderLabel];
    
    contactLabel = [[UILabel alloc] init];
    [contactLabel setTextColor:color];
    [contactLabel setTextAlignment:NSTextAlignmentCenter];
    [contactLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [contactLabel setText:@"联系我们"];
    [self.view addSubview:contactLabel];
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactLabel.superview);
        make.right.equalTo(contactLabel.superview);
        make.bottom.equalTo(contactLabel.superview).offset(-100);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 16.0));
    }];
    
    phoneBack = [[UIImageView alloc] init];
    [phoneBack setImage:[UIImage imageNamed:@"servicephone"]];
    [self.view addSubview:phoneBack];
    [phoneBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneBack.superview);
        make.right.equalTo(phoneBack.superview);
        make.top.equalTo(contactLabel.mas_bottom).offset(4);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 48.0));
    }];
    
    
    phoneLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneLabel setBackgroundColor:[UIColor clearColor]];
    phoneLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [phoneLabel setTitleColor:color forState:UIControlStateNormal];
    [phoneLabel.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [phoneLabel addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    [phoneBack addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLabel.superview).offset(self.view.frame.size.width * 105.0/320.0);
        make.top.equalTo(phoneLabel.superview).offset(18);
        make.size.mas_equalTo(CGSizeMake(200.0, 16.0));
    }];
    
    emailBack = [[UIImageView alloc] init];
    [emailBack setImage:[UIImage imageNamed:@"email"]];
    [self.view addSubview:emailBack];
    [emailBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(emailBack.superview);
        make.right.equalTo(emailBack.superview);
        make.top.equalTo(phoneBack.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 48.0));
    }];
    
    emailLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [emailLabel setBackgroundColor:[UIColor clearColor]];
    emailLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [emailLabel setTitleColor:color forState:UIControlStateNormal];
    [emailLabel.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [emailLabel addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];
    [emailBack addSubview:emailLabel];
    [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(emailLabel.superview).offset(self.view.frame.size.width * 105.0/320.0);
        make.top.equalTo(emailLabel.superview).offset(15);
        make.size.mas_equalTo(CGSizeMake(200.0, 16.0));
    }];
    
    addMoneyBackView = [[UIControl alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 634.0/640.0, self.view.frame.size.width, self.view.frame.size.height/2.0)];
    [addMoneyBackView addTarget:self action:@selector(addMoneyBackViewTap:) forControlEvents:UIControlEventTouchDown];
    addMoneyBackView.hidden = YES;
    [self.view addSubview:addMoneyBackView];
    
    addBackgroundImage = [[UIImageView alloc] initWithFrame:addMoneyBackView.bounds];
    [addBackgroundImage setImage:[UIImage imageNamed:@"historyLocationPickerBack"]];
    [addMoneyBackView addSubview:addBackgroundImage];
    
    pickerConfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pickerConfirmButton setFrame:CGRectMake(0.0, 0.0, 80, 50)];
    [pickerConfirmButton setBackgroundColor:[UIColor clearColor]];
    [pickerConfirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [pickerConfirmButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:15.0]];
    [pickerConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pickerConfirmButton addTarget:self action:@selector(pickerConfirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [addMoneyBackView addSubview:pickerConfirmButton];
    
    pickerCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pickerCancelButton setFrame:CGRectMake(self.view.frame.size.width - 80.0, 0.0, 80.0, 50.0)];
    [pickerCancelButton setBackgroundColor:[UIColor clearColor]];
    [pickerCancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [pickerCancelButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:15.0]];
    [pickerCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pickerCancelButton addTarget:self action:@selector(pickerCancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [addMoneyBackView addSubview:pickerCancelButton];
    
    leftMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 126.0/640.0, self.view.frame.size.width, 16.0)];
    [leftMoneyLabel setTextAlignment:NSTextAlignmentCenter];
    [leftMoneyLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [leftMoneyLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [addMoneyBackView addSubview:leftMoneyLabel];
    
    fieldBack = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 188.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 96.0/640.0)];
    [fieldBack setImage:[UIImage imageNamed:@"washPriceBack"]];
    [addMoneyBackView addSubview:fieldBack];
    
    addMoneyNumber = [[UITextField alloc] initWithFrame:CGRectMake(0.0, fieldBack.frame.origin.y + self.view.frame.size.width * 26.0/640.0, self.view.frame.size.width, 30.0)];
    addMoneyNumber.delegate = self;
    addMoneyNumber.tag = 2;
    addMoneyNumber.keyboardType = UIKeyboardTypeNumberPad;
    addMoneyNumber.borderStyle = UITextBorderStyleNone;
    [addMoneyNumber setTextAlignment:NSTextAlignmentCenter];
    [addMoneyNumber setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [addMoneyNumber setTextColor:color];
    addMoneyNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入充值金额" attributes:@{NSForegroundColorAttributeName: color}];
    [addMoneyBackView addSubview:addMoneyNumber];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    // Test
    [phoneLabel setTitle:[SharedInfo shared].phoneNumber forState:UIControlStateNormal];
    [emailLabel setTitle:[SharedInfo shared].emailAddress forState:UIControlStateNormal];
}

- (void)appWillResignActive:(id)sender {
    [addMoneyNumber resignFirstResponder];
}

- (void)showOrder:(id)sender {
    [self performSegueWithIdentifier:@"showOrder" sender:nil];
}

- (void)callPhone {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneLabel.titleLabel.text]]];
}

- (void)sendEmail {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", emailLabel.titleLabel.text]]];
}

- (void)setUserInfo:(id)object {
    NSDictionary *result = [object objectFromJSONData];
    
    NSNumber *success = [result objectForKey:@"success"];
    
    if ([success integerValue] == 1) {
        
    } else {
        NSString *message = [result objectForKey:@"message"];
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
    
    NSLog(@"%@", result);
    NSDictionary *userInfo = [result objectForKey:@"data"];
    [SharedInfo shared].userInfo = userInfo;
    NSNumber *balance = [userInfo objectForKey:@"balance"];
    NSNumber *point = [userInfo objectForKey:@"point"];
    NSString *phoneNumber = [userInfo objectForKey:@"phone"];
    if ([phoneNumber isEqual:[NSNull null]]) {
        phoneNumber = @"null";
    }
    NSNumber *orderCount = [userInfo objectForKey:@"orderCount"];
    NSString *userName = [userInfo objectForKey:@"userName"];
    if ([userName isEqual:[NSNull null]]) {
        userName = @"";
    }
    
    [myContactButton setTitle:phoneNumber forState:UIControlStateNormal];
    [myNameField setText:userName];
    [myMoneyLabel setText:[NSString stringWithFormat:@"%.2f", [balance floatValue]]];
    [finishOrderLabel setText:[NSString stringWithFormat:@"已完成%d次订单", [orderCount intValue]]];
    [lailabiLabel setText:[NSString stringWithFormat:@"来啦币：%.1f", [point floatValue]]];
    [leftMoneyLabel setText:[NSString stringWithFormat:@"余额：%.1f元", [balance floatValue]]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id theSegue = segue.destinationViewController;
    
    if ([segue.identifier isEqual:@"showPay"]) {
        [theSegue setValue:addMoneyNumber.text forKey:@"money"];
    }
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)addMoneyButtonPressed:(id)sender {
    addMoneyBackView.hidden = NO;
}

- (void)myContactButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注销" message:@"是否切换当前用户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)addMoneyBackViewTap:(id)sender {
    [addMoneyNumber resignFirstResponder];
}

- (void)pickerConfirmButtonPressed:(id)sender {
    if ([addMoneyNumber.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"金额不能为空";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        return;
    }
    [addMoneyNumber resignFirstResponder];
    addMoneyBackView.hidden = YES;
    [self performSegueWithIdentifier:@"showPay" sender:self];
}

- (void)pickerCancelButtonPressed:(id)sender {
    [addMoneyNumber resignFirstResponder];
    addMoneyBackView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewTap:(id)sender {
    [myNameField resignFirstResponder];
    [self changeName];
}

- (void)changeName {
    if (myNameField.text.length > 5) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入正确的名称";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        [myNameField becomeFirstResponder];
        return;
    } else if (myNameField.text.length == 0) {
        NSString *name = [[SharedInfo shared].userInfo objectForKey:@"userName"];
        [myNameField setText:name];
    }
    
    NSDictionary *parameters = @{@"userName": myNameField.text};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:CHANGENAME parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        NSNumber *success = [resultDic objectForKey:@"success"];
        
        if ([success intValue] == 1) {
            [manager GET:USERINFO parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSData *data = responseObject;
                NSDictionary *resultDic = [data objectFromJSONData];
                LoggerApp(2, @"用户信息：%@", resultDic);
                NSNumber *success = [resultDic objectForKey:@"success"];
                if ([success integerValue] == 1) {
                    [SharedInfo shared].userInfo = [resultDic objectForKey:@"data"];
                } else {
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"everSignedIn"];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                LoggerError(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                            [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                            [error.userInfo objectForKey:@"NSLocalizedDescription"]);
                NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
                LoggerError(1, @"Result: %@", result);
            }];
        } else {
            NSString *message = [resultDic objectForKey:@"success"];
            if (![message isEqual:[NSNull null]]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = message;
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    // Do something...
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerApp(1, @"Result: %@", result);
    }];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:LOGOUT parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                      [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                      [error.userInfo objectForKey:@"NSLocalizedDescription"]);
            NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
            LoggerApp(1, @"Result: %@", result);
        }];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"everSignedIn"];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"cookies"];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:nil];
        
        [self performSegueWithIdentifier:@"showLogin" sender:self];
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

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return true;
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 2) {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 216.0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField.tag == 1) {
        [self changeName];
    }
    return  YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 2) {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 216.0, self.view.frame.size.width, self.view.frame.size.height)];
    }
}

@end
