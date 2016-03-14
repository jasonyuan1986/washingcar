//
//  AlphaViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 2/26/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "AlphaViewController.h"

@interface AlphaViewController ()
{
    UIImageView *backgroundImage;
    NSArray *titleArray;
}

@end

@implementation AlphaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    titleArray = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"其他", nil];
    
    backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.width * 1007.0/640.0)];
    [backgroundImage setImage:[UIImage imageNamed:@"alphaBack"]];
    [self.view addSubview:backgroundImage];
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setBackgroundColor:[UIColor clearColor]];
    [aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [aButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    aButton.tag = 0;
    [aButton setTitle:[titleArray objectAtIndex:aButton.tag] forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    aButton.frame = CGRectMake(0.0, self.view.frame.size.width * 90.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:aButton];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bButton setBackgroundColor:[UIColor clearColor]];
    [bButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    bButton.tag = 1;
    [bButton setTitle:[titleArray objectAtIndex:bButton.tag] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    bButton.frame = CGRectMake(aButton.frame.origin.x + aButton.frame.size.width, self.view.frame.size.width * 90.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:bButton];
    
    UIButton *cButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cButton setBackgroundColor:[UIColor clearColor]];
    [cButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    cButton.tag = 2;
    [cButton setTitle:[titleArray objectAtIndex:cButton.tag] forState:UIControlStateNormal];
    [cButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    cButton.frame = CGRectMake(bButton.frame.origin.x + bButton.frame.size.width, self.view.frame.size.width * 90.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:cButton];
    
    UIButton *dButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dButton setBackgroundColor:[UIColor clearColor]];
    [dButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    dButton.tag = 3;
    [dButton setTitle:[titleArray objectAtIndex:dButton.tag] forState:UIControlStateNormal];
    [dButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    dButton.frame = CGRectMake(0.0, self.view.frame.size.width * 136.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:dButton];
    
    UIButton *eButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [eButton setBackgroundColor:[UIColor clearColor]];
    [eButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [eButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    eButton.tag = 4;
    [eButton setTitle:[titleArray objectAtIndex:eButton.tag] forState:UIControlStateNormal];
    [eButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    eButton.frame = CGRectMake(dButton.frame.origin.x + dButton.frame.size.width, self.view.frame.size.width * 136.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:eButton];
    
    UIButton *fButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fButton setBackgroundColor:[UIColor clearColor]];
    [fButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    fButton.tag = 5;
    [fButton setTitle:[titleArray objectAtIndex:fButton.tag] forState:UIControlStateNormal];
    [fButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    fButton.frame = CGRectMake(eButton.frame.origin.x + eButton.frame.size.width, self.view.frame.size.width * 136.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:fButton];
    
    UIButton *gButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [gButton setBackgroundColor:[UIColor clearColor]];
    [gButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    gButton.tag = 6;
    [gButton setTitle:[titleArray objectAtIndex:gButton.tag] forState:UIControlStateNormal];
    [gButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    gButton.frame = CGRectMake(0.0, self.view.frame.size.width * 184.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:gButton];
    
    UIButton *hButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hButton setBackgroundColor:[UIColor clearColor]];
    [hButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [hButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    hButton.tag = 7;
    [hButton setTitle:[titleArray objectAtIndex:hButton.tag] forState:UIControlStateNormal];
    [hButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    hButton.frame = CGRectMake(gButton.frame.origin.x + gButton.frame.size.width, self.view.frame.size.width * 184.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:hButton];
    
    UIButton *iButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [iButton setBackgroundColor:[UIColor clearColor]];
    [iButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [iButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    iButton.tag = 8;
    [iButton setTitle:[titleArray objectAtIndex:iButton.tag] forState:UIControlStateNormal];
    [iButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    iButton.frame = CGRectMake(hButton.frame.origin.x + hButton.frame.size.width, self.view.frame.size.width * 184.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:iButton];
    
    UIButton *jButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [jButton setBackgroundColor:[UIColor clearColor]];
    [jButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [jButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    jButton.tag = 9;
    [jButton setTitle:[titleArray objectAtIndex:jButton.tag] forState:UIControlStateNormal];
    [jButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    jButton.frame = CGRectMake(0.0, self.view.frame.size.width * 232.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:jButton];
    
    UIButton *kButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [kButton setBackgroundColor:[UIColor clearColor]];
    [kButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [kButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    kButton.tag = 10;
    [kButton setTitle:[titleArray objectAtIndex:kButton.tag] forState:UIControlStateNormal];
    [kButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    kButton.frame = CGRectMake(jButton.frame.origin.x + jButton.frame.size.width, self.view.frame.size.width * 232.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:kButton];
    
    UIButton *lButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lButton setBackgroundColor:[UIColor clearColor]];
    [lButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    lButton.tag = 11;
    [lButton setTitle:[titleArray objectAtIndex:lButton.tag] forState:UIControlStateNormal];
    [lButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    lButton.frame = CGRectMake(kButton.frame.origin.x + kButton.frame.size.width, self.view.frame.size.width * 232.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:lButton];
    
    UIButton *mButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mButton setBackgroundColor:[UIColor clearColor]];
    [mButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    mButton.tag = 12;
    [mButton setTitle:[titleArray objectAtIndex:mButton.tag] forState:UIControlStateNormal];
    [mButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    mButton.frame = CGRectMake(0.0, self.view.frame.size.width * 280.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:mButton];
    
    UIButton *nButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nButton setBackgroundColor:[UIColor clearColor]];
    [nButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    nButton.tag = 13;
    [nButton setTitle:[titleArray objectAtIndex:nButton.tag] forState:UIControlStateNormal];
    [nButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    nButton.frame = CGRectMake(mButton.frame.origin.x + mButton.frame.size.width, self.view.frame.size.width * 280.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:nButton];
    
    UIButton *oButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [oButton setBackgroundColor:[UIColor clearColor]];
    [oButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [oButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    oButton.tag = 14;
    [oButton setTitle:[titleArray objectAtIndex:oButton.tag] forState:UIControlStateNormal];
    [oButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    oButton.frame = CGRectMake(nButton.frame.origin.x + nButton.frame.size.width, self.view.frame.size.width * 280.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:oButton];
    
    UIButton *pButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pButton setBackgroundColor:[UIColor clearColor]];
    [pButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    pButton.tag = 15;
    [pButton setTitle:[titleArray objectAtIndex:pButton.tag] forState:UIControlStateNormal];
    [pButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    pButton.frame = CGRectMake(0.0, self.view.frame.size.width * 328.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:pButton];
    
    UIButton *qButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qButton setBackgroundColor:[UIColor clearColor]];
    [qButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [qButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    qButton.tag = 16;
    [qButton setTitle:[titleArray objectAtIndex:qButton.tag] forState:UIControlStateNormal];
    [qButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    qButton.frame = CGRectMake(pButton.frame.origin.x + pButton.frame.size.width, self.view.frame.size.width * 328.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:qButton];
    
    UIButton *rButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rButton setBackgroundColor:[UIColor clearColor]];
    [rButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    rButton.tag = 17;
    [rButton setTitle:[titleArray objectAtIndex:rButton.tag] forState:UIControlStateNormal];
    [rButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    rButton.frame = CGRectMake(qButton.frame.origin.x + qButton.frame.size.width, self.view.frame.size.width * 328.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:rButton];
    
    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sButton setBackgroundColor:[UIColor clearColor]];
    [sButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    sButton.tag = 18;
    [sButton setTitle:[titleArray objectAtIndex:sButton.tag] forState:UIControlStateNormal];
    [sButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    sButton.frame = CGRectMake(0.0, self.view.frame.size.width * 376.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:sButton];
    
    UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tButton setBackgroundColor:[UIColor clearColor]];
    [tButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    tButton.tag = 19;
    [tButton setTitle:[titleArray objectAtIndex:tButton.tag] forState:UIControlStateNormal];
    [tButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    tButton.frame = CGRectMake(sButton.frame.origin.x + sButton.frame.size.width, self.view.frame.size.width * 376.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:tButton];
    
    UIButton *uButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [uButton setBackgroundColor:[UIColor clearColor]];
    [uButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    uButton.tag = 20;
    [uButton setTitle:[titleArray objectAtIndex:uButton.tag] forState:UIControlStateNormal];
    [uButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    uButton.frame = CGRectMake(tButton.frame.origin.x + tButton.frame.size.width, self.view.frame.size.width * 376.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:uButton];
    
    UIButton *vButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vButton setBackgroundColor:[UIColor clearColor]];
    [vButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [vButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    vButton.tag = 21;
    [vButton setTitle:[titleArray objectAtIndex:vButton.tag] forState:UIControlStateNormal];
    [vButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    vButton.frame = CGRectMake(0.0, self.view.frame.size.width * 424.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:vButton];
    
    UIButton *wButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wButton setBackgroundColor:[UIColor clearColor]];
    [wButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [wButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    wButton.tag = 22;
    [wButton setTitle:[titleArray objectAtIndex:wButton.tag] forState:UIControlStateNormal];
    [wButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    wButton.frame = CGRectMake(vButton.frame.origin.x + vButton.frame.size.width, self.view.frame.size.width * 424.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:wButton];
    
    UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [xButton setBackgroundColor:[UIColor clearColor]];
    [xButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [xButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    xButton.tag = 23;
    [xButton setTitle:[titleArray objectAtIndex:xButton.tag] forState:UIControlStateNormal];
    [xButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    xButton.frame = CGRectMake(wButton.frame.origin.x + wButton.frame.size.width, self.view.frame.size.width * 424.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:xButton];
    
    UIButton *yButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [yButton setBackgroundColor:[UIColor clearColor]];
    [yButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    yButton.tag = 24;
    [yButton setTitle:[titleArray objectAtIndex:yButton.tag] forState:UIControlStateNormal];
    [yButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    yButton.frame = CGRectMake(0.0, self.view.frame.size.width * 473.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:yButton];
    
    UIButton *zButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [zButton setBackgroundColor:[UIColor clearColor]];
    [zButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [zButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    zButton.tag = 25;
    [zButton setTitle:[titleArray objectAtIndex:zButton.tag] forState:UIControlStateNormal];
    [zButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    zButton.frame = CGRectMake(yButton.frame.origin.x + yButton.frame.size.width, self.view.frame.size.width * 473.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:zButton];
    
    UIButton *aaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aaButton setBackgroundColor:[UIColor clearColor]];
    [aaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [aaButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    aaButton.tag = 26;
    [aaButton setTitle:[titleArray objectAtIndex:aaButton.tag] forState:UIControlStateNormal];
    [aaButton addTarget:self action:@selector(selectAlpha:) forControlEvents:UIControlEventTouchUpInside];
    aaButton.frame = CGRectMake(zButton.frame.origin.x + zButton.frame.size.width, self.view.frame.size.width * 473.0/320.0, self.view.frame.size.width/3.0, 21.0);
    [self.view addSubview:aaButton];
}

- (void)backBarButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectAlpha:(id)sender {
    UIButton *button = sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectAlpha" object:nil userInfo:@{@"alpha": button.titleLabel.text}];
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

@end
