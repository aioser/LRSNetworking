//
//  LRSCaptchaManager.h
//  LRSNetworking_Example
//
//  Created by sama 刘 on 2022/2/17.
//  Copyright © 2022 刘sama. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRSCaptchaManager : NSObject
+ (instancetype)instance;
- (void)createCaptchaWithInfo:(NSDictionary *)info end:(void(^)(NSString * _Nullable captcha, NSString * _Nullable smsCode, NSError * _Nullable error))end;
@end

NS_ASSUME_NONNULL_END
