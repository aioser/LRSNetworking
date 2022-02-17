//
//  LRSNetworkingClient+ConvenienceURL.h
//  LRSNetworking
//
//  Created by sama 刘 on 2022/2/15.
//

#import "LRSNetworkingClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface LRSNetworkingClient(ConvenienceURL)

@property (nonatomic, copy) NSURL *baseURL;

- (LRSNetworkToken *)GET:(NSString *)path
              parameters:(NSDictionary * _Nullable)parameters
                 context:(nullable LRSNetworkingContext *)context
                 success:(LRSNetworkOperationSuccessBlock)success
                 failure:(LRSNetworkOperationFailureBlock _Nullable)failure;

- (LRSNetworkToken *)POST:(NSString *)path
               parameters:(NSDictionary * _Nullable)parameters
                  context:(nullable LRSNetworkingContext *)context
                  success:(LRSNetworkOperationSuccessBlock)success
                  failure:(LRSNetworkOperationFailureBlock _Nullable)failure;

@end

NS_ASSUME_NONNULL_END
