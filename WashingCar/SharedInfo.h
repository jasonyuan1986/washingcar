//
//  SharedInfo.h
//  WashingCar
//
//  Created by Jason Yuan on 3/2/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SharedInfo : NSObject

@property (strong, nonatomic) NSDictionary *carBrandDictionary;
@property (strong, nonatomic) NSDictionary *userInfo;
@property (strong, nonatomic) NSArray *carColorArray;
@property (strong, nonatomic) NSArray *carTypeArray;
@property (strong, nonatomic) NSArray *carWashPrice;
@property (strong, nonatomic) NSArray *extraList;
@property (strong, nonatomic) NSArray *washPrice;
@property (strong, nonatomic) NSDictionary *carBrand;
@property (strong, nonatomic) NSDictionary *carModel;
@property (strong, nonatomic) NSDictionary *currentCar;
@property (strong, nonatomic) NSString *currentLocation;
@property (assign, nonatomic) CGFloat currentLatitude;
@property (assign, nonatomic) CGFloat currentLongitude;
@property (strong, nonatomic) NSString *washTime;
@property (strong, nonatomic) NSMutableArray *extraIds;
@property (strong, nonatomic) NSNumber *productId;
@property (strong, nonatomic) NSNumber *amount;
@property (strong, nonatomic) NSNumber *totalAmount;
@property (strong, nonatomic) NSString *firstOrder;
@property (strong, nonatomic) NSIndexPath *currentCarIndex;
@property (strong, nonatomic) NSString *loginType;
@property (strong, nonatomic) NSString *currentOrderId;
@property (strong, nonatomic) NSDictionary *planDict;
@property (strong, nonatomic) NSDictionary *timeDict;
@property (strong, nonatomic) NSString *pid;
@property (strong, nonatomic) NSURL *imageURL1;
@property (strong, nonatomic) NSString *pid1;
@property (strong, nonatomic) NSURL *imageURL2;
@property (strong, nonatomic) NSString *pid2;
@property (strong, nonatomic) NSURL *imageURL3;
@property (strong, nonatomic) NSString *pid3;
@property (strong, nonatomic) NSURL *imageURL4;
@property (strong, nonatomic) NSString *pid4;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *mapAddress;
@property (strong, nonatomic) NSString *mapAddress2;
@property (strong, nonatomic) NSString *timeOrderId;
@property (strong, nonatomic) NSNumber *leftCount;
@property (strong, nonatomic) NSString *aliPayType;
@property (strong, nonatomic) NSDictionary *youhuiquanDict;

+ (instancetype)shared;
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
+ (NSDictionary *)getIPAddresses2;

@end
