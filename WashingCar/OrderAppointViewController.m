//
//  OrderAppointViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 3/9/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "OrderAppointViewController.h"
#import "SharedInfo.h"
#import <RatingBar/RatingBar.h>
#import <AFNetworking/AFNetworking.h>
#import <JSONKit-NoWarning/JSONKit.h>
#import <AFNetworking/UIKit+AFNetworking.h>
#import <SMPageControl/SMPageControl.h>

@interface OrderAppointViewController () <UITextViewDelegate, UITabBarDelegate, UIScrollViewDelegate>
{
    UIImageView *backgroundImage;
    UIButton *shotImage;
    UILabel *nameLabel;
    UILabel *phoneLabel;
    UILabel *finishLabel;
    UILabel *orderPriceLabel1;
    UILabel *orderPriceLabel2;
    UILabel *statusLabel;
    UILabel *appointLabel1;
    UILabel *appointLabel2;
    UILabel *washTimeLabel1;
    UILabel *washTimeLabel2;
    UILabel *carInfoLabel;
    UILabel *locationLabel;
    UIImageView *splitView1;
    UIImageView *splitView2;
    RatingBar *myBar;
    UIButton *returnOrderButton;
    NSDictionary *infoDict;
    
    // feed view
    UIScrollView *feedView;
    RatingBar *feedRatingbar;
    UITextView *feedTextView;
    UIButton *feedButton;
    UIScrollView *feedScrollView;
    UIImageView *feedFirstImage;
    UIImageView *feedLastImage;
    UIImageView *feedImage1;
    UIImageView *feedImage2;
    UIImageView *feedImage3;
    
    // finish View;
    UIScrollView *finishView;
    RatingBar *finishRatingbar;
    UIImageView *splitImage;
    UITextView *finishTextView;
    UILabel *finishRatingLabel;
    UIScrollView *finishScrollView;
    UIImageView *finishFirstImage;
    UIImageView *finishLastImage;
    UIImageView *finishImage1;
    UIImageView *finishImage2;
    UIImageView *finishImage3;
    UIImageView *finishImage;
    
    SMPageControl *pageControl1;
    SMPageControl *pageControl2;
}
@property (weak, nonatomic) IBOutlet UITabBar *customTabbar;

@end

