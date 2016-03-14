//  来啦洗车主页
//  MainViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 1/19/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "MainViewController.h"
#import "SharedInfo.h"
#import <SMPageControl/SMPageControl.h>
#import <AFNetworking/UIKit+AFNetworking.h>
#import "Player.h"
#import <SDiPhoneVersion/SDiPhoneVersion.h>
#import "ShopViewController.h"
#import "ShareYouhuiquanViewController.h"


@interface MainViewController () <UITabBarDelegate, UIScrollViewDelegate>
{
    SMPageControl *pageControl;
    UIImageView *firstImageView;
    UIImageView *lastiImageView;
    BOOL flag;
    BOOL isFirst;
    NSTimer *myTimer2;
    double angle;
    NSInteger musicCount;
    UIImageView *topView;
    UIImageView *musicView;
    UILabel *titleLabel;
}

@property (strong, nonatomic) UIButton *washButton;
@property (strong, nonatomic) UIButton *weatherButton;
@property (strong, nonatomic) UIButton *flowButton;
@property (strong, nonatomic) UIButton *specialButton;
@property (weak, nonatomic) IBOutlet UITabBar *customTabBar;
@property (strong, nonatomic) UIScrollView *slideView;
@property (strong, nonatomic) UIImageView *imageView1;
@property (strong, nonatomic) UIImageView *imageView2;
@property (strong, nonatomic) UIImageView *imageView3;
@property (strong, nonatomic) UIImageView *imageView4;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"来啦主页"];
    
    self.navigationController.navigationBar.hidden = YES;
    [SharedInfo shared].pid = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"来啦首页"];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    // 获取图片地址
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@?T=%@", PICTUREURL, timeString] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSArray *result = [data objectFromJSONData];
        for (int i = 0; i < 4; i++) {
            NSDictionary *dict = [result objectAtIndex:i];
            NSString *urlString = [dict objectForKey:@"name"];
            NSString *goodsId = [dict objectForKey:@"goodsId"];
            switch (i) {
                case 0:
                {
                    [SharedInfo shared].imageURL1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@picture/%@", HOST, urlString]];
                    [SharedInfo shared].pid1 = goodsId == nil ? nil : goodsId;
                    break;
                }
                case 1:
                {
                    [SharedInfo shared].imageURL2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@picture/%@", HOST, urlString]];
                    [SharedInfo shared].pid2 = goodsId == nil ? nil : goodsId;
                    break;
                }
                case 2:
                {
                    [SharedInfo shared].imageURL3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@picture/%@", HOST, urlString]];
                    [SharedInfo shared].pid3 = goodsId == nil ? nil : goodsId;
                    break;
                }
                case 3:
                {
                    [SharedInfo shared].imageURL4 = [NSURL URLWithString:[NSString stringWithFormat:@"%@picture/%@", HOST, urlString]];
                    [SharedInfo shared].pid4 = goodsId == nil ? nil : goodsId;
                    break;
                }
                default:
                    break;
            }
            [self.imageView1 setImageWithURL:[SharedInfo shared].imageURL1];
            [self.imageView2 setImageWithURL:[SharedInfo shared].imageURL2];
            [self.imageView3 setImageWithURL:[SharedInfo shared].imageURL3];
            [self.imageView4 setImageWithURL:[SharedInfo shared].imageURL4];
            [firstImageView setImageWithURL:[SharedInfo shared].imageURL1];
            [lastiImageView setImageWithURL:[SharedInfo shared].imageURL4];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    isFirst = YES;
    
    // Do any additional setup after loading the view.
    topView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 20.0, self.view.frame.size.width, 44.0)];
    [topView setImage:[UIImage imageNamed:@"NavigationBackgroundImage"]];
    [self.view addSubview:topView];
    
    UIButton *addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addressButton.frame = CGRectMake(self.view.frame.size.width * 20.0/320.0, 32.0, self.view.frame.size.width * 84.0/640.0, self.view.frame.size.width * 31.0/640.0);
    [addressButton setBackgroundImage:[UIImage imageNamed:@"Address"] forState:UIControlStateNormal];
    [addressButton addTarget:self action:@selector(addressBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addressButton];
    
    musicView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 290.0/320.0, 32.0, self.view.frame.size.width * 35.0/640.0, self.view.frame.size.width * 35.0/640.0)];
    [musicView setImage:[UIImage imageNamed:@"Music"]];
    musicView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(musicBarButtonPressed:)];
    [musicView addGestureRecognizer:tap];
    [self.view addSubview:musicView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 250.0/640.0, 32.0, 160.0, 17.0)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:20.0]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"来啦洗车"];
    [self.view addSubview:titleLabel];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBackgroundImage"]forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     [UIFont fontWithName:@"Heiti SC" size:20.0],NSFontAttributeName,
                                                                     nil]];
    
    self.customTabBar.delegate = self;
    // 定时器 循环
    myTimer2 = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    self.slideView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.width * 440.0 /640.0)];
    if ([SDiPhoneVersion deviceVersion] == iPhone6) {
        self.slideView.frame = CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.width * 440.0 /640.0 + 22.0);
    } else if ([SDiPhoneVersion deviceVersion] == iPhone6Plus) {
        self.slideView.frame = CGRectMake(0.0, 64.0, self.view.frame.size.width, 304.0);
    } else if ([UIScreen mainScreen].bounds.size.height <= 480.0f) {
        self.slideView.frame = CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.width * 380.0 /640.0);
    }

    [self.slideView setBackgroundColor:[UIColor blackColor]];
    self.slideView.bounces = YES;
    self.slideView.pagingEnabled = YES;
    self.slideView.delegate = self;
    self.slideView.showsHorizontalScrollIndicator = NO;
    
    for (int i = 0; i < 4; i++) {
        switch (i) {
            case 0:
            {
                self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake((self.slideView.frame.size.width * 0) + self.slideView.frame.size.width, 0, self.slideView.frame.size.width, self.slideView.frame.size.height)];
                [self.imageView1 setBackgroundColor:[UIColor blackColor]];
                [self.slideView addSubview:self.imageView1];
                break;
            }
            case 1:
            {
                self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake((self.slideView.frame.size.width * 1) + self.slideView.frame.size.width, 0, self.slideView.frame.size.width, self.slideView.frame.size.height)];
                [self.imageView2 setBackgroundColor:[UIColor blackColor]];
                [self.slideView addSubview:self.imageView2];
                break;
            }
            case 2:
            {
                self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake((self.slideView.frame.size.width * 2) + self.slideView.frame.size.width, 0, self.slideView.frame.size.width, self.slideView.frame.size.height)];
                [self.imageView3 setBackgroundColor:[UIColor blackColor]];
                [self.slideView addSubview:self.imageView3];
                break;
            }
            case 3:
            {
                self.imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake((self.slideView.frame.size.width * 3) + self.slideView.frame.size.width, 0, self.slideView.frame.size.width, self.slideView.frame.size.height)];
                [self.imageView4 setBackgroundColor:[UIColor blackColor]];
                [self.slideView addSubview:self.imageView4];
                break;
            }
            default:
                break;
        }
    }
    
    // 取数组最后一张图片 放在第0页
    lastiImageView = [[UIImageView alloc] init];
    [lastiImageView setBackgroundColor:[UIColor blackColor]];
    lastiImageView.frame = CGRectMake(0, 0, self.slideView.frame.size.width, self.slideView.frame.size.height); // 添加最后1页在首页 循环
    [self.slideView addSubview:lastiImageView];
    // 取数组第一张图片 放在最后1页
    firstImageView = [[UIImageView alloc] init];
    [firstImageView setBackgroundColor:[UIColor blackColor]];
    firstImageView.frame = CGRectMake((self.slideView.frame.size.width * 5) , 0, self.slideView.frame.size.width, self.slideView.frame.size.height); // 添加第1页在最后 循环
    [self.slideView addSubview:firstImageView];
    
    [self.slideView setContentSize:CGSizeMake(self.slideView.frame.size.width * 6, self.slideView.frame.size.height)]; //  +上第1页和第3页  原理：3-[1-2-3]-1
    [self.slideView setContentOffset:CGPointMake(0, 0)];
    [self.slideView scrollRectToVisible:CGRectMake(self.slideView.frame.size.width,0,self.slideView.frame.size.width,self.slideView.frame.size.height) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置放第3页
    
    UITapGestureRecognizer *slideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slideTap:)];
    [self.slideView addGestureRecognizer:slideTap];
    [self.view addSubview:self.slideView];
    
    pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 500.0/640.0, self.view.frame.size.width, 30)];
    if ([SDiPhoneVersion deviceVersion] == iPhone6) {
        pageControl.frame = CGRectMake(0.0, self.view.frame.size.width * 500.0/640.0 + 22.0, self.view.frame.size.width, 30);
    } else if ([SDiPhoneVersion deviceVersion] == iPhone6Plus) {
        pageControl.frame = CGRectMake(0.0, self.view.frame.size.width * 500.0/640.0 + 26.0, self.view.frame.size.width, 30);
    } else if ([UIScreen mainScreen].bounds.size.height <= 480.0f) {
        pageControl.frame = CGRectMake(0.0, self.view.frame.size.width * 380.0/640.0 + 26.0, self.view.frame.size.width, 30);
    }
    pageControl.tapBehavior = SMPageControlTapBehaviorJump;
    pageControl.numberOfPages = 4;
    pageControl.currentPage = 0;
    
    [pageControl setPageIndicatorImage:[UIImage imageNamed:@"bannerdot"]];
    [pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"bannerdotactive"]];
    [pageControl addTarget:self action:@selector(pageControl:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    
    self.washButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, self.slideView.frame.origin.y + self.slideView.frame.size.height, self.view.frame.size.width / 2.0, self.view.frame.size.width  * 300.0 / 640.0)];
    if ([SDiPhoneVersion deviceVersion] == iPhone6Plus) {
        self.washButton.frame = CGRectMake(0.0, self.slideView.frame.origin.y + self.slideView.frame.size.height, self.view.frame.size.width / 2.0, 194.0);
    } else if ([UIScreen mainScreen].bounds.size.height <= 480.0f) {
        self.washButton.frame = CGRectMake(0.0, self.slideView.frame.origin.y + self.slideView.frame.size.height, self.view.frame.size.width / 2.0, self.view.frame.size.width  * 214.0 / 640.0);
    }
    [self.washButton setBackgroundImage:[UIImage imageNamed:@"Washing"] forState:UIControlStateNormal];
    [self.washButton addTarget:self action:@selector(washButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.weatherButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0, self.washButton.frame.origin.y, self.washButton.frame.size.width, self.washButton.frame.size.width * 25.0 / 32.0)];
    if ([UIScreen mainScreen].bounds.size.height <= 480.0f){
        self.weatherButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0, self.washButton.frame.origin.y, self.washButton.frame.size.width, self.washButton.frame.size.width * 20.0 / 32.0)];
    }
    [self.weatherButton setBackgroundImage:[UIImage imageNamed:@"shareButton"] forState:UIControlStateNormal];
    [self.weatherButton addTarget:self action:@selector(weatherButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.flowButton = [[UIButton alloc]  initWithFrame:CGRectMake(0.0, self.washButton.frame.origin.y + self.washButton.frame.size.height, self.washButton.frame.size.width, self.view.frame.size.width * 170.0/640.0)];
    self.flowButton.frame = CGRectMake(0.0, self.washButton.frame.origin.y + self.washButton.frame.size.height, self.washButton.frame.size.width, 145.0);
//    if ([SDiPhoneVersion deviceVersion] == iPhone6Plus) {
//        self.flowButton.frame = CGRectMake(0.0, self.washButton.frame.origin.y + self.washButton.frame.size.height, self.washButton.frame.size.width, 145.0);
//    } else if ([UIScreen mainScreen].bounds.size.height <= 480.0f) {
//        self.flowButton.frame = CGRectMake(0.0, self.washButton.frame.origin.y + self.washButton.frame.size.height, self.washButton.frame.size.width, self.view.frame.size.width * 140.0/640.0);
//    }
    [self.flowButton setBackgroundImage:[UIImage imageNamed:@"Flow"] forState:UIControlStateNormal];
    [self.flowButton addTarget:self action:@selector(flowButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.specialButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0, self.weatherButton.frame.origin.y + self.weatherButton.frame.size.height, self.washButton.frame.size.width, self.view.frame.size.height - 49.0 - self.weatherButton.frame.origin.y - self.weatherButton.frame.size.height)];
    [self.specialButton setBackgroundImage:[UIImage imageNamed:@"Special"] forState:UIControlStateNormal];
    [self.specialButton addTarget:self action:@selector(specialButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.washButton];
    [self.view addSubview:self.weatherButton];
    [self.view addSubview:self.flowButton];
    [self.view addSubview:self.specialButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicStatusChanged:) name:ASStatusChangedNotification object:nil];
}

- (void)washButtonPressed:(id)sender {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"everSignedIn"]){
        [self performSegueWithIdentifier:@"showWashCar" sender:self];
//        ShareYouhuiquanViewController *share = [[ShareYouhuiquanViewController alloc] init];
//        [self.navigationController pushViewController:share animated:YES];
    } else {
        [SharedInfo shared].loginType = @"Wash";
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

- (void)musicBarButtonPressed:(id)sender {
    if (isFirst) {
        isFirst = NO;
        [[Player shared] play];
    } else {
        [[Player shared] change];
    }
}

- (void)slideTap:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
    NSString *pid = nil;
    switch (pageControl.currentPage) {
        case 0:
        {
            if ([SharedInfo shared].pid1 != nil) {
                pid = [SharedInfo shared].pid1;
            }
            break;
        }
        case 1:
        {
            if ([SharedInfo shared].pid2 != nil) {
                pid = [SharedInfo shared].pid2;
            }
            break;
        }
        case 2:
        {
            if ([SharedInfo shared].pid3 != nil) {
                pid = [SharedInfo shared].pid3;
            }
            break;
        }
        case 3:
        {
            if ([SharedInfo shared].pid4 != nil) {
                pid = [SharedInfo shared].pid4;
            }
            break;
        }
        default:
            break;
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (pid != nil) {
        [SharedInfo shared].pid = pid;
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"everSignedIn"]){
            ShopViewController *shopViewController = [[ShopViewController alloc] init];
            [self.navigationController pushViewController:shopViewController animated:YES];
        } else {
            [SharedInfo shared].loginType = @"Shop";
            [self performSegueWithIdentifier:@"showLogin" sender:self];
        }
    }
}

