//
//  WCRegisterViewController.h
//  Wechat
//
//  Created by Craig Liao on 15/8/7.
//  Copyright (c) 2015年 Craig Liao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WCRegisterViewControllerDelegate <NSObject>
//完成注册
- (void)registerViewControllerDidFinishRegister;

@end

@interface WCRegisterViewController : UIViewController

@property (nonatomic, weak) id<WCRegisterViewControllerDelegate> registerDelegate;

@end
