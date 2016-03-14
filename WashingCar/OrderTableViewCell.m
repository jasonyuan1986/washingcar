//
//  OrderTableViewCell.m
//  WashingCar
//
//  Created by Jason Yuan on 3/10/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "OrderTableViewCell.h"
#import <JSONKit-NoWarning/JSONKit.h>

@implementation OrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        backImage = [[UIImageView alloc] init];
        backImage.frame = CGRectMake(0.0, width * 28.0/640.0, width, width * 192.0/640.0);
        [self addSubview:backImage];
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, width * 45.0/640.0, 200.0, 15.0)];
        [dateLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
        [dateLabel setTextColor:[UIColor whiteColor]];
        
        carInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, width * 90.0/640.0, 200.0, 15.0)];
        [carInfoLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
        [carInfoLabel setTextColor:[UIColor whiteColor]];
        
        locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, width * 135.0/640.0, 200.0, 30.0)];
        [locationLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
        locationLabel.lineBreakMode = NSLineBreakByCharWrapping;
        locationLabel.numberOfLines = 2;
        [locationLabel setTextColor:[UIColor whiteColor]];
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * 488.0/640.0, width * 28.0/640.0, width * 152.0/640.0, width * 192.0/640.0)];
        [statusLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
        [statusLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:dateLabel];
        [self addSubview:carInfoLabel];
        [self addSubview:locationLabel];
        [self addSubview:statusLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)dict {
    NSString *orderDate = [dict objectForKey:@"orderDate"];
    [dateLabel setText:orderDate];
    
    NSString *carInfo = [dict objectForKey:@"carInfo"];
    NSString *carNum = [dict objectForKey:@"carNum"];

    NSDictionary *locationDict = [[dict objectForKey:@"mapLocation"] objectFromJSONString];
    NSString *address = [locationDict objectForKey:@"address"];
    
    [carInfoLabel setText:[NSString stringWithFormat:@"%@ %@", carInfo, carNum]];
    [locationLabel setText:address];
    
    NSString *statusText = [dict objectForKey:@"statusText"];
    [statusLabel setText:statusText];
    
    NSNumber *status = [dict objectForKey:@"status"];
    
    if ([[status stringValue] isEqualToString:@"5"] ||
        [[status stringValue] isEqualToString:@"4"]) {
        [backImage setImage:[UIImage imageNamed:@"orderNotFeedCell"]];
        [statusLabel setTextColor:[UIColor blackColor]];
    } else if ([[status stringValue] isEqualToString:@"6"] ||
               [[status stringValue] isEqualToString:@"9"] ||
               [[status stringValue] isEqualToString:@"8"]) {
        [backImage setImage:[UIImage imageNamed:@"orderFeededCell"]];
        [statusLabel setTextColor:[UIColor blackColor]];
    } else {
        [backImage setImage:[UIImage imageNamed:@"orderAppointCell"]];
        [statusLabel setTextColor:YELLOWCOLOR];
    }
}

@end
