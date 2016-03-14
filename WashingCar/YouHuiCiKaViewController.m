//
//  YouHuiCiKaViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 3/12/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "YouHuiCiKaViewController.h"

@interface YouHuiCiKaViewController ()
{
    UIImageView *backgroundImage;
    UILabel *nameLabel;
    UILabel *priceLabel;
    UIImageView *timeBack;
    UILabel *timeLabel1;
    UILabel *timeLabel2;
    UIButton *confirmButton;
}

@property (strong, nonatomic) NSString *cikaName;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *washTimes;
@property (strong, nonatomic) NSString *productId;

@end

@implementation YouHuiCiKaViewController

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
    [nameLabel setText:self.cikaName];
    [self.view addSubview:nameLabel];
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0, self.view.frame.size.width * 79.0/320.0, self.view.frame.size.width/2.0, self.view.frame.size.width * 72.0/640.0)];
    [priceLabel setTextAlignment:NSTextAlignmentCenter];
    [priceLabel setBackgroundColor:[UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0]];
    [priceLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [priceLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [priceLabel setText:[NSString stringWithFormat:@"%@元", self.price]];
    [self.view addSubview:priceLabel];
    
    timeBack = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 140.0/320.0, self.view.frame.size.width, self.view.frame.size.width * 96.0/640.0)];
    [timeBack setImage:[UIImage imageNamed:@"cikaBack"]];
    [self.view addSubview:timeBack];
    
    timeLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 238.0/640.0, self.view.frame.size.width * 310.0/640.0, self.view.frame.size.width * 100.0/320.0, 16.0)];
    [timeLabel1 setText:@"共计 ："];
    [timeLabel1 setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [timeLabel1 setTextColor:[UIColor whiteColor]];
    [self.view addSubview:timeLabel1];
    
    timeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 354.0/640.0, self.view.frame.size.width * 310.0/640.0, 100.0, 16.0)];
    [timeLabel2 setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [timeLabel2 setTextColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [timeLabel2 setText:[NSString stringWithFormat:@"%@次", self.washTimes]];
    [self.view addSubview:timeLabel2];
    
    confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(0.0, self.view.frame.size.width * 948.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 88.0/640.0);
    [confirmButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [confirmButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id theSegue = segue.destinationViewController;
    [theSegue setValue:self.washTimes forKey:@"totalCount"];
    [theSegue setValue:self.productId forKey:@"productId"];
    [theSegue setValue:self.price forKey:@"amount"];
    [theSegue setValue:@"cika" forKey:@"memberType"];
}

- (void)confirmButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showPay" sender:self];
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

@end
