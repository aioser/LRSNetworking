//
//  TDCaptchaButton.h
//  TDCaptcha
//
//  Created by zeinber on 2018/4/9.
//  Copyright © 2018年 Tommybiteme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDCaptchaManager.h"

@interface TDCaptchaButton : UIButton
/**
 * SDK提供的验证码按钮
 * options 配置项 @{@"appName":xx,@"partnerCode":xx,@"tapToClose":@(true),@"skipCaptcha":@(false)} tapToClose不设置默认为false skipCaptcha不设置默认为false lang不设置默认为1 表示简体中文
 * @captchaSuperView 验证码父视图 不传默认加在keyWindow上
 */
- (instancetype)initWithOptions:(NSDictionary *)options captchaDelegate:(id<TDCaptchaDelegate>)captchaDelegate captchaSuperView:(UIView *)captchaSuperView;
@end
