//
//  FlowViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 3/6/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "FlowViewController.h"

@interface FlowViewController ()
{
    UIButton *washButton;
    UIButton *useButton;
    UIWebView *myWebView;
    UIButton *backButton;
    
    UITableView *myTableView;
}

@end

@implementation FlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    useButton.frame = CGRectMake(0.0, self.view.frame.size.width * 79.0/320.0, self.view.frame.size.width/2.0, self.view.frame.size.width * 9.0/80.0);
    [useButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [useButton setTitle:@"使用流程" forState:UIControlStateNormal];
    [useButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [useButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [useButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
    [useButton addTarget:self action:@selector(userButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    useButton.selected = YES;
    
    washButton = [UIButton buttonWithType:UIButtonTypeCustom];
    washButton.frame = CGRectMake(self.view.frame.size.width/2.0, self.view.frame.size.width * 79.0/320.0, self.view.frame.size.width/2.0, self.view.frame.size.width * 9.0/80.0);
    [washButton setBackgroundColor:[UIColor colorWithRed:95.0/255.0 green:95.0/255.0 blue:95.0/255.0 alpha:1.0]];
    [washButton setTitle:@"洗车流程" forState:UIControlStateNormal];
    [washButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [washButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [washButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
    [washButton addTarget:self action:@selector(washButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, self.view.frame.size.height - self.view.frame.size.width * 88.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 88.0/640.0);
    [backButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [backButton setTitle:@"返回体验" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, useButton.frame.origin.y + useButton.frame.size.height, self.view.frame.size.width, backButton.frame.origin.y - useButton.frame.origin.y - useButton.frame.size.height)];
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:USEINTRO]]];
    [myWebView setBackgroundColor:[UIColor clearColor]];
    [myWebView setOpaque:NO];
    
    [self.view addSubview:useButton];
    [self.view addSubview:washButton];
    [self.view addSubview:backButton];
    [self.view addSubview:myWebView];
    

}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userButtonPressed:(id)sender {
    if (!useButton.selected) {
        useButton.selected = YES;
        washButton.selected = NO;
        [washButton setBackgroundColor:[UIColor colorWithRed:95.0/255.0 green:95.0/255.0 blue:95.0/255.0 alpha:1.0]];
        [useButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:USEINTRO]]];
    }
}

- (void)washButtonPressed:(id)sender {
    if (!washButton.selected) {
        washButton.selected = YES;
        useButton.selected = NO;
        [useButton setBackgroundColor:[UIColor colorWithRed:95.0/255.0 green:95.0/255.0 blue:95.0/255.0 alpha:1.0]];
        [washButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:WASHINTRO]]];
    }
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
