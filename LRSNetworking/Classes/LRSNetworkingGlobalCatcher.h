//
//  LRSNetworkErrorCatchManager.h
//  LRSNetworking
//
//  Created by sama 刘 on 2022/2/9.
//

#import <Foundation/Foundation.h>
#import "LRSNetworkingErrorCatcher.h"
#import "LRSNetworkingRequestModifier.h"
#import "LRSNetworkingResponseModifier.h"

NS_ASSUME_NONNULL_BEGIN

@interface LRSNetworkingGlobalCatcher : NSObject
@property (nonatomic, class, readonly, nonnull) LRSNetworkingGlobalCatcher *shared;

@property (nonatomic, strong, readonly) NSSet<id<LRSNetworkingErrorCatcher>> *errorCatchers;
@property (nonatomic, strong, readonly) NSSet<id<LRSNetworkingRequestModifier>> *requestModifiers;

- (void)addErrorCatcher:(nonnull id<LRSNetworkingErrorCatcher>)catcher;
- (void)removeErrorCatcher:(nonnull id<LRSNetworkingErrorCatcher>)catcher;

- (void)addRequestModifier:(nonnull id<LRSNetworkingRequestModifier>)requestModifier;
- (void)removeRequestModifier:(nonnull id<LRSNetworkingRequestModifier>)requestModifier;
@end

NS_ASSUME_NONNULL_END
