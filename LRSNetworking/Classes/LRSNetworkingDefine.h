//
//  LRSNetworkingDefine.h
//  Pods
//
//  Created by sama 刘 on 2022/2/14.
//

typedef NSString* LRSNetworkingMethod NS_EXTENSIBLE_STRING_ENUM;
FOUNDATION_EXPORT LRSNetworkingMethod _Nonnull const LRSNetworkingMethodGET;
FOUNDATION_EXPORT LRSNetworkingMethod _Nonnull const LRSNetworkingMethodPOST;


typedef NSString * LRSNetworkingContextOption NS_EXTENSIBLE_STRING_ENUM;
typedef NSDictionary<LRSNetworkingContextOption, id> LRSNetworkingContext;
typedef NSMutableDictionary<LRSNetworkingContextOption, id> LRSNetworkingMutableContext;

FOUNDATION_EXPORT LRSNetworkingContextOption _Nonnull const LRSNetworkingContextOptionRequestModifier;
FOUNDATION_EXPORT LRSNetworkingContextOption _Nonnull const LRSNetworkingContextOptionResponseModifier;
FOUNDATION_EXPORT LRSNetworkingContextOption _Nonnull const LRSNetworkingContextOptionDecryptor;
FOUNDATION_EXPORT LRSNetworkingContextOption _Nonnull const LRSNetworkingContextOptionErrorCatcher;



