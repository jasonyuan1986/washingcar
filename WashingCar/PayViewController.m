//
//  PayViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 3/9/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "PayViewController.h"
#import "SharedInfo.h"
#import <AFNetworking/AFNetworking.h>
#import <JSONKit-NoWarning/JSONKit.h>
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"
#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"
#import "YouhuiDetailViewController.h"

@interface PayViewController () <UITableViewDataSource, UITableViewDelegate, UPPayPluginDelegate, UITextFieldDelegate>
{
    UITableView *myTableView;
    UIButton *confirmButton;
    NSInteger payType;
    NSString *payId;
    
    UIImageView *youhuiquan;
    UIImageView *youhuima;
    UIButton *radioyouhuiquan;
    UIButton *radioyouhuima;
    UILabel *youhuiquanLabel;
    UITextField *youhuimaField;
    UILabel *priceLabel;
    UIScrollView *myScrollView;
    
    NSDictionary *youhuiquanDict;
    NSNumber *disCountVal;
    NSInteger amountPrice;
    NSNumber *ticketId;
    NSString *discountCode;
    NSString *youhuiquanSize;
    
    BOOL isFromDetail;
}

@end

@implementation PayViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[SharedInfo shared].firstOrder isEqualToString:@"true"]) {
        radioyouhuiquan.enabled = NO;
        radioyouhuima.enabled = NO;
        youhuimaField.enabled = NO;
    }
    if (!isFromDetail) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:COUPONCOUNT parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSData *data = responseObject;
            NSDictionary *resultDic = [data objectFromJSONData];
            LoggerApp(1, @"%@", resultDic);
            NSDictionary *dataDict = [resultDic objectForKey:@"data"];
            youhuiquanSize = [dataDict objectForKey:@"size"];
            [youhuiquanLabel setText:[NSString stringWithFormat:@"可用优惠券（%@）", youhuiquanSize]];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            LoggerApp(1, @"Error: %@", error.userInfo);
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 800.0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    amountPrice = [[SharedInfo shared].totalAmount integerValue];
    // Do any additional setup after loading the view.
    amountPrice = [[SharedInfo shared].totalAmount integerValue];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [myScrollView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:myScrollView];
    
    myTableView = [[UITableView alloc] init];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.scrollEnabled = NO;
    [myTableView setBackgroundColor:[UIColor clearColor]];
    [myScrollView addSubview:myTableView];
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myTableView.superview);
        make.top.equalTo(myTableView.superview).offset(79);
        make.right.equalTo(myTableView.superview);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 240.0));
    }];

    youhuiquan = [[UIImageView alloc] init];
    youhuiquan.userInteractionEnabled = YES;
    [youhuiquan setImage:[UIImage imageNamed:@"youhuiquan"]];
    [myScrollView addSubview:youhuiquan];
    [youhuiquan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(youhuiquan.superview);
        make.top.equalTo(myTableView.mas_bottom).offset(40);
        make.right.equalTo(youhuiquan.superview);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 48.0));
    }];
    
    youhuiquanLabel = [[UILabel alloc] init];
    youhuiquanLabel.textAlignment = NSTextAlignmentCenter;
    [youhuiquanLabel setFont:HEITISC13];
    [youhuiquanLabel setTextColor:[UIColor whiteColor]];
    [youhuiquan addSubview:youhuiquanLabel];
    [youhuiquanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(youhuiquanLabel.superview);
        make.size.mas_equalTo(CGSizeMake(240, 20));
    }];
    
    radioyouhuiquan = [[UIButton alloc] init];
    [radioyouhuiquan setBackgroundImage:[UIImage imageNamed:@"extraNotSelectedButton"] forState:UIControlStateNormal];
    [radioyouhuiquan setBackgroundImage:[UIImage imageNamed:@"extraSelectedButton"] forState:UIControlStateSelected];
    [radioyouhuiquan addTarget:self action:@selector(raidoquan:) forControlEvents:UIControlEventTouchUpInside];
    [youhuiquan addSubview:radioyouhuiquan];
    [radioyouhuiquan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(radioyouhuiquan.superview).offset(10);
        make.top.equalTo(radioyouhuiquan.superview).offset(13);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(youhuiquantaped:)];
    [youhuiquan addGestureRecognizer:tap];
    
    youhuima = [[UIImageView alloc] init];
    youhuima.userInteractionEnabled = YES;
    [youhuima setImage:[UIImage imageNamed:@"youhuiquan"]];
    [myScrollView addSubview:youhuima];
    [youhuima mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(youhuima.superview);
        make.top.equalTo(youhuiquan.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 48.0));
    }];
    
    radioyouhuima = [[UIButton alloc] init];
    [radioyouhuima setBackgroundImage:[UIImage imageNamed:@"extraNotSelectedButton"] forState:UIControlStateNormal];
    [radioyouhuima setBackgroundImage:[UIImage imageNamed:@"extraSelectedButton"] forState:UIControlStateSelected];
    [radioyouhuima addTarget:self action:@selector(radioma:) forControlEvents:UIControlEventTouchUpInside];
    [youhuima addSubview:radioyouhuima];
    [radioyouhuima mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(radioyouhuima.superview).offset(10);
        make.top.equalTo(radioyouhuima.superview).offset(13);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    UIColor *color = [UIColor whiteColor];
    youhuimaField = [[UITextField alloc] init];
    youhuimaField.delegate = self;
    youhuimaField.textAlignment = NSTextAlignmentCenter;
    youhuimaField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入折扣码" attributes:@{NSForegroundColorAttributeName: color}];
    youhuimaField.font = HEITISC13;
    youhuimaField.textColor = [UIColor whiteColor];
    [youhuima addSubview:youhuimaField];
    [youhuimaField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(youhuimaField.superview).offset(40);
        make.right.equalTo(youhuimaField.superview).offset(-40);
        make.centerY.equalTo(youhuimaField.superview);
    }];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(youhuiquantaped2:)];
    [youhuima addGestureRecognizer:tap2];

    priceLabel = [[UILabel alloc] init];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.text = [NSString stringWithFormat:@"需要支付金额%ld元", (long)amountPrice];
    [myScrollView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLabel.superview);
        make.right.equalTo(priceLabel.superview);
        make.top.equalTo(youhuima.mas_bottom).offset(10);
    }];
    
    confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [confirmButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmButton.superview);
        make.right.equalTo(confirmButton.superview);
        make.top.equalTo(priceLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 44.0));
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySucceed:) name:@"PayOrderController" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(useYouhuiquan:) name:@"userYouhuiquan" object:nil];
}

