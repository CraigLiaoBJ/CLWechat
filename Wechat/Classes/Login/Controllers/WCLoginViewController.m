//
//  WCLoginViewController.m
//  Wechat
//
//  Created by Craig Liao on 15/8/6.
//  Copyright (c) 2015年 Craig Liao. All rights reserved.
//

#import "WCLoginViewController.h"
#import "WCRegisterViewController.h"
#import "WCNavigationController.h"
@interface WCLoginViewController ()<WCRegisterViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation WCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置TextFiel和Btn的样式
    self.pwdTextField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.pwdTextField addLeftViewWithImage:@"Card_Lock"];
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
//    UIImageView *lockView = [[UIImageView alloc] init];
//    lockView.bounds = CGRectMake(0, 0, 30, 30);
//    lockView.image = [UIImage imageNamed:@"Card_Lock"];
//    self.pwdTextField.leftView = lockView;
    
    
    // 设置用户名为上次登录的用户名
    //从沙盒中获取
    NSString *user = [WCUserInfo sharedWCUserInfo].user;
    self.userLabel.text = user;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginBtnClick:(id)sender {
   //保存数据到单例
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.user = self.userLabel.text;
    userInfo.pwd = self.pwdTextField.text;
    
    //调用父类的登录
    [super login];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //获取注册控制器
    id destVC = segue.destinationViewController;
    
    if ([destVC isKindOfClass:[WCNavigationController class]]) {
        WCNavigationController *nav = destVC;
        //获取根控制器
        if ([nav.topViewController isKindOfClass:[WCNavigationController class]]) {
            WCRegisterViewController *registerVC = (WCRegisterViewController *)nav.topViewController;
            //设置注册控制器的代理
            
            registerVC.registerDelegate = self;
        }
    }
}

#pragma mark -- registerViewController代理
- (void)registerViewControllerDidFinishRegister{
    WCLog(@"完成注册");
    //完成注册 userlabel显示注册的用户名
    self.userLabel.text = [WCUserInfo sharedWCUserInfo].registerUser;
    //提示
    [MBProgressHUD showSuccess:@"请重新输入密码进行登录" toView:self.view];
    }

@end
