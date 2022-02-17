//
//  LRSNetworkingClientConfig.h
//  LRSNetworking
//
//  Created by sama 刘 on 2022/2/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRSNetworkingClientConfig : NSObject
@property (nonatomic, class, readonly, nonnull) LRSNetworkingClientConfig *defaultConfig;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, strong, nullable) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic, copy, nullable) NSSet<NSString *> *acceptableContentTypes;
@end

NS_ASSUME_NONNULL_END
