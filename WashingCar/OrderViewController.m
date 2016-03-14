//
//  OrderViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 3/6/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderTableViewCell.h"
#import "SharedInfo.h"
#import <AFNetworking/AFNetworking.h>
#import <JSONKit-NoWarning/JSONKit.h>

@interface OrderViewController () <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UIScrollViewDelegate>
{
    UIImageView *backgroundImage;
    UISegmentedControl *mySegment;
    UITableView *myTableView;
    NSMutableArray *dataArray;
    NSInteger start;
    NSString *orderType;
    BOOL isLoading;
}
@property (weak, nonatomic) IBOutlet UITabBar *customTabbar;

@end

@implementation OrderViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [dataArray removeAllObjects];
    [self getData:orderType];
}

- (void)getData:(NSString *)orderType1 {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[ORDERLIST stringByAppendingString:[NSString stringWithFormat:@"/%@?start=%lu&rowNum=20", orderType1,  (unsigned long)[dataArray count]]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        isLoading = NO;
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
        NSArray *tempArray = [resultDic objectForKey:@"data"];
        
        if ([resultDic objectForKey:@"data"] != nil &&
            [tempArray count] != 0) {
            [dataArray addObjectsFromArray:tempArray];
            LoggerApp(1, @"订单信息：%@", dataArray);
            [myTableView reloadData];
            if ([dataArray count] > 20) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([dataArray count]-20) inSection:0];
                [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
            
        } else {
            [myTableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        isLoading = NO;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"网络连接异常";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
#ifdef DEBUGMODE
        LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerApp(1, @"Result: %@", result);
#endif
    }];
    isLoading = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    orderType = @"0";
    dataArray = [[NSMutableArray alloc] init];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backgroundImage setImage:[UIImage imageNamed:@"backgroundImage"]];
    [self.view addSubview:backgroundImage];
    
    self.customTabbar.delegate = self;
    
    NSArray *segmentArray = [NSArray arrayWithObjects:@"全部", @"预约中", @"已完成", nil];
    
    mySegment = [[UISegmentedControl alloc] initWithItems:segmentArray];
    mySegment.frame = CGRectMake(0.0, 79.0, self.view.frame.size.width, self.view.frame.size.width * 36.0/320.0);
    mySegment.selectedSegmentIndex = 0;
    [mySegment setDividerImage:[UIImage imageNamed:@"divideImage"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [mySegment setBackgroundImage:[UIImage imageNamed:@"segmentSelect"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [mySegment setBackgroundImage:[UIImage imageNamed:@"segmentNormal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [mySegment addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,  [UIFont fontWithName:@"Heiti SC"size:13], NSFontAttributeName, nil];
    [mySegment setTitleTextAttributes:dict forState:UIControlStateSelected];
    
    dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,  [UIFont fontWithName:@"Heiti SC"size:13], NSFontAttributeName, nil];
    [mySegment setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    [self.view addSubview:mySegment];
    
    myTableView = [[UITableView alloc] init];
    [myTableView setBackgroundColor:[UIColor clearColor]];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myTableView.superview);
        make.right.equalTo(myTableView.superview);
        make.top.equalTo(mySegment.mas_bottom);
        make.bottom.equalTo(myTableView.superview).offset(-50);
    }];
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if (item.tag == 1) {
        
    } else if (item.tag == 2) {
        [self performSegueWithIdentifier:@"showMine" sender:self];
    }
}

- (void)valueChanged:(id)sender {
    UISegmentedControl *segment = sender;
    switch (segment.selectedSegmentIndex) {
        case 0:
        {
            [dataArray removeAllObjects];
            orderType = @"0";
            [self getData:orderType];
            
            break;
        }
        case 1:
        {
            [dataArray removeAllObjects];
            orderType = @"1";
            [self getData:orderType];
            break;
        }
        case 2:
        {
            [dataArray removeAllObjects];
            orderType = @"2";
            [self getData:orderType];
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
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    
    if (cell == nil) {
        cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell" width:self.view.frame.size.width];
    }
    
    NSDictionary *dict = [dataArray objectAtIndex:indexPath.row];
    [cell setData:dict];
    
    return cell;
}

#pragma mark- Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.width * 111.0/320.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [dataArray objectAtIndex:indexPath.row];
    NSNumber *orderId = [dict objectForKey:@"orderId"];
    [SharedInfo shared].currentOrderId = [orderId stringValue];
    
    [self performSegueWithIdentifier:@"showAppoint" sender:self];
}

#pragma  mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    if ([dataArray count] < 20) {
        return;
    }
    
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 50;
    if(y > h + reload_distance) {
        //距离到底 20 像素
        if (!isLoading) {
            [self getData:orderType];
        }
    }
}


@end
