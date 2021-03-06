//
//  WCXMPPTool.h
//  Wechat
//
//  Created by Craig Liao on 15/8/7.
//  Copyright (c) 2015年 Craig Liao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XMPPFramework.h"
extern NSString *const WCLoginStatusChangeNotification;
typedef enum {
    XMPPResultTypeConnecting,//连接中...
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败
    XMPPResultTypeNetErr,//网络不给力
    XMPPResultTypeRegisterSuccess,//注册成功
    XMPPResultTypeRegisterFailure//注册失败
}XMPPResultType;
typedef void (^XMPPResultBlock)(XMPPResultType type);//XMPP请求结果的block

@interface WCXMPPTool : NSObject

singleton_interface(WCXMPPTool);

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *vCard;//电子名片
@property (nonatomic, strong, readonly) XMPPRoster *roster;//花名册数据存储
@property (nonatomic, strong) XMPPRosterCoreDataStorage *rosterStorage;//花名册数据存储
@property (nonatomic, strong, readonly) XMPPMessageArchivingCoreDataStorage *msgStorage;//聊天的数据存储



//注册标识 YES 注册/ NO 登录
@property (nonatomic, assign, getter=isregisterOperation) BOOL registerOperation;
//注销方法
- (void)xmppUserLogout;
//用户登录
- (void)xmppUserLogin:(XMPPResultBlock)resultBlock;
//用户注册
- (void)xmppUserRegister:(XMPPResultBlock)resultBlock;


@end