- (void)pageControl:(id)sender
{    
    NSInteger currentPage = pageControl.currentPage;
    
    [self.slideView scrollRectToVisible:CGRectMake(self.slideView.frame.size.width * (currentPage + 1),0,self.slideView.frame.size.width,self.slideView.frame.size.height) animated:NO];
}

- (void)weatherButtonPressed:(id)sender {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = @"系统升级中，敬请期待";
//    
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        // Do something...
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    });
//    UIImage *image = [UIImage imageNamed:@"ShareSmallImage"];
//    WXMediaMessage *message = [WXMediaMessage message];
//    [message setThumbImage:image];
//    
////    WXImageObject *ext = [WXImageObject object];
////    ext.imageData = UIImageJPEGRepresentation(image, 1.0f);
//
//    WXAppExtendObject *ext = [WXAppExtendObject object];
//    ext.url = @"https://itunes.apple.com/cn/app/lai-la-xi-che/id990872887?l=en&mt=8";
//    
//    message.mediaObject = ext;
//    message.title = @"来啦洗车";
//    message.description = @"欢迎使用来啦洗车";
//    
//    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//    req.bText = NO;
////    req.text = @"123";
//    req.message = message;
//    req.scene = 0;
//    
//    [WXApi sendReq:req];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"everSignedIn"]){
        [self performSegueWithIdentifier:@"showShare" sender:self];
    } else {
        [SharedInfo shared].loginType = @"Share";
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

- (void)flowButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showFlow" sender:self];
}

