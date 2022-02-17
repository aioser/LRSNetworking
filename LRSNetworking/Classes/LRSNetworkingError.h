//
//  LRSNetworkingError.h
//  LRSNetworking
//
//  Created by sama 刘 on 2022/2/14.
//

#import <Foundation/Foundation.h>
FOUNDATION_EXPORT NSErrorDomain const _Nonnull LRSNetworkingErrorDomain;

typedef NS_ERROR_ENUM(LRSNetworkingErrorDomain, LRSNetworkingError) {
    LRSNetworkingErrorInvalidURL = 1000,
    LRSNetworkingErrorDecryptFailed = 1001,
    LRSNetworkingErrorInvalidDownloadOperation = 1002,
};

FOUNDATION_EXPORT NSErrorUserInfoKey const _Nonnull LRSNetworkingErrorInfoKeyNotificationType;
FOUNDATION_EXPORT NSErrorUserInfoKey const _Nonnull LRSNetworkingErrorInfoKeyExtraParams;
FOUNDATION_EXPORT NSErrorUserInfoKey const _Nonnull LRSNetworkingErrorInfoKeyRequestOperation;
