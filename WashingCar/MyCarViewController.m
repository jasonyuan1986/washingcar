//
//  MyCarViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 3/12/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "MyCarViewController.h"
#import "SharedInfo.h"
#import <AFNetworking/AFNetworking.h>
#import <JSONKit-NoWarning/JSONKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface MyCarViewController () <UITableViewDataSource, UITableViewDelegate,
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
    UIButton *nextButton;
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
    NSArray *historyArray;
    NSIndexPath *lastIndexPath;

    UIScrollView *myScrollView;
}

@property (strong, nonatomic) NSString *planName;

@end

@implementation MyCarViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:CARLIST parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        historyCarArray = [resultDic objectForKey:@"data"];
        NSLog(@"%@", historyCarArray);
        [self reloadHistoryTableView];
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
    myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 623.0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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

    [SharedInfo shared].currentCarIndex = nil;

    backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImage"]];
    backgroundImage.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:backgroundImage];

    myTableView = [[UITableView alloc] init];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.scrollEnabled = NO;
    [myScrollView addSubview:myTableView];
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myTableView.superview);
        make.right.equalTo(myTableView.superview);
        make.top.equalTo(myTableView.superview).offset(15);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, [historyCarArray count] * 48.0));
    }];

    addCarButton = [[UIButton alloc] init];
    [addCarButton setBackgroundImage:[UIImage imageNamed:@"addCarButton"] forState:UIControlStateNormal];
    [addCarButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:addCarButton];
    [addCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addCarButton.superview);
        make.right.equalTo(addCarButton.superview);
        make.top.equalTo(myTableView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 48.0));
    }];

    selectHistoryLocation = [[UIButton alloc] init];
    [selectHistoryLocation setBackgroundImage:[UIImage imageNamed:@"selectHistoryLocation"] forState:UIControlStateNormal];
    [selectHistoryLocation addTarget:self action:@selector(selectHistoryLocationPressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:selectHistoryLocation];
    [selectHistoryLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectHistoryLocation.superview);
        make.right.equalTo(selectHistoryLocation.superview);
        make.top.equalTo(addCarButton.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 48.0));
    }];

    locationView1 = [[UIImageView alloc] init];
    [locationView1 setImage:[UIImage imageNamed:@"location1"]];
    [myScrollView addSubview:locationView1];
    [locationView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationView1.superview);
        make.right.equalTo(locationView1.superview);
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
    [locationView2 setImage:[UIImage imageNamed:@"location2"]];
    [myScrollView addSubview:locationView2];
    [locationView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationView2.superview);
        make.right.equalTo(locationView2.superview);
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

    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [nextButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nextButton.superview);
        make.right.equalTo(nextButton.superview);
        make.top.equalTo(tipLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 44.0));
    }];

    pickerBackView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height/2.0, self.view.frame.size.width, self.view.frame.size.height/2.0)];
    pickerBackView.hidden = YES;
    [self.view addSubview:pickerBackView];

    pickerBackImage = [[UIImageView alloc] initWithFrame:pickerBackView.bounds];
    [pickerBackImage setImage:[UIImage imageNamed:@"historyLocationPickerBack"]];
    [pickerBackView addSubview:pickerBackImage];

    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 10.0, self.view.frame.size.width, 420.0)];

    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    [myPickerView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.delegate = self;
    [pickerBackView addSubview:myPickerView];

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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setMapAddress2:) name:@"setMapAddress2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)setMapAddress2:(id)sender {
    location1Field.text = [SharedInfo shared].mapAddress2;
}

- (void)appWillResignActive:(id)sender {
    [location1Field resignFirstResponder];
    [location2Field resignFirstResponder];
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pickerConfirmButtonPressed:(id)sender {
    pickerBackView.hidden = YES;

    NSString *location = [historyArray objectAtIndex:currentRow];
    NSArray *locationArray = [location componentsSeparatedByString:@"；"];
    location1Field.text = [locationArray objectAtIndex:0];
    location2Field.text = [locationArray objectAtIndex:1];
}

- (void)pickerCancelButtonPressed:(id)sender {
    pickerBackView.hidden = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"showMonthMember"]) {
        id theSegue = segue.destinationViewController;
        NSString *carType = [[SharedInfo shared].currentCar objectForKey:@"carType"];
        [theSegue setValue:carType forKey:@"carType"];

        NSDictionary *detailDict = [[SharedInfo shared].planDict objectForKeyedSubscript:@"detail"];
        NSArray *detailArray = [detailDict objectForKeyedSubscript:carType];

        [theSegue setValue:self.planName forKey:@"planName"];
        [theSegue setValue:detailArray forKey:@"detailArray"];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showCarInfo" sender:self];
}

- (void)selectHistoryLocationPressed:(id)sender {
    pickerBackView.hidden = NO;

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"historyLocation"]) {
        historyArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"historyLocation"];
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

- (void)nextButtonPressed:(id)sender {
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

    NSString *carNumber = [[SharedInfo shared].currentCar objectForKey:@"carNum"];
    [[NSUserDefaults standardUserDefaults] setObject:carNumber forKey:@"lastCarNumber"];

    if ([SharedInfo shared].currentLatitude == 0.0 ||
        [SharedInfo shared].currentLongitude == 0.0) {
        mySearch = [[AMapSearchAPI alloc] initWithSearchKey:AMAPSEARCHKEY Delegate:self];

        //构造 AMapGeocodeSearchRequest 对象,address 为必选项,city 为可选项
        AMapGeocodeSearchRequest *geoRequest = [[AMapGeocodeSearchRequest alloc] init]; geoRequest.searchType = AMapSearchType_Geocode;
        geoRequest.city = @[@"上海"];
        geoRequest.address = [SharedInfo shared].currentLocation;

        //发起正向地理编码
        [mySearch AMapGeocodeSearch: geoRequest];
        return;
    }

    [location1Field resignFirstResponder];
    [location2Field resignFirstResponder];


    [self performSegueWithIdentifier:@"showMonthMember" sender:self];
}

- (void)mapButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showMap" sender:self];
}

- (void)reloadHistoryTableView {
  [myTableView mas_updateConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, [historyCarArray count] * 48.0));
  }];

  myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 623.0);
  [myTableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- Picker view dataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return ([historyArray count] > 3 ? 3 : [historyArray count]);
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
        [myLabel setText:[historyArray objectAtIndex:row]];
        [imageView addSubview:myLabel];

        return imageView;
    } else {
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.width * 11.0/80.0)];
        [myLabel setTextAlignment:NSTextAlignmentCenter];
        [myLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:12.0]];
        [myLabel setTextColor:[UIColor whiteColor]];
        [myLabel setText:[historyArray objectAtIndex:row]];

        return myLabel;
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    currentRow = row;

    [pickerView reloadAllComponents];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

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

            NSString *location = [historyArray objectAtIndex:currentRow];
            NSArray *locationArray = [location componentsSeparatedByString:@"；"];
            location1Field.text = [locationArray objectAtIndex:0];
            location2Field.text = [locationArray objectAtIndex:1];

        }

    }
}

#pragma mark - AMMapSearch delegate

-(void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"error info at geo:%@", [error userInfo]);
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
        [self performSegueWithIdentifier:@"showMonthMember" sender:self];
        return;
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

    return cell;
}

#pragma mark- Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.width * 3.0/20.0;
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

#pragma mark - Text field delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 200.0, self.view.frame.size.width, self.view.frame.size.height)];

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 200.0, self.view.frame.size.width, self.view.frame.size.height)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