@implementation OrderAppointViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *orderId = [SharedInfo shared].currentOrderId;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[ORDERDETAIL stringByAppendingString:orderId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        infoDict = [resultDic objectForKey:@"data"];
        [self setInfo:infoDict];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerApp(1, @"Result: %@", result);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    feedView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width * 830.0/640.0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    self.customTabbar.delegate = self;
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backgroundImage setImage:[UIImage imageNamed:@"backgroundImage"]];
    [self.view addSubview:backgroundImage];
    
    shotImage = [UIButton buttonWithType:UIButtonTypeCustom];
    shotImage.hidden = YES;
    shotImage.frame = CGRectMake(self.view.frame.size.width * 62.0/640.0, self.view.frame.size.width * 158.0/640.0, self.view.frame.size.width * 144.0/640.0, self.view.frame.size.width * 144.0/640.0);
    [shotImage setBackgroundImage:[UIImage imageNamed:@"defaultShot"] forState:UIControlStateNormal];
    [shotImage addTarget:self action:@selector(shotImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shotImage];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 230.0/640.0, self.view.frame.size.width * 174.0/640.0, 80, 16.0)];
    nameLabel.hidden = YES;
    [nameLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:nameLabel];
    
    phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 418/640.0, self.view.frame.size.width * 170.0/640.0, 120, 24.0)];
    phoneLabel.hidden = YES;
    phoneLabel.userInteractionEnabled = YES;
    [phoneLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [phoneLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:phoneLabel];
    
    UITapGestureRecognizer *tapPhone = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhone:)];
    [phoneLabel addGestureRecognizer:tapPhone];
    
    myBar = [[RatingBar alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 212.0/640.0, self.view.frame.size.width * 242.0/640.0, 60.0, 12.0)];
    myBar.hidden = YES;
    [myBar setBackgroundColor:[UIColor clearColor]];
    myBar.userInteractionEnabled = NO;
    [self.view addSubview:myBar];
    
    finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 418.0/640.0, self.view.frame.size.width * 246.0/640.0, 80, 11.0)];
    finishLabel.hidden = YES;
    [finishLabel setFont:[UIFont fontWithName:@"Heiti SC" size:11.0]];
    [finishLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:finishLabel];
    
    orderPriceLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 62.0/640.0, self.view.frame.size.width * 360.0/640.0, 80, 16.0)];
    orderPriceLabel1.hidden = YES;
    [orderPriceLabel1 setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [orderPriceLabel1 setTextColor:[UIColor whiteColor]];
    [orderPriceLabel1 setText:@"订单价格"];
    [self.view addSubview:orderPriceLabel1];
    
    orderPriceLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 226.0/640.0, self.view.frame.size.width * 360.0/640.0, 120, 16.0)];
    orderPriceLabel2.hidden = YES;
    [orderPriceLabel2 setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [orderPriceLabel2 setTextColor:[UIColor whiteColor]];
    [self.view addSubview:orderPriceLabel2];
    
    statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 500.0/640.0, self.view.frame.size.width * 366.0/640.0, 80, 11.0)];
    statusLabel.hidden = YES;
    [statusLabel setFont:[UIFont fontWithName:@"Heiti SC" size:11.0]];
    [statusLabel setTextColor:YELLOWCOLOR];
    [self.view addSubview:statusLabel];
    
    appointLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 62.0/640.0, self.view.frame.size.width * 426.0/640.0, 60, 11.0)];
    appointLabel1.hidden = YES;
    [appointLabel1 setFont:[UIFont fontWithName:@"Heiti SC" size:11.0]];
    [appointLabel1 setTextColor:[UIColor whiteColor]];
    [appointLabel1 setText:@"预约时间"];
    [self.view addSubview:appointLabel1];
    
    appointLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 166.0/640.0, self.view.frame.size.width * 426.0/640.0, 160.0, 11.0)];
    appointLabel2.hidden = YES;
    [appointLabel2 setFont:[UIFont fontWithName:@"Heiti SC" size:11.0]];
    [appointLabel2 setTextColor:[UIColor whiteColor]];
    [self.view addSubview:appointLabel2];
    
    washTimeLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 62.0/640.0, self.view.frame.size.width * 456.0/640.0, 60, 11.0)];
    washTimeLabel1.hidden = YES;
    [washTimeLabel1 setFont:[UIFont fontWithName:@"Heiti SC" size:11.0]];
    [washTimeLabel1 setTextColor:[UIColor whiteColor]];
    [washTimeLabel1 setText:@"洗车时间"];
    [self.view addSubview:washTimeLabel1];
    
    washTimeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 166.0/640.0, self.view.frame.size.width * 456.0/640.0, 160.0, 11.0)];
    washTimeLabel2.hidden = YES;
    [washTimeLabel2 setFont:[UIFont fontWithName:@"Heiti SC" size:11.0]];
    [washTimeLabel2 setTextColor:[UIColor whiteColor]];
    [self.view addSubview:washTimeLabel2];
    
    carInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 62.0/640.0, self.view.frame.size.width * 456.0/640.0, 280, 11.0)];
    carInfoLabel.hidden = YES;
    [carInfoLabel setFont:[UIFont fontWithName:@"Heiti SC" size:11.0]];
    [carInfoLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:carInfoLabel];

    locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 62.0/640.0, self.view.frame.size.width * 484.0/640.0, 260, 11.0)];
    locationLabel.hidden = YES;
    [locationLabel setFont:[UIFont fontWithName:@"Heiti SC" size:11.0]];
    [locationLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:locationLabel];
    
    splitView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 352.0/640.0, self.view.frame.size.width, self.view.frame.size.width/320.0)];
    splitView1.hidden = YES;
    [splitView1 setImage:[UIImage imageNamed:@"orderSplit"]];
    [self.view addSubview:splitView1];
    
    splitView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 556.0/640.0, self.view.frame.size.width, self.view.frame.size.width/320.0)];
    splitView2.hidden = YES;
    [splitView2 setImage:[UIImage imageNamed:@"orderSplit"]];
    [self.view addSubview:splitView2];
    
    returnOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnOrderButton.hidden = YES;
    returnOrderButton.frame = CGRectMake(0.0, self.view.frame.size.width * 596.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 78.0/640.0);
    [returnOrderButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [returnOrderButton setTitle:@"撤销订单" forState:UIControlStateNormal];
    [returnOrderButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [returnOrderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [returnOrderButton addTarget:self action:@selector(returnOrderButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnOrderButton];
    
    // feed view
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(feedViewTap:)];
    
    feedView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 584.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 480.0/640.0)];
    [feedView addGestureRecognizer:tap2];
    [feedView setBackgroundColor:[UIColor clearColor]];

    feedScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.width * 322.0/640.0)];
    feedScrollView.tag = 1;
    feedScrollView.delegate = self;
    feedScrollView.bounces = YES;
    feedScrollView.pagingEnabled = YES;
    feedScrollView.showsHorizontalScrollIndicator = NO;
    
    
    for (int i = 0; i < 3; i++) {
        switch (i) {
            case 0:
            {
                feedImage1 = [[UIImageView alloc] initWithFrame:CGRectMake((feedScrollView.frame.size.width * 0) + feedScrollView.frame.size.width, 0, feedScrollView.frame.size.width, feedScrollView.frame.size.height)];
                [feedImage1 setBackgroundColor:[UIColor blackColor]];
                [feedScrollView addSubview:feedImage1];
                break;
            }
            case 1:
            {
                feedImage2 = [[UIImageView alloc] initWithFrame:CGRectMake((feedScrollView.frame.size.width * 1) + feedScrollView.frame.size.width, 0, feedScrollView.frame.size.width, feedScrollView.frame.size.height)];
                [feedImage2 setBackgroundColor:[UIColor blackColor]];
                [feedScrollView addSubview:feedImage2];
                break;
            }
            case 2:
            {
                feedImage3 = [[UIImageView alloc] initWithFrame:CGRectMake((feedScrollView.frame.size.width * 2) + feedScrollView.frame.size.width, 0, feedScrollView.frame.size.width, feedScrollView.frame.size.height)];
                [feedImage3 setBackgroundColor:[UIColor blackColor]];
                [feedScrollView addSubview:feedImage3];
                break;
            }
            default:
                break;
        }
    }
    
    // 取数组最后一张图片 放在第0页
    feedLastImage = [[UIImageView alloc] initWithImage:nil];
    [feedLastImage setBackgroundColor:[UIColor blackColor]];
    feedLastImage.frame = CGRectMake(0, 0, feedScrollView.frame.size.width, feedScrollView.frame.size.height); // 添加最后1页在首页 循环
    [feedScrollView addSubview:feedLastImage];
    // 取数组第一张图片 放在最后1页
    feedFirstImage = [[UIImageView alloc] initWithImage:nil];
    [feedFirstImage setBackgroundColor:[UIColor blackColor]];
    feedFirstImage.frame = CGRectMake((feedScrollView.frame.size.width * 4) , 0, feedScrollView.frame.size.width, feedScrollView.frame.size.height); // 添加第1页在最后 循环
    [feedScrollView addSubview:feedFirstImage];
    
    [feedScrollView setContentSize:CGSizeMake(feedScrollView.frame.size.width * 5, feedScrollView.frame.size.height)]; //  +上第1页和第3页  原理：3-[1-2-3]-1
    [feedScrollView setContentOffset:CGPointMake(0, 0)];
    [feedScrollView scrollRectToVisible:CGRectMake(feedScrollView.frame.size.width,0,feedScrollView.frame.size.width,feedScrollView.frame.size.height) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置放第3页
    [feedView addSubview:feedScrollView];
    
    pageControl1 = [[SMPageControl alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 500.0/640.0, self.view.frame.size.width, 30)];
    pageControl1.tapBehavior = SMPageControlTapBehaviorJump;
    pageControl1.numberOfPages = 3;
    pageControl1.currentPage = 0;
    
    pageControl1 = [[SMPageControl alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 280.0/640.0, self.view.frame.size.width, 30)];
    pageControl1.tapBehavior = SMPageControlTapBehaviorJump;
    pageControl1.numberOfPages = 3;
    pageControl1.currentPage = 0;
    [pageControl1 setPageIndicatorImage:[UIImage imageNamed:@"bannerdot"]];
    [pageControl1 setCurrentPageIndicatorImage:[UIImage imageNamed:@"bannerdotactive"]];
    [pageControl1 addTarget:self action:@selector(pageControl1:) forControlEvents:UIControlEventValueChanged];
    [feedView addSubview:pageControl1];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 362.0/640.0, self.view.frame.size.width, 16.0)];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setFont:HEITISC16];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setText:@"请对这次服务做出评价"];
    [feedView addSubview:textLabel];
    
    feedRatingbar = [[RatingBar alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 50.0/640.0, self.view.frame.size.width * 416.0/640.0, self.view.frame.size.width * 540.0/640.0, 34.0)];
    [feedRatingbar setBackgroundColor:[UIColor clearColor]];
    [feedView addSubview:feedRatingbar];
    
    feedTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 120.0/640.0, self.view.frame.size.width * 482.0/640.0, self.view.frame.size.width * 400.0/640.0, self.view.frame.size.width * 200.0/640.0)];
    [feedTextView setBackgroundColor:GRAYCOLOR];
    [feedTextView setFont:HEITISC13];
    feedTextView.delegate = self;
    [feedTextView setTextColor:[UIColor whiteColor]];
    feedTextView.layer.borderWidth = 1.0;
    feedTextView.layer.borderColor = [YELLOWCOLOR CGColor];
    feedTextView.layer.cornerRadius = 10.0;
    [feedView addSubview:feedTextView];
    
    feedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [feedButton setBackgroundColor:YELLOWCOLOR];
    [feedButton setFrame:CGRectMake(0.0, self.view.frame.size.width * 726.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 78.0/640.0)];
    [feedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [feedButton setTitle:@"评价" forState:UIControlStateNormal];
    [feedButton addTarget:self action:@selector(feedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [feedView addSubview:feedButton];
    
    feedView.hidden = YES;
    
    [self.view addSubview:feedView];
    
    // finish view
    finishView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 584.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 480.0/640.0)];
    [finishView setBackgroundColor:[UIColor clearColor]];
    
    finishImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.width * 322.0/640.0)];
    finishImage.hidden = YES;
    [finishView addSubview:finishImage];
    
    finishScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.width * 322.0/640.0)];
    finishScrollView.tag = 2;
    finishScrollView.delegate = self;
    finishScrollView.bounces = YES;
    finishScrollView.pagingEnabled = YES;
    finishScrollView.showsHorizontalScrollIndicator = NO;
    
    for (int i = 0; i < 3; i++) {
        switch (i) {
            case 0:
            {
                finishImage1 = [[UIImageView alloc] initWithFrame:CGRectMake((finishScrollView.frame.size.width * 0) + finishScrollView.frame.size.width, 0, finishScrollView.frame.size.width, finishScrollView.frame.size.height)];
                [finishImage1 setBackgroundColor:[UIColor blackColor]];
                [finishScrollView addSubview:finishImage1];
                break;
            }
            case 1:
            {
                finishImage2 = [[UIImageView alloc] initWithFrame:CGRectMake((finishScrollView.frame.size.width * 1) + finishScrollView.frame.size.width, 0, finishScrollView.frame.size.width, finishScrollView.frame.size.height)];
                [finishImage2 setBackgroundColor:[UIColor blackColor]];
                [finishScrollView addSubview:finishImage2];
                break;
            }
            case 2:
            {
                finishImage3 = [[UIImageView alloc] initWithFrame:CGRectMake((finishScrollView.frame.size.width * 2) + finishScrollView.frame.size.width, 0, finishScrollView.frame.size.width, finishScrollView.frame.size.height)];
                [finishImage3 setBackgroundColor:[UIColor blackColor]];
                [finishScrollView addSubview:finishImage3];
                break;
            }
            default:
                break;
        }
    }
    
    // 取数组最后一张图片 放在第0页
    finishLastImage = [[UIImageView alloc] initWithImage:nil];
    [finishLastImage setBackgroundColor:[UIColor blackColor]];
    finishLastImage.frame = CGRectMake(0, 0, finishScrollView.frame.size.width, finishScrollView.frame.size.height); // 添加最后1页在首页 循环
    [finishScrollView addSubview:finishLastImage];
    // 取数组第一张图片 放在最后1页
    finishFirstImage = [[UIImageView alloc] initWithImage:nil];
    [finishFirstImage setBackgroundColor:[UIColor blackColor]];
    finishFirstImage.frame = CGRectMake((finishScrollView.frame.size.width * 4) , 0, finishScrollView.frame.size.width, feedScrollView.frame.size.height); // 添加第1页在最后 循环
    [finishScrollView addSubview:finishFirstImage];
    
    [finishScrollView setContentSize:CGSizeMake(finishScrollView.frame.size.width * 5, finishScrollView.frame.size.height)]; //  +上第1页和第3页  原理：3-[1-2-3]-1
    [finishScrollView setContentOffset:CGPointMake(0, 0)];
    [finishScrollView scrollRectToVisible:CGRectMake(finishScrollView.frame.size.width,0,finishScrollView.frame.size.width,finishScrollView.frame.size.height) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置放第3页
    [finishView addSubview:finishScrollView];
    
    pageControl2 = [[SMPageControl alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 280.0/640.0, self.view.frame.size.width, 30)];
    pageControl2.tapBehavior = SMPageControlTapBehaviorJump;
    pageControl2.numberOfPages = 3;
    pageControl2.currentPage = 0;
    [pageControl2 setPageIndicatorImage:[UIImage imageNamed:@"bannerdot"]];
    [pageControl2 setCurrentPageIndicatorImage:[UIImage imageNamed:@"bannerdotactive"]];
    [pageControl2 addTarget:self action:@selector(pageControl2:) forControlEvents:UIControlEventValueChanged];
    [finishView addSubview:pageControl2];
    
    splitImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 370.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 2.0/640.0)];
    [splitImage setImage:[UIImage imageNamed:@"orderSplit"]];
    [finishView addSubview:splitImage];
    
    finishRatingbar = [[RatingBar alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 50.0/640.0, self.view.frame.size.width * 420.0/640.0, self.view.frame.size.width * 540.0/640.0, 34.0)];
    finishRatingbar.userInteractionEnabled = NO;
    [finishRatingbar setBackgroundColor:[UIColor clearColor]];
    [finishView addSubview:finishRatingbar];
    
    finishRatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 498.0/640.0, self.view.frame.size.width, 16.0)];
    [finishRatingLabel setTextAlignment:NSTextAlignmentCenter];
    [finishRatingLabel setTextColor:YELLOWCOLOR];
    [finishRatingLabel setFont:HEITISC16];
    [finishView addSubview:finishRatingLabel];
    
    finishTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 120.0/640.0, self.view.frame.size.width * 552.0/640.0, self.view.frame.size.width * 400.0/640.0, self.view.frame.size.width * 200.0/640.0)];
    finishTextView.editable = NO;
    finishTextView.selectable = NO;
    [finishTextView setBackgroundColor:GRAYCOLOR];
    [finishTextView setFont:HEITISC13];
    [finishTextView setTextColor:[UIColor whiteColor]];
    finishTextView.layer.borderWidth = 1.0;
    finishTextView.layer.borderColor = [YELLOWCOLOR CGColor];
    finishTextView.layer.cornerRadius = 10.0;
    [finishView addSubview:finishTextView];
    
    finishView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width * 800.0/640.0);
    finishView.hidden = YES;
    [self.view addSubview:finishView];
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if (item.tag == 1) {
        
    } else if (item.tag == 2) {
        [self performSegueWithIdentifier:@"showMine" sender:self];
    }
}

