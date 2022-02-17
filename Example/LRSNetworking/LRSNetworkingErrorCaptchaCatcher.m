//
//  LRSNetworkingErrorCaptchaCatcher.m
//  LRSNetworking_Example
//
//  Created by sama 刘 on 2022/2/16.
//  Copyright © 2022 刘sama. All rights reserved.
//

#import "LRSNetworkingErrorCaptchaCatcher.h"
#import "LRSCaptchaManager.h"

@import JMProgressHUD;
@implementation LRSNetworkingErrorCaptchaCatcher

- (BOOL)isGlobalErrorCatcher {
    return true;
}

- (BOOL)catchError:(NSError *)error {
    if ([self tryCatch:error]) {
        LRSNetwokingErrorParams *params = error.userInfo[LRSNetworkingErrorInfoKeyExtraParams];
        [[LRSCaptchaManager instance] createCaptchaWithInfo:params.data end:^(NSString * _Nullable captcha, NSString * _Nullable smsCode, NSError * _Nullable error) {
            LRSNetworkOperation *catchedOpearation = error.userInfo[LRSNetworkingErrorInfoKeyRequestOperation];
            [catchedOpearation.unownedClient resumeOperation:catchedOpearation];
        }];
        return true;
    }
    return false;
}

- (BOOL)tryCatch:(NSError *)error {
    LRSNetwokingErrorParams *extra = error.userInfo[LRSNetworkingErrorInfoKeyExtraParams];
    return extra.extVerificationType.length > 1;
}
@end
