//
//  WCXMPPTool.m
//  Wechat
//
//  Created by Craig Liao on 15/8/7.
//  Copyright (c) 2015年 Craig Liao. All rights reserved.
//

#import "WCXMPPTool.h"
//在AppDelegate实现登录
//1.初始化XMPPStream
//2.连接到服务器【传一个JID】
//3.连接到服务成功后，再发送密码授权
//4.授权成功后，发送“在线”消息

@interface WCXMPPTool ()<XMPPStreamDelegate>{
    XMPPStream *_xmppStream;
    XMPPResultBlock _resultBlock;
    XMPPvCardTempModule *_vCard;//电子名片
    XMPPvCardCoreDataStorage *_vCardStorage;//电子名片的数据存储
    XMPPvCardAvatarModule *_avatar;//头像
}
//1.初始化XMPPStream
- (void)setupXMPPStream;

//2.连接到服务器【传一个JID】
- (void)connectToHost;

//3.连接到服务成功后，再发送密码授权
- (void)sendPwdToHost;

//4.授权成功后，发送“在线”消息
- (void)sendOnlineToHost;

@end

@implementation WCXMPPTool

singleton_implementation(WCXMPPTool);


#pragma mark -- 私有方法
#pragma mark -- 初始化XMPPSTREAM
- (void)setupXMPPStream{
    _xmppStream = [[XMPPStream alloc] init];

#warning 每一个模块添加后都要激活
    //添加电子名片模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    //激活
    [_vCard activate:_xmppStream];
    //添加头像模块
    _avatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    [_avatar activate:_xmppStream];
    
    //设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

#pragma mark -- 连接到服务器
- (void)connectToHost{
    WCLog(@"开始连接到服务器");
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    //设置JID
    //resource标识用户登陆的客户端 iPhone android
    //从沙盒中获取用户名
    NSString *user = nil;
    if (self.isregisterOperation) {
        user = [WCUserInfo sharedWCUserInfo].registerUser;
    } else {
        user = [WCUserInfo sharedWCUserInfo].user;
    }
    
    XMPPJID *myJID = [XMPPJID jidWithUser:user domain:@"catkingcraig.local" resource:@"iPhone"];
    _xmppStream.myJID = myJID;
    
    //设置服务器域名
    _xmppStream.hostName = @"catkingcraig.local";//不仅可以是这个域名，还可以是IP地址
    
    //设置端口 如果服务器端口是5222，可以省略。
    //    _xmppStream.hostPort = 5222;
    
    //连接
    NSError *error = nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]){
        WCLog(@"%@", error);
    }
}

#pragma mark -- 发送密码
- (void)sendPwdToHost{
    WCLog(@"再发送密码授权");
    NSError *error = nil;
    //从沙盒里面获取密码
    NSString *pwd = [WCUserInfo sharedWCUserInfo].pwd;
    
    [_xmppStream authenticateWithPassword:pwd error:&error];
    if (error) {
        WCLog(@"%@", error);
    }
}

#pragma mark -- 授权成功后，发送“在线”消息
- (void)sendOnlineToHost{
    WCLog(@"发送 在线 消息");
    XMPPPresence *presence = [XMPPPresence presence];
    WCLog(@"%@", presence);
    [_xmppStream sendElement:presence];
}

#pragma mark -- XMPPStream的代理
#pragma mark -- 与主机连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    WCLog(@"与主机连接成功");
    
    if (self.isregisterOperation) {//注册操作，发送注册的密码；
        NSString *pwd = [WCUserInfo sharedWCUserInfo].registerPwd;
        [_xmppStream registerWithPassword:pwd error:nil];
    }else {
        //主机连接成功后发送密码进行授权
        [self sendPwdToHost];
    }
    
}

#pragma mark -- 与主机断开连接
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    //如果有错误，代表连接失败
    //如果没有错误，表示正常的断开连接（人为断开连接）
    if (error && _resultBlock) {
        _resultBlock(XMPPResultTypeNetErr);
    }
    WCLog(@"与主机连接失败%@", error);
}

#pragma mark -- 授权成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    WCLog(@"授权成功");
    [self sendOnlineToHost];
    
    //回调控制器登录成功
    if (_resultBlock){
        _resultBlock(XMPPResultTypeLoginSuccess);
    }
    //登录成功，来到主界面
    //此方法是在子线程补调用，所以在主线程刷新UI
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //        self.window.rootViewController = storyboard.instantiateInitialViewController;
    //    });
    
}

#pragma mark -- 授权失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    WCLog(@"授权失败%@", error);
    //判断block有无值，再回调给登陆控制器。
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
}

#pragma mark -- 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    WCLog(@"注册成功");
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
}

#pragma mark -- 注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    WCLog(@"注册失败%@", error);
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterFailure);
    }
}
#pragma mark -- 公共方法
- (void)xmppUserLogout{
    //1.发送“离线”消息
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    
    //2.与服务器断开连接
    
    [_xmppStream disconnect];
    
    //3.回到登录界面
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    self.window.rootViewController = storyboard.instantiateInitialViewController;
    
    [UIStoryboard showInitialVCWithName:@"Login"];
    
    //4.更新用户的登录状态
    [WCUserInfo sharedWCUserInfo].LoginStatus = NO;
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSandbox];
}

- (void)xmppUserLogin:(XMPPResultBlock)resultBlock{
    //先把block存起来
    _resultBlock = resultBlock;
    
    //如果以前连接过服务，要断开
    [_xmppStream disconnect];
    
    //连接主机，成功后发送登录密码
    [self connectToHost];
}

- (void)xmppUserRegister:(XMPPResultBlock)resultBlock{
    //先把block存起来
    _resultBlock = resultBlock;
    
    //如果以前连接过服务，要断开
    [_xmppStream disconnect];
    
    //连接主机，成功后发送注册密码
    [self connectToHost];
}

@end