- (void)tapPhone:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"联系" message:@"是否立即联系洗车师傅" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1;
    [alert show];
}

- (void)returnOrderButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取消订单" message:@"确认取消订单？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag = 2;
    [alert show];
}

- (void)feedViewTap:(id)sender {
    [feedTextView resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id theSegue = segue.destinationViewController;
    if ([segue.identifier isEqual:@"showBusinessMan"]) {
        [theSegue setValue:[infoDict objectForKey:@"businessId"] forKey:@"businessId"];
    }
}

- (void)shotImagePressed:(id)sender {
    [self performSegueWithIdentifier:@"showBusinessMan" sender:self];
}

- (void)feedButtonPressed:(id)sender {
    NSDictionary *parameters = @{@"orderId": [SharedInfo shared].currentOrderId, @"comment": feedTextView.text, @"businessId": [infoDict objectForKey:@"businessId"], @"rank": [NSNumber numberWithLong:feedRatingbar.starNumber]};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:FEEDORDER parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        
        NSNumber *success = [resultDic objectForKey:@"success"];
        
        if ([success integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *message = [resultDic objectForKey:@"message"];
            
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInfo:(NSDictionary *)dict {
    NSLog(@"%@", dict);
    
    NSString *price = [dict objectForKey:@"price"];
    if ([price isEqual:[NSNull null]]) {
        price = @"";
    }
    [orderPriceLabel2 setText:[NSString stringWithFormat:@"%d元", [price intValue]]];
    
    NSNumber *businessCount = [dict objectForKey:@"businessCount"];
    if (businessCount == nil) {
        businessCount = [NSNumber numberWithInt:0];
    }
    [finishLabel setText:[NSString stringWithFormat:@"已完成%@单", [businessCount stringValue]]];

    NSString *statusText = [dict objectForKey:@"statusText"];
    [statusLabel setText:statusText];
    
    NSString *businessName = [dict objectForKey:@"businessName"];
    if ([businessName isEqual:[NSNull null]]) {
        businessName = @"";
    }
    [nameLabel setText:businessName];

    NSString *businessPhone = [dict objectForKey:@"businessPhone"];
    if ([businessPhone isEqual:[NSNull null]]) {
        businessPhone = @"";
    }
    [phoneLabel setText:businessPhone];
    
    NSNumber *timestamp = [dict objectForKey:@"orderDate"];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:([timestamp longLongValue]/1000)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *orderDate = [dateFormatter stringFromDate:date];
    if ([orderDate isEqual:[NSNull null]]) {
        orderDate = @"";
    }
    NSNumber *startTime = [dict objectForKey:@"startTime"];
    if (startTime == nil) {
        startTime = [NSNumber numberWithInt:0];
    }
    NSNumber *endTime = [dict objectForKey:@"endTime"];
    if (endTime == nil) {
        endTime = [NSNumber numberWithInt:0];
    }
    [appointLabel2 setText:[NSString stringWithFormat:@"%@ %@:00 ~ %@:00", orderDate, [startTime stringValue], [endTime stringValue]]];
    
    NSNumber *finishTime = [dict objectForKey:@"finishTime"];
    NSString *finishDate;
    if (![finishTime isEqual:[NSNull null]]) {
        NSDate *date2= [NSDate dateWithTimeIntervalSince1970:([finishTime longLongValue]/1000)];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        finishDate = [dateFormatter stringFromDate:date2];
    } else {
        finishDate = @"";
    }
    
    [washTimeLabel2 setText:finishDate];
    
    NSString *carInfo = [dict objectForKey:@"carInfo"];
    if ([carInfo isEqual:[NSNull null]]) {
        carInfo = @"null";
    }
    NSString *carNum = [dict objectForKey:@"carNum"];
    if ([carNum isEqual:[NSNull null]]) {
        carNum = @"";
    }
    [carInfoLabel setText:[NSString stringWithFormat:@"%@ %@", carInfo, carNum]];
    
    NSDictionary *locationDict = [[dict objectForKey:@"mapLocation"] objectFromJSONString];
    NSString *address = [locationDict objectForKey:@"address"];
    if (address == nil) {
        address = @"";
    }
    [locationLabel setText:address];
    
    NSNumber *businessRank = [dict objectForKey:@"businessRank"];
    if (![businessRank isEqual:[NSNull null]]) {
        myBar.starNumber = [businessRank intValue];
    } else {
        myBar.starNumber = 0;
    }
    
    NSNumber *cancelEnable = [dict objectForKey:@"cancelEnable"];
    if (![cancelEnable isEqual:[NSNull null]] &&
        [[cancelEnable stringValue] isEqualToString:@"1"]) {
        returnOrderButton.hidden = NO;
    }
    
    NSNumber *status = [dict objectForKey:@"status"];
    if ([[status stringValue] isEqual:[NSNull null]]) {
        status = [NSNumber numberWithInt:0];
    }
    
    orderPriceLabel1.hidden = NO;
    orderPriceLabel2.hidden = NO;
    statusLabel.hidden = NO;
    appointLabel1.hidden = NO;
    appointLabel2.hidden = NO;
    carInfoLabel.hidden = NO;
    locationLabel.hidden = NO;
    splitView1.hidden = NO;
    splitView2.hidden = NO;
    
    
    if ([[status stringValue] isEqualToString:@"5"]) {
        feedView.hidden = NO;
        washTimeLabel1.hidden = NO;
        washTimeLabel2.hidden = NO;
        shotImage.hidden = NO;
        myBar.hidden = NO;
        nameLabel.hidden = NO;
        phoneLabel.hidden = NO;
        finishLabel.hidden = NO;
        
        carInfoLabel.frame = CGRectMake(self.view.frame.size.width * 62.0/640.0, self.view.frame.size.width * 484.0/640.0, 280, 11.0);
        locationLabel.frame = CGRectMake(self.view.frame.size.width * 62.0/640.0, self.view.frame.size.width * 514.0/640.0, 260, 11.0);
        
        NSArray *attchPath = [dict objectForKey:@"attchPath"];
        [feedImage1 setImageWithURL:[NSURL URLWithString:attchPath[0]] placeholderImage:nil];
        [feedImage2 setImageWithURL:[NSURL URLWithString:attchPath[1]] placeholderImage:nil];
        [feedImage3 setImageWithURL:[NSURL URLWithString:attchPath[2]] placeholderImage:nil];
        [feedFirstImage setImageWithURL:[NSURL URLWithString:attchPath[0]] placeholderImage:nil];
        [feedLastImage setImageWithURL:[NSURL URLWithString:attchPath[2]] placeholderImage:nil];
    } else if ([[status stringValue] isEqualToString:@"6"]) {
        finishView.hidden = NO;
        washTimeLabel1.hidden = NO;
        washTimeLabel2.hidden = NO;
        shotImage.hidden = NO;
        myBar.hidden = NO;
        nameLabel.hidden = NO;
        phoneLabel.hidden = NO;
        finishLabel.hidden = NO;
        
        carInfoLabel.frame = CGRectMake(self.view.frame.size.width * 62.0/640.0, self.view.frame.size.width * 484.0/640.0, 280, 11.0);
        locationLabel.frame = CGRectMake(self.view.frame.size.width * 62.0/640.0, self.view.frame.size.width * 514.0/640.0, 260, 11.0);
        NSString *rank = [dict objectForKey:@"rank"];
        if (![rank isEqual:[NSNull null]]) {
            finishRatingbar.starNumber = [rank integerValue];
        }
        [finishRatingLabel setText:[NSString stringWithFormat:@"%@分", rank]];
        
        finishTextView.hidden = YES;
        
        NSArray *attchPath = [dict objectForKey:@"attchPath"];
        [finishImage1 setImageWithURL:[NSURL URLWithString:attchPath[0]] placeholderImage:nil];
        [finishImage2 setImageWithURL:[NSURL URLWithString:attchPath[1]] placeholderImage:nil];
        [finishImage3 setImageWithURL:[NSURL URLWithString:attchPath[2]] placeholderImage:nil];
        [finishFirstImage setImageWithURL:[NSURL URLWithString:attchPath[0]] placeholderImage:nil];
        [finishLastImage setImageWithURL:[NSURL URLWithString:attchPath[2]] placeholderImage:nil];
    } else if ([[status stringValue] isEqualToString:@"4"]) {
        shotImage.hidden = NO;
        myBar.hidden = NO;
        nameLabel.hidden = NO;
        phoneLabel.hidden = NO;
        finishLabel.hidden = NO;
    } else if ([[status stringValue] isEqualToString:@"3"]) {
        shotImage.hidden = NO;
        myBar.hidden = NO;
        nameLabel.hidden = NO;
        phoneLabel.hidden = NO;
        finishLabel.hidden = NO;
    } else if ([[status stringValue] isEqualToString:@"8"]) {
        finishView.hidden = NO;
        shotImage.hidden = NO;
        myBar.hidden = NO;
        nameLabel.hidden = NO;
        phoneLabel.hidden = NO;
        finishLabel.hidden = NO;
        finishImage.hidden = NO;
        finishScrollView.hidden = YES;
        
        finishRatingbar.hidden = YES;
        splitImage.hidden = YES;
        finishTextView.hidden = YES;
        finishRatingLabel.hidden = YES;
        pageControl2.hidden = YES;
        
//        finishView.scrollEnabled = NO;
//        [orderPriceLabel1 setFrame:CGRectMake(self.view.frame.size.width * 62.0/640.0, self.view.frame.size.width * 202.0/640.0, 80, 16.0)];
//        
//        [orderPriceLabel2 setFrame:CGRectMake(self.view.frame.size.width * 226.0/640.0, self.view.frame.size.width * 202.0/640.0, 200, 16.0)];
//        
//        [statusLabel setFrame:CGRectMake(self.view.frame.size.width * 500.0/640.0, self.view.frame.size.width * 208.0/640.0, 80, 11.0)];
//        
//        [appointLabel1 setFrame:CGRectMake(self.view.frame.size.width * 62.0/640.0, self.view.frame.size.width * 268.0/640.0, 60, 11.0)];
//        
//        [appointLabel2 setFrame:CGRectMake(self.view.frame.size.width * 166.0/640.0, self.view.frame.size.width * 268.0/640.0, 160.0, 11.0)];
//        
//        [carInfoLabel setFrame:CGRectMake(self.view.frame.size.width * 62.0/640.0, self.view.frame.size.width * 298.0/640.0, 280, 11.0)];
//        
//        [locationLabel setFrame:CGRectMake(self.view.frame.size.width * 62.0/640.0, self.view.frame.size.width * 326.0/640.0, 260, 11.0)];
//        
//        [splitView1 setFrame:CGRectMake(0.0, self.view.frame.size.width * 186.0/640.0, self.view.frame.size.width, self.view.frame.size.width/320.0)];
//        
//        [splitView2 setFrame:CGRectMake(0.0, self.view.frame.size.width * 398.0/640.0, self.view.frame.size.width, self.view.frame.size.width/320.0)];
        
        NSArray *attchPath = [dict objectForKey:@"attchPath"];
        [finishImage setImageWithURL:[NSURL URLWithString:attchPath[0]] placeholderImage:nil];
    } else {
        [orderPriceLabel1 setFrame:CGRectMake(self.view.frame.size.width * 62.0/640.0, self.view.frame.size.width * 202.0/640.0, 80, 16.0)];
        
        [orderPriceLabel2 setFrame:CGRectMake(self.view.frame.size.width * 226.0/640.0, self.view.frame.size.width * 202.0/640.0, 200, 16.0)];
        
        [statusLabel setFrame:CGRectMake(self.view.frame.size.width * 500.0/640.0, self.view.frame.size.width * 208.0/640.0, 80, 11.0)];
        
        [appointLabel1 setFrame:CGRectMake(self.view.frame.size.width * 62.0/640.0, self.view.frame.size.width * 268.0/640.0, 60, 11.0)];
        
        [appointLabel2 setFrame:CGRectMake(self.view.frame.size.width * 166.0/640.0, self.view.frame.size.width * 268.0/640.0, 160.0, 11.0)];
        
        [carInfoLabel setFrame:CGRectMake(self.view.frame.size.width * 62.0/640.0, self.view.frame.size.width * 298.0/640.0, 280, 11.0)];
        
        [locationLabel setFrame:CGRectMake(self.view.frame.size.width * 62.0/640.0, self.view.frame.size.width * 326.0/640.0, 260, 11.0)];

        [splitView1 setFrame:CGRectMake(0.0, self.view.frame.size.width * 186.0/640.0, self.view.frame.size.width, self.view.frame.size.width/320.0)];
        
        [splitView2 setFrame:CGRectMake(0.0, self.view.frame.size.width * 398.0/640.0, self.view.frame.size.width, self.view.frame.size.width/320.0)];
    
        returnOrderButton.frame = CGRectMake(0.0, self.view.frame.size.width * 438.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 78.0/640.0);
    }
    
}

#pragma mark - Text view delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 200.0, self.view.frame.size.width, self.view.frame.size.height);
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 200.0, self.view.frame.size.width, self.view.frame.size.height);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- UIScroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1) {
        CGFloat pagewidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pagewidth/5)/pagewidth)+1;
        page--;  // 默认从第二页开始
        pageControl1.currentPage = page;
    } else {
        CGFloat pagewidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pagewidth/5)/pagewidth)+1;
        page--;  // 默认从第二页开始
        pageControl2.currentPage = page;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = scrollView.frame.size.width;
    int currentPage = floor((scrollView.contentOffset.x - pagewidth/5) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage==0)
    {
        [scrollView scrollRectToVisible:CGRectMake(scrollView.frame.size.width * 3,0,scrollView.frame.size.width,scrollView.frame.size.height) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==4)
    {
        [scrollView scrollRectToVisible:CGRectMake(scrollView.frame.size.width,0,scrollView.frame.size.width,scrollView.frame.size.height) animated:NO]; // 最后+1,循环第1页
    }
}

- (void)pageControl1:(id)sender
{
    NSInteger currentPage = pageControl1.currentPage;
    
    [feedScrollView scrollRectToVisible:CGRectMake(feedScrollView.frame.size.width * (currentPage + 1),0,feedScrollView.frame.size.width,feedScrollView.frame.size.height) animated:NO];
}

- (void)pageControl2:(id)sender
{
    NSInteger currentPage = pageControl2.currentPage;
    
    [finishScrollView scrollRectToVisible:CGRectMake(finishScrollView.frame.size.width * (currentPage + 1),0,finishScrollView.frame.size.width,finishScrollView.frame.size.height) animated:NO];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneLabel.text]]];
        }
    } else {
        if (buttonIndex == 1) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:[NSString stringWithFormat:@"%@/%@", CANCELORDER, [SharedInfo shared].currentOrderId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSData *data = responseObject;
                NSDictionary *resultDic = [data objectFromJSONData];
                
                NSNumber *success = [resultDic objectForKey:@"success"];
                
                if ([success integerValue] == 1) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    NSString *message = [resultDic objectForKey:@"message"];
                    
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
    }
}

@end
