//
//  Pay3ViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 4/7/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "Pay3ViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"
#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"


@interface Pay3ViewController () <UITableViewDataSource, UITableViewDelegate, WXApiDelegate, UPPayPluginDelegate>
{
    UITableView *myTableView;
    UIButton *confirmButton;
    NSInteger payType;
}

@property (strong, nonatomic) NSString *money;

@end

@implementation Pay3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    myTableView = [[UITableView alloc] init];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.scrollEnabled = NO;
    [myTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:myTableView];
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myTableView.superview);
        make.top.equalTo(myTableView.superview).offset(79);
        make.right.equalTo(myTableView.superview);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 240.0));
    }];
    
    confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(0.0, self.view.frame.size.width * 636.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 88.0/640.0);
    [confirmButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [confirmButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySucceed:) name:@"AddMoneyController" object:nil];
}

- (void)paySucceed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmButtonPressed:(id)sender {
    switch (payType) {
        case 0:
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy/MM/dd"];
            NSString *dateStr = [formatter stringFromDate:[NSDate date]];
            
            NSDictionary *parameters = @{@"phone": [[SharedInfo shared].userInfo objectForKey:@"phone"], @"buyUser": [[SharedInfo shared].userInfo objectForKey:@"userId"], @"payType": @"1", @"payMethod": @"2", @"productId": @"11", @"totalAmount": self.money, @"orderDate": dateStr};
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:MAKEBALANCEORDER parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
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
                    NSString *payId = [dict objectForKey:@"payId"];
                    /*
                     *生成订单信息及签名
                     */
                    //将商品信息赋予AlixPayOrder的成员变量
                    Order *order = [[Order alloc] init];
                    order.partner = PARTNER;
                    order.seller = SELLER;
                    order.tradeNO = payId; //订单ID（由商家自行制定）
                    order.productName = @"来啦洗车-用户充值"; //商品标题
                    order.productDescription = @"来啦用户账户余额充值"; //商品描述
                    order.amount = self.money; //商品价格
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
                        [SharedInfo shared].aliPayType = @"1";
                        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                            NSLog(@"reslut = %@",resultDic);
                            NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
                            
                            if ([resultStatus isEqualToString:@"9000"]) {
                                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                hud.mode = MBProgressHUDModeText;
                                hud.labelText = @"付款成功";
                                
                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                    // Do something...
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                });
                                [self.navigationController popViewControllerAnimated:YES];
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
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy/MM/dd"];
            NSString *dateStr = [formatter stringFromDate:[NSDate date]];
            
            NSDictionary *parameters = @{@"phone": [[SharedInfo shared].userInfo objectForKey:@"phone"], @"buyUser": [[SharedInfo shared].userInfo objectForKey:@"userId"], @"payType": @"1", @"payMethod": @"3", @"productId": @"11", @"totalAmount": self.money, @"orderDate": dateStr};
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:MAKEBALANCEORDER parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                NSData *data = responseObject;
                NSDictionary *resultDic = [data objectFromJSONData];
                NSNumber *success = [resultDic objectForKey:@"success"];
                
                if ([[success stringValue] isEqualToString:@"1"]) {
                    //================================
                    //预付单参数订单设置
                    //================================
                    NSDictionary *dict = [resultDic objectForKey:@"data"];
                    NSNumber *ordernoNum = [dict objectForKey:@"payId"];
                    NSString *orderno = [ordernoNum stringValue];
                    NSString *order_name = @"来啦洗车-用户充值";
                    NSString *order_price = [NSString stringWithFormat:@"%d", [self.money intValue] * 100];
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
                        [SharedInfo shared].aliPayType = @"1";
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
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy/MM/dd"];
            NSString *dateStr = [formatter stringFromDate:[NSDate date]];
            
            NSDictionary *parameters = @{@"phone": [[SharedInfo shared].userInfo objectForKey:@"phone"], @"buyUser": [[SharedInfo shared].userInfo objectForKey:@"userId"], @"payType": @"1", @"payMethod": @"4", @"productId": @"11", @"totalAmount": self.money, @"orderDate": dateStr};
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:MAKEBALANCEORDER parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                NSData *data = responseObject;
                NSDictionary *resultDic = [data objectFromJSONData];
                NSNumber *success = [resultDic objectForKey:@"success"];
                
                if ([[success stringValue] isEqualToString:@"1"]) {
                    NSDictionary *dict = [resultDic objectForKey:@"data"];
                    NSString *payId = [dict objectForKey:@"payId"];
                    
                    [UPPayPlugin startPay:payId mode:@"00" viewController:self delegate:self];
                } else {
                    
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
            {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"付款成功";
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    // Do something...
                    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                });
                [self.navigationController popViewControllerAnimated:YES];
                break;
            }
            default:
            {
                break;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell1"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell1"];
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 16.0, self.view.frame.size.width, 16.0)];
        [myLabel setTextAlignment:NSTextAlignmentCenter];
        [myLabel setTag:1];
        [myLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
        [myLabel setTextColor:[UIColor whiteColor]];
        [myLabel setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:myLabel];
        cell.backgroundView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payCellBack"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payCellSelect"]];
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
    return self.view.frame.size.width * 12.0/80.0;
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

#pragma mark - UPPayDelegate

-(void)UPPayPluginResult:(NSString*)result {
    if ([result isEqualToString:@"success"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"购买成功";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        });
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
