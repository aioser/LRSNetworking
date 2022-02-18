//
//  LRSNetworkingRequestModifier.h
//  LRSNetworking
//
//  Created by sama 刘 on 2022/2/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LRSNetworkingRequestModifier <NSObject>
- (nullable __kindof NSURLRequest *)modifiedRequestWithRequest:(nonnull __kindof NSURLRequest *)request;
- (BOOL)isGlobalModifier;
@end

NS_ASSUME_NONNULL_END
