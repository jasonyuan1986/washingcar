//
//  ShareViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 5/29/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "ShareViewController.h"
#import "ShopViewController.h"

@interface ShareViewController () <UIWebViewDelegate>
{
    UIWebView *myWebView;
//    UIWebView *myWebView;
    NSString *token;
    NSString *key;
    UIButton *shoppingButton;
}

@end

@implementation ShareViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
    
    char data[12];
    for (int x=0;x<12;data[x++] = (char)('A' + (arc4random_uniform(26))));
    key = [[NSString alloc] initWithBytes:data length:12 encoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@%@", GETTOKEN, key] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        NSNumber *success = [resultDic objectForKey:@"success"];
        if ([success integerValue] == 1) {
            NSDictionary *tokenData = [resultDic objectForKey:@"data"];
            token = [tokenData objectForKey:@"token"];
            
            NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (NSHTTPCookie *cookie in [cookieJar cookies]) {
                LoggerApp(1, @"%@", cookie);
            }
            
            [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SHOPPING, token]]]];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerApp(1, @"Result: %@", result);
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [shareButton setBackgroundColor:[UIColor clearColor]];
    [shareButton setTitle:@"分享好友" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareButton setFrame:CGRectMake(0.0, 0.0, 80.0, 30.0)];
    [shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *shareBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItem = shareBarButton;
    
    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
//    [self set]
    myWebView.delegate = self;
    [myWebView setBackgroundColor:[UIColor blackColor]];
    [myWebView setOpaque:NO];
    [self.view addSubview:myWebView];
    
    shoppingButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    shoppingButton.hidden = YES;
    shoppingButton.backgroundColor = YELLOWCOLOR;
    [shoppingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shoppingButton setTitle:@"[来啦]商城" forState:UIControlStateNormal];
    [shoppingButton addTarget:self action:@selector(shoppingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shoppingButton];
    
    [shoppingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySucceed:) name:@"ShareController" object:nil];
}

- (void)paySucceed:(id)sender {
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        LoggerApp(1, @"%@", cookie);
    }
    
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ORDERPAYFINISH]]];
}

- (void)shoppingButtonPressed:(id)sender {
    ShopViewController *shopViewController = [[ShopViewController alloc] init];
    [self.navigationController pushViewController:shopViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)shareButtonPressed:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@%@", GETSHARE, key] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        NSNumber *success = [resultDic objectForKey:@"success"];
        if ([success integerValue] == 1) {
            NSDictionary *shareData = [resultDic objectForKey:@"data"];
            NSString *desc = [shareData objectForKey:@"desc"];
            UIImage *image = [UIImage imageNamed:@"ShareSmallImage"];
            WXMediaMessage *message = [WXMediaMessage message];
            [message setThumbImage:image];
            
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.rongmai.laila.user";
            
            message.mediaObject = ext;
            message.title = @"来啦洗车";
            message.description = desc;
            
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            req.scene = 0;
            
            [WXApi sendReq:req];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerApp(1, @"Result: %@", result);
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString hasPrefix:@"laila://wechatpay"]) {
        NSArray *urlArray = [request.URL.absoluteString componentsSeparatedByString:@"?"];
        NSString *paramsString = urlArray[1];
        
        NSArray *paramsArray = [paramsString componentsSeparatedByString:@"&"];
        NSString *ordernoString = paramsArray[0];
        NSArray *ordernoArray = [ordernoString componentsSeparatedByString:@"="];
        NSString *orderno = ordernoArray[1];
        
        NSString *amountString = paramsArray[1];
        NSArray *amountArray = [amountString componentsSeparatedByString:@"="];
        NSString *amout = amountArray[1];
        
        NSString *order_name = @"来啦商城-支付订单";
        NSString *order_price = [NSString stringWithFormat:@"%d", [amout intValue] * 100];
        srand( (unsigned)time(0) );
        NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()];
        NSMutableDictionary *packageParams = [NSMutableDictionary dictionary];
        NSString *ipAddress = [SharedInfo getIPAddress:YES];
        
        [packageParams setObject: APP_ID            forKey:@"appid"];       //开放平台appid
        [packageParams setObject: MCH_ID            forKey:@"mch_id"];      //商户号
        [packageParams setObject: noncestr          forKey:@"nonce_str"];   //随机串
        [packageParams setObject: @"APP"            forKey:@"trade_type"];  //支付类型，固定为APP
        [packageParams setObject: order_name        forKey:@"body"];        //订单描述，展示给用户
        [packageParams setObject: NOTIFY_URL_SHARE  forKey:@"notify_url"];  //支付结果异步通知
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
            [SharedInfo shared].aliPayType = @"4";
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
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

/**
 *  微信支付回调
 *
 *  @param resp 微信支付返回值，判断是否支付成功
 */
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
//        PayResp *response = (PayResp *)resp;
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ORDERPAYFINISH]]];
    } else {
        switch (resp.errCode) {
            case WXSuccess:
            {
                
                break;
            }
            case WXErrCodeUserCancel:
            {
                
            }
            default:
            {
                break;
            }
        }
    }
    
    
}

@end
