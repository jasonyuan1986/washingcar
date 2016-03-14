//
//  MemberViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 3/12/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "MemberViewController.h"
#import "SharedInfo.h"
#import <AFNetworking/AFNetworking.h>
#import <JSONKit-NoWarning/JSONKit.h>

@interface MemberViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UIImageView *backgroundImage;
    UISegmentedControl *mySegment;
    UIImageView *standardBack;
    UIImageView *delicacyBack;
    UILabel *standardLabel;
    UILabel *delicacyLabel;
    UIButton *standardButton;
    UIButton *delicacyButton;
    UITableView *standardTable;
    UITableView *delicacyTable;
    NSArray *standardArray;
    NSArray *delicacyArray;
    NSNumber *minPrice;
    NSNumber *minPrice2;
    NSString *washType;
    NSNumber *washTimes;
    NSString *productId;
    NSArray *detailArray;
    UIImageView *splitView;
    UIScrollView *myScrollView;
}

@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 623.0);
    myScrollView.showsVerticalScrollIndicator = NO;
    [myScrollView setBackgroundColor:[UIColor blackColor]];
    self.view = myScrollView;
    
    // Prepair Data
    NSString *descString = [[SharedInfo shared].planDict objectForKeyedSubscript:@"desc"];
    NSDictionary *myDict = [descString objectFromJSONString];

    standardArray = [myDict objectForKey:@"desc1"];
    delicacyArray = [myDict objectForKey:@"desc2"];
    
    NSDictionary *detailDict = [[SharedInfo shared].planDict objectForKeyedSubscript:@"detail"];
    detailArray = [detailDict objectForKeyedSubscript:@"1"];
    NSDictionary *priceDict = [detailArray objectAtIndex:0];
    
    minPrice = [priceDict objectForKeyedSubscript:@"price1"];
    minPrice2 = [priceDict objectForKeyedSubscript:@"price2"];
    productId = [priceDict objectForKey:@"productId"];
    
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backgroundImage setImage:[UIImage imageNamed:@"backgroundImage"]];
    [self.view addSubview:backgroundImage];
    
    NSArray *segmentArray = [NSArray arrayWithObjects:@"包月套餐", @"优惠次卡", nil];
    
    mySegment = [[UISegmentedControl alloc] initWithItems:segmentArray];
    mySegment.frame = CGRectMake(0.0, self.view.frame.size.width * 28.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 72.0/640.0);
    mySegment.selectedSegmentIndex = 0;
    [mySegment setDividerImage:[UIImage imageNamed:@"divideImage"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [mySegment setBackgroundImage:[UIImage imageNamed:@"memberSelect"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [mySegment setBackgroundImage:[UIImage imageNamed:@"memberSegNot"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [mySegment addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,  [UIFont fontWithName:@"Heiti SC"size:13], NSFontAttributeName, nil];
    [mySegment setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    [self.view addSubview:mySegment];
    
    standardBack = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 134.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 191.0/640.0)];
    [standardBack setImage:[UIImage imageNamed:@"memberStandardBack"]];
    [self.view addSubview:standardBack];
    
    standardTable = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 230.0/640.0, self.view.frame.size.width * 149.0/640.0, 360.0, self.view.frame.size.width * 160.0/640.0)];
    [standardTable setBackgroundColor:[UIColor clearColor]];
    standardTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    standardTable.allowsSelection = NO;
    standardTable.tag = 1;
    standardTable.dataSource = self;
    standardTable.delegate = self;
    [self.view addSubview:standardTable];
    
    standardLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 368.0/640.0, self.view.frame.size.width, 18.0)];
    [standardLabel setTextAlignment:NSTextAlignmentCenter];
    [standardLabel setFont:[UIFont fontWithName:@"Heiti SC" size:18.0]];
    [standardLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [standardLabel setText:[NSString stringWithFormat:@"%@元起", minPrice]];
    [self.view addSubview:standardLabel];
    
    standardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    standardButton.frame = CGRectMake(0.0, self.view.frame.size.width * 424.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 88.0/640.0);
    [standardButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [standardButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [standardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [standardButton setTitle:@"立即下单" forState:UIControlStateNormal];
    [standardButton addTarget:self action:@selector(standardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:standardButton];
    
    splitView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 532.0/640.0, self.view.frame.size.width, self.view.frame.size.width/320.0)];
//    splitView.hidden = YES;
    [splitView setImage:[UIImage imageNamed:@"memberSplit"]];
    [self.view addSubview:splitView];
    
    delicacyBack = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 558.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 231.0/640.0)];
//    delicacyBack.hidden = YES;
    [delicacyBack setImage:[UIImage imageNamed:@"memberDelicacyBack"]];
    [self.view addSubview:delicacyBack];
    
    delicacyTable = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 230.0/640.0, self.view.frame.size.width * 575.0/640.0, 360.0, self.view.frame.size.width * 200.0/640.0)];
