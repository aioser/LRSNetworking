//
//  TDCaptchaManager.h
//  TeeTest
//
//  Created by vee on 18/2/3.
//  Copyright © 2018年 Tommybiteme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TDCaptchaManager;
@protocol TDCaptchaDelegate <NSObject>
@required
/// 验证码验证成功
- (void)captchaSuccessedResponse:(NSString *)validateToken;
/// 验证码验证失败
- (void)captchaFailedResponse:(NSInteger)errorCode errorMsg:(NSString *)errorMsg;
/// 验证码等待验证
- (void)captchaOnReady;
@end

@interface TDCaptchaManager : NSObject
/**
 * 创建验证码视图
 * options 配置项 @{@"appName":xx,@"partnerCode":xx,@"tapToClose":@(true),@"skipCaptcha":@(false),@"lang":@"1"} tapToClose不设置默认为false skipCaptcha不设置默认为false lang不设置默认为1 表示简体中文
 * superView 控件所在的父视图
 * delegate 代理
 */
+ (void)createCaptchaWithOptions:(NSDictionary *)options superView:(UIView *)superView andSetDelegate:(id<TDCaptchaDelegate>)delegate;

/**
 * 创建验证码视图
 * options 配置项 @{@"appName":xx,@"partnerCode":xx,@"tapToClose":@(true),@"skipCaptcha":@(false)} tapToClose不设置默认为false skipCaptcha不设置默认为false lang不设置默认为1 表示简体中文
 * superView 控件所在的父视图
 * delegate 代理
 * token 验证码token
 */
+ (void)createCaptchaWithOptions:(NSDictionary *)options superView:(UIView *)superView andSetDelegate:(id<TDCaptchaDelegate>)delegate andEncryptCaptchaToken:(NSString *)token;

/**
 * 日志开关 默认是关闭
 */
+ (void)openLog:(BOOL)openLog;

/**
 * 版本号 1.6.6
 */
+ (NSString *)getVersion;
@end
