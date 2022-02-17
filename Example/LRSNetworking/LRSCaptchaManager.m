//
//  LRSCaptchaManager.m
//  LRSNetworking_Example
//
//  Created by sama 刘 on 2022/2/17.
//  Copyright © 2022 刘sama. All rights reserved.
//

#import "LRSCaptchaManager.h"

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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        end(@"captcha", @"sms", nil);
    });
}
@end
