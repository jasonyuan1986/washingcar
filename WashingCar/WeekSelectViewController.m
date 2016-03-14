//
//  WeekSelectViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 3/13/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "WeekSelectViewController.h"
#import "SharedInfo.h"
#import <AFNetworking/AFNetworking.h>
#import <JSONKit-NoWarning/JSONKit.h>

@interface WeekSelectViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate>
{
    UIImageView *backgroundImage;
    UILabel *nameLabel;
    UILabel *priceLabel;
    UIButton *week1Button;
    UIButton *week2Button;
    UIButton *week3Button;
    UIButton *week4Button;
    UIButton *week5Button;
    UIButton *week6Button;
    UIButton *week7Button;
    UILabel *week1Label;
    UILabel *week2Label;
    UILabel *week3Label;
    UILabel *week4Label;
    UILabel *week5Label;
    UILabel *week6Label;
    UILabel *week7Label;
    UIButton *week1Time;
    UIButton *week2Time;
    UIButton *week3Time;
    UIButton *week4Time;
    UIButton *week5Time;
    UIButton *week6Time;
    UIButton *week7Time;
    NSInteger daycount;
    NSInteger currentWeekNum;
    UIButton *nextButton;
    
    // Picker View
    UIView *pickerBackView;
    UIImageView *pickerBackImage;
    UIPickerView *myPickerView;
    UIButton *pickerConfirmButton;
    UIButton *pickerCancelButton;
    NSInteger currentRow;
    NSArray *timeArray;
    
    NSMutableArray *weekNumArray;
    NSMutableArray *timeNumArray;
    
    UIScrollView *myScrollView;
    
    NSInteger lastSelected;
    NSArray *buttonArray;
}

@property (strong, nonatomic) NSString *planName;
@property (strong, nonatomic) NSArray *detailArray;
@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *carType;

@end

