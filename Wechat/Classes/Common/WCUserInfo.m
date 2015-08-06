//
//  WCUserInfo.m
//  Wechat
//
//  Created by Craig Liao on 15/8/6.
//  Copyright (c) 2015年 Craig Liao. All rights reserved.
//

#import "WCUserInfo.h"
#define UserKey @"user"
#define PwdKey @"pwd"
#define LoginStatusKey @"LoginStatus"
@implementation WCUserInfo

singleton_implementation(WCUserInfo);
- (void)saveUserInfoToSandbox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.user forKey:UserKey];
    [defaults setObject:self.pwd forKey:PwdKey];
    [defaults setBool:self.LoginStatus forKey:LoginStatusKey];
    [defaults synchronize];
}

- (void)loadUserFromSandbox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.user = [defaults objectForKey:UserKey];
    self.pwd = [defaults objectForKey:PwdKey];
    self.LoginStatus = [defaults boolForKey:LoginStatusKey];
}

@end
