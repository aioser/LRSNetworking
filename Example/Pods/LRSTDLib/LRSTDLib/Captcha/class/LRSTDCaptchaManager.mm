//
//  JMTDCaptchaManager.m
//  LangRen
//
//  Created by ljc on 2020/12/10.
//  Copyright © 2020 langrengame.com. All rights reserved.
//

#import "LRSTDCaptchaManager.h"
#import "TDCaptchaManager.h"

@interface LRSTDCaptchaManager() <TDCaptchaDelegate>

@property (nonatomic, copy) LRSTDCaptchaManagerSuccessedBlock successBlock;
@property (nonatomic, copy) LRSTDCaptchaManagerFailedBlock failBlock;
@property (nonatomic, copy) LRSTDCaptchaManagerViewOnReadyBlock onReadyBlock;

@end

@implementation LRSTDCaptchaManager

+ (instancetype)shared {
    static LRSTDCaptchaManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LRSTDCaptchaManager alloc] init];
    });
    return instance;
}

+ (NSDictionary *)defaultOptions {
    return @{
        @"partnerCode": @"jiamiantech",
        @"appName": @"jiamiantech_ios",
        @"tapToClose": @0,
        @"lang": @1,
        @"skipCaptcha": @0,
        @"hideCompInfo": @1,
    };
}

+ (void)createCaptchaWithOptions:(NSDictionary *)options
                           token:(NSString *)token
                       superView:(UIView *)captchaView
                         onReady:(LRSTDCaptchaManagerViewOnReadyBlock)onReady
                          failed:(LRSTDCaptchaManagerFailedBlock)failed
                       successed:(LRSTDCaptchaManagerSuccessedBlock)successed {
    NSAssert(successed, @"JMTDCaptchaManager的successed回调不能为空");
    LRSTDCaptchaManager *manager = [LRSTDCaptchaManager shared];
    manager.successBlock = successed;
    manager.failBlock = failed;
    manager.onReadyBlock = onReady;
    if (token) {
        [TDCaptchaManager createCaptchaWithOptions:options ? : [self defaultOptions]
                                         superView:captchaView ? : UIApplication.sharedApplication.delegate.window
                                    andSetDelegate:[LRSTDCaptchaManager shared]
                            andEncryptCaptchaToken:token];
    } else {
        [TDCaptchaManager createCaptchaWithOptions:options ? : [self defaultOptions]
                                         superView:captchaView ? : UIApplication.sharedApplication.delegate.window
                                    andSetDelegate:[LRSTDCaptchaManager shared]];
    }
}
/// 验证码验证成功
- (void)captchaSuccessedResponse:(NSString *)validateToken{
    if (self.successBlock) {
        self.successBlock(validateToken ? : @"");
    }
    self.successBlock = nil;
}
/// 验证码验证失败
- (void)captchaFailedResponse:(NSInteger)errorCode errorMsg:(NSString *)errorMsg{
    if (self.failBlock) {
        self.failBlock(errorCode, errorMsg);
    }
    self.failBlock = nil;

}
/// 验证码等待验证
- (void)captchaOnReady{
    if (self.onReadyBlock) {
        self.onReadyBlock();
    }
    self.onReadyBlock = nil;
}

+ (void)openLog:(BOOL)open {
    [TDCaptchaManager openLog:open];
}

+ (NSString *)version {
    return [TDCaptchaManager getVersion];
}
@end
