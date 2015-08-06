//
//  WCLoginViewController.m
//  Wechat
//
//  Created by Craig Liao on 15/8/6.
//  Copyright (c) 2015年 Craig Liao. All rights reserved.
//

#import "WCLoginViewController.h"

@interface WCLoginViewController ()
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


@end
