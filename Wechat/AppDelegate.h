//
//  AppDelegate.h
//  Wechat
//
//  Created by Craig Liao on 15/8/5.
//  Copyright (c) 2015年 Craig Liao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//注销方法
- (void)logout;
//用户登录
- (void)xmppUserLogin;

@end

