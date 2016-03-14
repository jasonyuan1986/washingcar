//
//  CarBrandViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 3/2/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "CarBrandViewController.h"
#import "SharedInfo.h"
#import <AFNetworking/AFNetworking.h>
#import <JSONKit-NoWarning/JSONKit.h>
#import <SDiPhoneVersion/SDiPhoneVersion.h>

@interface CarBrandViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *carBranTableView;
    UITableView *carTypeTableView;
    NSDictionary *carBrandDictionary;
    NSArray *carKeyArray;
    NSArray *carModelArray;
    NSString *currentBrand;
    NSIndexPath *currentIndex;
}

@end

@implementation CarBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    currentBrand = @"";
    carBranTableView = [[UITableView alloc] init];
    carBranTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [carBranTableView setBackgroundColor:[UIColor blackColor]];
    carBranTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    carBranTableView.sectionIndexColor = [UIColor whiteColor];
    carBranTableView.tag = 1;
    carBranTableView.dataSource = self;
    carBranTableView.delegate = self;
    [self.view addSubview:carBranTableView];
    [carBranTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    carTypeTableView = [[UITableView alloc] init];
    carTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [carTypeTableView setBackgroundColor:[UIColor blackColor]];
    carTypeTableView.tag = 2;
    carTypeTableView.dataSource = self;
    carTypeTableView.delegate = self;
    carTypeTableView.hidden = YES;
    [self.view addSubview:carTypeTableView];
    [carTypeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view).offset(self.view.frame.size.width/2.0);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    
    carBrandDictionary = [SharedInfo shared].carBrandDictionary;
    NSArray *tempArray = [carBrandDictionary allKeys];
    carKeyArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    if (tableView.tag == 1) {
        return [carBrandDictionary count];
    } else {
        return 1;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView.tag == 1) {
//        if ([SDiPhoneVersion deviceVersion] == iPhone6 ||
//            [SDiPhoneVersion deviceVersion] == iPhone6Plus) {
//            return @[@"A", @"", @"B", @"", @"C", @"", @"D", @"", @"F", @"", @"G", @"", @"H", @"", @"J", @"", @"K", @"", @"L", @"", @"M", @"", @"N", @"", @"O", @"", @"P", @"", @"Q", @"", @"R", @"", @"S", @"", @"T", @"", @"W", @"", @"X", @"", @"Y", @"", @"Z"];
//        } else {
            return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U",@"V", @"W", @"X", @"Y", @"Z"];
//        }
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (currentIndex != nil) {
        [self tableView:carBranTableView didDeselectRowAtIndexPath:currentIndex];
    }
    
    if ([title compare:@"V"] == 1) {
        return index - 5;
    } else if ([title compare:@"U"] == 1) {
        return index - 4;
    } else if ([title compare:@"P"] == 1) {
        return index - 3;
    } else if ([title compare:@"I"] == 1) {
        return index - 2;
    } else if ([title compare:@"E"] == 1) {
        return index - 1;
    } else {
        return index;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView.tag == 1) {
        NSArray *array = [carBrandDictionary objectForKey:[carKeyArray objectAtIndex:section]];
        return [array count];
    } else {
        return [carModelArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(77.0, 16.0, 240.0, 16.0)];
            [myLabel setTag:1];
            [myLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
            [myLabel setTextColor:[UIColor whiteColor]];
            [myLabel setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:myLabel];
            cell.backgroundView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carBrandCell"]];
        }
        
        NSUInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        UILabel *tempLabel = (UILabel *)[cell viewWithTag:1];
        [tempLabel setTextColor:[UIColor whiteColor]];
        
        NSArray *array = [carBrandDictionary objectForKey:[carKeyArray objectAtIndex:section]];
        NSDictionary *dict = [array objectAtIndex:row];
        [tempLabel setText:[dict objectForKey:@"configName"]];
        
        if ([currentBrand isEqualToString:tempLabel.text]) {
            [tempLabel setTextColor:YELLOWCOLOR];
        }
        
        return cell;
    } else if(tableView.tag == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewModelCell"];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewModelCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 16.0, 240.0, 16.0)];
            [myLabel setTag:2];
            [myLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
            [myLabel setTextColor:[UIColor whiteColor]];
            [myLabel setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:myLabel];
            cell.backgroundView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carBrandCell"]];
        }
        
        NSInteger row = indexPath.row;
        UILabel *tempLabel = (UILabel *)[cell viewWithTag:2];
        NSDictionary *dict = [carModelArray objectAtIndex:row];
        [tempLabel setText:[dict objectForKey:@"configName"]];
        
        return cell;
    } else {
        return nil;
    }
}

#pragma mark- Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return self.view.frame.size.width * 15.0/320.0;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.width * 15.0/320.0)];
        [myView setBackgroundColor:[UIColor blackColor]];
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:myView.bounds];
        [myImageView setImage:[UIImage imageNamed:@"carBrandHeader"]];
        
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(57.0, 0.0, 20.0, self.view.frame.size.width * 15.0/320.0)];
        [myLabel setTextColor:[UIColor whiteColor]];
        [myLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
        [myLabel setText:[carKeyArray objectAtIndex:section]];
        
        
        [myView addSubview:myImageView];
        [myView addSubview:myLabel];
        
        return myView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.width * 3.0/20.0;
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *tempLabel = (UILabel *)[cell viewWithTag:1];
        [tempLabel setTextColor:[UIColor whiteColor]];
    } else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *tempLabel = (UILabel *)[cell viewWithTag:2];
        [tempLabel setTextColor:[UIColor whiteColor]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        currentIndex = indexPath;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *tempLabel = (UILabel *)[cell viewWithTag:1];
        [tempLabel setTextColor:YELLOWCOLOR];
        
        if ([tempLabel.text isEqualToString:currentBrand] &&
            carTypeTableView.hidden == NO) {
            carTypeTableView.hidden = YES;
            return;
        } else {
            currentBrand = tempLabel.text;
        }
        
        NSUInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        NSDictionary *dict = nil;
        
        NSArray *array = [carBrandDictionary objectForKey:[carKeyArray objectAtIndex:section]];
        dict = [array objectAtIndex:row];
    
        [SharedInfo shared].carBrand = dict;
        [self getCarModel:[dict objectForKey:@"configValue"]];
    } else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *tempLabel = (UILabel *)[cell viewWithTag:2];
        [tempLabel setTextColor:YELLOWCOLOR];
        
        [SharedInfo shared].carModel = [carModelArray objectAtIndex:indexPath.row];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setCarBrand" object:nil];
    }
}

- (void)getCarModel:(NSString *)configValue {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/%@", CARMODEL, configValue] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        carModelArray = [resultDic objectForKey:@"data"];
        [carTypeTableView reloadData];
        [carTypeTableView setHidden:NO];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerApp(1, @"Result: %@", result);
    }];
}

@end
