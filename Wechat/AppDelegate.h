//
//  AppDelegate.h
//  Wechat
//
//  Created by Craig Liao on 15/8/5.
//  Copyright (c) 2015年 Craig Liao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败
    XMPPResultTypeNetErr//网络不给力
}XMPPResultType;
typedef void (^XMPPResultBlock)(XMPPResultType type);//XMPP请求结果的block

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//注销方法
- (void)xmppUserLogout;
//用户登录
- (void)xmppUserLogin:(XMPPResultBlock)resultBlock;

@end