- (void)youhuiquantaped:(id)sender {
    if (![[SharedInfo shared].firstOrder isEqualToString:@"true"]) {
        isFromDetail = NO;
        youhuiquanDict = nil;
        ticketId = nil;
        YouhuiDetailViewController *youhuiDetail = [[YouhuiDetailViewController alloc] init];
        [self.navigationController pushViewController:youhuiDetail animated:YES];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"首次下单，不能使用抵用券";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
}

- (void)youhuiquantaped2:(id)sender {
    if (![[SharedInfo shared].firstOrder isEqualToString:@"true"]) {
        
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"首次下单，不能使用折扣码";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
}

- (void)useYouhuiquan:(id)sender {
    isFromDetail = YES;
    radioyouhuiquan.selected = YES;
    radioyouhuima.selected = NO;
    amountPrice = [[SharedInfo shared].totalAmount integerValue];
    NSNotification *notification = sender;
    youhuiquanDict = notification.userInfo;
    
    NSNumber *val = [youhuiquanDict objectForKey:@"val"];
    amountPrice = amountPrice - [val integerValue];
    ticketId = [youhuiquanDict objectForKey:@"ticketId"];
    [youhuiquanLabel setText:[NSString stringWithFormat:@"抵扣%@元", val]];
    priceLabel.text = [NSString stringWithFormat:@"需要支付金额%ld元", (long)amountPrice];
}

- (void)raidoquan:(id)sender {
    UIButton *button = sender;
    if (button.selected) {
        amountPrice = [[SharedInfo shared].totalAmount integerValue];
        [youhuiquanLabel setText:[NSString stringWithFormat:@"可用优惠券（%@）", youhuiquanSize]];
        priceLabel.text = [NSString stringWithFormat:@"需要支付金额%ld元", (long)amountPrice];
    } else {
        radioyouhuima.selected = NO;
        if (youhuiquanDict != nil) {
            amountPrice = [[SharedInfo shared].totalAmount integerValue];
            NSNumber *val = [youhuiquanDict objectForKey:@"val"];
            amountPrice = amountPrice - [val integerValue];
            ticketId = [youhuiquanDict objectForKey:@"ticketId"];
            [youhuiquanLabel setText:[NSString stringWithFormat:@"抵扣%@元", val]];
            priceLabel.text = [NSString stringWithFormat:@"需要支付金额%ld元", (long)amountPrice];
        } else {
            amountPrice = [[SharedInfo shared].totalAmount integerValue];
            priceLabel.text = [NSString stringWithFormat:@"需要支付金额%ld元", (long)amountPrice];
        }
    }
    
    button.selected = !button.selected;
}

- (void)radioma:(id)sender {
    UIButton *button = sender;
    if (button.selected) {
        amountPrice = [[SharedInfo shared].totalAmount integerValue];
        priceLabel.text = [NSString stringWithFormat:@"需要支付金额%ld元", (long)amountPrice];
    } else {
        radioyouhuiquan.selected = NO;
        
        if (![youhuimaField.text isEqualToString:@""]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager GET:[NSString stringWithFormat:@"%@%@", DISCOUNTCODE, youhuimaField.text] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSData *data = responseObject;
                NSDictionary *resultDic = [data objectFromJSONData];
                LoggerApp(1, @"%@", resultDic);
                
                NSNumber *success = [resultDic objectForKey:@"success"];
                if ([success integerValue] == 1) {
                    NSDictionary *data = [resultDic objectForKey:@"data"];
                    disCountVal = [data objectForKey:@"val"];
                    
                    amountPrice = [[SharedInfo shared].totalAmount integerValue];
                    amountPrice = amountPrice - [disCountVal integerValue];
                    
                    priceLabel.text = [NSString stringWithFormat:@"需要支付金额%ld元", (long)amountPrice];
                } else {
                    NSString *messageUTF8 = [resultDic objectForKey:@"message"];
                    
                    const char *messagePoint = [messageUTF8 UTF8String];
                    NSString *message = [NSString stringWithCString:messagePoint encoding:NSUTF8StringEncoding];
                    
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
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                LoggerApp(1, @"Error: %@", error.userInfo);
            }];
        } else {
            amountPrice = [[SharedInfo shared].totalAmount integerValue];
            priceLabel.text = [NSString stringWithFormat:@"需要支付金额%ld元", (long)amountPrice];
        }
    }
    
    button.selected = !button.selected;
}

- (void)paySucceed:(id)sender {
    [SharedInfo shared].currentCarIndex = nil;
    [SharedInfo shared].currentCar = nil;
    [SharedInfo shared].currentLatitude = 0.0;
    [SharedInfo shared].currentLongitude = 0.0;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"购买成功";
    hud.detailsLabelText = @"您的洗车技师会在接近洗车时间和您联系";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // Do something...
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
    [self getCoupon];
}

- (void)getCoupon {
    [self performSegueWithIdentifier:@"showShare" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id theSegue = segue.destinationViewController;
    
    [theSegue setValue:payId forKey:@"payId"];
}

- (void)confirmButtonPressed:(id)sender {
    if (radioyouhuiquan.selected) {
        if (youhuiquanDict == nil) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请选择优惠券";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            return;
        } else {
            discountCode = nil;
        }
        [self makeSingleOrder];
    } else if (radioyouhuima.selected) {
        if ([youhuimaField.text isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请输入优惠码";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            return;
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:[NSString stringWithFormat:@"%@%@", DISCOUNTCODE, youhuimaField.text] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSData *data = responseObject;
            NSDictionary *resultDic = [data objectFromJSONData];
            LoggerApp(1, @"%@", resultDic);
            
            NSNumber *success = [resultDic objectForKey:@"success"];
            if ([success integerValue] == 1) {
                NSDictionary *data = [resultDic objectForKey:@"data"];
                disCountVal = [data objectForKey:@"val"];
                
                amountPrice = [[SharedInfo shared].totalAmount integerValue];
                amountPrice = amountPrice - [disCountVal integerValue];
                
                priceLabel.text = [NSString stringWithFormat:@"需要支付金额%ld元", (long)amountPrice];
                
                [self makeSingleOrder];
            } else {
                NSString *messageUTF8 = [resultDic objectForKey:@"message"];
                
                const char *messagePoint = [messageUTF8 UTF8String];
                NSString *message = [NSString stringWithCString:messagePoint encoding:NSUTF8StringEncoding];
                
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
            LoggerApp(1, @"Error: %@", error.userInfo);
        }];
    } else {
        discountCode = nil;
        ticketId = nil;
        [self makeSingleOrder];
    }
    
}

- (void)makeSingleOrder
{
    switch (payType) {
        case 0:
        {
            // 支付宝支付
            NSDictionary *locationDict = @{@"address": [SharedInfo shared].currentLocation, @"lat": [NSNumber numberWithFloat:[SharedInfo shared].currentLatitude], @"lon":[NSNumber numberWithFloat:[SharedInfo shared].currentLongitude]};
            NSString *locationJson = [locationDict JSONString];
            
            NSArray *timeArray = [[SharedInfo shared].washTime componentsSeparatedByString:@" "];
            NSString *date = [timeArray objectAtIndex:0];
            NSString *formatDate = [date stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            NSString *startAllTime = [timeArray objectAtIndex:1];
            NSString *endAllTime = [timeArray objectAtIndex:3];
            NSArray *startArray = [startAllTime componentsSeparatedByString:@":"];
            NSArray *endArray = [endAllTime componentsSeparatedByString:@":"];
            NSString *startTime = [startArray objectAtIndex:0];
            NSString *endTime = [endArray objectAtIndex:0];
            
            NSMutableString *extrIdStr = [[NSMutableString alloc] init];
            NSMutableArray *extraArray = [SharedInfo shared].extraIds;
            
            for (int i = 0; i < [extraArray count]; i++) {
                if (i == 0) {
                    [extrIdStr appendString:[[extraArray objectAtIndex:i] stringValue]];
                } else if (i == [extraArray count] - 1) {
                    [extrIdStr appendString:@","];
                    [extrIdStr appendString:[[extraArray objectAtIndex:i] stringValue]];
                } else {
                    [extrIdStr appendString:@","];
                    [extrIdStr appendString:[[extraArray objectAtIndex:i] stringValue]];
                }
            }
            
            NSDictionary *parameters = @{@"payType": @"1", @"productId": [SharedInfo shared].productId, @"buyUser": [[SharedInfo shared].userInfo objectForKey:@"userId"], @"orderDate": formatDate, @"phone": [[SharedInfo shared].userInfo objectForKey:@"phone"], @"carNum": [[SharedInfo shared].currentCar objectForKey:@"carNum"], @"carInfo": [NSString stringWithFormat:@"%@ %@ %@", [[SharedInfo shared].currentCar objectForKey:@"carBrand"], [[SharedInfo shared].currentCar objectForKey:@"carModel"], [[SharedInfo shared].currentCar objectForKey:@"carColor"]], @"mapLocation": locationJson, @"firstOrder": [SharedInfo shared].firstOrder, @"amount": [SharedInfo shared].amount, @"totalAmount": [SharedInfo shared].totalAmount, @"startTime": startTime, @"endTime": endTime, @"extraIds": extrIdStr, @"payMethod": @"2", @"ticketId": (ticketId == nil ? @"0" : ticketId), @"discountCode": youhuimaField.text};
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:SINGLEORDER parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                NSData *data = responseObject;
                NSDictionary *resultDic = [data objectFromJSONData];
                NSNumber *success = [resultDic objectForKey:@"success"];
                
                if ([[success stringValue] isEqualToString:@"1"]) {
                    //partner和seller获取失败,提示
                    if ([PARTNER length] == 0 ||
                        [SELLER length] == 0 ||
                        [PRIVATEKEY length] == 0)
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                        message:@"缺少partner或者seller或者私钥。"
                                                                       delegate:self
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                        [alert show];
                        return;
                    }
                    NSDictionary *dict = [resultDic objectForKey:@"data"];
                    payId = [dict objectForKey:@"payId"];
                    /*
                     *生成订单信息及签名
                     */
                    //将商品信息赋予AlixPayOrder的成员变量
                    Order *order = [[Order alloc] init];
                    order.partner = PARTNER;
                    order.seller = SELLER;
                    order.tradeNO = payId; //订单ID（由商家自行制定）
                    order.productName = @"来啦洗车-支付订单"; //商品标题
                    order.productDescription = @"洗车支付"; //商品描述
                    order.amount = [dict objectForKey:@"amount"]; //商品价格
                    order.notifyURL =  ALIPAY; //回调URL
                    
                    order.service = @"mobile.securitypay.pay";
                    order.paymentType = @"1";
                    order.inputCharset = @"utf-8";
                    order.itBPay = @"30m";
                    order.showUrl = @"m.alipay.com";
                    
                    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
                    NSString *appScheme = @"alisdkdemo";
                    
                    //将商品信息拼接成字符串
                    NSString *orderSpec = [order description];
                    NSLog(@"orderSpec = %@",orderSpec);
                    
                    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
                    id<DataSigner> signer = CreateRSADataSigner(PRIVATEKEY);
                    NSString *signedString = [signer signString:orderSpec];
                    
                    //将签名成功字符串格式化为订单字符串,请严格按照该格式
                    NSString *orderString = nil;
                    if (signedString != nil) {
                        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                       orderSpec, signedString, @"RSA"];
                        [SharedInfo shared].aliPayType = @"2";
                        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                            NSLog(@"reslut = %@",resultDic);
                            
                            NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
                            
                            if ([resultStatus isEqualToString:@"9000"]) {
                                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
                                hud.mode = MBProgressHUDModeText;
                                hud.labelText = @"购买成功";
                                hud.detailsLabelText = @"您的洗车技师会在接近洗车时间和您联系";
                                
                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC);
                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                    // Do something...
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                });
                                [self getCoupon];
                            }
                        }];
                    }
                } else {
                    NSString *messageUTF8 = [resultDic objectForKey:@"message"];
                    
                    const char *messagePoint = [messageUTF8 UTF8String];
                    NSString *message = [NSString stringWithCString:messagePoint encoding:NSUTF8StringEncoding];
                    
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
            break;
        }
        case 1:
        {
            // 微信支付
            NSDictionary *locationDict = @{@"address": [SharedInfo shared].currentLocation, @"lat": [NSNumber numberWithFloat:[SharedInfo shared].currentLatitude], @"lon":[NSNumber numberWithFloat:[SharedInfo shared].currentLongitude]};
            NSString *locationJson = [locationDict JSONString];
            
            NSArray *timeArray = [[SharedInfo shared].washTime componentsSeparatedByString:@" "];
            NSString *date = [timeArray objectAtIndex:0];
            NSString *formatDate = [date stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            NSString *startAllTime = [timeArray objectAtIndex:1];
            NSString *endAllTime = [timeArray objectAtIndex:3];
            NSArray *startArray = [startAllTime componentsSeparatedByString:@":"];
            NSArray *endArray = [endAllTime componentsSeparatedByString:@":"];
            NSString *startTime = [startArray objectAtIndex:0];
            NSString *endTime = [endArray objectAtIndex:0];
            
            NSMutableString *extrIdStr = [[NSMutableString alloc] init];
            NSMutableArray *extraArray = [SharedInfo shared].extraIds;
            
            for (int i = 0; i < [extraArray count]; i++) {
                if (i == 0) {
                    [extrIdStr appendString:[[extraArray objectAtIndex:i] stringValue]];
                } else if (i == [extraArray count] - 1) {
                    [extrIdStr appendString:@","];
                    [extrIdStr appendString:[[extraArray objectAtIndex:i] stringValue]];
                } else {
                    [extrIdStr appendString:@","];
                    [extrIdStr appendString:[[extraArray objectAtIndex:i] stringValue]];
                }
            }
            
            NSDictionary *parameters = @{@"payType": @"1", @"productId": [SharedInfo shared].productId, @"buyUser": [[SharedInfo shared].userInfo objectForKey:@"userId"], @"orderDate": formatDate, @"phone": [[SharedInfo shared].userInfo objectForKey:@"phone"], @"carNum": [[SharedInfo shared].currentCar objectForKey:@"carNum"], @"carInfo": [NSString stringWithFormat:@"%@ %@ %@", [[SharedInfo shared].currentCar objectForKey:@"carBrand"], [[SharedInfo shared].currentCar objectForKey:@"carModel"], [[SharedInfo shared].currentCar objectForKey:@"carColor"]], @"mapLocation": locationJson, @"firstOrder": [SharedInfo shared].firstOrder, @"amount": [SharedInfo shared].amount, @"totalAmount": [SharedInfo shared].totalAmount, @"startTime": startTime, @"endTime": endTime, @"extraIds": extrIdStr, @"payMethod": @"3", @"ticketId": (ticketId == nil ? @"" : ticketId), @"discountCode": youhuimaField.text};
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:SINGLEORDER parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                NSData *data = responseObject;
                NSDictionary *resultDic = [data objectFromJSONData];
                NSNumber *success = [resultDic objectForKey:@"success"];
                
                if ([[success stringValue] isEqualToString:@"1"]) {
                    //================================
                    //预付单参数订单设置
                    //================================
                    NSDictionary *dict = [resultDic objectForKey:@"data"];
                    payId = [dict objectForKey:@"payId"];
                    NSNumber *ordernoNum = [dict objectForKey:@"payId"];
                    NSString *orderno = [ordernoNum stringValue];
                    NSString *order_name = @"来啦洗车-支付订单";
                    NSString *order_price = [NSString stringWithFormat:@"%d", [[dict objectForKey:@"amount"] integerValue] * 100];
                    srand( (unsigned)time(0) );
                    NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()];
                    NSMutableDictionary *packageParams = [NSMutableDictionary dictionary];
                    NSString *ipAddress = [SharedInfo getIPAddress:YES];
                    
                    [packageParams setObject: APP_ID            forKey:@"appid"];       //开放平台appid
                    [packageParams setObject: MCH_ID            forKey:@"mch_id"];      //商户号
                    [packageParams setObject: noncestr          forKey:@"nonce_str"];   //随机串
                    [packageParams setObject: @"APP"            forKey:@"trade_type"];  //支付类型，固定为APP
                    [packageParams setObject: order_name        forKey:@"body"];        //订单描述，展示给用户
                    [packageParams setObject: NOTIFY_URL        forKey:@"notify_url"];  //支付结果异步通知
                    [packageParams setObject: orderno           forKey:@"out_trade_no"];//商户订单号
                    [packageParams setObject: ipAddress         forKey:@"spbill_create_ip"];//发器支付的机器ip
                    [packageParams setObject: order_price       forKey:@"total_fee"];       //订单金额，单位为分
                    
                    //获取prepayId（预支付交易会话标识）
                    payRequsestHandler *payHandler = [[payRequsestHandler alloc] init];
                    [payHandler init:APP_ID mch_id:MCH_ID];
                    [payHandler setKey:PARTNER_ID];
                    NSString *prePayid;
                    prePayid            = [payHandler sendPrepay:packageParams];
                    
                    if ( prePayid != nil) {
                        //获取到prepayid后进行第二次签名
                        
                        NSString    *package, *time_stamp, *nonce_str;
                        //设置支付参数
                        time_t now;
                        time(&now);
                        time_stamp  = [NSString stringWithFormat:@"%ld", now];
                        nonce_str	= [WXUtil md5:time_stamp];
                        //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
                        //package       = [NSString stringWithFormat:@"Sign=%@",package];
                        package         = @"Sign=WXPay";
                        //第二次签名参数列表
                        NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
                        [signParams setObject: APP_ID        forKey:@"appid"];
                        [signParams setObject: nonce_str    forKey:@"noncestr"];
                        [signParams setObject: package      forKey:@"package"];
                        [signParams setObject: MCH_ID        forKey:@"partnerid"];
                        [signParams setObject: time_stamp   forKey:@"timestamp"];
                        [signParams setObject: prePayid     forKey:@"prepayid"];
                        //[signParams setObject: @"MD5"       forKey:@"signType"];
                        //生成签名
                        NSString *sign  = [payHandler createMd5Sign:signParams];
                        
                        //添加签名
                        [signParams setObject: sign         forKey:@"sign"];
                        
                        NSMutableString *stamp  = [signParams objectForKey:@"timestamp"];
                        
                        //调起微信支付
                        PayReq* req             = [[PayReq alloc] init];
                        req.openID              = [signParams objectForKey:@"appid"];
                        req.partnerId           = [signParams objectForKey:@"partnerid"];
                        req.prepayId            = [signParams objectForKey:@"prepayid"];
                        req.nonceStr            = [signParams objectForKey:@"noncestr"];
                        req.timeStamp           = stamp.intValue;
                        req.package             = [signParams objectForKey:@"package"];
                        req.sign                = [signParams objectForKey:@"sign"];
                        [SharedInfo shared].aliPayType = @"2";
                        [WXApi sendReq:req];
                    }else{
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"获取prepayid失败!";
                        
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            // Do something...
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                        });
                    }
                } else {
                    NSString *messageUTF8 = [resultDic objectForKey:@"message"];
                    
                    const char *messagePoint = [messageUTF8 UTF8String];
                    NSString *message = [NSString stringWithCString:messagePoint encoding:NSUTF8StringEncoding];
                    
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
            break;
        }
        case 2:
        {
            // 余额支付
            NSDictionary *locationDict = @{@"address": [SharedInfo shared].currentLocation, @"lat": [NSNumber numberWithFloat:[SharedInfo shared].currentLatitude], @"lon":[NSNumber numberWithFloat:[SharedInfo shared].currentLongitude]};
            NSString *locationJson = [locationDict JSONString];
            
            NSArray *timeArray = [[SharedInfo shared].washTime componentsSeparatedByString:@" "];
            NSString *date = [timeArray objectAtIndex:0];
            NSString *formatDate = [date stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            NSString *startAllTime = [timeArray objectAtIndex:1];
            NSString *endAllTime = [timeArray objectAtIndex:3];
            NSArray *startArray = [startAllTime componentsSeparatedByString:@":"];
            NSArray *endArray = [endAllTime componentsSeparatedByString:@":"];
            NSString *startTime = [startArray objectAtIndex:0];
            NSString *endTime = [endArray objectAtIndex:0];
            
            NSMutableString *extrIdStr = [[NSMutableString alloc] init];
            NSMutableArray *extraArray = [SharedInfo shared].extraIds;
            
            for (int i = 0; i < [extraArray count]; i++) {
                if (i == 0) {
                    [extrIdStr appendString:[[extraArray objectAtIndex:i] stringValue]];
                } else if (i == [extraArray count] - 1) {
                    [extrIdStr appendString:@","];
                    [extrIdStr appendString:[[extraArray objectAtIndex:i] stringValue]];
                } else {
                    [extrIdStr appendString:@","];
                    [extrIdStr appendString:[[extraArray objectAtIndex:i] stringValue]];
                }
            }
            
            NSDictionary *parameters = @{@"payType": [NSNumber numberWithInteger:2], @"productId": [SharedInfo shared].productId, @"buyUser": [[SharedInfo shared].userInfo objectForKey:@"userId"], @"orderDate": formatDate, @"phone": [[SharedInfo shared].userInfo objectForKey:@"phone"], @"carNum": [[SharedInfo shared].currentCar objectForKey:@"carNum"], @"carInfo": [NSString stringWithFormat:@"%@ %@ %@", [[SharedInfo shared].currentCar objectForKey:@"carBrand"], [[SharedInfo shared].currentCar objectForKey:@"carModel"], [[SharedInfo shared].currentCar objectForKey:@"carColor"]], @"mapLocation": locationJson, @"firstOrder": [SharedInfo shared].firstOrder, @"amount": [SharedInfo shared].amount, @"totalAmount": [SharedInfo shared].totalAmount, @"startTime": startTime, @"endTime": endTime, @"extraIds": extrIdStr, @"ticketId": (ticketId == nil ? @"" : ticketId), @"discountCode": youhuimaField.text};
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:SINGLEORDER parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                NSData *data = responseObject;
                NSDictionary *resultDic = [data objectFromJSONData];
                NSNumber *success = [resultDic objectForKey:@"success"];
                
                if ([[success stringValue] isEqualToString:@"1"]) {
                    NSDictionary *dict = [resultDic objectForKey:@"data"];
                    payId = [dict objectForKey:@"payId"];
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"购买成功";
                    hud.detailsLabelText = @"您的洗车技师会在接近洗车时间和您联系";
                    
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        // Do something...
                        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                    });
                    
                    [SharedInfo shared].currentCarIndex = nil;
                    [SharedInfo shared].currentCar = nil;
                    [SharedInfo shared].currentLatitude = 0.0;
                    [SharedInfo shared].currentLongitude = 0.0;
                    
                    [self getCoupon];
                } else {
                    NSString *messageUTF8 = [resultDic objectForKey:@"message"];
                    
                    const char *messagePoint = [messageUTF8 UTF8String];
                    NSString *message = [NSString stringWithCString:messagePoint encoding:NSUTF8StringEncoding];
                    
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = message;
                    
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        // Do something...
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    });
                    LoggerApp(1, @"余额支付失败：%@", message);
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
                LoggerApp(1, @"%@", error);
            }];
            break;
        }
        case 3:
        {
            // 次数支付
            int leftCount = [[SharedInfo shared].leftCount intValue];
            if (!(leftCount > 0)) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"剩余次数不足，请重新购买";
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    // Do something...
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
                return;
            }
            
            NSDictionary *locationDict = @{@"address": [SharedInfo shared].currentLocation, @"lat": [NSNumber numberWithFloat:[SharedInfo shared].currentLatitude], @"lon":[NSNumber numberWithFloat:[SharedInfo shared].currentLongitude]};
            NSString *locationJson = [locationDict JSONString];
            
            NSArray *timeArray = [[SharedInfo shared].washTime componentsSeparatedByString:@" "];
            NSString *date = [timeArray objectAtIndex:0];
            NSString *formatDate = [date stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            NSString *startAllTime = [timeArray objectAtIndex:1];
            NSString *endAllTime = [timeArray objectAtIndex:3];
            NSArray *startArray = [startAllTime componentsSeparatedByString:@":"];
            NSArray *endArray = [endAllTime componentsSeparatedByString:@":"];
            NSString *startTime = [startArray objectAtIndex:0];
            NSString *endTime = [endArray objectAtIndex:0];
            
            NSMutableString *extrIdStr = [[NSMutableString alloc] init];
            NSMutableArray *extraArray = [SharedInfo shared].extraIds;
            
            for (int i = 0; i < [extraArray count]; i++) {
                if (i == 0) {
                    [extrIdStr appendString:[[extraArray objectAtIndex:i] stringValue]];
                } else if (i == [extraArray count] - 1) {
                    [extrIdStr appendString:@","];
                    [extrIdStr appendString:[[extraArray objectAtIndex:i] stringValue]];
                } else {
                    [extrIdStr appendString:@","];
                    [extrIdStr appendString:[[extraArray objectAtIndex:i] stringValue]];
                }
            }
            
            NSDictionary *parameters = @{@"payType": [NSNumber numberWithInteger:3], @"productId": [SharedInfo shared].productId, @"buyUser": [[SharedInfo shared].userInfo objectForKey:@"userId"], @"orderDate": formatDate, @"phone": [[SharedInfo shared].userInfo objectForKey:@"phone"], @"carNum": [[SharedInfo shared].currentCar objectForKey:@"carNum"], @"carInfo": [NSString stringWithFormat:@"%@ %@ %@", [[SharedInfo shared].currentCar objectForKey:@"carBrand"], [[SharedInfo shared].currentCar objectForKey:@"carModel"], [[SharedInfo shared].currentCar objectForKey:@"carColor"]], @"mapLocation": locationJson, @"firstOrder": [SharedInfo shared].firstOrder, @"amount": [SharedInfo shared].amount, @"totalAmount": [SharedInfo shared].totalAmount, @"startTime": startTime, @"endTime": endTime, @"extraIds": extrIdStr, @"orderId": [SharedInfo shared].timeOrderId};
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:SINGLEORDER parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                NSData *data = responseObject;
                NSDictionary *resultDic = [data objectFromJSONData];
                NSNumber *success = [resultDic objectForKey:@"success"];
                
                if ([[success stringValue] isEqualToString:@"1"]) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"购买成功";
                    hud.detailsLabelText = @"您的洗车技师会在接近洗车时间和您联系";
                    
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        // Do something...
                        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                    });
                    [SharedInfo shared].currentCarIndex = nil;
                    [SharedInfo shared].currentCar = nil;
                    [SharedInfo shared].currentLatitude = 0.0;
                    [SharedInfo shared].currentLongitude = 0.0;
                    [self getCoupon];
                } else {
                    NSString *messageUTF8 = [resultDic objectForKey:@"message"];
                    
                    const char *messagePoint = [messageUTF8 UTF8String];
                    NSString *message = [NSString stringWithCString:messagePoint encoding:NSUTF8StringEncoding];
                    
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
            break;
        }
        case 4:
        {
            // 银联支付
            NSDictionary *locationDict = @{@"address": [SharedInfo shared].currentLocation, @"lat": [NSNumber numberWithFloat:[SharedInfo shared].currentLatitude], @"lon":[NSNumber numberWithFloat:[SharedInfo shared].currentLongitude]};
            NSString *locationJson = [locationDict JSONString];
            
            NSArray *timeArray = [[SharedInfo shared].washTime componentsSeparatedByString:@" "];
            NSString *date = [timeArray objectAtIndex:0];
            NSString *formatDate = [date stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            NSString *startAllTime = [timeArray objectAtIndex:1];
            NSString *endAllTime = [timeArray objectAtIndex:3];
            NSArray *startArray = [startAllTime componentsSeparatedByString:@":"];
            NSArray *endArray = [endAllTime componentsSeparatedByString:@":"];
            NSString *startTime = [startArray objectAtIndex:0];
            NSString *endTime = [endArray objectAtIndex:0];
            
            NSMutableString *extrIdStr = [[NSMutableString alloc] init];
            NSMutableArray *extraArray = [SharedInfo shared].extraIds;
            
            for (int i = 0; i < [extraArray count]; i++) {
                if (i == 0) {
                    [extrIdStr appendString:[[extraArray objectAtIndex:i] stringValue]];
                } else if (i == [extraArray count] - 1) {
                    [extrIdStr appendString:@","];
                    [extrIdStr appendString:[[extraArray objectAtIndex:i] stringValue]];
                } else {
                    [extrIdStr appendString:@","];
                    [extrIdStr appendString:[[extraArray objectAtIndex:i] stringValue]];
                }
            }
            
            NSDictionary *parameters = @{@"payType": @"1", @"productId": [SharedInfo shared].productId, @"buyUser": [[SharedInfo shared].userInfo objectForKey:@"userId"], @"orderDate": formatDate, @"phone": [[SharedInfo shared].userInfo objectForKey:@"phone"], @"carNum": [[SharedInfo shared].currentCar objectForKey:@"carNum"], @"carInfo": [NSString stringWithFormat:@"%@ %@ %@", [[SharedInfo shared].currentCar objectForKey:@"carBrand"], [[SharedInfo shared].currentCar objectForKey:@"carModel"], [[SharedInfo shared].currentCar objectForKey:@"carColor"]], @"mapLocation": locationJson, @"firstOrder": [SharedInfo shared].firstOrder, @"amount": [SharedInfo shared].amount, @"totalAmount": [SharedInfo shared].totalAmount, @"startTime": startTime, @"endTime": endTime, @"extraIds": extrIdStr, @"payMethod": @"4", @"ticketId": (ticketId == nil ? @"" : ticketId), @"discountCode": youhuimaField.text};
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:SINGLEORDER parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                NSData *data = responseObject;
                NSDictionary *resultDic = [data objectFromJSONData];
                NSNumber *success = [resultDic objectForKey:@"success"];
                
                if ([[success stringValue] isEqualToString:@"1"]) {
                    //================================
                    //预付单参数订单设置
                    //================================
                    NSDictionary *dict = [resultDic objectForKey:@"data"];
                    payId = [dict objectForKey:@"payId"];
                    [UPPayPlugin startPay:payId mode:@"00" viewController:self delegate:self];
                    
                } else {
                    NSString *messageUTF8 = [resultDic objectForKey:@"message"];
                    
                    const char *messagePoint = [messageUTF8 UTF8String];
                    NSString *message = [NSString stringWithCString:messagePoint encoding:NSUTF8StringEncoding];
                    
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
        default:
            break;
    }
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  微信支付回调
 *
 *  @param resp 微信支付返回值，判断是否支付成功
 */
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
            {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                [SharedInfo shared].currentCarIndex = nil;
                [SharedInfo shared].currentCar = nil;
                [SharedInfo shared].currentLatitude = 0.0;
                [SharedInfo shared].currentLongitude = 0.0;
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"购买成功";
                hud.detailsLabelText = @"您的洗车技师会在接近洗车时间和您联系";
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    // Do something...
                    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                });
                [self getCoupon];
                break;
            }
            case WXErrCodeUserCancel:
            {
                ;
                break;
            }
            default:
            {
                break;
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell1"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell1"];
        UILabel *myLabel = [[UILabel alloc] init];
        [myLabel setTextAlignment:NSTextAlignmentCenter];
        [myLabel setTag:1];
        [myLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
        [myLabel setTextColor:[UIColor whiteColor]];
        [myLabel setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:myLabel];
        cell.backgroundView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payCellBack"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(myLabel.superview);
            make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 20.0));
        }];
    }
    NSInteger row = indexPath.row;
    UILabel *tempLabel = (UILabel *)[cell viewWithTag:1];
    
    switch (row) {
        case 0:
        {
            payType = 0;
            [tempLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
            [tempLabel setText:@"支付宝支付"];
            break;
        }
        case 1:
        {
            [tempLabel setText:@"微信支付"];
            break;
        }
        case 2:
        {
            [tempLabel setText:@"余额支付"];
            break;
        }
        case 3:
        {
            [tempLabel setText:@"优惠套餐支付"];
            break;
        }
        case 4:
        {
            [tempLabel setText:@"银联支付"];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark- Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *tempLabel = (UILabel *)[cell viewWithTag:1];
    [tempLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    if (indexPath.row != 0) {
        [self tableView:tableView didDeselectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    }
    payType = indexPath.row;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *tempLabel = (UILabel *)[cell viewWithTag:1];
    [tempLabel setTextColor:[UIColor whiteColor]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UPPayDelegate

- (void)UPPayPluginResult:(NSString*)result {
    if ([result isEqualToString:@"success"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"购买成功";
        hud.detailsLabelText = @"您的洗车技师会在接近洗车时间和您联系";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        [SharedInfo shared].currentCarIndex = nil;
        [SharedInfo shared].currentCar = nil;
        [SharedInfo shared].currentLatitude = 0.0;
        [SharedInfo shared].currentLongitude = 0.0;
        
        [self getCoupon];
    }
}

#pragma mark- Text field delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 120.0, self.view.frame.size.width, self.view.frame.size.height)];
    radioyouhuima.selected = YES;
    radioyouhuiquan.selected = NO;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 120.0, self.view.frame.size.width, self.view.frame.size.height)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (![textField.text isEqualToString:@""]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:[NSString stringWithFormat:@"%@%@", DISCOUNTCODE, textField.text] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSData *data = responseObject;
            NSDictionary *resultDic = [data objectFromJSONData];
            LoggerApp(1, @"%@", resultDic);
            
            NSNumber *success = [resultDic objectForKey:@"success"];
            if ([success integerValue] == 1) {
                NSDictionary *data = [resultDic objectForKey:@"data"];
                disCountVal = [data objectForKey:@"val"];
                
                amountPrice = [[SharedInfo shared].totalAmount integerValue];
                amountPrice = amountPrice - [disCountVal integerValue];
                
                priceLabel.text = [NSString stringWithFormat:@"需要支付金额%ld元", (long)amountPrice];
            } else {
                NSString *messageUTF8 = [resultDic objectForKey:@"message"];
                
                const char *messagePoint = [messageUTF8 UTF8String];
                NSString *message = [NSString stringWithCString:messagePoint encoding:NSUTF8StringEncoding];
                
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
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            LoggerApp(1, @"Error: %@", error.userInfo);
        }];
    } else {
        amountPrice = [[SharedInfo shared].totalAmount integerValue];
        priceLabel.text = [NSString stringWithFormat:@"需要支付金额%ld元", (long)amountPrice];
    }
    
    return YES;
}

@end
