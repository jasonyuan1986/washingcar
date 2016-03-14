//
//  BusinessManViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 3/12/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "BusinessManViewController.h"
#import "SharedInfo.h"
#import "CarBoyTableViewCell.h"
#import <RatingBar/RatingBar.h>

@interface BusinessManViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UIImageView *backgroundImage;
    UIImageView *shotImage;
    UILabel *nameLabel;
    UILabel *finishLabel;
    RatingBar *myBar;
    RatingBar *totalRatingBar;
    NSArray *dataArray;
    UITableView *myTableView;
    UIImageView *splitView1;
    UIImageView *splitView2;
}

@property (weak, nonatomic) IBOutlet UITabBar *customTabbar;
@property (strong, nonatomic) NSString *businessId;

@end

@implementation BusinessManViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[CARBOY stringByAppendingString:[NSString stringWithFormat:@"/%@", self.businessId]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        NSNumber *success = [resultDic objectForKey:@"success"];
        if ([success intValue] == 0) {
            NSString *message = [resultDic objectForKey:@"message"];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = message;
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            return;
        }
        NSDictionary *dict = [resultDic objectForKey:@"data"];
        NSString *mugshotUrl = [dict objectForKey:@"mugshotUrl"];
        NSString *businessName = [dict objectForKey:@"businessName"];
        if (![businessName isEqual:[NSNull null]]) {
            [nameLabel setText:businessName];
        }
        NSNumber *totalCount = [dict objectForKey:@"totalCount"];
        if (totalCount != nil) {
            [finishLabel setText:[NSString stringWithFormat:@"已完成%d单", [totalCount intValue]]];
        }
        NSNumber *totalRank = [dict objectForKey:@"totalRank"];
        myBar.starNumber = [totalRank integerValue];
        totalRatingBar.starNumber = [totalRank integerValue];
        if (![mugshotUrl isEqual:[NSNull null]]) {
            [manager GET:mugshotUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSData *data = responseObject;
                UIImage *image = [[UIImage alloc] initWithData:data];
                if (image != nil) {
                    [shotImage setImage:image];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                          [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                          [error.userInfo objectForKey:@"NSLocalizedDescription"]);
                NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
                LoggerApp(1, @"Result: %@", result);
            }];
        }
        dataArray = [dict objectForKey:@"commentList"];
        [myTableView reloadData];
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
    backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backgroundImage setImage:[UIImage imageNamed:@"backgroundImage"]];
    [self.view addSubview:backgroundImage];
    
    shotImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 62.0/640.0, self.view.frame.size.width * 158.0/640.0, self.view.frame.size.width * 144.0/640.0, self.view.frame.size.width * 144.0/640.0)];
    [shotImage setImage:[UIImage imageNamed:@"defaultShot"]];
    [self.view addSubview:shotImage];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 230.0/640.0, self.view.frame.size.width * 174.0/640.0, 80, 16.0)];
    [nameLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:nameLabel];
    
    myBar = [[RatingBar alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 210.0/640.0, self.view.frame.size.width * 242.0/640.0, 60.0, 12.0)];
    myBar.starNumber = 5;
    [myBar setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:myBar];
    
    finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 418.0/640.0, self.view.frame.size.width * 246.0/640.0, 80, 11.0)];
    [finishLabel setFont:[UIFont fontWithName:@"Heiti SC" size:11.0]];
    [finishLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:finishLabel];
    
    splitView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 352.0/640.0, self.view.frame.size.width, self.view.frame.size.width/320.0)];
    [splitView1 setImage:[UIImage imageNamed:@"orderSplit"]];
    [self.view addSubview:splitView1];
    
    splitView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 488.0/640.0, self.view.frame.size.width, self.view.frame.size.width/320.0)];
    [splitView2 setImage:[UIImage imageNamed:@"orderSplit"]];
    [self.view addSubview:splitView2];
    
    totalRatingBar = [[RatingBar alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 50.0/640.0, self.view.frame.size.width * 384.0/640.0, self.view.frame.size.width * 540.0/640.0, 34.0)];
    [totalRatingBar setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:totalRatingBar];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 506.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 510.0/640.0)];
    [myTableView setBackgroundColor:[UIColor clearColor]];
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarBoyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    
    if (cell == nil) {
        cell = [[CarBoyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell" width:self.view.frame.size.width];
    }
    
    NSDictionary *dict = [dataArray objectAtIndex:indexPath.row];
    [cell setData:dict];
    
    return cell;
}

#pragma mark- Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.width * 214.0/640.0;
}

@end
