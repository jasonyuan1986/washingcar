//
//  ProvinceViewController.m
//  WashingCar
//
//  Created by Jason Yuan on 2/26/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "ProvinceViewController.h"

@interface ProvinceViewController ()
{
    UIScrollView *myScrollView;
    UIImageView *backgroundImage;
    NSArray *titleArray;
}

@end

@implementation ProvinceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    titleArray = [NSArray arrayWithObjects:@"京（北京）", @"沪（上海）",
                  @"粤（广东）", @"浙（浙江）", @"津（天津）", @"渝（重庆）", @"川（四川）", @"黑（黑龙江）", @"吉（吉林）",
                  @"辽（辽宁）", @"鲁（山东）", @"湘（湖南）", @"蒙（内蒙古）", @"冀（河北）", @"新（新疆）", @"甘（甘肃）",
                  @"青（青海）", @"陕（陕西）", @"宁（宁夏）", @"豫（河南）", @"晋（山西）", @"皖（安徽）", @"鄂（湖北）",
                  @"苏（江苏）", @"贵（贵州）", @"黔（贵州）", @"云（云南）", @"闽（福建）", @"琼（海南）", @"使（大使馆）",
                  @"桂（广西）", @"藏（西藏）", @"赣（江西）", @"其他", nil];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    [myScrollView setBackgroundColor:[UIColor blackColor]];
    myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width * 600.0/320.0);
    myScrollView.bounces = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    
    backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.width * 571.0/320.0)];
    [backgroundImage setImage:[UIImage imageNamed:@"provinceBack"]];
    
    [myScrollView addSubview:backgroundImage];
    
    [self.view addSubview:myScrollView];
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setBackgroundColor:[UIColor clearColor]];
    [aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [aButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    aButton.tag = 0;
    [aButton setTitle:[titleArray objectAtIndex:aButton.tag] forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    aButton.frame = CGRectMake(0.0, self.view.frame.size.width * 58.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:aButton];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bButton setBackgroundColor:[UIColor clearColor]];
    [bButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    bButton.tag = 1;
    [bButton setTitle:[titleArray objectAtIndex:bButton.tag] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    bButton.frame = CGRectMake(aButton.frame.origin.x + aButton.frame.size.width, self.view.frame.size.width * 58.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:bButton];
    
    UIButton *cButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cButton setBackgroundColor:[UIColor clearColor]];
    [cButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    cButton.tag = 2;
    [cButton setTitle:[titleArray objectAtIndex:cButton.tag] forState:UIControlStateNormal];
    [cButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    cButton.frame = CGRectMake(bButton.frame.origin.x + bButton.frame.size.width, self.view.frame.size.width * 58.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:cButton];
    
    UIButton *dButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dButton setBackgroundColor:[UIColor clearColor]];
    [dButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    dButton.tag = 3;
    [dButton setTitle:[titleArray objectAtIndex:dButton.tag] forState:UIControlStateNormal];
    [dButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    dButton.frame = CGRectMake(0.0, self.view.frame.size.width * 154.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:dButton];
    
    UIButton *eButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [eButton setBackgroundColor:[UIColor clearColor]];
    [eButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [eButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    eButton.tag = 4;
    [eButton setTitle:[titleArray objectAtIndex:eButton.tag] forState:UIControlStateNormal];
    [eButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    eButton.frame = CGRectMake(dButton.frame.origin.x + dButton.frame.size.width, self.view.frame.size.width * 154.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:eButton];
    
    UIButton *fButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fButton setBackgroundColor:[UIColor clearColor]];
    [fButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    fButton.tag = 5;
    [fButton setTitle:[titleArray objectAtIndex:fButton.tag] forState:UIControlStateNormal];
    [fButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    fButton.frame = CGRectMake(eButton.frame.origin.x + eButton.frame.size.width, self.view.frame.size.width * 154.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:fButton];
    
    UIButton *gButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [gButton setBackgroundColor:[UIColor clearColor]];
    [gButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    gButton.tag = 6;
    [gButton setTitle:[titleArray objectAtIndex:gButton.tag] forState:UIControlStateNormal];
    [gButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    gButton.frame = CGRectMake(0.0, self.view.frame.size.width * 252.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:gButton];
    
    UIButton *hButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hButton setBackgroundColor:[UIColor clearColor]];
    [hButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [hButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    hButton.tag = 7;
    [hButton setTitle:[titleArray objectAtIndex:hButton.tag] forState:UIControlStateNormal];
    [hButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    hButton.frame = CGRectMake(gButton.frame.origin.x + gButton.frame.size.width, self.view.frame.size.width * 252.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:hButton];
    
    UIButton *iButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [iButton setBackgroundColor:[UIColor clearColor]];
    [iButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [iButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    iButton.tag = 8;
    [iButton setTitle:[titleArray objectAtIndex:iButton.tag] forState:UIControlStateNormal];
    [iButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    iButton.frame = CGRectMake(hButton.frame.origin.x + hButton.frame.size.width, self.view.frame.size.width * 252.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:iButton];
    
    UIButton *jButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [jButton setBackgroundColor:[UIColor clearColor]];
    [jButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [jButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    jButton.tag = 9;
    [jButton setTitle:[titleArray objectAtIndex:jButton.tag] forState:UIControlStateNormal];
    [jButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    jButton.frame = CGRectMake(0.0, self.view.frame.size.width * 348.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:jButton];
    
    UIButton *kButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [kButton setBackgroundColor:[UIColor clearColor]];
    [kButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [kButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    kButton.tag = 10;
    [kButton setTitle:[titleArray objectAtIndex:kButton.tag] forState:UIControlStateNormal];
    [kButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    kButton.frame = CGRectMake(jButton.frame.origin.x + jButton.frame.size.width, self.view.frame.size.width * 348.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:kButton];
    
    UIButton *lButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lButton setBackgroundColor:[UIColor clearColor]];
    [lButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    lButton.tag = 11;
    [lButton setTitle:[titleArray objectAtIndex:lButton.tag] forState:UIControlStateNormal];
    [lButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    lButton.frame = CGRectMake(kButton.frame.origin.x + kButton.frame.size.width, self.view.frame.size.width * 348.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:lButton];
    
    UIButton *mButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mButton setBackgroundColor:[UIColor clearColor]];
    [mButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    mButton.tag = 12;
    [mButton setTitle:[titleArray objectAtIndex:mButton.tag] forState:UIControlStateNormal];
    [mButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    mButton.frame = CGRectMake(0.0, self.view.frame.size.width * 446.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:mButton];
    
    UIButton *nButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nButton setBackgroundColor:[UIColor clearColor]];
    [nButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    nButton.tag = 13;
    [nButton setTitle:[titleArray objectAtIndex:nButton.tag] forState:UIControlStateNormal];
    [nButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    nButton.frame = CGRectMake(mButton.frame.origin.x + mButton.frame.size.width, self.view.frame.size.width * 446.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:nButton];
    
    UIButton *oButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [oButton setBackgroundColor:[UIColor clearColor]];
    [oButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [oButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    oButton.tag = 14;
    [oButton setTitle:[titleArray objectAtIndex:oButton.tag] forState:UIControlStateNormal];
    [oButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    oButton.frame = CGRectMake(nButton.frame.origin.x + nButton.frame.size.width, self.view.frame.size.width * 446.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:oButton];
    
    UIButton *pButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pButton setBackgroundColor:[UIColor clearColor]];
    [pButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    pButton.tag = 15;
    [pButton setTitle:[titleArray objectAtIndex:pButton.tag] forState:UIControlStateNormal];
    [pButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    pButton.frame = CGRectMake(0.0, self.view.frame.size.width * 540.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:pButton];
    
    UIButton *qButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qButton setBackgroundColor:[UIColor clearColor]];
    [qButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [qButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    qButton.tag = 16;
    [qButton setTitle:[titleArray objectAtIndex:qButton.tag] forState:UIControlStateNormal];
    [qButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    qButton.frame = CGRectMake(pButton.frame.origin.x + pButton.frame.size.width, self.view.frame.size.width * 540.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:qButton];
    
    UIButton *rButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rButton setBackgroundColor:[UIColor clearColor]];
    [rButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    rButton.tag = 17;
    [rButton setTitle:[titleArray objectAtIndex:rButton.tag] forState:UIControlStateNormal];
    [rButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    rButton.frame = CGRectMake(qButton.frame.origin.x + qButton.frame.size.width, self.view.frame.size.width * 540.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:rButton];
    
    UIButton *sButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sButton setBackgroundColor:[UIColor clearColor]];
    [sButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    sButton.tag = 18;
    [sButton setTitle:[titleArray objectAtIndex:sButton.tag] forState:UIControlStateNormal];
    [sButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    sButton.frame = CGRectMake(0.0, self.view.frame.size.width * 638.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:sButton];
    
    UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tButton setBackgroundColor:[UIColor clearColor]];
    [tButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    tButton.tag = 19;
    [tButton setTitle:[titleArray objectAtIndex:tButton.tag] forState:UIControlStateNormal];
    [tButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    tButton.frame = CGRectMake(sButton.frame.origin.x + sButton.frame.size.width, self.view.frame.size.width * 638.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:tButton];
    
    UIButton *uButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [uButton setBackgroundColor:[UIColor clearColor]];
    [uButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    uButton.tag = 20;
    [uButton setTitle:[titleArray objectAtIndex:uButton.tag] forState:UIControlStateNormal];
    [uButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    uButton.frame = CGRectMake(tButton.frame.origin.x + tButton.frame.size.width, self.view.frame.size.width * 638.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:uButton];
    
    UIButton *vButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vButton setBackgroundColor:[UIColor clearColor]];
    [vButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [vButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    vButton.tag = 21;
    [vButton setTitle:[titleArray objectAtIndex:vButton.tag] forState:UIControlStateNormal];
    [vButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    vButton.frame = CGRectMake(0.0, self.view.frame.size.width * 736.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:vButton];
    
    UIButton *wButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wButton setBackgroundColor:[UIColor clearColor]];
    [wButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [wButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    wButton.tag = 22;
    [wButton setTitle:[titleArray objectAtIndex:wButton.tag] forState:UIControlStateNormal];
    [wButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    wButton.frame = CGRectMake(vButton.frame.origin.x + vButton.frame.size.width, self.view.frame.size.width * 736.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:wButton];
    
    UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [xButton setBackgroundColor:[UIColor clearColor]];
    [xButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [xButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    xButton.tag = 23;
    [xButton setTitle:[titleArray objectAtIndex:xButton.tag] forState:UIControlStateNormal];
    [xButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    xButton.frame = CGRectMake(wButton.frame.origin.x + wButton.frame.size.width, self.view.frame.size.width * 736.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:xButton];
    
    UIButton *yButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [yButton setBackgroundColor:[UIColor clearColor]];
    [yButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    yButton.tag = 24;
    [yButton setTitle:[titleArray objectAtIndex:yButton.tag] forState:UIControlStateNormal];
    [yButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    yButton.frame = CGRectMake(0.0, self.view.frame.size.width * 830.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:yButton];
    
    UIButton *zButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [zButton setBackgroundColor:[UIColor clearColor]];
    [zButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [zButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    zButton.tag = 25;
    [zButton setTitle:[titleArray objectAtIndex:zButton.tag] forState:UIControlStateNormal];
    [zButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    zButton.frame = CGRectMake(yButton.frame.origin.x + yButton.frame.size.width, self.view.frame.size.width * 830.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:zButton];
    
    UIButton *aaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aaButton setBackgroundColor:[UIColor clearColor]];
    [aaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [aaButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    aaButton.tag = 26;
    [aaButton setTitle:[titleArray objectAtIndex:aaButton.tag] forState:UIControlStateNormal];
    [aaButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    aaButton.frame = CGRectMake(zButton.frame.origin.x + zButton.frame.size.width, self.view.frame.size.width * 830.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:aaButton];
    
    UIButton *bbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bbButton setBackgroundColor:[UIColor clearColor]];
    [bbButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bbButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    bbButton.tag = 27;
    [bbButton setTitle:[titleArray objectAtIndex:bbButton.tag] forState:UIControlStateNormal];
    [bbButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    bbButton.frame = CGRectMake(0.0, self.view.frame.size.width * 924.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:bbButton];
    
    UIButton *ccButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ccButton setBackgroundColor:[UIColor clearColor]];
    [ccButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ccButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    ccButton.tag = 28;
    [ccButton setTitle:[titleArray objectAtIndex:ccButton.tag] forState:UIControlStateNormal];
    [ccButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    ccButton.frame = CGRectMake(bbButton.frame.origin.x + bbButton.frame.size.width, self.view.frame.size.width * 924.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:ccButton];
    
    UIButton *ddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ddButton setBackgroundColor:[UIColor clearColor]];
    [ddButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ddButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    ddButton.tag = 29;
    [ddButton setTitle:[titleArray objectAtIndex:ddButton.tag] forState:UIControlStateNormal];
    [ddButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    ddButton.frame = CGRectMake(ccButton.frame.origin.x + ccButton.frame.size.width, self.view.frame.size.width * 924.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:ddButton];
    
    UIButton *eeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [eeButton setBackgroundColor:[UIColor clearColor]];
    [eeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [eeButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    eeButton.tag = 30;
    [eeButton setTitle:[titleArray objectAtIndex:eeButton.tag] forState:UIControlStateNormal];
    [eeButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    eeButton.frame = CGRectMake(0.0, self.view.frame.size.width * 1020.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:eeButton];
    
    UIButton *ffButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ffButton setBackgroundColor:[UIColor clearColor]];
    [ffButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ffButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    ffButton.tag = 31;
    [ffButton setTitle:[titleArray objectAtIndex:ccButton.tag] forState:UIControlStateNormal];
    [ffButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    ffButton.frame = CGRectMake(eeButton.frame.origin.x + eeButton.frame.size.width, self.view.frame.size.width * 1020.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:ffButton];
    
    UIButton *ggButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ggButton setBackgroundColor:[UIColor clearColor]];
    [ggButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ggButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    ggButton.tag = 32;
    [ggButton setTitle:[titleArray objectAtIndex:ggButton.tag] forState:UIControlStateNormal];
    [ggButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    ggButton.frame = CGRectMake(ffButton.frame.origin.x + ffButton.frame.size.width, self.view.frame.size.width * 1020.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:ggButton];
    
    UIButton *hhButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hhButton setBackgroundColor:[UIColor clearColor]];
    [hhButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [hhButton.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
    hhButton.tag = 33;
    [hhButton setTitle:[titleArray objectAtIndex:hhButton.tag] forState:UIControlStateNormal];
    [hhButton addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
    hhButton.frame = CGRectMake(0.0, self.view.frame.size.width * 1116.0/640.0, self.view.frame.size.width/3.0, 21.0);
    [myScrollView addSubview:hhButton];
}

- (void)selectProvince:(id)sender {
    UIButton *button = sender;
    NSString *buttonText = button.titleLabel.text;
    NSArray *stringArray = [buttonText componentsSeparatedByString:@"（"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectProvince" object:nil userInfo:@{@"province": [stringArray objectAtIndex:0]}];
    [self.navigationController popViewControllerAnimated:YES];
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

@end
