//
//  CarTypeSelectViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 4/1/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "CarTypeSelectViewController.h"

@interface CarTypeSelectViewController () <UITableViewDataSource, UITabBarDelegate, UITableViewDelegate>
{
    UITableView *myTableView;
    UIButton *nextButton;
    NSString *carType;
    NSString *price;
    NSString *washTimes;
    NSArray *dataArray;
    NSString *productId;
}

@property (strong, nonatomic) NSString *cikaName;

@end

@implementation CarTypeSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    carType = @"-1";
    dataArray = [SharedInfo shared].carTypeArray;
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 15.0/320.0, self.view.frame.size.width, self.view.frame.size.width * 96.0/640.0 * ([dataArray count] + 1))];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.scrollEnabled = NO;
    [myTableView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:myTableView];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0.0, self.view.frame.size.width * 100.0/640.0 + myTableView.frame.origin.y + myTableView.frame.size.height, self.view.frame.size.width, self.view.frame.size.width * 88.0/640.0);
    [nextButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [nextButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id theSegue = segue.destinationViewController;
    
    [theSegue setValue:price forKey:@"price"];
    [theSegue setValue:@"标准洗车" forKey:@"cikaName"];
    [theSegue setValue:washTimes forKey:@"washTimes"];
    [theSegue setValue:productId forKey:@"productId"];
}

- (void)nextButtonPressed:(id)sender {
    if ([carType isEqualToString:@"-1"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请选择车辆类型";
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        return;
    }
    
    [self performSegueWithIdentifier:@"showCika" sender:self];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell1"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell1"];
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 16.0, self.view.frame.size.width, 16.0)];
        [myLabel setTextAlignment:NSTextAlignmentCenter];
        [myLabel setTag:1];
        [myLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
        [myLabel setTextColor:[UIColor whiteColor]];
        [myLabel setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:myLabel];
        cell.backgroundView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payCellBack"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payCellSelect"]];
    }
    UILabel *tempLabel = (UILabel *)[cell viewWithTag:1];
    
    NSDictionary *dict = [dataArray objectAtIndex:indexPath.row];
    [tempLabel setText:[dict objectForKey:@"configName"]];
    
    return cell;
}

#pragma mark- Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.width * 96.0/640.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *tempLabel = (UILabel *)[cell viewWithTag:1];
    [tempLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    
    NSDictionary *carTypedict = [dataArray objectAtIndex:indexPath.row];
    carType = [carTypedict objectForKey:@"configValue"];
    
    NSDictionary *dict = [SharedInfo shared].timeDict;
    NSDictionary *detailDict = [dict objectForKey:@"detail"];
    NSArray *thisDict = [detailDict objectForKey:carType];
    NSDictionary *myDict = [thisDict objectAtIndex:0];
    productId = [myDict objectForKey:@"productId"];
    
    if ([self.cikaName isEqualToString:@"标准洗车"]) {
        price = [myDict objectForKey:@"price1"];
    } else {
        price = [myDict objectForKey:@"price2"];
    }
    
    washTimes = [myDict objectForKey:@"count"];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *tempLabel = (UILabel *)[cell viewWithTag:1];
    [tempLabel setTextColor:[UIColor whiteColor]];
}

@end
