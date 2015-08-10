//
//  WCInputView.m
//  Wechat
//
//  Created by Craig Liao on 15/8/9.
//  Copyright (c) 2015年 Craig Liao. All rights reserved.
//

#import "WCInputView.h"

@implementation WCInputView

+(instancetype)inputView{
    return [[[NSBundle mainBundle] loadNibNamed:@"WCInputView" owner:nil options:nil] lastObject];
}

@end
