//
//  WCOtherLoginViewController.m
//  Wechat
//
//  Created by Craig Liao on 15/8/6.
//  Copyright (c) 2015年 Craig Liao. All rights reserved.
//

#import "WCOtherLoginViewController.h"
#import "AppDelegate.h"


@interface WCOtherLoginViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation WCOtherLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"其他方式登录";
    //判断当前设备的类型，改变左右两边约束的距离
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftConstraint.constant = 10;
        self.rightConstraint.constant = 10;
    }
    //设置textfild的背景
    self.userField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];

}
- (IBAction)loginBtnClick {
    //登录
    //官方的登录实现
    //1. 把用户名和密码放在沙盒里
    //2. 调用AppDelegate的一个login，连接服务并登录
    NSString *user = self.userField.text;
    NSString *pwd = self.pwdField.text;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user forKey:@"user"];
    [defaults setObject:pwd forKey:@"pwd"];
    [defaults synchronize];
    
    //隐藏键盘
    [self.view endEditing:YES];
    
    [MBProgressHUD showMessage:@"正在登录中..." toView:self.view];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    __weak typeof(self) selfVC = self;
    [app xmppUserLogin:^(XMPPResultType type) {
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
    //隐藏模态窗口
    [self dismissViewControllerAnimated:NO completion:nil];
    
    //登录成功来到主界面
    //此方法是在子线程补调用，所以在主线程刷新UI
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.view.window.rootViewController = storyBoard.instantiateInitialViewController;
}



- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)dealloc{
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
