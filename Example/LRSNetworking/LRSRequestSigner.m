//
//  LRSRequestSigner.m
//  LRSNetworking_Example
//
//  Created by sama 刘 on 2022/2/18.
//  Copyright © 2022 刘sama. All rights reserved.
//

#import "LRSRequestSigner.h"


@interface NSURLRequest(Paras)
- (NSDictionary *)parameters;
@end
@implementation NSURLRequest(Paras)

- (NSDictionary *)parameters {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[self HTTPMethod] uppercaseString]]) {
        NSURLComponents *urlComponents = [NSURLComponents componentsWithString:self.URL.absoluteString];
        [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            parameters[obj.name] = obj.value;
        }];
    } else {
        parameters = [NSJSONSerialization JSONObjectWithData:self.HTTPBody options:(NSJSONReadingMutableContainers) error:nil];
    }
    return parameters;
}

- (NSSet<NSString *> *)HTTPMethodsEncodingParametersInURI {
    static NSSet *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE", nil];
    });
    return instance;
}


@end


@import LRSWhiteBoxQA;
@implementation LRSRequestSigner

+ (NSMutableURLRequest *)signRequest:(NSMutableURLRequest *)request {
    int64_t timestamp = [self signedTimestamp];
    int32_t nonce = [self nonce];
    NSString *inputValue = [[self v5_signWithURL:request.URL parameter:request.parameters timestamp:timestamp] stringByAppendingString:[@(nonce) stringValue]];
    NSString *sign = [LRSWhiteBoxSecurityUtils securitySignatureWithValueToSignV6:inputValue];
    [request setValue:[self signVersion] forHTTPHeaderField:@"signVersion"];
    [request setValue:[@(nonce) stringValue] forHTTPHeaderField:@"nonce"];
    [request setValue:sign forHTTPHeaderField:@"signKey"];
    [request setValue:[@(timestamp) stringValue] forHTTPHeaderField:@"signTime"];
    return request;
}

+ (NSString *)signVersion {
    return @"6.1";
}

+ (int32_t)nonce {
    int32_t nonce = arc4random() % INT32_MAX;
    return nonce;
}

+ (int64_t)signedTimestamp {
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 - [self localSystemLag];
    return timestamp;
}

+ (int64_t)localSystemLag {
    long long localSystemLag = [[NSUserDefaults.standardUserDefaults valueForKey:@"kSystemLocalTimeLag"] longLongValue];
    return localSystemLag;
}

+ (NSString *)v5_signWithURL:(NSURL *)url parameter:(NSDictionary *)parameter timestamp:(long long)timestamp {
    NSString *urlString = [url absoluteString];
    NSString *originText = url.path;
    if ([urlString hasSuffix:@"/"]) {
        originText = [NSString stringWithFormat:@"%@/", originText];
    }
    // KEY 升序
    NSArray *allKeys = [[parameter allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *_Nonnull obj1, NSString *_Nonnull obj2) {
        return [obj1 compare:obj2];
    }];

    NSString *valueText = @"";
    for (NSString *key in allKeys) {
        NSString *value = parameter[key];
        if (value) {
            if ([value isKindOfClass:[NSString class]] && value.length != 0) {
                valueText = [NSString stringWithFormat:@"%@%@", valueText, value];
            }
            if ([value isKindOfClass:[NSNumber class]]) {
                valueText = [NSString stringWithFormat:@"%@%@", valueText, value];
            }
        }
    }
    NSString *timestampText = [NSString stringWithFormat:@"%lld", timestamp];
    NSString *text = [NSString stringWithFormat:@"%@%@%@", originText, valueText, timestampText];
    return text;
}

@end
