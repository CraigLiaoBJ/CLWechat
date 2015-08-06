//
//  WCUserInfo.h
//  Wechat
//
//  Created by Craig Liao on 15/8/6.
//  Copyright (c) 2015年 Craig Liao. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface WCUserInfo : NSObject

singleton_interface(WCUserInfo);

@property (nonatomic, copy) NSString *user;//用户名

@property (nonatomic, copy) NSString *pwd;//密码

@property (nonatomic, assign) BOOL LoginStatus;//登录的状态，yes代表登陆过 no 注销

//保存用户数据到沙盒
- (void)saveUserInfoToSandbox;

//从沙盒获取用户数据
- (void)loadUserFromSandbox;
@end
