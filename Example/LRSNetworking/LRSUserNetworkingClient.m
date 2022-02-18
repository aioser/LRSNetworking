//
//  LRSUserNetworkingClient.m
//  LRSNetworking_Example
//
//  Created by sama 刘 on 2022/2/18.
//  Copyright © 2022 刘sama. All rights reserved.
//

#import "LRSUserNetworkingClient.h"

@import LRSNetworking;

@interface LRSUserNetworkingClient()
@property (nonatomic, strong) LRSNetworkingClient *client;
@end

@implementation LRSUserNetworkingClient
+ (instancetype)instance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        LRSNetworkingClientConfig *configure = [LRSNetworkingClientConfig defaultConfig];
        _client = [[LRSNetworkingClient alloc] initWithConfig:configure];
        LRSNetworkingGlobalCatcher *global = [LRSNetworkingGlobalCatcher shared];
        for (id<LRSNetworkingErrorCatcher> catcher in global.errorCatchers) {
            [_client addErrorCatcher:catcher];
        }
        for (id<LRSNetworkingRequestModifier> modifier in global.requestModifiers) {
            [_client addRequestModifier:modifier];
        }
        [_client setValue:@"User" forHTTPHeaderField:@"Module"];
        _client.baseURL = [NSURL URLWithString:@"http://localhost:3000/users/"];
    }
    return self;
}

- (RACSignal<NSDictionary *> *)info:(NSNumber *)uid {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *parameters = [@{} mutableCopy];
        parameters[@"uid"] = [NSString stringWithFormat:@"%@", uid];
        LRSNetworkToken *token = [self.client GET:@"info" parameters:parameters context:nil success:^(__kindof NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(__kindof NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [token cancel];
        }];
    }];
}
@end
