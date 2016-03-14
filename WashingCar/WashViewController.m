//
//  WashViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 1/22/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "WashViewController.h"
#import "SharedInfo.h"
#import <AFNetworking/AFNetworking.h>
#import <JSONKit-NoWarning/JSONKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface WashViewController () <UITableViewDataSource, UITableViewDelegate,
    UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, AMapSearchDelegate, UIGestureRecognizerDelegate>
{
    UIImageView *backgroundImage;
    UITableView *myTableView;
    UIButton *addCarButton;
    UIButton *selectHistoryLocation;
    UIImageView *locationView1;
    UIButton *locationButton;
    UITextField *location1Field;
    UIImageView *locationView2;
    UITextField *location2Field;
    UILabel *tipLabel;
    UIButton *orderButton;
    UIButton *washTimeButton;
    NSMutableArray *historyCarArray;
    NSInteger selectedRow;
    BOOL hasTime;
    AMapSearchAPI *mySearch;
    
    // Picker View
    UIView *pickerBackView;
    UIImageView *pickerBackImage;
    UIPickerView *myPickerView;
    UIButton *pickerConfirmButton;
    UIButton *pickerCancelButton;
    NSInteger currentRow;
    NSMutableArray *timeArray;
    NSArray *dataArray;
    BOOL pickerType;
    NSIndexPath *lastIndexPath;
    
    UIScrollView *myScrollView;
}

@end

