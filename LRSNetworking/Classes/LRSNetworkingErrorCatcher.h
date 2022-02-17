//
//  LRSNetworkingErrorCatcher.h
//  LRSNetworking
//
//  Created by sama 刘 on 2022/2/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LRSNetworkingErrorCatcher <NSObject>
- (BOOL)catchError:(NSError *)error;
- (BOOL)isGlobalErrorCatcher;
@optional
- (BOOL)tryCatch:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
