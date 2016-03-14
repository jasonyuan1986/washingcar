//
//  CustomCalloutView.m
//  WashingCar
//
//  Created by Jason Yuan on 4/9/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "CustomCalloutView.h"

#define kArrorHeight 10
#define kPortraitMargin 5 
#define kPortraitWidth 70 
#define kPortraitHeight 50
#define kTitleWidth 200 
#define kTitleHeight 20

@implementation CustomCalloutView 

@synthesize delegate;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame]; if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews]; }
    return self;
}

- (void)initSubViews {
    // 添加标题,即商户名
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, kPortraitMargin, kTitleWidth, kTitleHeight)];
    self.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:12.0];
    self.titleLabel.textColor = [UIColor whiteColor]; self.titleLabel.text = @"titletitletitletitle";
    [self addSubview:self.titleLabel];
    // 添加副标题,即商户地址
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, kPortraitMargin * 2 + kTitleHeight, kTitleWidth, kTitleHeight)];
    self.subtitleLabel.font = [UIFont fontWithName:@"Heiti SC" size:10.0];
    self.subtitleLabel.textColor = [UIColor lightGrayColor];
    self.subtitleLabel.text = @"subtitleLabelsubtitleLabelsubtitleLabel";
    [self addSubview:self.subtitleLabel];
    
    UIGestureRecognizer *tap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(viewTaped:)];
    [self addGestureRecognizer:tap];
    tap.delegate = self;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return true;
}

- (void)viewTaped:(id)sender {
    [self.delegate calloutTaped];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle
{
    self.subtitleLabel.text = subtitle;
}

- (void)drawRect:(CGRect)rect {
    [self drawInContext:UIGraphicsGetCurrentContext()];
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)drawInContext:(CGContextRef)context {
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8].CGColor);
    [self getDrawPath:context]; CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context {
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy); CGContextAddLineToPoint(context,midx, maxy+kArrorHeight); CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius); CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius); CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius); CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius); CGContextClosePath(context);
}

@end
