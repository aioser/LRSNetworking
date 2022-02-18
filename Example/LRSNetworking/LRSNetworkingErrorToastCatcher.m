//
//  LRSNetworkingErrorToastCatcher.m
//  LRSNetworking_Example
//
//  Created by sama 刘 on 2022/2/16.
//  Copyright © 2022 刘sama. All rights reserved.
//

#import "LRSNetworkingErrorToastCatcher.h"

@import JMProgressHUD;
@implementation LRSNetworkingErrorToastCatcher

- (BOOL)isGlobalErrorCatcher {
    return true;
}

- (BOOL)catchError:(NSError *)error {
    if ([self tryCatch:error]) {
        [LRSProgressHUD showErrorWithStatus:error.localizedDescription];
        return true;
    }
    return false;
}

- (BOOL)tryCatch:(NSError *)error {
    return [error.userInfo[LRSNetworkingErrorInfoKeyNotificationType] integerValue] == LRSNetwokingErrorMessageTypeToast && !error.userInfo[LRSNetworkingErrorInfoKeyExtraParams];
}

@end
