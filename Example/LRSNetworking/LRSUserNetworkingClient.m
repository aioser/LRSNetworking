//
//  LRSUserNetworkingClient.m
//  LRSNetworking_Example
//
//  Created by sama 刘 on 2022/2/18.
//  Copyright © 2022 刘sama. All rights reserved.
//

#import "LRSUserNetworkingClient.h"

@import LRSNetworking;
@import AFNetworking;

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
//        for (id<LRSNetworkingErrorCatcher> catcher in global.errorCatchers) {
//            [_client addErrorCatcher:catcher];
//        }
//        for (id<LRSNetworkingRequestModifier> modifier in global.requestModifiers) {
//            [_client addRequestModifier:modifier];
//        }
//        [_client setValue:@"User" forHTTPHeaderField:@"Module"];
        _client.baseURL = [NSURL URLWithString:@"http://121.41.117.170:8080/pickme/aws/s3/img/"];
        [_client setValue:@"6030033f73baebee822e13b7a32cd938" forHTTPHeaderField:@"token"];
        [_client setValue:@"256" forHTTPHeaderField:@"uid"];
        [_client setValue:@"0.9.1" forHTTPHeaderField:@"pcode"];
        [_client setValue:@"2fe711e1e3894527754d66313b86ecc3e662b946" forHTTPHeaderField:@"deviceId"];
        _client.session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/javascript", @"text/html", nil];
    }
    return self;
}

- (RACSignal<NSDictionary *> *)info:(NSNumber *)uid {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *parameters = [@{} mutableCopy];
        parameters[@"contentLength"] = @(147361);
        parameters[@"contentType"] = @"image/jpeg";
        parameters[@"fileName"] = @"images/6dc7ad09b264db94794a8ffebed01123.jpg";
        LRSNetworkToken *token = [self.client GET:@"uploadUrl" parameters:parameters context:nil success:^(__kindof NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
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