- (void)specialButtonPressed:(id)sender {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"everSignedIn"]){
        [self performSegueWithIdentifier:@"showMember" sender:self];
    } else {
        [SharedInfo shared].loginType = @"Member";
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 0) {
        
    } else if (item.tag == 1) {
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"everSignedIn"]){
            [self performSegueWithIdentifier:@"showOrder" sender:self];
        } else {
            [self performSegueWithIdentifier:@"showLogin" sender:self];
        }
    } else if (item.tag == 2) {
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"everSignedIn"]){
            [self performSegueWithIdentifier:@"showMine" sender:self];
        } else {
            [self performSegueWithIdentifier:@"showLogin" sender:self];
        }
    }
}

#pragma mark- UIScroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = self.slideView.frame.size.width;
    int page = floor((self.slideView.contentOffset.x - pagewidth/6)/pagewidth)+1;
    page--;  // 默认从第二页开始
    pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [myTimer2 invalidate];
    CGFloat pagewidth = self.slideView.frame.size.width;
    int currentPage = floor((self.slideView.contentOffset.x - pagewidth/6) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage==0)
    {
        [self.slideView scrollRectToVisible:CGRectMake(self.slideView.frame.size.width * 4, 0 ,self.slideView.frame.size.width, self.slideView.frame.size.height) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==5)
    {
        [self.slideView scrollRectToVisible:CGRectMake(self.slideView.frame.size.width, 0, self.slideView.frame.size.width,self.slideView.frame.size.height) animated:NO]; // 最后+1,循环第1页
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

- (void)addressBarButtonPressed:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"目前只提供上海地区的服务";
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // Do something...
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

// 定时器 绑定的方法
- (void)runTimePage
{
    NSInteger page = pageControl.currentPage; // 获取当前的page
    page++;
    page = page > 3 ? 0 : page ;
    pageControl.currentPage = page;
    [self pageControl:nil];
}

- (void)musicStatusChanged:(id)sender {
    if ([[Player shared] player].isPlaying) {
        [self startAnimation];
    }
}

- (void)startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.028];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    musicView.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

- (void)endAnimation
{
    angle += 10;
    if ([[Player shared] player].isPlaying) {
        [self startAnimation];
    }
}

@end
