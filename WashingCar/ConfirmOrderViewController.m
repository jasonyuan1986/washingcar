//
//  ConfirmOrderViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 2/28/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "SharedInfo.h"
#import <AFNetworking/AFNetworking.h>
#import <JSONKit-NoWarning/JSONKit.h>

@interface ConfirmOrderViewController ()
{
    UIImageView *backgroundImage;
    UIImageView *washPriceBack;
    UIImageView *allPriceBack;
    UIButton *confirmButton;
    BOOL firstOrder;
    NSDictionary *orderInfo;
    UILabel *priceLabel;
    UILabel *firstPriceLabel;
    UIImageView *removeImage;
    UILabel *allPriceLabel1;
    UILabel *allPriceLabel2;
    float amount;
    NSMutableArray *selectExtras;
    
    UIButton *myButton;
    UIButton *myButton2;
    UILabel *myLabel;
    UILabel *myLabel2;
    UILabel *myPrice;
    UILabel *myPrice2;
}

@end

@implementation ConfirmOrderViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
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
        
        if ([[SharedInfo shared].firstOrder isEqualToString:@"true"]) {
            firstOrder = YES;
        };
        
        NSArray *infoArray = [SharedInfo shared].washPrice;
        NSNumber *carTypeObj = [[SharedInfo shared].currentCar objectForKey:@"carType"];
        NSInteger carType = [carTypeObj integerValue];
        for (NSDictionary *myDict in infoArray) {
            NSNumber *thisCarTypeObj = [myDict objectForKey:@"cartype"];
            NSInteger thisCarType = [thisCarTypeObj integerValue];
            
            if (carType == thisCarType) {
                orderInfo = myDict;
                break;
            }
        }
        [self setData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerApp(1, @"Result: %@", result);
    }];
    
    NSNumber *carTypeObj = [[SharedInfo shared].currentCar objectForKey:@"carType"];
    
    [manager GET:[NSString stringWithFormat:@"%@/%@", EXTRALIST, carTypeObj] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        NSArray *dataDict = [resultDic objectForKey:@"data"];
        
        [SharedInfo shared].extraList = dataDict;
        [self setExtraData];
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
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    selectExtras = [[NSMutableArray alloc] init];
    
    backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backgroundImage setImage:[UIImage imageNamed:@"backgroundImage"]];
    [self.view addSubview:backgroundImage];
    
    washPriceBack = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 79.0/320.0, self.view.frame.size.width, self.view.frame.size.width * 3.0/20.0)];
    [washPriceBack setImage:[UIImage imageNamed:@"washPriceBack"]];
    [self.view addSubview:washPriceBack];
    
    UILabel *washLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 87.0/640.0, self.view.frame.size.width * 97.0/320.0, 60.0, 17.0)];
    [washLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [washLabel setTextColor:[UIColor whiteColor]];
    [washLabel setText:@"外观清洗"];
    [self.view addSubview:washLabel];
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 242.0/320.0, self.view.frame.size.width * 97.0/320.0, 60.0, 17.0)];
    [priceLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [priceLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:priceLabel];
    
    firstPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 342.0/640.0, self.view.frame.size.width * 97.0/320.0, 60.0, 17.0)];
    [firstPriceLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [firstPriceLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    firstPriceLabel.hidden = YES;
    [self.view addSubview:firstPriceLabel];
    
    removeImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 47.0/64.0, self.view.frame.size.width * 206.0/640.0, self.view.frame.size.width * 101.0/640.0, self.view.frame.size.width * 2.0/640.0)];
    [removeImage setImage:[UIImage imageNamed:@"removeImage"]];
    removeImage.hidden = YES;
    [self.view addSubview:removeImage];
    
    UILabel *tipLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 87.0/640.0, washPriceBack.frame.origin.y + washPriceBack.frame.size.height, self.view.frame.size.width - self.view.frame.size.width * 87.0/640.0, self.view.frame.size.width * 49.0/640.0)];
    [tipLabel1 setText:@"*外观清洗不包含内饰，不需要车主在场。"];
    [tipLabel1 setFont:[UIFont fontWithName:@"Heiti SC" size:12.0]];
    [tipLabel1 setTextColor:[UIColor whiteColor]];
    [self.view addSubview:tipLabel1];
    
    UILabel *tipLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 87.0/640.0, tipLabel1.frame.origin.y + tipLabel1.frame.size.height, self.view.frame.size.width - self.view.frame.size.width * 87.0/640.0, self.view.frame.size.width * 49.0/640.0)];
    [tipLabel2 setText:@"附加服务项目"];
    [tipLabel2 setFont:[UIFont fontWithName:@"Heiti SC" size:12.0]];
    [tipLabel2 setTextColor:[UIColor whiteColor]];
    [self.view addSubview:tipLabel2];

    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, tipLabel2.frame.origin.y + tipLabel2.frame.size.height + self.view.frame.size.width * 0 * 3.0/20.0, self.view.frame.size.width, self.view.frame.size.width * 3.0/20.0)];
    [myImageView setImage:[UIImage imageNamed:@"washPriceBack"]];
    [self.view addSubview:myImageView];
        
    myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton setFrame:CGRectMake(self.view.frame.size.width * 87.0/640.0, myImageView.frame.origin.y + 15.0, self.view.frame.size.width * 44.0/640.0, self.view.frame.size.width * 44.0/640.0)];
    [myButton setBackgroundImage:[UIImage imageNamed:@"extraNotSelectedButton"] forState:UIControlStateNormal];
    [myButton setBackgroundImage:[UIImage imageNamed:@"extraSelectedButton"] forState:UIControlStateSelected];
    [myButton addTarget:self action:@selector(myButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myButton];
        
    myLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width /5.0, myImageView.frame.origin.y + 20.0, 120.0, 17.0)];
    [myLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [myLabel setTextColor:[UIColor whiteColor]];
    
    [self.view addSubview:myLabel];

    myPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 487.0 /640.0, myImageView.frame.origin.y + 20.0, 60.0, 17.0)];
    [myPrice setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [myPrice setTextColor:[UIColor whiteColor]];
    
    [self.view addSubview:myPrice];
    
    UIImageView *myImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, tipLabel2.frame.origin.y + tipLabel2.frame.size.height + self.view.frame.size.width * 1 * 3.0/20.0, self.view.frame.size.width, self.view.frame.size.width * 3.0/20.0)];
    [myImageView2 setImage:[UIImage imageNamed:@"washPriceBack"]];
    [self.view addSubview:myImageView2];
    
    myButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton2 setFrame:CGRectMake(self.view.frame.size.width * 87.0/640.0, myImageView2.frame.origin.y + 15.0, self.view.frame.size.width * 44.0/640.0, self.view.frame.size.width * 44.0/640.0)];
    [myButton2 setBackgroundImage:[UIImage imageNamed:@"extraNotSelectedButton"] forState:UIControlStateNormal];
    [myButton2 setBackgroundImage:[UIImage imageNamed:@"extraSelectedButton"] forState:UIControlStateSelected];
    [myButton2 addTarget:self action:@selector(myButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myButton2];
    
    myLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width /5.0, myImageView2.frame.origin.y + 20.0, 120.0, 17.0)];
    [myLabel2 setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [myLabel2 setTextColor:[UIColor whiteColor]];
    [self.view addSubview:myLabel2];
    
    myPrice2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 487.0 /640.0, myImageView2.frame.origin.y + 20.0, 60.0, 17.0)];
    [myPrice2 setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [myPrice2 setTextColor:[UIColor whiteColor]];
    [self.view addSubview:myPrice2];
    
    allPriceBack = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 175.0 + self.view.frame.size.width * 3 * 3.0/20.0, self.view.frame.size.width, self.view.frame.size.width * 3.0/20.0)];
    [allPriceBack setImage:[UIImage imageNamed:@"washPriceBack"]];
    [self.view addSubview:allPriceBack];
    
    allPriceLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 12.0/32.0, allPriceBack.frame.origin.y + 20.0, 50.0, 17.0)];
    [allPriceLabel1 setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [allPriceLabel1 setTextColor:[UIColor whiteColor]];
    [allPriceLabel1 setText:@"共计："];
    [self.view addSubview:allPriceLabel1];
    
    allPriceLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(allPriceLabel1.frame.origin.x + allPriceLabel1.frame.size.width + 10.0, allPriceBack.frame.origin.y + 20.0, 100.0, 17.0)];
    [allPriceLabel2 setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [allPriceLabel2 setTextColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [self.view addSubview:allPriceLabel2];
    
    confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(0.0, allPriceBack.frame.origin.y + allPriceBack.frame.size.height + self.view.frame.size.width * 14.0/320.0, self.view.frame.size.width, self.view.frame.size.width * 11.0/80.0)];
    [confirmButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [confirmButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
}

- (void)myButtonPressed:(id)sender {
    UIButton *button = sender;
    button.selected = !button.selected;
    
    if (button.selected) {
        NSDictionary *dict = [[SharedInfo shared].extraList objectAtIndex:button.tag];
        NSNumber *price = [dict objectForKey:@"price"];
        amount = amount + [price floatValue];
        [SharedInfo shared].totalAmount = [NSNumber numberWithFloat:amount];
        [allPriceLabel2 setText:[NSString stringWithFormat:@"%.2f元", amount]];
        
        [selectExtras addObject:[dict objectForKey:@"extraId"]];
    } else {
        NSDictionary *dict = [[SharedInfo shared].extraList objectAtIndex:button.tag];
        NSNumber *price = [dict objectForKey:@"price"];
        amount = amount - [price floatValue];
        [SharedInfo shared].totalAmount = [NSNumber numberWithFloat:amount];
        [allPriceLabel2 setText:[NSString stringWithFormat:@"%.2f元", amount]];
        [selectExtras removeObject:[dict objectForKey:@"extraId"]];
    }
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmButtonPressed:(id)sender {
    [SharedInfo shared].productId = [orderInfo objectForKey:@"productId"];
    [SharedInfo shared].extraIds = [[NSMutableArray alloc] init];
    
    for (NSString *extrId in selectExtras) {
        [[SharedInfo shared].extraIds addObject:extrId];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:GETTIMESORDER parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        NSNumber *success = [resultDic objectForKey:@"success"];
        if ([success intValue] == 1) {
            NSDictionary *dict = [resultDic objectForKey:@"data"];
            [SharedInfo shared].leftCount = [dict objectForKey:@"leftCount"];
            [SharedInfo shared].timeOrderId = [dict objectForKey:@"timeOrderId"];
        } else {
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
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
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerApp(1, @"Result: %@", result);
    }];
    
    [self performSegueWithIdentifier:@"showPay" sender:self];
}

- (void)setData {
    if (myButton.selected ||
        myButton2.selected) {
        return;
    }
    if (firstOrder) {
        NSNumber *price = [orderInfo objectForKey:@"price"];
        [SharedInfo shared].amount = price;
        [SharedInfo shared].totalAmount = price;
        NSNumber *removePrice = [orderInfo objectForKey:@"removePrice"];
        [firstPriceLabel setText:[NSString stringWithFormat:@"%.2f元", [price floatValue]]];
        [priceLabel setText:[NSString stringWithFormat:@"%.2f元", [removePrice floatValue]]];
        firstPriceLabel.hidden = NO;
        removeImage.hidden = NO;
        [allPriceLabel2 setText:[NSString stringWithFormat:@"%.2f元", [price floatValue]]];
        amount = [price floatValue];
    } else {
        NSNumber *price = [orderInfo objectForKey:@"price"];
        [SharedInfo shared].amount = price;
        [SharedInfo shared].totalAmount = price;
        [priceLabel setText:[NSString stringWithFormat:@"%.2f元", [price floatValue]]];
        [allPriceLabel2 setText:[NSString stringWithFormat:@"%.2f元", [price floatValue]]];
        amount = [price floatValue];
    }
}

- (void)setExtraData {
    NSArray *extraArray = [SharedInfo shared].extraList;
    NSDictionary *dict1 = extraArray[0];
    NSDictionary *dict2 = extraArray[1];
    
    myButton.tag = 0;
    
    NSString *extraName = [dict1 objectForKey:@"extraName"];
    [myLabel setText:extraName];
    
    NSNumber *price = [dict1 objectForKey:@"price"];
    [myPrice setText:[NSString stringWithFormat:@"%.2f元", [price floatValue]]];
    
    myButton2.tag = 1;
    
    NSString *extraName2 = [dict2 objectForKey:@"extraName"];
    [myLabel2 setText:extraName2];
    
    NSNumber *price2 = [dict2 objectForKey:@"price"];
    [myPrice2 setText:[NSString stringWithFormat:@"%.2f元", [price2 floatValue]]];
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

@end
