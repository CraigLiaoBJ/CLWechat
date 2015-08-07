//
//  WCRegisterViewController.m
//  Wechat
//
//  Created by Craig Liao on 15/8/7.
//  Copyright (c) 2015年 Craig Liao. All rights reserved.
//

#import "WCRegisterViewController.h"

@interface WCRegisterViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
- (IBAction)registerBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation WCRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    //判断当前设备的类型，改变左右两边约束的距离
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftConstraint.constant = 10;
        self.rightConstraint.constant = 10;
    }
    //设置textfild的背景
    self.userField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    [self.registerBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registerBtnClick:(id)sender {
    //1.把用户注册保存到单例
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.registerUser = self.userField.text;
    userInfo.registerPwd = self.pwdField.text;
    //2.调用appDelegate的xmppUserRegister
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.registerOperation = YES;
    [app xmppUserRegister:^(XMPPResultType type) {
        
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
