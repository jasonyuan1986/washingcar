//
//  CarBoyTableViewCell.m
//  WashingCar
//
//  Created by Jason Yuan on 3/30/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "CarBoyTableViewCell.h"

@implementation CarBoyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carBoyCellBack"]];
        backImage.frame = CGRectMake(0.0, width * 22.0/640.0, width, width * 192.0/640.0);
        [self addSubview:backImage];
        
        commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * 20.0/640.0, width * 94.0/640.0, width * 460.0/640.0, 15.0)];
        [commentLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
        [commentLabel setTextColor:[UIColor whiteColor]];
        
        myRatingBar = [[RatingBar alloc] initWithFrame:CGRectMake(width * 510.0/640.0, width * 94.0/640.0, width * 115.0/640.0, width * 34.0/640.0)];
        [myRatingBar setBackgroundColor:[UIColor clearColor]];
        [self addSubview:myRatingBar];
        
        phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * 20.0/640.0, width * 146.0/640.0, width * 180.0/640.0, 15.0)];
        [phoneLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
        [phoneLabel setTextColor:[UIColor whiteColor]];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * 220.0/640.0, width * 146.0/640.0, width * 300.0/640.0, 15.0)];
        [timeLabel setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
        [timeLabel setTextColor:[UIColor whiteColor]];
        
        [self addSubview:commentLabel];
        [self addSubview:phoneLabel];
        [self addSubview:timeLabel];
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
    NSString *comment = [dict objectForKey:@"comment"];
    NSString *phone = [dict objectForKey:@"phone"];
    
    NSNumber *timestamp = [dict objectForKey:@"finishTime"];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:([timestamp longLongValue]/1000)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *finishTime = [dateFormatter stringFromDate:date];
    if ([finishTime isEqual:[NSNull null]]) {
        finishTime = @"";
    }
    
    NSNumber *rank = [dict objectForKey:@"rank"];
    
    [commentLabel setText:comment];
    [phoneLabel setText:phone];
    [timeLabel setText:finishTime];
    myRatingBar.starNumber = [rank intValue];
    
}

@end
