//
//  CarBoyTableViewCell.h
//  WashingCar
//
//  Created by Jason Yuan on 3/30/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RatingBar/RatingBar.h>

@interface CarBoyTableViewCell : UITableViewCell
{
    UILabel *commentLabel;
    RatingBar *myRatingBar;
    UILabel *phoneLabel;
    UILabel *timeLabel;
    UIImageView *backImage;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width;
- (void)setData:(NSDictionary *)dict;

@end
