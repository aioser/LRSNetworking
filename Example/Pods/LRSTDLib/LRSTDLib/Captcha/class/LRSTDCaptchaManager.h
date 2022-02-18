//
//  JMTDCaptchaManager.h
//  LangRen
//
//  Created by ljc on 2020/12/10.
//  Copyright © 2020 langrengame.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LRSTDCaptchaManagerSuccessedBlock)(NSString * _Nonnull token);
typedef void(^LRSTDCaptchaManagerFailedBlock)(NSInteger code, NSString * _Nonnull errorMsg);
typedef void(^LRSTDCaptchaManagerViewOnReadyBlock)(void);

@interface LRSTDCaptchaManager : NSObject

/// 同盾智能验证
/// @param options 配置项。默认值： options @{\  @"appName":xx,\   @"partnerCode":xx,\   @"tapToClose":@(true),\   @"skipCaptcha":@(false),\   @"lang":@"1" 按需求选择语言，1、简体中文，2、繁体中文，3、英文\   @"hideCompInfo": @1 是否隐藏“同盾验证服务”文案， 1、隐藏，0、不隐藏\ }
/// @param token token
/// @param captchaView 验证框的父视图
/// @param onReady 验证框准备就绪
/// @param failed 验证失败
/// @param successed 验证成功
+ (void)createCaptchaWithOptions:(NSDictionary  *_Nullable)options
                           token:(NSString  *_Nullable)token
                       superView:(UIView  *_Nullable)captchaView
                         onReady:(LRSTDCaptchaManagerViewOnReadyBlock _Nullable)onReady
                          failed:(LRSTDCaptchaManagerFailedBlock _Nullable)failed
                       successed:(LRSTDCaptchaManagerSuccessedBlock _Nonnull)successed;

/// 打开日志
/// @param open open
+ (void)openLog:(BOOL)open;


/// version
+ (NSString *)version;
@end

NS_ASSUME_NONNULL_END
