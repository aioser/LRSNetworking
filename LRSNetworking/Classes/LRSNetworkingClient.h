//
//  LRSNetworkingClient.h
//  LRSNetworking
//
//  Created by sama 刘 on 2021/10/12.
//

#import <Foundation/Foundation.h>
#import "LRSNetworkingRequestModifier.h"
#import "LRSNetworkingClientConfig.h"
#import "LRSNetworkingDecryptor.h"
#import "LRSNetworkingResponseModifier.h"
#import "LRSNetworkOperation.h"
#import "LRSNetworkingError.h"
#import "LRSNetworkingDefine.h"
#import "LRSNetworkingErrorCatcher.h"

NS_ASSUME_NONNULL_BEGIN

@interface LRSNetworkToken : NSObject
@property (nonatomic, strong, nullable, readonly) NSURL *url;
@property (nonatomic, strong, nullable, readonly) NSURLRequest *request;
@property (nonatomic, strong, nullable, readonly) NSURLResponse *response;
- (void)cancel;
@end


@class AFHTTPSessionManager;
@interface LRSNetworkingClient : NSObject

@property (nonatomic, strong, readonly) AFHTTPSessionManager *session;
@property (nonatomic, strong, readonly, nonnull) LRSNetworkingClientConfig *config;

@property (nonatomic, strong, nullable) id<LRSNetworkingDecryptor> decryptor;

+ (nonnull instancetype)shared;

- (nonnull instancetype)initWithConfig:(nullable LRSNetworkingClientConfig *)config NS_DESIGNATED_INITIALIZER;

- (void)setValue:(nullable NSString *)value forHTTPHeaderField:(nullable NSString *)field;
- (nullable NSString *)valueForHTTPHeaderField:(nullable NSString *)field;
- (NSDictionary *)allHTTPHeaders;

- (void)addErrorCatcher:(nonnull id<LRSNetworkingErrorCatcher>)catcher;
- (void)removeErrorCatcher:(nonnull id<LRSNetworkingErrorCatcher>)catcher;
- (NSArray<id<LRSNetworkingErrorCatcher>> *)errorCatchers;

- (void)addRequestModifier:(nonnull id<LRSNetworkingRequestModifier>)requestModifier;
- (void)removeRequestModifier:(nonnull id<LRSNetworkingRequestModifier>)requestModifier;
- (NSArray<id<LRSNetworkingRequestModifier>> *)requestModifiers;

- (void)addResponseModifier:(nonnull id<LRSNetworkingResponseModifier>)responseModifier;
- (void)removeResponseModifier:(nonnull id<LRSNetworkingResponseModifier>)responseModifier;
- (NSArray<id<LRSNetworkingResponseModifier>> *)responseModifiers;

- (LRSNetworkToken *)requestURL:(NSURL *)URL
                     parameters:(NSDictionary * _Nullable)parameters
                         method:(LRSNetworkingMethod)method
                        context:(nullable LRSNetworkingContext *)context
                        success:(LRSNetworkOperationSuccessBlock)success
                        failure:(LRSNetworkOperationFailureBlock _Nullable)failure;

- (LRSNetworkToken *)resumeOperation:(LRSNetworkOperation *)operation;

- (void)cancelAllTasks;

@end

NS_ASSUME_NONNULL_END
