//
//  AppDelegate.m
//  Wechat
//
//  Created by Craig Liao on 15/8/5.
//  Copyright (c) 2015年 Craig Liao. All rights reserved.
//
#import "AppDelegate.h"
#import "XMPPFramework.h"
//在AppDelegate实现登录
//1.初始化XMPPStream
//2.连接到服务器【传一个JID】
//3.连接到服务成功后，再发送密码授权
//4.授权成功后，发送“在线”消息

@interface AppDelegate ()<XMPPStreamDelegate>{
    XMPPStream *_xmppStream;
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

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //程序一启动就连接到主机
    [self connectToHost];
    
    return YES;
}

#pragma mark -- 私有方法
#pragma mark -- 初始化XMPPSTREAM
- (void)setupXMPPStream{
    _xmppStream = [[XMPPStream alloc] init];
    
    //设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

#pragma mark -- 连接到服务器
- (void)connectToHost{
    NSLog(@"开始连接到服务器");
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    //设置JID
    //resource标识用户登陆的客户端 iPhone android
   //从沙盒中获取用户名
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    
    XMPPJID *myJID = [XMPPJID jidWithUser:user domain:@"catkingcraig.local" resource:@"iPhone"];
    _xmppStream.myJID = myJID;
    
    //设置服务器域名
    _xmppStream.hostName = @"catkingcraig.local";//不仅可以是这个域名，还可以是IP地址
    
    //设置端口 如果服务器端口是5222，可以省略。
    //    _xmppStream.hostPort = 5222;
    
    //连接
    NSError *error = nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]){
        NSLog(@"%@", error);
    }
}

#pragma mark -- 发送密码
- (void)sendPwdToHost{
    NSLog(@"再发送密码授权");
    NSError *error = nil;
    //从沙盒里面获取密码
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
    
    [_xmppStream authenticateWithPassword:pwd error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
}

#pragma mark -- 授权成功后，发送“在线”消息
- (void)sendOnlineToHost{
    NSLog(@"发送 在线 消息");
    XMPPPresence *presence = [XMPPPresence presence];
    NSLog(@"%@", presence);
    [_xmppStream sendElement:presence];
}

#pragma mark -- XMPPStream的代理
#pragma mark -- 与主机连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"与主机连接成功");
    //主机连接成功后发送密码进行授权
    [self sendPwdToHost];
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    //如果有错误，代表连接失败
    NSLog(@"与主机连接失败%@", error);
}

#pragma mark -- 授权成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"授权成功");
    [self sendOnlineToHost];
    //登录成功，来到主界面
    //此方法是在子线程补调用，所以在主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = storyboard.instantiateInitialViewController;
    });
   
}

#pragma mark -- 授权失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"授权失败%@", error);
}

#pragma mark -- 公共方法
- (void)logout{
    //1.发送“离线”消息
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    //2.与服务器断开连接
    [_xmppStream disconnect];
}
- (void)xmppUserLogin{
    //连接主机，成功后发送密码
    [self connectToHost];
}

@end