@implementation WashViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [SharedInfo shared].washTime = nil;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:CARLIST parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        NSNumber *success = [resultDic objectForKey:@"success"];
        if ([success intValue] == 1) {
            historyCarArray = [[NSMutableArray alloc] initWithArray:[resultDic objectForKey:@"data"]];
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
        
        LoggerApp(1, @"历史车辆：%@", historyCarArray);
        [self reloadHistoryTableView];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
        LoggerApp(1, @"Result: %@", [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
    }];
    
    [manager GET:WASHTIME parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        NSNumber *success = [resultDic objectForKey:@"success"];
        if ([success integerValue] == 0) {
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
        
        NSDictionary *dict = [resultDic objectForKey:@"data"];
        int startDay = [[dict objectForKey:@"startDay"] intValue];
        int startTime = [[dict objectForKey:@"startTime"] intValue];
        int endDay = [[dict objectForKey:@"endDay"] intValue];
        
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//设置成中国阳历
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;//这句我也不明白具体时用来做什么。。。
        NSDateComponents *comps = [calendar components:unitFlags fromDate:now];
        long day=[comps day];//获取日期对应的长整形字符串
        long year=[comps year];//获取年对应的长整形字符串
        long month=[comps month];//获取月对应的长整形字符串
        
        timeArray = [[NSMutableArray alloc] init];
        
        for (int i = startDay; i <= endDay; i++) {
            if (i == startDay) {
                for (int j = startTime; j <= 20; j++) {
                    NSString *string = [NSString stringWithFormat:@"%ld-%02ld-%02ld %d:00 ~ %d:00", year, month, day+i, j, j+1];
                    [timeArray addObject:string];
                }
            } else {
                for (int k = 8; k <= 20; k++) {
                    NSString *string = [NSString stringWithFormat:@"%ld-%02ld-%02ld %d:00 ~ %d:00", year, month, day+i, k, k+1];
                    [timeArray addObject:string];
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
        LoggerApp(1, @"Result: %@", [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 623.0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self tableView:myTableView didDeselectRowAtIndexPath:[SharedInfo shared].currentCarIndex];
    NSString *carNumber = [[SharedInfo shared].currentCar objectForKey:@"carNum"];
    [[NSUserDefaults standardUserDefaults] setObject:carNumber forKey:@"lastCarNumber"];
    [location1Field resignFirstResponder];
    [location2Field resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    hasTime = NO;
    [SharedInfo shared].currentCarIndex = nil;
    
    myScrollView = [[UIScrollView alloc] init];
    [myScrollView setBackgroundColor:[UIColor blackColor]];
    myScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myScrollView];
    [myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myScrollView.superview);
        make.top.equalTo(myScrollView.superview).offset(64);
        make.right.equalTo(myScrollView.superview);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height));
    }];
    
    backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImage"]];
    backgroundImage.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:backgroundImage];
    
    myTableView = [[UITableView alloc] init];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.clearsContextBeforeDrawing = YES;
    myTableView.allowsSelection = YES;
    myTableView.allowsMultipleSelection = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.scrollEnabled = NO;
    [myScrollView addSubview:myTableView];
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(myTableView.superview);
        make.top.equalTo(myTableView.superview).offset(15);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, [historyCarArray count] * 48.0));
    }];

    addCarButton = [[UIButton alloc] init];
    [addCarButton setBackgroundImage:[UIImage imageNamed:@"addCarButton"] forState:UIControlStateNormal];
    [addCarButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:addCarButton];
    [addCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(addCarButton.superview);
        make.top.equalTo(myTableView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 48.0));
    }];
    
    selectHistoryLocation = [[UIButton alloc] init];
    [selectHistoryLocation setBackgroundImage:[UIImage imageNamed:@"selectHistoryLocation"] forState:UIControlStateNormal];
    [selectHistoryLocation addTarget:self action:@selector(selectHistoryLocationPressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:selectHistoryLocation];
    [selectHistoryLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(selectHistoryLocation.superview);
        make.top.equalTo(addCarButton.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 48.0));
    }];
    
    locationView1 = [[UIImageView alloc] init];
    locationView1.userInteractionEnabled = YES;
    [locationView1 setImage:[UIImage imageNamed:@"location1"]];
    [myScrollView addSubview:locationView1];
    [locationView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(locationView1.superview);
        make.top.equalTo(selectHistoryLocation.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 47.5));
    }];
    
    UIColor *color = [UIColor whiteColor];
    location1Field = [[UITextField alloc] init];
    location1Field.delegate = self;
    location1Field.borderStyle = UITextBorderStyleNone;
    [location1Field setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [location1Field setTextColor:color];
    location1Field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"您的车辆位置 精确到小区和门牌号" attributes:@{NSForegroundColorAttributeName: color}];
    [locationView1 addSubview:location1Field];
    [location1Field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(location1Field.superview).offset(75);
        make.top.equalTo(location1Field.superview).offset(8.75);
        make.size.mas_equalTo(CGSizeMake(200.0, 30.0));
    }];
    
    locationButton = [[UIButton alloc] init];
    [locationButton setBackgroundImage:[UIImage imageNamed:@"locationButton"] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(mapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [locationView1 addSubview:locationButton];
    [locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationButton.superview).offset(282);
        make.top.equalTo(locationButton.superview).offset(12.5);
        make.size.mas_equalTo(CGSizeMake(25.0, 25.0));
    }];
    
    locationView2 = [[UIImageView alloc] init];
    locationView2.userInteractionEnabled = YES;
    [locationView2 setImage:[UIImage imageNamed:@"location2"]];
    [myScrollView addSubview:locationView2];
    [locationView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(locationView2.superview);
        make.top.equalTo(locationView1.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 48.0));
    }];
    
    location2Field = [[UITextField alloc] init];
    location2Field.delegate = self;
    location2Field.borderStyle = UITextBorderStyleNone;
    [location2Field setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [location2Field setTextColor:color];
    location2Field.text = @"电联";
    location2Field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"车位信息 如不清楚填写\"电联\"" attributes:@{NSForegroundColorAttributeName: color}];
    [locationView2 addSubview:location2Field];
    [location2Field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(location2Field.superview).offset(75);
        make.top.equalTo(location2Field.superview).offset(8.75);
        make.size.mas_equalTo(CGSizeMake(200.0, 30.0));
    }];
    
    tipLabel = [[UILabel alloc] init];
    [tipLabel setNumberOfLines:0];
    [tipLabel setFont:[UIFont fontWithName:@"Heiti SC" size:11.0]];
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    [tipLabel setText:@"提示： 可以根据您的实际情况，“如地面车位 靠近6号楼”“地下车库B区01车位”“电联”等。"];
    [tipLabel setTextColor:[UIColor whiteColor]];
    [tipLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [myScrollView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipLabel.superview).offset(30);
        make.right.equalTo(tipLabel.superview).offset(-30);
        make.top.equalTo(locationView2.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    
    washTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [washTimeButton setBackgroundImage:[UIImage imageNamed:@"washTimeButton"] forState:UIControlStateNormal];
    [washTimeButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [washTimeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [washTimeButton setTitle:@"期望洗车时间" forState:UIControlStateNormal];
    [washTimeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [washTimeButton setContentEdgeInsets:UIEdgeInsetsMake(0.0, self.view.frame.size.width * 150.0/640.0, 0.0, 0.0)];
    [washTimeButton addTarget:self action:@selector(washTimeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    washTimeButton.hidden = YES;
    [myScrollView addSubview:washTimeButton];
    
    orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [orderButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [orderButton setTitle:@"立即下单" forState:UIControlStateNormal];
    [orderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [orderButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [orderButton addTarget:self action:@selector(orderButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:orderButton];
    [orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderButton.superview);
        make.right.equalTo(orderButton.superview);
        make.top.equalTo(tipLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 44.0));
    }];
    
    pickerBackView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height/2.0, self.view.frame.size.width, self.view.frame.size.height/2.0)];
    pickerBackView.hidden = YES;
    [self.view addSubview:pickerBackView];
    [pickerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pickerBackView.superview);
        make.right.equalTo(pickerBackView.superview);
        make.top.equalTo(pickerBackView.superview).offset(self.view.frame.size.height/2.0);
        make.bottom.equalTo(pickerBackView.superview);
    }];
    
    pickerBackImage = [[UIImageView alloc] initWithFrame:pickerBackView.bounds];
    [pickerBackImage setImage:[UIImage imageNamed:@"historyLocationPickerBack"]];
    [pickerBackView addSubview:pickerBackImage];
    [pickerBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pickerBackImage.superview);
        make.right.equalTo(pickerBackImage.superview);
        make.top.equalTo(pickerBackImage.superview);
        make.bottom.equalTo(pickerBackImage.superview);
    }];
    
    myPickerView = [[UIPickerView alloc] init];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    [myPickerView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.delegate = self;
    [pickerBackView addSubview:myPickerView];
    [myPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myPickerView.superview);
        make.right.equalTo(myPickerView.superview);
        make.top.equalTo(myPickerView.superview);
        make.bottom.equalTo(myPickerView.superview);
    }];
    
    pickerConfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pickerConfirmButton setFrame:CGRectMake(0.0, 0.0, 80, 50)];
    [pickerConfirmButton setBackgroundColor:[UIColor clearColor]];
    [pickerConfirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [pickerConfirmButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:15.0]];
    [pickerConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pickerConfirmButton addTarget:self action:@selector(pickerConfirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [pickerBackView addSubview:pickerConfirmButton];
    
    pickerCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pickerCancelButton setFrame:CGRectMake(self.view.frame.size.width - 80.0, 0.0, 80.0, 50.0)];
    [pickerCancelButton setBackgroundColor:[UIColor clearColor]];
    [pickerCancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [pickerCancelButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:15.0]];
    [pickerCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pickerCancelButton addTarget:self action:@selector(pickerCancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [pickerBackView addSubview:pickerCancelButton];
    
    NSString *lastLocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastLocation"];
    if (lastLocation) {
        NSArray *locationArray = [lastLocation componentsSeparatedByString:@"；"];
        location1Field.text = [locationArray objectAtIndex:0];
        location2Field.text = [locationArray objectAtIndex:1];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTimePicker:) name:@"addTimePicker" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setMapAddress:) name:@"setMapAddress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)setMapAddress:(id)sender {
    location1Field.text = [SharedInfo shared].mapAddress;
}

- (void)appWillResignActive:(id)sender {
    [location1Field resignFirstResponder];
    [location2Field resignFirstResponder];
}

- (void)pickerConfirmButtonPressed:(id)sender {
    pickerBackView.hidden = YES;
    if (pickerType) {
        [SharedInfo shared].washTime = [dataArray objectAtIndex:currentRow];
        [washTimeButton setTitle:[SharedInfo shared].washTime forState:UIControlStateNormal];
    } else {
        NSString *location = [dataArray objectAtIndex:currentRow];
        NSArray *locationArray = [location componentsSeparatedByString:@"；"];
        location1Field.text = [locationArray objectAtIndex:0];
        location2Field.text = [locationArray objectAtIndex:1];
    }
}

- (void)pickerCancelButtonPressed:(id)sender {
    pickerBackView.hidden = YES;
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)orderButtonPressed:(id)sender {
    if ([SharedInfo shared].currentCar == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请选择车辆";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        return;
    }
    
    if ([location1Field.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请填写车辆位置";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        return;
    }
    
    if ([location2Field.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请填写车位信息";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        return;
    }
    
    if (hasTime) {
        if ([SharedInfo shared].washTime == nil) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请选择洗车时间";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
            return;
        }
        
        [SharedInfo shared].currentLocation = [NSString stringWithFormat:@"%@；%@", location1Field.text, location2Field.text];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"historyLocation"]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"historyLocation"]];
            BOOL isLocationExist = NO;
            for (NSString *string in array) {
                if ([string isEqualToString:[SharedInfo shared].currentLocation]) {
                    isLocationExist = YES;
                    break;
                }
            }
            if (!isLocationExist) {
                [array insertObject:[SharedInfo shared].currentLocation atIndex:0];
                [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"historyLocation"];
            }
        } else {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array insertObject:[SharedInfo shared].currentLocation atIndex:0];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"historyLocation"];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[SharedInfo shared].currentLocation forKey:@"lastLocation"];
        
        mySearch = [[AMapSearchAPI alloc] initWithSearchKey:AMAPSEARCHKEY Delegate:self];
            
        //构造 AMapGeocodeSearchRequest 对象,address 为必选项,city 为可选项
        AMapGeocodeSearchRequest *geoRequest = [[AMapGeocodeSearchRequest alloc] init]; geoRequest.searchType = AMapSearchType_Geocode;
        geoRequest.city = @[@"上海"];
        geoRequest.address = [SharedInfo shared].currentLocation;
            
        //发起正向地理编码
        [mySearch AMapGeocodeSearch: geoRequest];
    } else {
        [location1Field resignFirstResponder];
        [location2Field resignFirstResponder];
        [self performSegueWithIdentifier:@"showFindWorker" sender:self];
    }
}

