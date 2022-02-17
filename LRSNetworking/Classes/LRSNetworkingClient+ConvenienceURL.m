//
//  LRSNetworkingClient+ConvenienceURL.m
//  LRSNetworking
//
//  Created by sama 刘 on 2022/2/15.
//

#import "LRSNetworkingClient+ConvenienceURL.h"
#import <objc/runtime.h>

LRSNetworkingMethod const LRSNetworkingMethodGET = @"GET";
LRSNetworkingMethod const LRSNetworkingMethodPOST = @"POST";

@implementation LRSNetworkingClient (ConvenienceURL)
static char *kLRSNetworkingClientBaseURLKey = "kLRSNetworkingClientBaseURLKey";

- (NSURL *)baseURL {
    @synchronized (self) {
        return objc_getAssociatedObject(self, kLRSNetworkingClientBaseURLKey);
    }
}

- (void)setBaseURL:(NSURL *)baseURL {
    @synchronized (self) {
        objc_setAssociatedObject(self, kLRSNetworkingClientBaseURLKey, baseURL, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (LRSNetworkToken *)GET:(NSString *)path parameters:(NSDictionary *)parameters context:(nullable LRSNetworkingContext *)context success:(nonnull LRSNetworkOperationSuccessBlock)success failure:(LRSNetworkOperationFailureBlock _Nullable)failure {
    NSURL *URL = [self.baseURL URLByAppendingPathComponent:path];
    return [self requestURL:URL parameters:parameters method:LRSNetworkingMethodGET context:context success:success failure:failure];
}

- (LRSNetworkToken *)POST:(NSString *)path parameters:(NSDictionary *)parameters context:(LRSNetworkingContext *)context success:(LRSNetworkOperationSuccessBlock)success failure:(LRSNetworkOperationFailureBlock)failure {
    NSURL *URL = [self.baseURL URLByAppendingPathComponent:path];
    return [self requestURL:URL parameters:parameters method:LRSNetworkingMethodPOST context:context success:success failure:failure];
}
@end
