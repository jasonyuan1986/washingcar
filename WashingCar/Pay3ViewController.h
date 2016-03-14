//
//  Pay3ViewController.h
//  WashingCar
//
//  Created by Jason Yuan on 4/7/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Product : NSObject{
@private
    float     _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;

@end

@interface Pay3ViewController : UIViewController

@end
