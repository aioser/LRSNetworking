//
//  LRSNetworkOperation.h
//  LRSNetworking
//
//  Created by sama 刘 on 2022/2/8.
//

#import <Foundation/Foundation.h>
#import "LRSNetworkingDefine.h"

NS_ASSUME_NONNULL_BEGIN
static NSString *const kLRSFailureCallbackKey = @"Failure";
static NSString *const kLRSSuccessCallbackKey = @"Success";
static NSString *const kLRSCompletedCallbackKey = @"Completed";
typedef NSMutableDictionary<NSString *, id> LRSCallbacksDictionary;

@class LRSNetworkOperation;
@class LRSNetworkingClient;
typedef void(^LRSNetworkOperationSuccessBlock)(__kindof NSURLSessionTask *task, id _Nullable responseObject);
typedef void(^LRSNetworkOperationFailureBlock)(__kindof NSURLSessionTask * _Nullable task, NSError *error);
typedef void(^LRSNetworkOperationCompletionBlock)(LRSNetworkOperation *task);

@interface LRSNetworkOperation : NSObject

- (nonnull instancetype)initWithRequest:(nullable NSURLRequest *)request
                              inSession:(nullable LRSNetworkingClient *)session
                                context:(nullable LRSNetworkingContext *)context;

- (BOOL)cancel:(nullable id)token;
- (void)resume;

@property (copy, nonatomic, readonly, nullable) LRSNetworkingContext *context;
@property (weak, nonatomic, readonly, nullable) LRSNetworkingClient *unownedClient;
@property (strong, nonatomic, readonly, nonnull) LRSCallbacksDictionary *callbackBlocks;
@property (strong, nonatomic, readonly, nullable) NSURLRequest *request;
@property (strong, nonatomic, readonly, nullable) NSURLResponse *response;

@property (strong, nonatomic, readonly, nullable) NSURLSessionTask *dataTask;

@property (copy, nonatomic, nullable) NSSet<NSString *> *acceptableContentTypes;

- (nullable id)addHandlersForSuccess:(LRSNetworkOperationSuccessBlock)successBlock failure:(LRSNetworkOperationFailureBlock)failureBlock;

@property (nonatomic, copy, nullable) LRSNetworkOperationCompletionBlock completionBlock;
@end
NS_ASSUME_NONNULL_END
