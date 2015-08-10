//
//  AppDelegate.m
//  Wechat
//
//  Created by Craig Liao on 15/8/5.
//  Copyright (c) 2015年 Craig Liao. All rights reserved.
//
#import "AppDelegate.h"
#import "XMPPFramework.h"
#import "WCNavigationController.h"
#import "DDLog.h"
#import "DDTTYLogger.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //沙盒的路径
   NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@", path);
    
    //打开XMPP日志
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    //设置导航栏背景
    [WCNavigationController setupNavTheme];
    
    //程序一启动就连接到主机
//    [self connectToHost];
    //从沙盒里加载数据到单例里面
    [[WCUserInfo sharedWCUserInfo] loadUserFromSandbox];
    
    //判断用户的登陆状态 yes直接来到主界面
    if ([WCUserInfo sharedWCUserInfo].LoginStatus) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = storyboard.instantiateInitialViewController;
        //自动登录服务器
        //1s后再自动登录
#warning 一般情况下，都不会马上连接，会稍微等等
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[WCXMPPTool sharedWCXMPPTool] xmppUserLogin:nil];
        });
    }
    //注册应用接收通知
    if ([[UIDevice currentDevice].systemVersion doubleValue] > 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    return YES;
}


@end
