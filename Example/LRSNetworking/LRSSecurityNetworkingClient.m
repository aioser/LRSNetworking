//
//  LRSSecurityNetworkingClient.m
//  LRSNetworking_Example
//
//  Created by sama 刘 on 2022/2/16.
//  Copyright © 2022 刘sama. All rights reserved.
//

#import "LRSSecurityNetworkingClient.h"
#import "LRSSecurityNetworkingResponseModifier.h"

@import LRSNetworking;
@import JMEncryption;

@interface LRSSecurityNetworkingClient()
@property (nonatomic, strong) LRSNetworkingClient *client;
@end

@implementation LRSSecurityNetworkingClient
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
        [_client addResponseModifier:[LRSSecurityNetworkingResponseModifier new]];
        [_client setValue:@"security" forHTTPHeaderField:@"Module"];
        _client.baseURL = [NSURL URLWithString:@"http://localhost:3000/security/"];
    }
    return self;
}

- (RACSignal<LRSLoginResponseModel *> *)login {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *parameters = [@{} mutableCopy];
        parameters[@"token"] = @"13253565920";
        parameters[@"accessToken"] = @"123456";
        LRSNetworkToken *token = [self.client GET:@"login" parameters:parameters context:nil success:^(__kindof NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
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