- (void)addButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showCarInfo" sender:self];
}

- (void)selectHistoryLocationPressed:(id)sender {
    dataArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"historyLocation"];
    if (dataArray) {
        pickerBackView.hidden = NO;
        pickerType = NO;
        dataArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"historyLocation"];
        [myPickerView reloadAllComponents];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"没有历史记录";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
}

- (void)washTimeButtonPressed:(id)sender {
    pickerBackView.hidden = NO;
    pickerType = YES;
    dataArray = timeArray;
    [myPickerView reloadAllComponents];
}

- (void)mapButtonPressed:(id)sender {
    [location1Field resignFirstResponder];
    [location2Field resignFirstResponder];
    [self performSegueWithIdentifier:@"showMap" sender:self];
}

- (void)reloadHistoryTableView {
    if (hasTime) {
        [washTimeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(washTimeButton.superview);
            make.right.equalTo(washTimeButton.superview);
            make.top.equalTo(tipLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 48.0));
        }];
        [orderButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(orderButton.superview);
            make.right.equalTo(orderButton.superview);
            make.top.equalTo(washTimeButton.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 44.0));
        }];
    }

    [myTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, [historyCarArray count] * 48.0));
    }];
    
    myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 623.0);
    [myTableView reloadData];
}

- (void)addTimePicker:(id)sender {
    hasTime = YES;
    washTimeButton.hidden = NO;
    orderButton.frame = CGRectMake(0.0, washTimeButton.frame.origin.y + washTimeButton.frame.size.height + 15.0, orderButton.frame.size.width, orderButton.frame.size.height);
}

