//
//  OrderTableViewCell.h
//  WashingCar
//
//  Created by Jason Yuan on 3/10/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
{
    UILabel *dateLabel;
    UILabel *carInfoLabel;
    UILabel *locationLabel;
    UILabel *statusLabel;
    UIImageView *backImage;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width;
- (void)setData:(NSDictionary *)dict;

@end
