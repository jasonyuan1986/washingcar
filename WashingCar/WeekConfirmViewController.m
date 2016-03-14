//
//  WeekConfirmViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 3/26/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "WeekConfirmViewController.h"

@interface WeekConfirmViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UIImageView *backgroundImage;
    UILabel *nameLabel;
    UILabel *priceLabel;
    UITableView *myTableView;
    NSArray *dataArray;
    UIButton *confirmButton;
    NSMutableString *weekNum;
}

@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *planName;
@property (strong, nonatomic) NSMutableArray *weekNumArray;
@property (strong, nonatomic) NSMutableArray *timeNumArray;
@property (strong, nonatomic) NSString *productId;

@end

@implementation WeekConfirmViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    weekNum = [[NSMutableString alloc] init];
    
    for (int i = 0; i < [self.weekNumArray count]; i++) {
        NSString *num = [self.weekNumArray objectAtIndex:i];
        if (i == 0) {
            [weekNum appendString:num];
        } else {
            [weekNum appendString:@","];
            [weekNum appendString:num];
        }
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:GETDATE parameters:@{@"weekNum": weekNum} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        NSNumber *success = [resultDic objectForKey:@"success"];
        
        if ([success intValue] == 1) {
            dataArray = [resultDic objectForKey:@"data"];
            [myTableView reloadData];
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
    
    backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backgroundImage setImage:[UIImage imageNamed:@"backgroundImage"]];
    [self.view addSubview:backgroundImage];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 79.0/320.0, self.view.frame.size.width/2.0, self.view.frame.size.width * 72.0/640.0)];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [nameLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [nameLabel setTextColor:[UIColor blackColor]];
    [nameLabel setText:self.planName];
    [self.view addSubview:nameLabel];
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0, self.view.frame.size.width * 79.0/320.0, self.view.frame.size.width/2.0, self.view.frame.size.width * 72.0/640.0)];
    [priceLabel setTextAlignment:NSTextAlignmentCenter];
    [priceLabel setBackgroundColor:[UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0]];
    [priceLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [priceLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [priceLabel setText:[NSString stringWithFormat:@"%@", self.price]];
    [self.view addSubview:priceLabel];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 270.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 700.0/640.0)];
    [myTableView setBackgroundColor:[UIColor clearColor]];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    
    confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setBackgroundColor:YELLOWCOLOR];
    [confirmButton.titleLabel setFont:HEITISC16];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmButton.superview);
        make.right.equalTo(confirmButton.superview);
        make.bottom.equalTo(confirmButton.superview);
        make.height.mas_equalTo(44);
    }];
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id theSegue = segue.destinationViewController;
    [theSegue setValue:weekNum forKey:@"weekNum"];
    [theSegue setValue:self.timeNumArray forKey:@"timeNumArray"];
    [theSegue setValue:self.productId forKey:@"productId"];
    [theSegue setValue:self.price forKey:@"amount"];
}

- (void)confirmButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showPay" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)weekDayWithDate:(NSString *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromdate=[dateFormatter dateFromString:date];
    
    NSCalendar *gregorian = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *weekDayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:fromdate];
    NSInteger mDay = [weekDayComponents weekday];
    NSString *week=@"";
    switch (mDay) {
        case 0:{
            week=@"周日";
            break;
        }
        case 1:{
            week=@"周日";
            break;
        }
        case 2:{
            week=@"周一";
            break;
        }
        case 3:{
            week=@"周二";
            break;
        }
        case 4:{
            week=@"周三";
            break;
        }
        case 5:{
            week=@"周四";
            break;
        }
        case 6:{
            week=@"周五";
            break;
        }
        case 7:{
            week=@"周六";
            break;
        }
        default:{
            break;
        }
    };
    return week;
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
        [myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(10);
            make.top.equalTo(cell).offset(self.view.frame.size.width * 50.0/640.0);
            make.size.mas_equalTo(CGSizeMake(120, 16));
        }];
        
        UILabel *myLabel2 = [[UILabel alloc] init];
        [myLabel2 setTextAlignment:NSTextAlignmentCenter];
        [myLabel2 setTag:2];
        [myLabel2 setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
        [myLabel2 setTextColor:[UIColor whiteColor]];
        [myLabel2 setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:myLabel2];
        [myLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell);
            make.top.equalTo(cell).offset(self.view.frame.size.width * 50.0/640.0);
            make.size.mas_equalTo(CGSizeMake(80, 16));
        }];
        
        UILabel *myLabel3 = [[UILabel alloc] init];
        [myLabel3 setTextAlignment:NSTextAlignmentCenter];
        [myLabel3 setTag:3];
        [myLabel3 setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
        [myLabel3 setTextColor:[UIColor whiteColor]];
        [myLabel3 setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:myLabel3];
        [myLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-10);
            make.top.equalTo(cell).offset(self.view.frame.size.width * 50.0/640.0);
            make.size.mas_equalTo(CGSizeMake(120, 16));
        }];
        
        [cell.backgroundView setBackgroundColor:[UIColor clearColor]];
        cell.backgroundView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weekCellBack"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    NSInteger row = indexPath.row;
    NSString *dateString = [dataArray objectAtIndex:row];
    UILabel *tempLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *tempLabel2 = (UILabel *)[cell viewWithTag:2];
    UILabel *tempLabel3 = (UILabel *)[cell viewWithTag:3];
    [tempLabel setText:dateString];
    [tempLabel2 setText:[self weekDayWithDate:dateString]];
    
    NSString *timeString;
    
    if (row < 4) {
        timeString = [self.timeNumArray objectAtIndex:0];
    } else if (row >= 4 && row < 8) {
        timeString = [self.timeNumArray objectAtIndex:1];
    } else {
        timeString = [self.timeNumArray objectAtIndex:2];
    }
    
    [tempLabel3 setText:timeString];
    
    return cell;
}

#pragma mark- Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.width * 116.0/640.0;
}

@end