#pragma mark- Picker view dataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [dataArray count];
}

#pragma mark- Picker view delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.view.frame.size.width / 3.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return self.view.frame.size.width * 11.0/80.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (row == currentRow) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.width * 11.0/80.0)];
        [imageView setImage:[UIImage imageNamed:@"carInfoSelectedBack"]];
        UILabel *myLabel = [[UILabel alloc] initWithFrame:imageView.bounds];
        [myLabel setTextAlignment:NSTextAlignmentCenter];
        [myLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:12.0]];
        [myLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
        [myLabel setText:[dataArray objectAtIndex:row]];
        [imageView addSubview:myLabel];
        
        return imageView;
    } else {
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.width * 11.0/80.0)];
        [myLabel setTextAlignment:NSTextAlignmentCenter];
        [myLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:12.0]];
        [myLabel setTextColor:[UIColor whiteColor]];
        [myLabel setText:[dataArray objectAtIndex:row]];
        
        return myLabel;
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    currentRow = row;
    
    [pickerView reloadAllComponents];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return true;
}

- (void)pickerViewTapGestureRecognized:(UITapGestureRecognizer*)gestureRecognizer
{
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    
    CGRect frame = myPickerView.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, myPickerView.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) )
    {
        NSInteger rowNm = [myPickerView selectedRowInComponent:0];
        
        if(currentRow == rowNm) {
            //触发确认事件
            pickerBackView.hidden = YES;
            if (pickerType) {
                [SharedInfo shared].washTime = [dataArray objectAtIndex:currentRow];
                [washTimeButton setTitle:[SharedInfo shared].washTime forState:UIControlStateNormal];
            } else {
                NSString *location = [dataArray objectAtIndex:currentRow];
                NSArray *locationArray = [location componentsSeparatedByString:@"；"];
                location1Field.text = [locationArray objectAtIndex:0];
                location2Field.text = [locationArray objectAtIndex:1];
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
    return [historyCarArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 87.0/640.0, self.view.frame.size.width * 31.0/640.0, self.view.frame.size.width * 42.0/640.0, self.view.frame.size.width * 34.0/640.0)];
        [imageView setImage:[UIImage imageNamed:@"notSelectCar"]];
        imageView.tag = 2;
        [cell.contentView addSubview:imageView];
        
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 154.0/640.0, self.view.frame.size.width * 32.0/640.0, self.view.frame.size.width * 480.0/640.0, self.view.frame.size.width * 32.0/640.0)];
        [myLabel setTag:1];
        [myLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
        [myLabel setTextColor:[UIColor whiteColor]];
        [myLabel setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:myLabel];
        cell.backgroundView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"washPriceBack"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dict = [historyCarArray objectAtIndex:[indexPath row]];
    NSString *carNumber = [dict objectForKey:@"carNum"];
    NSString *carBrand = [dict objectForKey:@"carBrand"];
    NSString *carColor = [dict objectForKey:@"carColor"];
    
    UILabel *tempLabel = (UILabel *)[cell viewWithTag:1];
    [tempLabel setText:[NSString stringWithFormat:@"%@ %@ %@色", carNumber, carBrand, carColor]];

    NSString *lastCarNumer = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastCarNumber"];
    if ([lastCarNumer isEqualToString:carNumber]) {
        [SharedInfo shared].currentCar = dict;
        [SharedInfo shared].currentCarIndex = indexPath;
        lastIndexPath = indexPath;
        UIImageView *tempImage = (UIImageView *)[cell viewWithTag:2];
        [tempImage setImage:[UIImage imageNamed:@"selectCar"]];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark- Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    selectedRow = [indexPath row];
    [SharedInfo shared].currentCarIndex = indexPath;
    [SharedInfo shared].currentCar = [historyCarArray objectAtIndex:selectedRow];
    NSString *carNumber = [[SharedInfo shared].currentCar objectForKey:@"carNum"];
    [[NSUserDefaults standardUserDefaults] setObject:carNumber forKey:@"lastCarNumber"];
    UIImageView *tempImage = (UIImageView *)[cell viewWithTag:2];
    [tempImage setImage:[UIImage imageNamed:@"selectCar"]];
    
    if (lastIndexPath.row != selectedRow) {
        [self tableView:myTableView didDeselectRowAtIndexPath:lastIndexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *tempImage = (UIImageView *)[cell viewWithTag:2];
    [tempImage setImage:[UIImage imageNamed:@"notSelectCar"]];
}

-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *deleteCar = [historyCarArray objectAtIndex:indexPath.row];
        NSString *carId = [deleteCar objectForKey:@"carId"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES].dimBackground = YES;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:[NSString stringWithFormat:@"%@%@", DELETECAR, carId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSData *data = responseObject;
            NSDictionary *resultDic = [data objectFromJSONData];
            NSNumber *success = [resultDic objectForKey:@"success"];
            if ([success intValue] == 1) {
                
                NSDictionary *removeCar = [historyCarArray objectAtIndex:indexPath.row];
                [historyCarArray removeObjectAtIndex:indexPath.row];
                
                NSString *lastCarNumer = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastCarNumber"];
                if ([lastCarNumer isEqualToString:[removeCar objectForKey:@"carNum"]]) {
                    [self tableView:myTableView didDeselectRowAtIndexPath:[SharedInfo shared].currentCarIndex];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastCarNumber"];
                    [SharedInfo shared].currentCar = nil;
                }
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
            
            LoggerApp(1, @"历史车辆：%@", historyCarArray);
            [self reloadHistoryTableView];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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
            LoggerApp(1, @"Result: %@", [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
        }];
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

#pragma mark - AMMapSearch delegate

- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    LoggerApp(1, @"error info at geo:%@", [error userInfo]);
}
//实现正向地理编码的回调函数
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if(response.geocodes.count == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"地址无法识别，请重新输入";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        return;
    }
    //处理搜索结果
    
    for (AMapGeocode *p in response.geocodes) {
        if (p.location.latitude == 0.0 ||
            p.location.longitude == 0.0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"地址无法识别，请重新输入";
            [location1Field becomeFirstResponder];
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
            return;
        }
        
        [SharedInfo shared].currentLatitude = p.location.latitude;
        [SharedInfo shared].currentLongitude = p.location.longitude;
        
        AMapGeocode *temp = response.geocodes[0];
        
        NSDictionary *params = @{@"province": temp.province, @"city": temp.city, @"district": temp.district};
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:CHECKAREA parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSData *data = responseObject;
            NSDictionary *resultDic = [data objectFromJSONData];
            NSNumber *success = [resultDic objectForKey:@"success"];
            if ([success intValue] == 1) {
                NSDictionary *checkResult = [resultDic objectForKey:@"data"];
                NSNumber *check = [checkResult objectForKey:@"check"];
                if ([check intValue] == 1) {
                    [self performSegueWithIdentifier:@"showConfirmOrder" sender:self];
                } else {
                    NSString *message = [checkResult objectForKey:@"message"];
                    
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = message;
                    
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        // Do something...
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    });
                }
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
            
            LoggerApp(1, @"历史车辆%@", historyCarArray);
            [self reloadHistoryTableView];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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
            LoggerApp(1, @"Result: %@", [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
        }];
    }
}

#pragma mark- Text field delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 120.0, self.view.frame.size.width, self.view.frame.size.height)];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 120.0, self.view.frame.size.width, self.view.frame.size.height)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
