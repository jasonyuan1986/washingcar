//
//  YouhuiDetailViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 8/12/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "YouhuiDetailViewController.h"

@interface YouhuiDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    UIImageView *backgroundImage;
    UITableView *youhuiquanTableView;
    
    NSMutableArray *dataArray;
    NSInteger start;
    BOOL isLoading;
}

@end

@implementation YouhuiDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[GETDIYONGQUANLIST stringByAppendingString:[NSString stringWithFormat:@"?start=0&rowNum=20"]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        LoggerApp(1, @"%@", resultDic);
        dataArray = [NSMutableArray arrayWithArray:[resultDic objectForKey:@"data"]];
        [youhuiquanTableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        LoggerApp(1, @"Result: %@", [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
    }];
}

- (void)getData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[GETDIYONGQUANLIST stringByAppendingString:[NSString stringWithFormat:@"?start=%lu&rowNum=20", (unsigned long)[dataArray count]]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        LoggerApp(1, @"%@", resultDic);
        dataArray = [NSMutableArray arrayWithArray:[resultDic objectForKey:@"data"]];
        [youhuiquanTableView reloadData];
        isLoading = NO;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        LoggerApp(1, @"Result: %@", [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
        isLoading = NO;
    }];
    isLoading = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的抵用券";
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backgroundImage setImage:[UIImage imageNamed:@"backgroundImage"]];
    [self.view addSubview:backgroundImage];
    
    youhuiquanTableView = [[UITableView alloc] init];
    youhuiquanTableView.dataSource = self;
    youhuiquanTableView.delegate = self;
    youhuiquanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    youhuiquanTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:youhuiquanTableView];
    
    [youhuiquanTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(84);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"youhuiquan"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"youhuiquan"];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youhuiquancell"]];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.tag = 1;
        [label1 setFont:HEITISC13];
        [label1 setTextColor:[UIColor whiteColor]];
        [cell.contentView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label1.superview).offset(20);
            make.top.equalTo(label1.superview).offset(12);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.tag = 2;
        label2.textAlignment = NSTextAlignmentCenter;
        [label2 setFont:HEITISC13];
        [label2 setTextColor:[UIColor whiteColor]];
        [cell.contentView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(label2.superview);
            make.top.equalTo(label2.superview).offset(12);
            make.size.mas_equalTo(CGSizeMake(160, 20));
        }];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *infoLabel = (UILabel *)[cell viewWithTag:2];
    
    NSDictionary *dict = [dataArray objectAtIndex:indexPath.row];
    NSNumber *val = [dict objectForKey:@"val"];
    [priceLabel setText:[NSString stringWithFormat:@"%@元", val]];
    
    NSNumber *status = [dict objectForKey:@"status"];
    if ([status intValue] == 1) {
        NSNumber *timestamp = [dict objectForKey:@"effectDate"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([timestamp longLongValue]/1000)];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *effectDate = [dateFormatter stringFromDate:date];
        [infoLabel setText:[NSString stringWithFormat:@"有效期：%@", effectDate]];
    } else {
        [infoLabel setText:@"已失效"];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSDictionary *dict = [dataArray objectAtIndex:indexPath.row];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:[DELETEDIYONGQUAN stringByAppendingString:[NSString stringWithFormat:@"%@", [dict objectForKey:@"ticketId"]]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSData *data = responseObject;
            NSDictionary *resultDic = [data objectFromJSONData];
            LoggerApp(1, @"%@", resultDic);
            NSNumber *success = [resultDic objectForKey:@"success"];
            if ([success integerValue] == 1) {
                [dataArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                NSString *messageUTF8 = [resultDic objectForKey:@"message"];
                
                const char *messagePoint = [messageUTF8 UTF8String];
                NSString *message = [NSString stringWithCString:messagePoint encoding:NSUTF8StringEncoding];
                
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark- Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *infoLabel = (UILabel *)[cell viewWithTag:2];
    
    [priceLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [infoLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    
    NSDictionary *dict = [dataArray objectAtIndex:indexPath.row];
    
    NSNumber *status = [dict objectForKey:@"status"];
    if ([status intValue] == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userYouhuiquan" object:nil userInfo:dict];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *infoLabel = (UILabel *)[cell viewWithTag:2];
    [priceLabel setTextColor:[UIColor whiteColor]];
    [infoLabel setTextColor:[UIColor whiteColor]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
            [self getData];
        }
    }
}


@end
