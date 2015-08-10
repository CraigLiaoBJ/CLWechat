//
//  WCInputView.h
//  Wechat
//
//  Created by Craig Liao on 15/8/9.
//  Copyright (c) 2015年 Craig Liao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCInputView : UIView

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

+(instancetype)inputView;

@end
