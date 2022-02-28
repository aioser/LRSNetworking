//
//  LRSSecurityNetworkingClient.m
//  LRSNetworking_Example
//
//  Created by sama 刘 on 2022/2/16.
//  Copyright © 2022 刘sama. All rights reserved.
//

#import "LRSSecurityNetworkingClient.h"
#import "LRSSecurityNetworkingResponseModifier.h"

@import CommonCrypto;
@import LRSNetworking;
@import JMEncryption;
@import OpenUDID;
@import AFNetworking;

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
//        for (id<LRSNetworkingErrorCatcher> catcher in global.errorCatchers) {
//            [_client addErrorCatcher:catcher];
//        }
//        for (id<LRSNetworkingRequestModifier> modifier in global.requestModifiers) {
//            [_client addRequestModifier:modifier];
//        }
        [_client addResponseModifier:[LRSSecurityNetworkingResponseModifier new]];
        [_client setValue:@"security" forHTTPHeaderField:@"Module"];
        _client.baseURL = [NSURL URLWithString:@"http://121.41.117.170:8080/pickme/"];
        _client.session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/javascript", @"text/html", @"application/xml", nil];

    }
    return self;
}

static NSString *num = @"15566905555";

- (RACSignal *)smscode {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *parameters = [@{} mutableCopy];
        parameters[@"phoneNumber"] = num;
        parameters[@"codeVerificationType"] = @(1);
        LRSNetworkToken *token = [self.client GET:@"securities/code" parameters:parameters context:nil success:^(__kindof NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
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

- (RACSignal<LRSLoginResponseModel *> *)login {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *parameters = [@{} mutableCopy];
        parameters[@"loginType"] = @"1";
        parameters[@"channel"] = @"";
        parameters[@"verificationCode"] = @"1234";
        parameters[@"deviceId"] = [OpenUDID value];
//        NSString *deviceType = [[NSString currentDeviceType] stringByReplacingOccurrencesOfString:@"%" withString:@""];
        parameters[@"deviceType"] = @"ipad";
        parameters[@"userIdentity"] = [LRSSecurityNetworkingClient md5:num];
        parameters[@"phoneType"] = @(2);
        parameters[@"uniqueId"] = [OpenUDID value]; // 传deviceId
        parameters[@"version"] = @"0.9.1";
        parameters[@"versionName"] = @"0.9.1";
        LRSNetworkToken *token = [self.client POST:@"securities/loginOrRegister" parameters:parameters context:nil success:^(__kindof NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
            [self updateToken:responseObject[@"result"][@"httpToken"] uid:responseObject[@"result"][@"user"][@"userBasicInfo"][@"userId"]];
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

- (RACSignal<NSDictionary *> *)uploadFile:(UIImage *)image {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *parameters = [@{} mutableCopy];
        NSData *data = UIImagePNGRepresentation(image);
        parameters[@"contentLength"] = @(data.length);
        parameters[@"contentType"] = @"image/jpeg";
        parameters[@"fileName"] = [NSString stringWithFormat:@"images/6dc7ad09b264db94794a8ffebed0%d.jpg", arc4random() % 1000];
        LRSNetworkToken *token = [self.client GET:@"aws/s3/img/uploadUrl" parameters:parameters context:nil success:^(__kindof NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
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

- (RACSignal *)uploadFile:(NSData *)data url:(NSString *)url {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT" URLString:url parameters:nil error:nil];
//        [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
//        [request setHTTPBody:data];                           /*设置body*/
//        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
//        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/javascript", @"text/html", nil];
//        manager.responseSerializer = responseSerializer;
//
//        [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//            if (!error) {
//                [subscriber sendNext:responseObject];
//                [subscriber sendCompleted];
//            } else {
//                [subscriber sendError:error];
//            }
//        }] resume];
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT" URLString:url parameters:nil error:nil];
        [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:data];
        LRSNetworkOperation *operation = [[LRSNetworkOperation alloc] initWithRequest:request inSession:self.client context:nil];
        [self.client resumeOperation:operation];
        [operation addHandlersForSuccess:^(__kindof NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
            [subscriber sendNext:responseObject];
        } failure:^(__kindof NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{

        }];
    }];
}

- (void)updateToken:(NSString *)httpToken uid:(NSString *)uid {
    [_client setValue:[NSString stringWithFormat:@"%@", httpToken] forHTTPHeaderField:@"token"];
    [_client setValue:[NSString stringWithFormat:@"%@", uid] forHTTPHeaderField:@"uid"];
}

+ (NSString *)md5:(NSString *)value {
    const char *cStr = [value UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG) strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

@end
