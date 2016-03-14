//
//  ShareYouhuiquanViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 8/13/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "ShareYouhuiquanViewController.h"

@interface ShareYouhuiquanViewController ()
{
    UIImageView *backgroundImage;
    UILabel *textLabel;
    UILabel *priceLabel;
    UILabel *dateLabel;
    UIImageView *priceImage;
    UIButton *shareHaoyou;
    UIButton *sharePengyouquan;
    
    NSString *shareMsg;
    NSString *shareUrl;
}

@property (nonatomic, strong) NSString *payId;

@end

@implementation ShareYouhuiquanViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[GETDIYONGQUAN stringByAppendingString:[NSString stringWithFormat:@"%@", self.payId]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        LoggerApp(2, @"%@", resultDic);
        NSDictionary *dataDict = [resultDic objectForKey:@"data"];
        shareMsg = [dataDict objectForKey:@"shareMsg"];
        shareUrl = [dataDict objectForKey:@"shareUrl"];

        NSNumber *timestamp = [dataDict objectForKey:@"date"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([timestamp longLongValue]/1000)];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *effectDate = [dateFormatter stringFromDate:date];
        [dateLabel setText:[NSString stringWithFormat:@"有效期：%@", effectDate]];
        
        NSNumber *val = [dataDict objectForKey:@"val"];
        [priceLabel setText:[NSString stringWithFormat:@"%@元", val]];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerApp(1, @"Result: %@", result);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SharedInfo shared].aliPayType = @"5";
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
    backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backgroundImage setImage:[UIImage imageNamed:@"backgroundImage"]];
    [self.view addSubview:backgroundImage];
    
    textLabel = [[UILabel alloc] init];
    textLabel.textColor = YELLOWCOLOR;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"恭喜您获得了一张抵用券";
    [self.view addSubview:textLabel];
    
    priceImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youhuiquanPrice"]];
    [self.view addSubview:priceImage];
    
    priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = [UIColor blackColor];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.font = HEITISC16;
    [self.view addSubview:priceLabel];
    
    dateLabel = [[UILabel alloc] init];
    dateLabel.textColor = YELLOWCOLOR;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.font = [UIFont fontWithName:@"Heiti SC" size:12.0];
    [self.view addSubview:dateLabel];
    
    shareHaoyou = [[UIButton alloc] init];
    [shareHaoyou setBackgroundImage:[UIImage imageNamed:@"shareHaoyou"] forState:UIControlStateNormal];
    [shareHaoyou addTarget:self action:@selector(shareHaoyou:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareHaoyou];
    
    sharePengyouquan = [[UIButton alloc] init];
    [sharePengyouquan setBackgroundImage:[UIImage imageNamed:@"sharePengyouquan"] forState:UIControlStateNormal];
    [sharePengyouquan addTarget:self action:@selector(sharePengyouquan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sharePengyouquan];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(90);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 40));
    }];
    
    [priceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(140);
        make.size.mas_equalTo(CGSizeMake(90, 45));
    }];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(145);
        make.size.mas_equalTo(CGSizeMake(80, 35));
    }];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(195);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 20));
    }];
    
    [shareHaoyou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(225);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.width * 176/640));
    }];
    
    [sharePengyouquan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(225);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.width * 176/640));
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySucceed:) name:@"ShareYouhuiquan" object:nil];
}

- (void)paySucceed:(id)sender {
    [self performSegueWithIdentifier:@"showOrder" sender:nil];
}

- (void)backBarButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showOrder" sender:nil];
}

- (void)shareHaoyou:(id)sender {
    UIImage *image = [UIImage imageNamed:@"ShareSmallImage"];
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = shareUrl;
    
    message.mediaObject = ext;
    message.title = @"来啦洗车";
    message.description = shareMsg;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = 0;
    
    [WXApi sendReq:req];
}

- (void)sharePengyouquan:(id)sender {
    UIImage *image = [UIImage imageNamed:@"ShareSmallImage"];
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = shareUrl;
    
    message.mediaObject = ext;
    message.title = shareMsg;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = 1;
    
    [WXApi sendReq:req];
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

/**
 *  微信支付回调
 *
 *  @param resp 微信支付返回值，判断是否支付成功
 */
- (void)onResp:(BaseResp *)resp {
    switch (resp.errCode) {
        case WXSuccess:
        {
            [self performSegueWithIdentifier:@"showOrder" sender:nil];
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

@end
