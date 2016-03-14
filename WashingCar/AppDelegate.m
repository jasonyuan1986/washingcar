//
//  AppDelegate.m
//  WashingCar
//
//  Created by Jason Yuan on 1/19/15.
//  Copyright (c) 2015 Rongmai. All rights reserved.
//

#import "AppDelegate.h"
#import "APService.h"
#import "Player.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "payRequsestHandler.h"

#define SUPPORT_IOS8 1

@interface AppDelegate ()<WXApiDelegate, UIAlertViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    
    [MobClick startWithAppkey:MOBAPPKEY reportPolicy:BATCH channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hasCookies"]) {
        NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"cookies"];
        if([cookiesdata length]) {
            NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
            NSHTTPCookie *cookie;
            for (cookie in cookies) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            }
        }
    }
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        LoggerApp(2, @"第一次启动");
    }else{
        LoggerApp(2, @"不是第一次启动");
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:VERSION parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        LoggerApp(2, @"版本信息：%@", resultDic);
        NSString *lastVersion = [resultDic objectForKey:@"ios-user-inner"];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if ([version doubleValue] < [lastVersion doubleValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新" message:@"发现新版本，是否更新？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            [alert show];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LoggerError(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerError(1, @"Result: %@", result);
    }];
    
    [manager GET:INFOURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        LoggerApp(2, @"应用信息：%@", resultDic);
        [SharedInfo shared].phoneNumber = [resultDic objectForKey:@"phone"];
        [SharedInfo shared].emailAddress = [resultDic objectForKey:@"email"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LoggerError(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerError(1, @"Result: %@", result);
    }];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"everSignedIn"]){
        [manager GET:USERINFO parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSData *data = responseObject;
            NSDictionary *resultDic = [data objectFromJSONData];
            LoggerApp(2, @"用户信息：%@", resultDic);
            NSNumber *success = [resultDic objectForKey:@"success"];
            if ([success integerValue] == 1) {
                [SharedInfo shared].userInfo = [resultDic objectForKey:@"data"];
            } else {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"everSignedIn"];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            LoggerError(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                      [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                      [error.userInfo objectForKey:@"NSLocalizedDescription"]);
            NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
            LoggerError(1, @"Result: %@", result);
        }];
    }
    
    [manager GET:CARBRAND parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        LoggerApp(2, @"车辆品牌：%@", resultDic);
        [SharedInfo shared].carBrandDictionary = [resultDic objectForKey:@"data"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LoggerError(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerError(1, @"Result: %@", result);
    }];
    
    [manager GET:CARCOLOR parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        LoggerApp(2, @"车辆颜色：%@", resultDic);
        [SharedInfo shared].carColorArray = [resultDic objectForKey:@"data"];;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LoggerError(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerError(1, @"Result: %@", result);
    }];
    
    [manager GET:CARTYPE parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        LoggerApp(2, @"车辆型号：%@", resultDic);
        [SharedInfo shared].carTypeArray = [resultDic objectForKey:@"data"];;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LoggerError(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerError(1, @"Result: %@", result);
    }];
    
    [manager GET:MEMBERINFO parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        LoggerApp(2, @"套餐信息：%@", resultDic);
        NSDictionary *dataDict = [resultDic objectForKey:@"data"];
        [SharedInfo shared].planDict = [dataDict objectForKey:@"plan"];
        [SharedInfo shared].timeDict = [dataDict objectForKey:@"time"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LoggerError(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerError(1, @"Result: %@", result);
    }];
    
    
    
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //categories
            [APService
             registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                 UIUserNotificationTypeSound |
                                                 UIUserNotificationTypeAlert)
             categories:nil];
        } else {
            //categories nil
            [APService
             registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                 UIUserNotificationTypeSound |
                                                 UIUserNotificationTypeAlert)
#else
             //categories nil
             categories:nil];
            [APService
             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)
#endif
             // Required
             categories:nil];
        }
    [APService setupWithOption:launchOptions];

    //向微信注册
    [WXApi registerApp:APP_ID withDescription:@"来啦洗车"];
    
    return YES;
}

#if SUPPORT_IOS8
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}
#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:APPGAME parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *data = responseObject;
        NSDictionary *resultDic = [data objectFromJSONData];
        LoggerApp(1, @"%@", resultDic);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                  [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                  [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        LoggerApp(1, @"Result: %@", result);
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        return  [WXApi handleOpenURL:url delegate:self];
    } else {
        NSArray *urlArray = [url.absoluteString componentsSeparatedByString:@"?"];
        NSString *jsonString = urlArray[1];
        NSString *decodeString = [jsonString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [decodeString objectFromJSONString];
        NSDictionary *memoDict = [dict objectForKey:@"memo"];
        
        NSString *resultStatus = [memoDict objectForKey:@"ResultStatus"];
        if ([resultStatus isEqualToString:@"9000"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"购买成功";
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // Do something...
                [MBProgressHUD hideHUDForView:self.window animated:YES];
            });
            
            if ([[SharedInfo shared].aliPayType isEqualToString:@"1"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AddMoneyController" object:nil];
            } else if ([[SharedInfo shared].aliPayType isEqualToString:@"2"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayOrderController" object:nil];
            } else if ([[SharedInfo shared].aliPayType isEqualToString:@"3"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BuyMemberController" object:nil];
            }
        }
        
        return YES;
    }
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
            {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                [SharedInfo shared].currentCarIndex = nil;
                [SharedInfo shared].currentCar = nil;
                [SharedInfo shared].currentLatitude = 0.0;
                [SharedInfo shared].currentLongitude = 0.0;
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"购买成功";
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    // Do something...
                    [MBProgressHUD hideHUDForView:self.window animated:YES];
                });
                if ([[SharedInfo shared].aliPayType isEqualToString:@"1"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddMoneyController" object:nil];
                } else if ([[SharedInfo shared].aliPayType isEqualToString:@"2"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PayOrderController" object:nil];
                } else if ([[SharedInfo shared].aliPayType isEqualToString:@"3"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"BuyMemberController" object:nil];
                } else if ([[SharedInfo shared].aliPayType isEqualToString:@"4"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShareController" object:nil];
                }
                break;
            }
            default:
            {
                break;
            }
        }
    } else {
        switch (resp.errCode) {
            case WXSuccess:
            {
                if ([[SharedInfo shared].aliPayType isEqualToString:@"5"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShareYouhuiquan" object:nil];
                    return;
                }
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                
                [manager GET:APPGAME parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSData *data = responseObject;
                    NSDictionary *resultDic = [data objectFromJSONData];
                    LoggerApp(1, @"%@", resultDic);
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    LoggerApp(1, @"NSErrorFailingURLKey: %@\nNSLocalizedDescription: %@",
                              [error.userInfo objectForKey:@"NSErrorFailingURLKey"],
                              [error.userInfo objectForKey:@"NSLocalizedDescription"]);
                    NSString *result = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
                    LoggerApp(1, @"Result: %@", result);
                }];
                
                break;
            }
            default:
            {
                break;
            }
        }
    }
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSURL * url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/lai-la-xi-che/id990872887?l=zh&ls=1&mt=8"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