@implementation WeekSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 623.0);
    [myScrollView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:myScrollView];
    
    timeArray = [NSArray arrayWithObjects:@"08:00 ~ 09:00", @"09:00 ~ 10:00", @"10:00 ~ 11:00", @"11:00 ~ 12:00", @"12:00 ~ 13:00", @"13:00 ~ 14:00", @"14:00 ~ 15:00", @"15:00 ~ 16:00", @"16:00 ~ 17:00", @"17:00 ~ 18:00", @"18:00 ~ 19:00", @"19:00 ~ 20:00", @"20:00 ~ 21:00", @"21:00 ~ 22:00", nil];
    
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backgroundImage setImage:[UIImage imageNamed:@"backgroundImage"]];
    [myScrollView addSubview:backgroundImage];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width * 15.0/320.0, self.view.frame.size.width/2.0, self.view.frame.size.width * 72.0/640.0)];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [nameLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [nameLabel setTextColor:[UIColor blackColor]];
    [nameLabel setText:self.planName];
    [myScrollView addSubview:nameLabel];
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0, self.view.frame.size.width * 15.0/320.0, self.view.frame.size.width/2.0, self.view.frame.size.width * 72.0/640.0)];
    [priceLabel setTextAlignment:NSTextAlignmentCenter];
    [priceLabel setBackgroundColor:[UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0]];
    [priceLabel setFont:[UIFont fontWithName:@"Heiti SC" size:16.0]];
    [priceLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:0.0 alpha:1.0]];
    [priceLabel setText:[NSString stringWithFormat:@"%@元", @"0"]];
    [myScrollView addSubview:priceLabel];
    
    week1Button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 71.0/640.0, self.view.frame.size.width * 179.0/640.0, self.view.frame.size.width * 30.0/640.0, self.view.frame.size.width * 30.0/640.0)];
    week1Button.tag = 1;
    [week1Button setBackgroundImage:[UIImage imageNamed:@"checkboxOff"] forState:UIControlStateNormal];
    [week1Button setBackgroundImage:[UIImage imageNamed:@"checkboxOn"] forState:UIControlStateSelected];
    [week1Button addTarget:self action:@selector(weekButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:week1Button];
    
    week1Label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 125.0/640.0, self.view.frame.size.width * 179.0/640.0, self.view.frame.size.width * 55.0/640.0, self.view.frame.size.width * 30.0/640.0)];
    [week1Label setText:@"周一"];
    [week1Label setTextColor:[UIColor whiteColor]];
    [week1Label setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [myScrollView addSubview:week1Label];
    
    week1Time = [UIButton buttonWithType:UIButtonTypeCustom];
    week1Time.frame = CGRectMake(self.view.frame.size.width * 321.0/640.0, self.view.frame.size.width * 153.0/640.0, self.view.frame.size.width * 319.0/640.0, self.view.frame.size.width * 80.0/640.0);
    week1Time.tag = 1;
    [week1Time setBackgroundImage:[UIImage imageNamed:@"planTimeBack"] forState:UIControlStateNormal];
    [week1Time.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [week1Time setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [week1Time setTitle:@"08:00 ~ 09:00" forState:UIControlStateNormal];
    [week1Time addTarget:self action:@selector(weekTimePressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:week1Time];
    
    week2Button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 71.0/640.0, self.view.frame.size.width * 269.0/640.0, self.view.frame.size.width * 30.0/640.0, self.view.frame.size.width * 30.0/640.0)];
    week2Button.tag = 2;
    [week2Button setBackgroundImage:[UIImage imageNamed:@"checkboxOff"] forState:UIControlStateNormal];
    [week2Button setBackgroundImage:[UIImage imageNamed:@"checkboxOn"] forState:UIControlStateSelected];
    [week2Button addTarget:self action:@selector(weekButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:week2Button];
    
    week2Label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 125.0/640.0, self.view.frame.size.width * 269.0/640.0, self.view.frame.size.width * 55.0/640.0, self.view.frame.size.width * 30.0/640.0)];
    [week2Label setText:@"周二"];
    [week2Label setTextColor:[UIColor whiteColor]];
    [week2Label setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [myScrollView addSubview:week2Label];
    
    week2Time = [UIButton buttonWithType:UIButtonTypeCustom];
    week2Time.frame = CGRectMake(self.view.frame.size.width * 321.0/640.0, self.view.frame.size.width * 243.0/640.0, self.view.frame.size.width * 319.0/640.0, self.view.frame.size.width * 80.0/640.0);
    week2Time.tag = 2;
    [week2Time setBackgroundImage:[UIImage imageNamed:@"planTimeBack"] forState:UIControlStateNormal];
    [week2Time.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [week2Time setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [week2Time setTitle:@"08:00 ~ 09:00" forState:UIControlStateNormal];
    [week2Time addTarget:self action:@selector(weekTimePressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:week2Time];
    
    week3Button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 71.0/640.0, self.view.frame.size.width * 359.0/640.0, self.view.frame.size.width * 30.0/640.0, self.view.frame.size.width * 30.0/640.0)];
    week3Button.tag = 3;
    [week3Button setBackgroundImage:[UIImage imageNamed:@"checkboxOff"] forState:UIControlStateNormal];
    [week3Button setBackgroundImage:[UIImage imageNamed:@"checkboxOn"] forState:UIControlStateSelected];
    [week3Button addTarget:self action:@selector(weekButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:week3Button];
    
    week3Label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 125.0/640.0, self.view.frame.size.width * 359.0/640.0, self.view.frame.size.width * 55.0/640.0, self.view.frame.size.width * 30.0/640.0)];
    [week3Label setText:@"周三"];
    [week3Label setTextColor:[UIColor whiteColor]];
    [week3Label setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [myScrollView addSubview:week3Label];
    
    week3Time = [UIButton buttonWithType:UIButtonTypeCustom];
    week3Time.frame = CGRectMake(self.view.frame.size.width * 321.0/640.0, self.view.frame.size.width * 333.0/640.0, self.view.frame.size.width * 319.0/640.0, self.view.frame.size.width * 80.0/640.0);
    week3Time.tag = 3;
    [week3Time setBackgroundImage:[UIImage imageNamed:@"planTimeBack"] forState:UIControlStateNormal];
    [week3Time.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [week3Time setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [week3Time setTitle:@"08:00 ~ 09:00" forState:UIControlStateNormal];
    [week3Time addTarget:self action:@selector(weekTimePressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:week3Time];
    
    week4Button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 71.0/640.0, self.view.frame.size.width * 450.0/640.0, self.view.frame.size.width * 30.0/640.0, self.view.frame.size.width * 30.0/640.0)];
    week4Button.tag = 4;
    [week4Button setBackgroundImage:[UIImage imageNamed:@"checkboxOff"] forState:UIControlStateNormal];
    [week4Button setBackgroundImage:[UIImage imageNamed:@"checkboxOn"] forState:UIControlStateSelected];
    [week4Button addTarget:self action:@selector(weekButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:week4Button];
    
    week4Label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 125.0/640.0, self.view.frame.size.width * 450.0/640.0, self.view.frame.size.width * 55.0/640.0, self.view.frame.size.width * 30.0/640.0)];
    [week4Label setText:@"周四"];
    [week4Label setTextColor:[UIColor whiteColor]];
    [week4Label setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [myScrollView addSubview:week4Label];
    
    week4Time = [UIButton buttonWithType:UIButtonTypeCustom];
    week4Time.frame = CGRectMake(self.view.frame.size.width * 321.0/640.0, self.view.frame.size.width * 424.0/640.0, self.view.frame.size.width * 319.0/640.0, self.view.frame.size.width * 80.0/640.0);
    week4Time.tag = 4;
    [week4Time setBackgroundImage:[UIImage imageNamed:@"planTimeBack"] forState:UIControlStateNormal];
    [week4Time.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [week4Time setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [week4Time setTitle:@"08:00 ~ 09:00" forState:UIControlStateNormal];
    [week4Time addTarget:self action:@selector(weekTimePressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:week4Time];
    
    week5Button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 71.0/640.0, self.view.frame.size.width * 540.0/640.0, self.view.frame.size.width * 30.0/640.0, self.view.frame.size.width * 30.0/640.0)];
    week5Button.tag = 5;
    [week5Button setBackgroundImage:[UIImage imageNamed:@"checkboxOff"] forState:UIControlStateNormal];
    [week5Button setBackgroundImage:[UIImage imageNamed:@"checkboxOn"] forState:UIControlStateSelected];
    [week5Button addTarget:self action:@selector(weekButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:week5Button];
    
    week5Label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 125.0/640.0, self.view.frame.size.width * 540.0/640.0, self.view.frame.size.width * 55.0/640.0, self.view.frame.size.width * 30.0/640.0)];
    [week5Label setText:@"周五"];
    [week5Label setTextColor:[UIColor whiteColor]];
    [week5Label setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [myScrollView addSubview:week5Label];
    
    week5Time = [UIButton buttonWithType:UIButtonTypeCustom];
    week5Time.frame = CGRectMake(self.view.frame.size.width * 321.0/640.0, self.view.frame.size.width * 514.0/640.0, self.view.frame.size.width * 319.0/640.0, self.view.frame.size.width * 80.0/640.0);
    week5Time.tag = 5;
    [week5Time setBackgroundImage:[UIImage imageNamed:@"planTimeBack"] forState:UIControlStateNormal];
    [week5Time.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [week5Time setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [week5Time setTitle:@"08:00 ~ 09:00" forState:UIControlStateNormal];
    [week5Time addTarget:self action:@selector(weekTimePressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:week5Time];
    
    week6Button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 71.0/640.0, self.view.frame.size.width * 630.0/640.0, self.view.frame.size.width * 30.0/640.0, self.view.frame.size.width * 30.0/640.0)];
    week6Button.tag = 6;
    [week6Button setBackgroundImage:[UIImage imageNamed:@"checkboxOff"] forState:UIControlStateNormal];
    [week6Button setBackgroundImage:[UIImage imageNamed:@"checkboxOn"] forState:UIControlStateSelected];
    [week6Button addTarget:self action:@selector(weekButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:week6Button];
    
    week6Label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 125.0/640.0, self.view.frame.size.width * 630.0/640.0, self.view.frame.size.width * 55.0/640.0, self.view.frame.size.width * 30.0/640.0)];
    [week6Label setText:@"周六"];
    [week6Label setTextColor:[UIColor whiteColor]];
    [week6Label setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [myScrollView addSubview:week6Label];
    
    week6Time = [UIButton buttonWithType:UIButtonTypeCustom];
    week6Time.frame = CGRectMake(self.view.frame.size.width * 321.0/640.0, self.view.frame.size.width * 604.0/640.0, self.view.frame.size.width * 319.0/640.0, self.view.frame.size.width * 80.0/640.0);
    week6Time.tag = 6;
    [week6Time setBackgroundImage:[UIImage imageNamed:@"planTimeBack"] forState:UIControlStateNormal];
    [week6Time.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [week6Time setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [week6Time setTitle:@"08:00 ~ 09:00" forState:UIControlStateNormal];
    [week6Time addTarget:self action:@selector(weekTimePressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:week6Time];
    
    week7Button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 71.0/640.0, self.view.frame.size.width * 718.0/640.0, self.view.frame.size.width * 30.0/640.0, self.view.frame.size.width * 30.0/640.0)];
    week7Button.tag = 7;
    [week7Button setBackgroundImage:[UIImage imageNamed:@"checkboxOff"] forState:UIControlStateNormal];
    [week7Button setBackgroundImage:[UIImage imageNamed:@"checkboxOn"] forState:UIControlStateSelected];
    [week7Button addTarget:self action:@selector(weekButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:week7Button];
    
    week7Label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 125.0/640.0, self.view.frame.size.width * 718.0/640.0, self.view.frame.size.width * 55.0/640.0, self.view.frame.size.width * 30.0/640.0)];
    [week7Label setText:@"周日"];
    [week7Label setTextColor:[UIColor whiteColor]];
    [week7Label setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [myScrollView addSubview:week7Label];
    
    week7Time = [UIButton buttonWithType:UIButtonTypeCustom];
    week7Time.frame = CGRectMake(self.view.frame.size.width * 321.0/640.0, self.view.frame.size.width * 692.0/640.0, self.view.frame.size.width * 319.0/640.0, self.view.frame.size.width * 80.0/640.0);
    week7Time.tag = 7;
    [week7Time setBackgroundImage:[UIImage imageNamed:@"planTimeBack"] forState:UIControlStateNormal];
    [week7Time.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    [week7Time setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [week7Time setTitle:@"08:00 ~ 09:00" forState:UIControlStateNormal];
    [week7Time addTarget:self action:@selector(weekTimePressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:week7Time];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0.0, self.view.frame.size.width * 857.0/640.0, self.view.frame.size.width, self.view.frame.size.width * 88.0/640.0);
    [nextButton setBackgroundColor:YELLOWCOLOR];
    [nextButton.titleLabel setFont:HEITISC16];
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:nextButton];
    
    
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
    
    lastSelected = 0;
    
    buttonArray = @[week1Button, week2Button, week3Button, week4Button, week5Button, week6Button, week7Button];
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextButtonPressed:(id)sender {
    weekNumArray = [[NSMutableArray alloc] init];
    timeNumArray = [[NSMutableArray alloc] init];
    
    if (week1Button.selected) {
        [weekNumArray addObject:@"1"];
        [timeNumArray addObject:week1Time.titleLabel.text];
    }
    
    if (week2Button.selected) {
        [weekNumArray addObject:@"2"];
        [timeNumArray addObject:week2Time.titleLabel.text];
    }
    
    if (week3Button.selected) {
        [weekNumArray addObject:@"3"];
        [timeNumArray addObject:week3Time.titleLabel.text];
    }
    
    if (week4Button.selected) {
        [weekNumArray addObject:@"4"];
        [timeNumArray addObject:week4Time.titleLabel.text];
    }
    
    if (week5Button.selected) {
        [weekNumArray addObject:@"5"];
        [timeNumArray addObject:week5Time.titleLabel.text];
    }
    
    if (week6Button.selected) {
        [weekNumArray addObject:@"6"];
        [timeNumArray addObject:week6Time.titleLabel.text];
    }
    
    if (week7Button.selected) {
        [weekNumArray addObject:@"7"];
        [timeNumArray addObject:week7Time.titleLabel.text];
    }
    
    [self performSegueWithIdentifier:@"showWeekConfirm" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id theSegue = segue.destinationViewController;
    [theSegue setValue:weekNumArray forKey:@"weekNumArray"];
    [theSegue setValue:timeNumArray forKey:@"timeNumArray"];
    [theSegue setValue:self.planName forKey:@"planName"];
    [theSegue setValue:priceLabel.text forKey:@"price"];
    [theSegue setValue:self.productId forKey:@"productId"];
}

- (void)weekButtonPressed:(id)sender {
    UIButton *button = sender;
    if (!button.selected) {
        if (lastSelected != 0) {
            UIButton *lastButton = [buttonArray objectAtIndex:lastSelected - 1];
            lastButton.selected = NO;
        }
        
//        if (daycount == 1) {
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"包月每周只能选一天";
//            
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                // Do something...
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//            });
//            
//            return;
//        }
    }
    
    button.selected = !button.selected;
    
    if (button.selected) {
        lastSelected = button.tag;
//        daycount++;
        
        NSDictionary *dict = [self.detailArray objectAtIndex:0];
        if ([self.planName isEqual:@"标准洗车"]) {
            NSNumber *price = [dict objectForKey:@"price1"];
            self.productId = [dict objectForKey:@"productId"];
            [priceLabel setText:[NSString stringWithFormat:@"%@元", [price stringValue]]];
        } else {
            NSNumber *price = [dict objectForKey:@"price2"];
            [priceLabel setText:[NSString stringWithFormat:@"%@元", [price stringValue]]];
            self.productId = [dict objectForKey:@"productId"];
        }
    } else {
//        daycount--;
        
        if (daycount != 0) {
            NSDictionary *dict = [self.detailArray objectAtIndex:0];
            if ([self.planName isEqual:@"标准洗车"]) {
                NSNumber *price = [dict objectForKey:@"price1"];
                [priceLabel setText:[NSString stringWithFormat:@"%@元", [price stringValue]]];
                self.productId = [dict objectForKey:@"productId"];
            } else {
                NSNumber *price = [dict objectForKey:@"price2"];
                [priceLabel setText:[NSString stringWithFormat:@"%@元", [price stringValue]]];
                self.productId = [dict objectForKey:@"productId"];
            }
        } else {
            [priceLabel setText:[NSString stringWithFormat:@"%@元", @"0"]];
        }
    }
}

- (void)weekTimePressed:(id)sender {
    pickerBackView.hidden = NO;
    
    UIButton *button = sender;
    
    switch (button.tag) {
        case 1:
        {
            currentWeekNum = 1;
            break;
        }
        case 2:
        {
            currentWeekNum = 2;
            break;
        }
        case 3:
        {
            currentWeekNum = 3;
            break;
        }
        case 4:
        {
            currentWeekNum = 4;
            break;
        }
        case 5:
        {
            currentWeekNum = 5;
            break;
        }
        case 6:
        {
            currentWeekNum = 6;
            break;
        }
        case 7:
        {
            currentWeekNum = 7;
            break;
        }
        default:
            break;
    }
}

- (void)pickerConfirmButtonPressed:(id)sender {
    pickerBackView.hidden = YES;
    
    switch (currentWeekNum) {
        case 1:
        {
            [week1Time setTitle:[timeArray objectAtIndex:currentRow] forState:UIControlStateNormal];
            break;
        }
        case 2:
        {
            [week2Time setTitle:[timeArray objectAtIndex:currentRow] forState:UIControlStateNormal];
            break;
        }
        case 3:
        {
            [week3Time setTitle:[timeArray objectAtIndex:currentRow] forState:UIControlStateNormal];
            break;
        }
        case 4:
        {
            [week4Time setTitle:[timeArray objectAtIndex:currentRow] forState:UIControlStateNormal];
            break;
        }
        case 5:
        {
            [week5Time setTitle:[timeArray objectAtIndex:currentRow] forState:UIControlStateNormal];
            break;
        }
        case 6:
        {
            [week6Time setTitle:[timeArray objectAtIndex:currentRow] forState:UIControlStateNormal];
            break;
        }
        case 7:
        {
            [week7Time setTitle:[timeArray objectAtIndex:currentRow] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}

- (void)pickerCancelButtonPressed:(id)sender {
    pickerBackView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Picker view dataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [timeArray count];
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
        [myLabel setText:[timeArray objectAtIndex:row]];
        [imageView addSubview:myLabel];
        
        return imageView;
    } else {
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.width * 11.0/80.0)];
        [myLabel setTextAlignment:NSTextAlignmentCenter];
        [myLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:12.0]];
        [myLabel setTextColor:[UIColor whiteColor]];
        [myLabel setText:[timeArray objectAtIndex:row]];
        
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
            
            switch (currentWeekNum) {
                case 1:
                {
                    [week1Time setTitle:[timeArray objectAtIndex:currentRow] forState:UIControlStateNormal];
                    break;
                }
                case 2:
                {
                    [week2Time setTitle:[timeArray objectAtIndex:currentRow] forState:UIControlStateNormal];
                    break;
                }
                case 3:
                {
                    [week3Time setTitle:[timeArray objectAtIndex:currentRow] forState:UIControlStateNormal];
                    break;
                }
                case 4:
                {
                    [week4Time setTitle:[timeArray objectAtIndex:currentRow] forState:UIControlStateNormal];
                    break;
                }
                case 5:
                {
                    [week5Time setTitle:[timeArray objectAtIndex:currentRow] forState:UIControlStateNormal];
                    break;
                }
                case 6:
                {
                    [week6Time setTitle:[timeArray objectAtIndex:currentRow] forState:UIControlStateNormal];
                    break;
                }
                case 7:
                {
                    [week7Time setTitle:[timeArray objectAtIndex:currentRow] forState:UIControlStateNormal];
                    break;
                }
                default:
                    break;
            }
            
        }
        
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
