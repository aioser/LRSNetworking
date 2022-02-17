//
//  LRSNetworkingClientConfig.m
//  LRSNetworking
//
//  Created by sama 刘 on 2022/2/8.
//

#import "LRSNetworkingClientConfig.h"
#import "LRSNetworkingHelper.h"

static LRSNetworkingClientConfig * _defaultConfig;

@implementation LRSNetworkingClientConfig
+ (LRSNetworkingClientConfig *)defaultConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultConfig = [LRSNetworkingClientConfig new];
    });
    return _defaultConfig;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _timeout = [LRSNetworkingHelper timeoutInterval];
        _acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        _sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    LRSNetworkingClientConfig *config = [[[self class] allocWithZone:zone] init];
    config.timeout = self.timeout;
    config.sessionConfiguration = [self.sessionConfiguration copyWithZone:zone];
    config.acceptableContentTypes = self.acceptableContentTypes;
    return config;
}

@end
