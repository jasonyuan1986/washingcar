//
//  AddCarViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 1/28/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "AddCarViewController.h"

@interface AddCarViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *addCarTableView;

@end

@implementation AddCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.addCarTableView.dataSource = self;
    self.addCarTableView.delegate = self;
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

#pragma mark UITable view dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carInfoCell" forIndexPath:indexPath];
    
    NSInteger row = [indexPath row];
    
    if (row == 0) {
        cell.textLabel.text = @"车牌号码";
    } else if (row == 1) {
        cell.textLabel.text = @"品牌";
    } else if (row == 2) {
        cell.textLabel.text = @"车型";
    } else {
        cell.textLabel.text = @"颜色";
    }
    
    return cell;
}

#pragma mark UITable view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    
    if (row == 0) {
        [self performSegueWithIdentifier:@"showCarNumber" sender:self];
    } else if (row == 1) {
        [self performSegueWithIdentifier:@"showCarBrand" sender:self];
    } else if (row == 2) {
        
    } else {
        
    }
}

@end
