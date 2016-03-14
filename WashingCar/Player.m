//
//  Player.m
//  WashingCar
//
//  Created by Jason Yuan on 3/23/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "Player.h"


@implementation Player

@synthesize player;

+ (instancetype)shared {
    static Player *sharedPlayer = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedPlayer = [[self alloc] init];
    });
    return sharedPlayer;
}

- (void)play {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:MUSICURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        NSString *fileName = [resultDic objectForKey:@"file"];
        
        //播放在线音乐
        NSString *urlStr = [NSString stringWithFormat:@"%@music/%@", HOST, fileName];
        NSURL *url = [[NSURL alloc]initWithString:urlStr];
        
        self.player = [[AudioStreamer alloc] initWithURL:url];
        [self.player start];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerApp(1, @"Result: %@", result);
    }];
}

- (void)change {
    if (self.player.isPlaying) {
        [self.player pause];
    } else {
        [self.player start];
    }
}

@end
