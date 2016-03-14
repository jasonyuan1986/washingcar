//
//  CustomCalloutView.h
//  WashingCar
//
//  Created by Jason Yuan on 4/9/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomCalloutViewDelegate <NSObject>

- (void)calloutTaped;

@end

@interface CustomCalloutView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, copy) NSString *title; //商户名
@property (nonatomic, copy) NSString *subtitle; //地址
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *myButton;
@property (assign, nonatomic) id<CustomCalloutViewDelegate> delegate;

@end
