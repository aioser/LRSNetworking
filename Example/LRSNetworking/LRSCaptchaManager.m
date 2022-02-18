//
//  LRSCaptchaManager.m
//  LRSNetworking_Example
//
//  Created by sama 刘 on 2022/2/17.
//  Copyright © 2022 刘sama. All rights reserved.
//

#import "LRSCaptchaManager.h"
@import LRSTDLib;
@implementation LRSCaptchaManager
+ (instancetype)instance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (void)createCaptchaWithInfo:(NSDictionary *)info end:(nonnull void (^)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))end {
    NSString *token = info[@"captcha"];
    if (!token) {
        token = @"N/DoylTZuhu5Sms3sqG57tE0LvnHbgtZ0zt4Ra3Pf+4154TpEQF3Y8hQ411Yi+19PuO/NzyzY7g7OByB94O0xUm6DrP8Fq4Pc2KDqmkbGNE=_2";
    }
    [LRSTDCaptchaManager createCaptchaWithOptions:nil token:token superView:nil onReady:nil failed:^(NSInteger code, NSString * _Nonnull errorMsg) {
        end(nil, nil, [NSError errorWithDomain:@"com.lrs.td" code:code userInfo:@{
            NSLocalizedDescriptionKey: errorMsg
        }]);
    } successed:^(NSString * _Nonnull token) {
        end(token, nil, nil);
    }];
}
@end