//    delicacyTable.hidden = YES;
    delicacyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    delicacyTable.allowsSelection = NO;
    delicacyTable.tag = 2;
    [delicacyTable setBackgroundColor:[UIColor clearColor]];
    delicacyTable.dataSource = self;
    delicacyTable.delegate = self;
    [self.view addSubview:delicacyTable];
    
    delicacyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 826.0/640.0, self.view.frame.size.width, 18.0)];
//    delicacyLabel.hidden = YES;
    [delicacyLabel setTextAlignment:NSTextAlignmentCenter];
    [delicacyLabel setFont:[UIFont fontWithName:@"Heiti SC" size:18.0]];
    [delicacyLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [delicacyLabel setText:[NSString stringWithFormat:@"%@元起", minPrice2]];
    [self.view addSubview:delicacyLabel];
    
    delicacyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    delicacyButton.frame = CGRectMake(0.0, self.view.frame.size.width * 882.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 88.0/640.0);
//    delicacyButton.hidden = YES;
    [delicacyButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [delicacyButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [delicacyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [delicacyButton setTitle:@"立即下单" forState:UIControlStateNormal];
    [delicacyButton addTarget:self action:@selector(delicacyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delicacyButton];
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id theSegue = segue.destinationViewController;
    
    if ([segue.identifier isEqual:@"showCarType"]) {
        if ([washType isEqual:@"standard"]) {
            [theSegue setValue:[minPrice stringValue] forKey:@"price"];
            [theSegue setValue:@"标准洗车" forKey:@"cikaName"];
            [theSegue setValue:[washTimes stringValue] forKey:@"washTimes"];
            [theSegue setValue:productId forKey:@"productId"];
        } else {
            [theSegue setValue:[minPrice2 stringValue] forKey:@"price"];
            [theSegue setValue:@"精洗" forKey:@"cikaName"];
            [theSegue setValue:[washTimes stringValue] forKey:@"washTimes"];
            [theSegue setValue:productId forKey:@"productId"];
        }
    } else {
        if ([washType isEqual:@"standard"]) {
            [theSegue setValue:@"标准洗车" forKey:@"planName"];
        } else {
            [theSegue setValue:@"精洗" forKey:@"planName"];
        }
    }
}

- (void)standardButtonPressed:(id)sender {
    washType = @"standard";
    switch (mySegment.selectedSegmentIndex) {
        case 0:
        {
            [self performSegueWithIdentifier:@"showMyCar" sender:self];
            break;
        }
        case 1:
        {
            [self performSegueWithIdentifier:@"showCarType" sender:self];
            break;
        }
        default:
            break;
    }
}

- (void)delicacyButtonPressed:(id)sender {
    washType = @"delicacy";
    switch (mySegment.selectedSegmentIndex) {
        case 0:
        {
            [self performSegueWithIdentifier:@"showMyCar" sender:self];
            break;
        }
        case 1:
        {
            [self performSegueWithIdentifier:@"showCarType" sender:self];
            break;
        }
        default:
            break;
    }
}

- (void)valueChanged:(id)sender {
    UISegmentedControl *segment = sender;
    switch (segment.selectedSegmentIndex) {
        case 0:
        {
            NSString *descString = [[SharedInfo shared].planDict objectForKeyedSubscript:@"desc"];
            NSDictionary *myDict = [descString objectFromJSONString];
            
            NSDictionary *priceDict = [detailArray objectAtIndex:0];
            
            minPrice = [priceDict objectForKey:@"price1"];
            minPrice2 = [priceDict objectForKey:@"price2"];
            washTimes = [priceDict objectForKey:@"count"];
            productId = [priceDict objectForKey:@"productId"];
            
            [standardLabel setText:[NSString stringWithFormat:@"%@元起", minPrice]];
            [delicacyLabel setText:[NSString stringWithFormat:@"%@元起", minPrice2]];
            
            standardArray = [myDict objectForKey:@"desc1"];
            delicacyArray = [myDict objectForKey:@"desc2"];
            [standardTable reloadData];
            [delicacyTable reloadData];
            break;
        }
        case 1:
        {
            NSString *descString = [[SharedInfo shared].timeDict objectForKeyedSubscript:@"desc"];
            NSDictionary *myDict = [descString objectFromJSONString];
            
            NSDictionary *detailDict = [[SharedInfo shared].timeDict objectForKeyedSubscript:@"detail"];
            NSArray *detailTimeArray = [detailDict objectForKeyedSubscript:@"1"];
            NSDictionary *priceDict = [detailTimeArray objectAtIndex:0];
            
            minPrice = [priceDict objectForKeyedSubscript:@"price1"];
            minPrice2 = [priceDict objectForKeyedSubscript:@"price2"];
            washTimes = [priceDict objectForKeyedSubscript:@"count"];
            productId = [priceDict objectForKey:@"productId"];
            
            [standardLabel setText:[NSString stringWithFormat:@"%@元起", minPrice]];
            [delicacyLabel setText:[NSString stringWithFormat:@"%@元起", minPrice2]];
            
            standardArray = [myDict objectForKey:@"desc1"];
            delicacyArray = [myDict objectForKey:@"desc2"];
            [standardTable reloadData];
            [delicacyTable reloadData];
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
    if (tableView.tag == 1) {
        return [standardArray count];
    } else {
        return [delicacyArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCellPlan"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCellPlan"];
            cell.backgroundColor = [UIColor clearColor];
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 7.0/640.0, 300.0, 13.0)];
            myLabel.tag = 1;
            [myLabel setTextAlignment:NSTextAlignmentLeft];
            [myLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
            [myLabel setTextColor:[UIColor whiteColor]];
            
            [cell.contentView addSubview:myLabel];
        }
        
        NSDictionary *dict = [standardArray objectAtIndex:indexPath.row];
        UILabel *tempLabel = (UILabel *)[cell viewWithTag:1];
        [tempLabel setText:[NSString stringWithFormat:@"%d.%@", (int)(indexPath.row + 1), [dict objectForKey:@"info"]]];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCellTime"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCellTime"];
            cell.backgroundColor = [UIColor clearColor];
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 7.0/640.0, 300.0, 13.0)];
            myLabel.tag = 1;
            [myLabel setTextAlignment:NSTextAlignmentLeft];
            [myLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
            [myLabel setTextColor:[UIColor whiteColor]];
            
            [cell.contentView addSubview:myLabel];
        }
        NSDictionary *dict = [delicacyArray objectAtIndex:indexPath.row];
        UILabel *tempLabel = (UILabel *)[cell viewWithTag:1];
        [tempLabel setText:[NSString stringWithFormat:@"%d.%@", (int)(indexPath.row + 1), [dict objectForKey:@"info"]]];
        
        return cell;
    }
}

#pragma mark- Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.width / 16.0;
}

@end
