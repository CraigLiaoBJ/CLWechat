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
        [[WCXMPPTool sharedWCXMPPTool] xmppUserLogin:nil];
    }
    return YES;
}


@end
