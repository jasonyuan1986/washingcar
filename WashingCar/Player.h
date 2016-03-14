//
//  Player.h
//  WashingCar
//
//  Created by Jason Yuan on 3/23/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioStreamer.h"

@interface Player : NSObject

@property (strong, nonatomic) AudioStreamer *player;

+ (instancetype)shared;
- (void)play;
- (void)change;

@end
