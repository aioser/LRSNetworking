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
        [LRSProgressHUD showWithStatus:@"开始智能校验"];
        LRSNetworkOperation *errorOpearation = error.userInfo[LRSNetworkingErrorInfoKeyRequestOperation];
        LRSCallbacksDictionary *callbackBlocks = [errorOpearation.callbackBlocks copy];
        LRSNetworkOperationSuccessBlock success = callbackBlocks[kLRSSuccessCallbackKey];
        LRSNetworkOperationFailureBlock failure = callbackBlocks[kLRSFailureCallbackKey];
        LRSNetwokingErrorParams *params = error.userInfo[LRSNetworkingErrorInfoKeyExtraParams];
        [[LRSCaptchaManager instance] createCaptchaWithInfo:params.data end:^(NSString * _Nullable captcha, NSString * _Nullable smsCode, NSError * _Nullable captchaError) {
            [LRSProgressHUD showWithStatus:@"智能校验结束，开始重试请求"];
            NSURLRequest *errorRequest = errorOpearation.request;
            NSMutableURLRequest *retryRequest = [NSMutableURLRequest requestWithURL:errorRequest.URL];
            retryRequest.HTTPBody = errorRequest.HTTPBody;
            retryRequest.HTTPMethod = errorRequest.HTTPMethod;
            retryRequest.allHTTPHeaderFields = errorRequest.allHTTPHeaderFields;
            [retryRequest setValue:captcha forHTTPHeaderField:@"captcha"];
            [retryRequest setValue:smsCode forHTTPHeaderField:@"sms"];
            NSArray<id<LRSNetworkingRequestModifier>> *requestModifiers = errorOpearation.context[LRSNetworkingContextOptionRequestModifier];
            NSURLRequest *request = [retryRequest copy];
            for (id<LRSNetworkingRequestModifier> requestModifier in requestModifiers) {
                request = [requestModifier modifiedRequestWithRequest:request];
            }
            LRSNetworkOperation *retryOperation = [[LRSNetworkOperation alloc] initWithRequest:request inSession:errorOpearation.unownedClient context:errorOpearation.context];
            [retryOperation addHandlersForSuccess:success failure:failure];
            [retryOperation.unownedClient resumeOperation:retryOperation];
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
