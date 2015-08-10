//
//  WCBaseLoginViewController.m
//  Wechat
//
//  Created by Craig Liao on 15/8/6.
//  Copyright (c) 2015年 Craig Liao. All rights reserved.
//

#import "WCBaseLoginViewController.h"
#import "AppDelegate.h"
@interface WCBaseLoginViewController ()

@end

@implementation WCBaseLoginViewController
- (void)login {
    //登录
    //官方的登录实现
    //1. 把用户名和密码放在WCUserInfo的单例
    //2. 调用AppDelegate的一个login，连接服务并登录
    
    //隐藏键盘
    [self.view endEditing:YES];
    
    [MBProgressHUD showMessage:@"正在登录中..." toView:self.view];
    
    [WCXMPPTool sharedWCXMPPTool].registerOperation = NO;
    __weak typeof(self) selfVC = self;
    [[WCXMPPTool sharedWCXMPPTool] xmppUserLogin:^(XMPPResultType type) {
        [selfVC handleResultType:type];
    }];
}

- (void)handleResultType:(XMPPResultType)type{
    //主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        switch (type) {
            case XMPPResultTypeLoginSuccess:
                [self enterMainPage];
                NSLog(@"登录成功");
                break;
            case XMPPResultTypeLoginFailure:
                NSLog(@"登录失败");
                [MBProgressHUD showError:@"用户名或者密码不正确"];
                break;
            case XMPPResultTypeNetErr:
                NSLog(@"网络超时");
                [MBProgressHUD showError:@"网络不给力"];
                break;
            default:
                break;
        }
    });
}

- (void)enterMainPage{
    //更改用户的登录状态为yes
    [WCUserInfo sharedWCUserInfo].LoginStatus = YES;
    
    //把用户登陆成功的数据保存到沙盒
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSandbox];
    //隐藏模态窗口
    [self dismissViewControllerAnimated:NO completion:nil];
    
    //登录成功来到主界面
    //此方法是在子线程补调用，所以在主线程刷新UI
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    self.view.window.rootViewController = storyBoard.instantiateInitialViewController;
    [UIStoryboard showInitialVCWithName:@"Main"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
